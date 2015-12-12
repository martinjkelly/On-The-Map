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
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    class func sharedInstance() -> OTMClient {
        
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        
        return Singleton.sharedInstance
    }
    
    func fetch(urlString:String, parameters: [String:AnyObject], headers: [String:AnyObject]?, completionHandler: CompletionHandlerType) -> NSURLSessionDataTask {
        
        let url = NSURL(string: urlString + OTMClient.escapedParameters(parameters))
        let request = NSMutableURLRequest(URL: url!)
        
        if let headers = headers {
            for (key,value) in headers {
                request.setValue(value as? String, forHTTPHeaderField: key)
            }
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
        
            guard (error == nil) else {
                completionHandler(Result.Failure(NSError(domain: "OTMClient:fetch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Request error: \(error)"])))
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            guard let data = data else {
                completionHandler(Result.Failure(NSError(domain: "OTMClient:fetch", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data returned from request"])))
                return
            }
            
            OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            
        }
        
        task.resume()
        
        return task
    }
    
    func delete(urlString:String, parameters: [String:AnyObject], completionHandler: CompletionHandlerType) -> NSURLSessionTask {
        
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "DELETE"
        
        for (key,value) in parameters {
            request.setValue(value as? String, forHTTPHeaderField: key)
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard (error == nil) else {
                completionHandler(Result.Failure(NSError(domain: "OTMClient:fetch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Request error: \(error)"])))
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            guard var data = data else {
                completionHandler(Result.Failure(NSError(domain: "OTMClient:fetch", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data returned from request"])))
                return
            }
            
            if url!.host == "www.udacity.com" {
                data = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            }
            
            OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)

        }
        
        task.resume()
        return task
    }
    
    func send(urlString:String, parameters: [String:AnyObject], completionHandler: CompletionHandlerType) -> NSURLSessionDataTask {
        
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        
        if let jsonData = try? NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted) {
            request.HTTPBody = jsonData
        } else {
            print("error sending params as JSON, params: \(parameters)")
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                completionHandler(Result.Failure(NSError(domain: "OTMClient:fetch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Request error: \(error)"])))
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            guard var data = data else {
                completionHandler(Result.Failure(NSError(domain: "OTMClient:fetch", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data returned from request"])))
                return
            }
            
            if url!.host == "www.udacity.com" {
                data = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            }
            
            OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            
        }
        
        task.resume()
        
        return task
    }
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: CompletionHandlerType) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            completionHandler(Result.Failure(NSError(domain: "OTMClient:parseJson", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to parse JSON: \(String(data))"])))
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