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
    var step = 1
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
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        geocoder = CLGeocoder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = OTMClient.CustomColors.blueColor
        locationTextField.delegate = self
        linkTextField.delegate = self
        
        locationTextField.attributedPlaceholder = NSAttributedString(string: locationTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        linkTextField.attributedPlaceholder = NSAttributedString(string: linkTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
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
            
            questionLabel.hidden = false
            mapView.hidden = true
            locationTextField.hidden = false
            linkTextField.hidden = true
            findButton.hidden = false
            submitButton.hidden = true
            cancelButton.titleLabel?.textColor = OTMClient.CustomColors.darKBlueColor
        } else {
            topContainerView.backgroundColor = OTMClient.CustomColors.blueColor
            bottomContainerView.backgroundColor = UIColor.clearColor()
            
            questionLabel.hidden = true
            mapView.hidden = false
            locationTextField.hidden = true
            linkTextField.hidden = false
            findButton.hidden = true
            submitButton.hidden = false
            cancelButton.titleLabel?.textColor = UIColor.whiteColor()
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = (selectedPlacemark?.location?.coordinate)!
            mapView.addAnnotation(annotation)
            mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpanMake(spanSize, spanSize)), animated: false)
        }
    }
    
    // MARK: Actions
    @IBAction func submitButtonPressed(sender: UIButton) {
        
        if (linkTextField.text == "") {
            showQuickAlert("Invalid link", message: "Please enter a valid URL in the blue section above before submitting.")
            return
        }
        
        ParseClient.sharedInstance().submitStudentLocation(selectedPlacemark!, locationString: locationTextField.text!, linkString: linkTextField.text!) { (success:Bool) in
            
            StudentLocations.sharedInstance().getStudentLocations(true, completion: { (success:Bool, locations: [StudentLocation]?) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func findButtonPressed(sender: UIButton) {
        
        showActivityIndicator()
        self.view.alpha = 0.5
        geocoder.geocodeAddressString(locationTextField.text!) { (placemarks:[CLPlacemark]?, error:NSError?) in
            
            self.view.alpha = 1.0
            self.hideActivityIndicator()
            
            if let _ = error {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.showQuickAlert("Unable to find location", message: "We were unable to find a location based on your input, please try again.");
                }
                
            } else {
            
                if let location = placemarks?.first {
                    self.selectedPlacemark = location
                    dispatch_async(dispatch_get_main_queue()) {
                        self.switchView()
                    }
                }
                
            }
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension InformationPostingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}