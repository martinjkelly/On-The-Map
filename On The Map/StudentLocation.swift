//
//  StudentLocation.swift
//  On The Map
//
//  Created by Martin Kelly on 12/12/2015.
//  Copyright © 2015 Martin Kelly. All rights reserved.
//

import Foundation
import MapKit

class StudentLocation: NSObject, MKAnnotation
{
    var objectId = ""
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    var mapString = ""
    var mediaUrl:NSURL?
    var latitude = 0.0
    var longitude = 0.0
    
    @objc var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        }
    }
    
    var title:String? {
        get {
            return "\(self.firstName) \(self.lastName)"
        }
    }
    
    var subtitle:String? {
        get {
            return "\(self.mediaUrl)"
        }
    }
}
