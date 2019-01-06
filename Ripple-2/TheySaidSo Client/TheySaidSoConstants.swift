//
//  TheySaidSoConstants.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit

extension TheySaidSoClient {
    
    // MARK: Constants
    struct Constants {
        // MARK: - TheySaidSo
        struct TheySaidSo {
            static let APIScheme = "https"
            static let APIHost = "quotes.rest"
            static let AuthHeader = "X-TheySaidSo-Api-Secret"
        }
    }
    
    // MARK: - TheySaidSo Methods
    struct Methods {
        static let QuoteOfTheDay  = "/qod.json"
        static let RandomQuote = "/quote/random.json"
        static let Categories = "/qod/categories.json"
        static let Search = "/quote/search.json"
    }
    
    // MARK: - TheySaidSo Parameter Keys
    struct TheySaidSoParameterKeys {
        static let Category = "category"
        static let MaxLength = "maxlength"
    }
    
    struct TheySaidSoParameterValues {
        static let MaxLength = "140"
    }
    
    // MARK: - TheySaidSo Response Keys
    struct TheySaidSoResponseKeys {
        static let Contents = "contents"
        static let Quotes = "quotes"
        static let Quote = "quote"
        static let Categories = "categories"
        static let Category = "category"
        static let Author = "author"
    }
    
    // MARK: - TheySaidSo Random Quotes Constant
    struct QuoteConstantsForRandom {
        static let randomQuotesConstants: Int = 8
    }
    
    struct Alert {
        static let NoInternetTitle = "No internet connection"
        static let NoInternetMessage = "Please check your internet connection settings"
        static let OK = "OK"
        static let Dismiss = "Dismiss"
    }
    
    
}

