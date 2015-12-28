//
//  StudentLocations.swift
//  On The Map
//
//  Created by Martin Kelly on 28/12/2015.
//  Copyright © 2015 Martin Kelly. All rights reserved.
//

import Foundation

class StudentLocations
{
    var locations = [StudentLocation]()
    
    class func sharedInstance() -> StudentLocations {
        
        struct Singleton {
            static var sharedInstance = StudentLocations()
        }
        
        return Singleton.sharedInstance
    }
    
    func getStudentLocations(forceRelaod:Bool, completion:((success:Bool, locations:[StudentLocation]?) -> Void)?) {
        
        if locations.count == 0 || forceRelaod {
            ParseClient.sharedInstance().getStudentLocations() { (success:Bool, locations:[StudentLocation]?) in
                if (success) {
                    self.locations = locations!
                }
            
                if (completion != nil) {
                    completion!(success: success, locations: locations)
                }
            }
        } else {
            completion!(success: true, locations: locations)
        }
    }
}