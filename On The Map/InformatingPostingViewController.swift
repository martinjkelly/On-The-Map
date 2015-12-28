//
//  InformatingPostingViewController.swift
//  On The Map
//
//  Created by Martin Kelly on 28/12/2015.
//  Copyright © 2015 Martin Kelly. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController:UIViewController
{
    var step = 0
    let spanSize = 0.025
    var geocoder:CLGeocoder!
    var selectedPlacemark:CLPlacemark?
    
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        geocoder = CLGeocoder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = OTMClient.CustomColors.blueColor
        loadCurrentStep()
    }
    
    func switchView() {
        // use a bitwise not to toggle the view
        step = ~step
        loadCurrentStep()
    }
    
    func loadCurrentStep() {
        
        // safeguard, should never be required.
        if selectedPlacemark == nil {
            step = 0
        }
        
        if step == 0 {
            topContainerView.backgroundColor = OTMClient.CustomColors.greyColor
            bottomContainerView.backgroundColor = OTMClient.CustomColors.greyColor
            
            mapView.hidden = true
            locationTextField.hidden = false
            linkTextField.hidden = true
            findButton.hidden = false
            submitButton.hidden = true
        } else {
            topContainerView.backgroundColor = OTMClient.CustomColors.darKBlueColor
            bottomContainerView.backgroundColor = UIColor.clearColor()
            mapView.hidden = false
            locationTextField.hidden = true
            linkTextField.hidden = false
            findButton.hidden = true
            submitButton.hidden = false
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = (selectedPlacemark?.location?.coordinate)!
            mapView.addAnnotation(annotation)
            mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpanMake(spanSize, spanSize)), animated: false)
        }
    }
    
    // MARK: Actions
    @IBAction func submitButtonPressed(sender: UIButton) {
        switchView()
    }
    
    @IBAction func findButtonPressed(sender: UIButton) {
        
        geocoder.geocodeAddressString(locationTextField.text!) { (placemarks:[CLPlacemark]?, error:NSError?) in
            
            if let location = placemarks?.first {
                self.selectedPlacemark = location
                dispatch_async(dispatch_get_main_queue()) {
                    self.switchView()
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
