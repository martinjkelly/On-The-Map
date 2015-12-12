//
//  MapViewController.swift
//  On The Map
//
//  Created by Martin Kelly on 29/10/2015.
//  Copyright © 2015 Martin Kelly. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
