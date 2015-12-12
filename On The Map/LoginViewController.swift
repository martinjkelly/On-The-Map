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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // fix the placeholder text color.
        usernameField.attributedPlaceholder = NSAttributedString(string: usernameField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordField.attributedPlaceholder = NSAttributedString(string: passwordField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        // @TODO: sort the rest of this later.
        let fbLoginButton = FBSDKLoginButton()
        fbLoginButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height - 50)
        view.addSubview(fbLoginButton)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let usernamePaddingView = UIView(frame: CGRectMake(0,0,015,usernameField.frame.height))
        usernameField.leftView = usernamePaddingView
        usernameField.leftViewMode = .Always
        
        let passwordPaddingView = UIView(frame: CGRectMake(0,0,015,usernameField.frame.height))
        passwordField.leftView = passwordPaddingView
        passwordField.leftViewMode = .Always
    
    }
    
    @IBAction func loginButton(sender: UIButton) {
        
        if (usernameField.text!.isEmpty || passwordField.text!.isEmpty) {
            loginFailed("Missing credentials", reason: "Please enter your username and password to login")
            return
        }
        
        let udacityClient = UdacityClient.sharedInstance()
        udacityClient.login(usernameField.text!, password: passwordField.text!) { (success) in
            
            dispatch_async(dispatch_get_main_queue()) {
                let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
            
                let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarController")
                appDelegate.window?.rootViewController = initialViewController
                appDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    func loginFailed(title:String, reason:String) {
        let alertView = UIAlertController(title: title, message: reason, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(sender: UIButton) {
        
        // open the udacity sign up page url
        let urlString = "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signin&sa=D&usg=AFQjCNHOjlXo3QS15TqT0Bp_TKoR9Dvypw"
        UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
        
    }

}

