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
    
    func getStudents(limit:Int = 100, offset:Int = 0, orderBy:String = "-createdAt", completionHandler: (success:Bool, students: [StudentLocation]?) -> Void) {
        let client = OTMClient.sharedInstance()
        
        let parameters = [
            "limit": limit,
            "offset": offset,
            "order": orderBy
        ]
        
        var headers = [String:AnyObject]()
        headers["X-Parse-Application-Id"] = OTMClient.ParseAPI.ApplicationID
        headers["X-Parse-REST-API-Key"] = OTMClient.ParseAPI.RESTApiKey
        
        client.fetch(OTMClient.ParseAPI.StudentLocationsEndPoint, parameters: parameters as! [String : AnyObject], headers: headers) { (result:OTMClient.Result) in
            switch result {
            case .Failure(let error):
                print("login failed with error: \(error)")
                completionHandler(success: false, students: nil)
                break
            case .Success(let res):
                // print("res = \(res)")
                
                if let json = res!["results"] as? [[String:AnyObject]] {
                    print("parsing student locations was a success.")
                    completionHandler(success: true, students: self.parseStudentLocations(json))
                } else {
                    print("parsing student locations falied.")
                    completionHandler(success: false, students: nil)
                }
                
                
                break
            }

        }
    }
    
    func parseStudentLocations(json:[[String:AnyObject]]) -> [StudentLocation] {
        var locations = [StudentLocation]()
        
        for location in json {
            let studentLocation = StudentLocation(
                objectId: location["objectId"] as! String,
                uniqueKey: location["uniqueKey"] as? String,
                firstName: location["firstName"] as! String,
                lastName: location["lastName"] as! String,
                mapString: location["mapString"] as! String,
                mediaUrl: NSURL(string: location["mediaUrl"] as! String)!,
                latitude: Float(location["latitude"] as! Float),
                longitude: Float(location["longitude"] as! Float),
                createdAt: nil,
                updatedAt: nil
            )
            
            locations.append(studentLocation)
        }
        
        return locations
    }
}
