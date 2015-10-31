//
//  OTMClient.swift
//  On The Map
//
//  Created by Martin Kelly on 31/10/2015.
//  Copyright © 2015 Martin Kelly. All rights reserved.
//

import Foundation

class OTMClient: NSObject {
    
    typealias CompletionHandlerType = (Result) -> Void
    
    enum Result {
        case Success(AnyObject?)
        case Failure(NSError)
    }
    
    var session: NSURLSession
    
    override init() {
        super.init()
        session = NSURLSession.sharedSession()
    }
    
    class func sharedInstance() -> OTMClient {
        
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        
        return Singleton.sharedInstance
    }
    
    func fetch(urlString:String, parameters: [String:AnyObject], completionHandler: CompletionHandlerType) {
        
        let url = NSURL(string: urlString + OTMClient.escapedParameters(parameters))
        let request = NSMutableURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
        
            guard (error == nil) else {
                completionHandler(Result.Failure(NSError(domain: "OTMClient:fetch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Request error: \(error)"])))
                return
            }
            
        }
        
        task.resume()
        
        return task
    }
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: CompletionHandlerType) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            completionHandler(Result.Failure(Error.JSONParsingError))
        }
        
        completionHandler(Result.Success(parsedResult))
    }
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
}