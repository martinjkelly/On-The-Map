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
    var user:User?
    
    override class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    
    func login(username:String, password:String, completionHandler:(success:Bool) -> Void) {
        
        let parameters = ["udacity": ["username": username, "password": password]]
        
        OTMClient.sharedInstance().send(OTMClient.UdacityAPI.AuthorizationURL, parameters: parameters, headers: nil) { (result:OTMClient.Result) in
            
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

                self.getUserData(self.userId!) { (success:Bool, userDict:Dictionary<String,AnyObject>?, error:NSError?) in
                    
                    if success {
                        self.user = User(dict: userDict!)
                        completionHandler(success: true)
                    } else {
                        completionHandler(success: false)
                    }
                }
                break
            }
        }
    }
    
    func getUserData(accountID:Int, completionHandler:(success:Bool, user:Dictionary<String,AnyObject>?, error:NSError?) -> Void) {
        
        OTMClient.sharedInstance().fetch("\(OTMClient.UdacityAPI.GetUserDataURL)\(accountID)", parameters: Dictionary<String,AnyObject>(), headers: nil) { (result:OTMClient.Result) in
            
            switch result {
            case .Failure(let error):
                print("get user data failed with error: \(error)")
                completionHandler(success: false, user: nil, error: error)
                break
            case .Success(let res):
                completionHandler(success: true, user: res!["user"] as? [String:AnyObject], error: nil)
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
        
        OTMClient.sharedInstance().delete(OTMClient.UdacityAPI.AuthorizationURL, parameters: headers) { (result:OTMClient.Result) in
            switch result {
            case .Failure(let error):
                print("logout failed with error: \(error)")
                completionHandler(success: false)
                break
            case .Success(_):
                self.user = nil
                self.sessionId = nil
                self.userId = nil
                completionHandler(success: true)
                break
            }
        }
    }
}
