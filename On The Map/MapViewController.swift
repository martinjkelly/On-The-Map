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
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadStudentLocations(false)
    }
    
    // MARK: Methods
    func loadStudentLocations(freshData:Bool) {
        
        showActivityIndicator()
        
        mapView.removeAnnotations(currentAnnotations)
        currentAnnotations.removeAll()
        
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
                    self.showQuickAlert("Unable to download locations", message: "No locations were found, please check your network connection")
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.hideActivityIndicator()
            }
        })
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
        loadStudentLocations(true)
    }
    
}

extension MapViewController {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "mapPin"
        var annotationView:MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView {
            
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
            
        } else {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView.canShowCallout = true
            annotationView.calloutOffset = CGPoint(x: -5, y: 5)
            annotationView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let urlString = (view.annotation?.subtitle)! else {
            self.showQuickAlert("Invalid URL", message: "The provided link was invalid or missing")
            return
        }
        
        if let url = NSURL(string: urlString) {
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    
}
