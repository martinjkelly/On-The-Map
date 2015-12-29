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
    let studentLocations = StudentLocations.sharedInstance()
    var currentAnnotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadStudentLocations(false)
    }
    
    // MARK: Methods
    func loadStudentLocations(freshData:Bool) {
        print("loading student locations, with freshData: \(freshData)")
        studentLocations.getStudentLocations(freshData, completion: { (success:Bool, locations: [StudentLocation]?) in
            if (success) {
                for location in locations! {
                    self.currentAnnotations.append(location.annotation)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotations(self.currentAnnotations)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showErrorAlert("Unable to download locations", message: "No locations were found, please check your network connection")
                }
            }
        })
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let urlString = view.annotation?.subtitle {
            if let url = NSURL(string: urlString!) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    // MARK: Actions
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().logout() { (success:Bool) in
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
        mapView.removeAnnotations(currentAnnotations)
        currentAnnotations.removeAll()
        loadStudentLocations(true)
    }
    
}
