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
    var sessionId:Int?
    
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
                print(res!["account"])
                completionHandler(success: true)
                break
            }
        }
    }
    
    
}
