//
//  ParseClient.swift
//  On The Map
//
//  Created by Martin Kelly on 12/12/2015.
//  Copyright © 2015 Martin Kelly. All rights reserved.
//

import Foundation
import MapKit

class ParseClient: OTMClient
{
    override class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
    func getStudentLocations(limit:Int = 100, offset:Int = 0, orderBy:String = "-createdAt", completionHandler: (success:Bool, students: [StudentLocation]?) -> Void) {
        
        let parameters = [
            "limit": limit,
            "offset": offset,
            "order": orderBy
        ]
        
        var headers = [String:AnyObject]()
        headers["X-Parse-Application-Id"] = OTMClient.ParseAPI.ApplicationID
        headers["X-Parse-REST-API-Key"] = OTMClient.ParseAPI.RESTApiKey
        
        OTMClient.sharedInstance().fetch(OTMClient.ParseAPI.StudentLocationsEndPoint, parameters: parameters as! [String : AnyObject], headers: headers) { (result:OTMClient.Result) in
            switch result {
            case .Failure(let error):
                print("login failed with error: \(error)")
                completionHandler(success: false, students: nil)
                break
            case .Success(let res):
                if let json = res!["results"] as? [[String:AnyObject]] {
                    completionHandler(success: true, students: self.parseStudentLocations(json))
                } else {
                    print("parsing student locations falied.")
                    completionHandler(success: false, students: nil)
                }
                break
            }

        }
    }
    
    func findStudentLocation(completionHandler: (success:Bool, objectId:String?) -> Void) {
        
        let parameters:[String:AnyObject] = [
            "where": "{\"uniqueKey\":\"\(UdacityClient.sharedInstance().userId!)\"}"
        ]
        
        var headers = [String:AnyObject]()
        headers["X-Parse-Application-Id"] = OTMClient.ParseAPI.ApplicationID
        headers["X-Parse-REST-API-Key"] = OTMClient.ParseAPI.RESTApiKey
        
        OTMClient.sharedInstance().fetch(OTMClient.ParseAPI.StudentLocationsEndPoint, parameters: parameters, headers: headers) { (result:OTMClient.Result) in
            switch result {
            case .Failure(let error):
                print("login failed with error: \(error)")
                completionHandler(success: false, objectId: nil)
                break
            case .Success(let res):
                if let json = res!["results"] as? [[String:AnyObject]] {
                    
                    if json.count > 0 {
                        let row = json.first
                        let objectId = row!["objectId"] as! String
                        completionHandler(success: true, objectId: objectId)
                    } else {
                        completionHandler(success: false, objectId: nil)
                    }
                } else {
                    print("parsing student locations falied.")
                    completionHandler(success: false, objectId: nil)
                }
                break
            }
            
        }

    }
    
    func submitStudentLocation(location: CLPlacemark, locationString:String, linkString:String, completionHandler: (success:Bool) -> Void) {
        
        
        findStudentLocation() { (success:Bool, objectId:String?) in
            
            if let user = UdacityClient.sharedInstance().user {
                
                var headers = [String:AnyObject]()
                headers["X-Parse-Application-Id"] = OTMClient.ParseAPI.ApplicationID
                headers["X-Parse-REST-API-Key"] = OTMClient.ParseAPI.RESTApiKey
                
                let params:[String:AnyObject] = [
                    "uniqueKey": String(user.accountID),
                    "firstName": user.firstName,
                    "lastName": user.lastName,
                    "mapString": locationString,
                    "mediaURL": linkString,
                    "latitude": (location.location?.coordinate.latitude)!,
                    "longitude": (location.location?.coordinate.longitude)!
                ]
                
                if success {
                    OTMClient.sharedInstance().update("\(OTMClient.ParseAPI.StudentLocationsEndPoint)/\(objectId!)", parameters: params, headers: headers) { (result:OTMClient.Result) in
                        
                        switch result {
                        case .Failure(_):
                            completionHandler(success: false)
                            break
                        case .Success(_):
                            completionHandler(success: true)
                            break
                        }
                        
                    }
                } else {
                    OTMClient.sharedInstance().send(OTMClient.ParseAPI.StudentLocationsEndPoint, parameters: params, headers: headers) { (result:OTMClient.Result) in
                        
                        switch result {
                        case .Failure(_):
                            completionHandler(success: false)
                            break
                        case .Success(_):
                            completionHandler(success: true)
                            break
                        }
                        
                    }
                    
                }
            }
            
        }
    }
    
    func parseStudentLocations(json:[[String:AnyObject]]) -> [StudentLocation] {
        var locations = [StudentLocation]()
        
        for location in json {
            let studentLocation = StudentLocation(dict: location)
            locations.append(studentLocation)
        }
        
        return locations
    }
}
