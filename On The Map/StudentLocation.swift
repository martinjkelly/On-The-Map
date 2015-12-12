//
//  StudentLocation.swift
//  On The Map
//
//  Created by Martin Kelly on 12/12/2015.
//  Copyright © 2015 Martin Kelly. All rights reserved.
//

import Foundation

struct StudentLocation
{
    var objectId:String;
    var uniqueKey:String?;
    var firstName:String;
    var lastName:String;
    var mapString:String;
    var mediaUrl:NSURL;
    var latitude:Float;
    var longitude:Float;
    var createdAt:NSDate?;
    var updatedAt:NSDate?;
}
