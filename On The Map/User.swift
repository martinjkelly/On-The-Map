//
//  User.swift
//  On The Map
//
//  Created by Martin Kelly on 02/01/2016.
//  Copyright © 2016 Martin Kelly. All rights reserved.
//

import Foundation

class User {
    var accountID:Int
    var firstName:String
    var lastName:String
    
    init(dict:Dictionary<String,AnyObject>) {
        accountID = Int(dict["key"] as! String)!
        firstName = dict["first_name"] as! String
        lastName = dict["last_name"] as! String
    }
}