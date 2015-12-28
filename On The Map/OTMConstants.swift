//
//  OTMConstants.swift
//  On The Map
//
//  Created by Martin Kelly on 29/10/2015.
//  Copyright © 2015 Martin Kelly. All rights reserved.
//

import Foundation

extension OTMClient {
    
    struct UdacityAPI {
        static let UdacityURL = "www.udacity.com"
        static let AuthorizationURL = "https://www.udacity.com/api/session"
        static let SignupURL = "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signin&sa=D&usg=AFQjCNHOjlXo3QS15TqT0Bp_TKoR9Dvypw"
    }
    
    struct ParseAPI {
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let StudentLocationsEndPoint = "https://api.parse.com/1/classes/StudentLocation"
    }
    
    struct CustomColors {
        static let blueColor = UIColor(red: 81/255, green: 137/255, blue: 180/255, alpha: 1.0)
        static let darKBlueColor = UIColor(red: 16/255, green: 63/255, blue: 112/255, alpha: 1.0)
        static let greyColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
    }
}
