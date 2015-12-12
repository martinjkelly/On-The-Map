//
//  ParseClient.swift
//  On The Map
//
//  Created by Martin Kelly on 12/12/2015.
//  Copyright © 2015 Martin Kelly. All rights reserved.
//

import Foundation

class ParseClient: OTMClient
{
    override class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
}
