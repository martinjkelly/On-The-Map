//
//  ViewController.swift
//  On The Map
//
//  Created by Martin Kelly on 29/10/2015.
//  Copyright © 2015 Martin Kelly. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var fbLoginButton:FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // fix the placeholder text color.
        usernameField.attributedPlaceholder = NSAttributedString(string: usernameField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordField.attributedPlaceholder = NSAttributedString(string: passwordField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        checkFacebookLoggedIn()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let usernamePaddingView = UIView(frame: CGRectMake(0,0,015,usernameField.frame.height))
        usernameField.leftView = usernamePaddingView
        usernameField.leftViewMode = .Always
        
        let passwordPaddingView = UIView(frame: CGRectMake(0,0,015,usernameField.frame.height))
        passwordField.leftView = passwordPaddingView
        passwordField.leftViewMode = .Always
    
    }
    
    func checkFacebookLoggedIn() {
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            showActivityIndicator()
            UdacityClient.sharedInstance().login(nil, password: nil, token: FBSDKAccessToken.currentAccessToken().tokenString) { (success) in
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.hideActivityIndicator()
                    
                    if (success) {
                        self.startApplication()
                    } else {
                        self.showQuickAlert("Invalid Credentials", message: "The login details provided are not valid.")
                    }
                }
                
            }
        }
        else
        {
            fbLoginButton = FBSDKLoginButton()
            fbLoginButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height - 50)
            fbLoginButton.delegate = self
            view.addSubview(fbLoginButton)
        }
    }
    
    func startApplication() {
        let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarController")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: Actions
    @IBAction func loginButton(sender: UIButton) {
        
        if (usernameField.text!.isEmpty || passwordField.text!.isEmpty) {
            showQuickAlert("Missing credentials", message: "Please enter your username and password to login")
            return
        }
        
        showActivityIndicator()
        UdacityClient.sharedInstance().login(usernameField.text!, password: passwordField.text!, token: nil) { (success) in
            
            dispatch_async(dispatch_get_main_queue()) {
                self.hideActivityIndicator()
                
                if (success) {
                    self.startApplication()
                } else {
                    self.showQuickAlert("Invalid Credentials", message: "The login details provided are not valid.")
                }
            }
            
        }
    }
    
    @IBAction func signUpButton(sender: UIButton) {
        
        // open the udacity sign up page url
        UIApplication.sharedApplication().openURL(NSURL(string: OTMClient.UdacityAPI.SignupURL)!)
        
    }

}

extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        checkFacebookLoggedIn()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        // don't actually need to do anything here, but method needs to be here to conform to protocol.
    }
}

extension UIViewController {
    
    // Show a quick alert error message
    func showQuickAlert(title:String, message:String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    func showActivityIndicator() {
        (UIApplication.sharedApplication().delegate as! AppDelegate).showActivityIndicator(self)
    }
    
    func hideActivityIndicator() {
        (UIApplication.sharedApplication().delegate as! AppDelegate).hideActivityIndicator()
    }
    
}

