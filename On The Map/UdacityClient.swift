//
//  UdacityClient.swift
//  On The Map
//
//  Created by Martin Kelly on 01/11/2015.
//  Copyright © 2015 Martin Kelly. All rights reserved.
//

import Foundation

class UdacityClient: OTMClient {
    
    var userId:Int?
    var sessionId:String?
    
    override class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    
    func login(username:String, password:String, completionHandler:(success:Bool) -> Void) {
        
        let parameters = ["udacity": ["username": username, "password": password]]
        
        let client = OTMClient.sharedInstance()
        client.send(OTMClient.UdacityAPI.AuthorizationUrl, parameters: parameters) { (result:OTMClient.Result) in
            
            switch result {
            case .Failure(let error):
                print("login failed with error: \(error)")
                completionHandler(success: false)
                break
            case .Success(let res):
                let account = res!["account"] as? [String:AnyObject]
                let session = res!["session"] as? [String:AnyObject]
                
                self.userId = Int(account!["key"] as! String)
                self.sessionId = session!["id"] as? String
                
                completionHandler(success: true)
                break
            }
        }
    }
    
    func logout(completionHandler:(success:Bool) -> Void) {
        
        var xsrfCookie: NSHTTPCookie? = nil
        var headers = [String:AnyObject]()
        
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            headers["X-XSRF-TOKEN"] = xsrfCookie.value
        }
        
        let client = OTMClient.sharedInstance()
        client.delete(OTMClient.UdacityAPI.AuthorizationUrl, headers: headers) { (result:OTMClient.Result) in
            switch result {
            case .Failure(let error):
                print("logout failed with error: \(error)")
                completionHandler(success: false)
                break
            case .Success(let res):
                print("logout success, retuned: \(res)")
                completionHandler(success: true)
                break
            }
        }
    }
}
