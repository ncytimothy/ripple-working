//
//  TheySaidSoClient.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import Foundation
import Keys
import CoreData

class TheySaidSoClient: NSObject {
    
    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    // URL Shared Session
    var session = URLSession.shared
    
    
    // -------------------------------------------------------------------------
    // MARK: - GET
    func taskForGETMethod(_ parameters: [String:AnyObject], method: String, completionHandlerForGET: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        // 1. Create the request with URL
        var request = URLRequest(url: theySaySoURL(parameters: parameters, method: method))
        
        // Uncomment below for Debug Purposes
        print("theySaidSoURL in taskForGETMethod: \(theySaySoURL(parameters: parameters, method: method))")
        
        
        // 2. Add the API Key into the project
        // TODO: Use Cocoapods-Keys later
        let keys = Ripple2Keys()
        
        // INSERT API KEY HERE
        request.setValue(keys.theySaidSoAPIKey, forHTTPHeaderField: Constants.TheySaidSo.AuthHeader)
        
        // 3. Create the task
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // 4. sendError for debug work
            func sendError(_ error: String) {
                debugPrint(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // 5. GUARD: Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            // 6. Guard: Did we get a successful 2xx response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // 7. Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by your request")
                return
            }
            
            // 8. Parse the data and use the data, returned in the completion handler
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
            
        }
        
        // 9. Resume (Start) the dataTask
        task.resume()
        return task
        
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Helpers
    
    // Create URL from method and parameters
    private func theySaySoURL(parameters: [String:AnyObject], method: String) -> URL {
        var components = URLComponents()
        components.scheme = Constants.TheySaidSo.APIScheme
        components.host = Constants.TheySaidSo.APIHost
        components.path = method
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // Convert data from requests into JSON
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // Shared Instance for the client to be accessed by the controller
    class func sharedInstance() -> TheySaidSoClient {
        struct Singleton {
            static var shared = TheySaidSoClient()
        }
        return Singleton.shared
    }
    
}

