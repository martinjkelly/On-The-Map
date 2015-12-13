//
//  MapViewController.swift
//  On The Map
//
//  Created by Martin Kelly on 29/10/2015.
//  Copyright © 2015 Martin Kelly. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var parseClient:ParseClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a
        
        parseClient = ParseClient.sharedInstance()
        parseClient?.getStudents() { (success:Bool, locations:[StudentLocation]?) in
            if (success) {
                print(locations!.count)
                self.mapView.addAnnotations(locations!)
            }
        }
    }
    
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        let client = UdacityClient.sharedInstance()
        client.logout() { (success:Bool) in
            dispatch_async(dispatch_get_main_queue()) {
                let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
                
                let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("loginViewController")
                appDelegate.window?.rootViewController = initialViewController
                appDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func addPinButtonPressed(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func reloadDataButtonPressed(sender: UIBarButtonItem) {
        
    }
    
    
}
