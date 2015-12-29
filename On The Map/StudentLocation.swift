//
//  StudentLocation.swift
//  On The Map
//
//  Created by Martin Kelly on 12/12/2015.
//  Copyright © 2015 Martin Kelly. All rights reserved.
//

import Foundation
import MapKit

struct StudentLocation
{
    var objectId:String
    var uniqueKey:String?
    var firstName:String
    var lastName:String
    var mapString:String
    var mediaUrl:NSURL?
    var latitude:Double
    var longitude:Double
    
    init(dict:Dictionary<String,AnyObject>) {
        objectId = dict["objectId"] as! String
        uniqueKey = dict["uniqueKey"] as? String
        firstName = dict["firstName"] as! String
        lastName = dict["lastName"] as! String
        mapString = dict["mapString"] as! String
        
        if let mediaUrl = dict["mediaURL"] as? String {
            self.mediaUrl = NSURL(string: mediaUrl)
        }
        
        latitude = dict["latitude"] as! Double
        longitude = dict["longitude"] as! Double
    }
    
    var annotation: MKPointAnnotation {
        get {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
            annotation.title = "\(self.firstName) \(self.lastName)"
            if let subtitle = self.mediaUrl {
                annotation.subtitle = "\(subtitle)"
            }
            
            return annotation
        }
    }
}
