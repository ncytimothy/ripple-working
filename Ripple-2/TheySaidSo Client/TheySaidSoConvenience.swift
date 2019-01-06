//
//  TheySaidSoConvenience.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import Foundation

extension TheySaidSoClient {
    //---------------------------------------------------------------------------------
    // MARK: - Main downloadQuotes method
    func downloadQuotes(dataController: DataController, completionHandlerForDownloadQuote: @escaping(_ success: Bool, _ errorString: String?) -> Void) {
        var categories: [String]?
        
        // 1. Specify the parameters
        var parameters = [String:AnyObject]()
        
        // 2. Make the request
        let  _ = taskForGETMethod(parameters, method: TheySaidSoClient.Methods.Categories) { (result, error) in
            // 3. Was there an error returned?
            guard (error == nil) else {
                completionHandlerForDownloadQuote(false, "Cannot download quotes")
                return
            }
            
            // 4. Are results returned?
            guard let result = result else {
                debugPrint("Cannot get result")
                return
            }
            
            // 5. First get the categories
            categories = self.convertJSONToCategories(result: result)
            
            // 6. Unwrap categories, and make categorical quote request for each category
            if let categories = categories {
                for category in categories {
                    parameters = [TheySaidSoClient.TheySaidSoResponseKeys.Category:category] as [String:AnyObject]
                    let _ = self.taskForGETMethod(parameters, method: TheySaidSoClient.Methods.QuoteOfTheDay) { (result, error) in
                        guard (error == nil) else {
                            completionHandlerForDownloadQuote(false, "Cannot download quotes")
                            return
                        }
                        
                        guard let result = result else {
                            debugPrint("Cannot get result!")
                            return
                        }
                        
                        guard let quote = self.convertJSONToQuote(result: result) else {
                            debugPrint("Cannot unwrap JSON to Quote!")
                            return
                        }
                        
                        //                        QuoteSharedData.sharedInstance.Quotes.append(quote)
                        completionHandlerForDownloadQuote(true, "")
                    }
                }
            }
        }
        
        // 1. Get Random Quote as well
        let _ = taskForGETMethod([:], method: TheySaidSoClient.Methods.RandomQuote) { (result, error) in
            guard (error == nil) else {
                completionHandlerForDownloadQuote(false, "Cannot download quotes")
                return
            }
        }
    }
    
    func downloadRandomQuote(dataController: DataController, completionHandlerForDownloadRandomQuote: @escaping(_ success: Bool, _ errorString: String?) -> Void) {
        // 1. Specify the parameters
        let parameters = [TheySaidSoClient.TheySaidSoParameterKeys.MaxLength:TheySaidSoClient.TheySaidSoParameterValues.MaxLength
            ] as [String:AnyObject]
        
        // 2. Make the request
        let _ = taskForGETMethod(parameters, method: TheySaidSoClient.Methods.Search) { (result, error) in
            // 3. Were there errors returned?
            guard (error == nil) else {
                completionHandlerForDownloadRandomQuote(false, "Cannot download random quotes!")
                return
            }
            // 4. Was result returned?
            guard let result = result else {
                debugPrint("Cannot get result")
                return
            }
            
            // 5. Save to Core Data
            self.saveRandomQuoteToCoreData(result: result, dataController: dataController, { (success) in
                if success {
                    completionHandlerForDownloadRandomQuote(true, "")
                }
            })
            
            //            // 5. Convert JSON result to random quote
            //            guard let quote = self.convertJSONToRandomQuote(result: result) else {
            //                debugPrint("Cannot convert JSON to random quote")
            //                return
            //            }
            //
            //            QuoteSharedData.sharedInstance.Quotes.append(quote)
            //            completionHandlerForDownloadRandomQuote(true, "")
            
        }
    }
    
    //---------------------------------------------------------------------------------
    // MARK: - Conversion and Core Data Methods
    fileprivate func saveRandomQuoteToCoreData(result: AnyObject, dataController: DataController, _ completionHandlerForSaveRandomQuoteToCoreData: @escaping(_ success: Bool) -> Void) {
        
        guard let randomQuoteString = self.convertJSONForRandomQuote(result: result, attribute: TheySaidSoResponseKeys.Quote) else { return }
        guard let randomQuoteAuthor = self.convertJSONForRandomQuote(result: result, attribute: TheySaidSoResponseKeys.Author) else { return }
        guard let randomQuoteCategory = convertJSONToRandomQuoteCategory(result: result) else { return }
        
        let quote = Quote(context: dataController.viewContext)
        quote.quoteString = randomQuoteString
        quote.author = randomQuoteAuthor
        quote.category = randomQuoteCategory
        
        quote.creationDate = Date()
        
        do {
            try dataController.viewContext.save()
            completionHandlerForSaveRandomQuoteToCoreData(true)
        } catch {
            debugPrint("Cannot save quote to Core Data")
            completionHandlerForSaveRandomQuoteToCoreData(false)
        }
        
    }
    
    fileprivate func convertJSONForRandomQuote(result: AnyObject, attribute: String) -> String? {
        var randomQuoteAttribute: String? = nil
        
        print("result: \(result)")
        
        guard let contentsDictionary = result[TheySaidSoResponseKeys.Contents] as? [String:AnyObject], let quoteAttribute = contentsDictionary[attribute] as? String else {
            debugPrint("Cannot find keys '\(TheySaidSoResponseKeys.Contents)' or '\(attribute)' in '\(result)'")
            randomQuoteAttribute = ""
            return randomQuoteAttribute
        }
        
        randomQuoteAttribute = quoteAttribute
        return randomQuoteAttribute
    }
    
    fileprivate func convertJSONToRandomQuoteCategory(result: AnyObject) -> String? {
        var randomQuoteCategory: String? = nil
        
        guard let contentsDictionary = result[TheySaidSoResponseKeys.Contents] as? [String:AnyObject], let categoriesArray = contentsDictionary[TheySaidSoResponseKeys.Categories] as? [String] else {
            debugPrint("Cannot find keys \'\(TheySaidSoResponseKeys.Contents)\' and \'\(TheySaidSoResponseKeys.Categories)\' in \'\(result)\'")
            return randomQuoteCategory
        }
        
        if categoriesArray.isEmpty {
            randomQuoteCategory = "INSPIRING"
            return randomQuoteCategory
        }
        
        randomQuoteCategory = categoriesArray.first
        return randomQuoteCategory
    }
    
    fileprivate func convertJSONToCategories(result: AnyObject) -> [String]? {
        var categories: [String]? = nil
        
        guard let contentsDictionary = result[TheySaidSoClient.TheySaidSoResponseKeys.Contents] as? [String:AnyObject], let categoriesDictionary = contentsDictionary[TheySaidSoClient.TheySaidSoResponseKeys.Categories] as? [String:AnyObject] else {
            debugPrint("Cannot find keys '\(TheySaidSoClient.TheySaidSoResponseKeys.Contents)' and/or '\(TheySaidSoClient.TheySaidSoResponseKeys.Categories)' in '\(result)'")
            return categories
        }
        
        categories = Array(categoriesDictionary.keys)
        return categories
    }
    
    fileprivate func convertJSONToQuote(result: AnyObject) -> Quote? {
        var quote: Quote? = nil
        
        guard let contentsDictionary = result[TheySaidSoClient.TheySaidSoResponseKeys.Contents] as? [String:AnyObject], let quotesArray = contentsDictionary[TheySaidSoClient.TheySaidSoResponseKeys.Quotes] as? [[String:AnyObject]] else {
            debugPrint("Cannot find keys '\(TheySaidSoClient.TheySaidSoResponseKeys.Contents)' or '\(TheySaidSoClient.TheySaidSoResponseKeys.Quotes)' in '\(result)'")
            return quote
        }
        
        let quoteDictionary = quotesArray[0]
        print("quote: \(quoteDictionary)")
        
        return quote
    }
    
    fileprivate func convertJSONToRandomQuote(result: AnyObject) -> Quote? {
        var quote: Quote? = nil
        
        guard let contentsDictionary = result[TheySaidSoClient.TheySaidSoResponseKeys.Contents] as? [String:AnyObject] else {
            debugPrint("Cannot find keys '\(TheySaidSoClient.TheySaidSoResponseKeys.Contents)' in '\(result)'")
            return quote
        }
        return quote
    }
    
}
