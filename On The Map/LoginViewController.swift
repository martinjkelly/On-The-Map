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
        //usernameField.attributedPlaceholder = NSAttributedString(string: usernameField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        // passwordField.attributedPlaceholder = NSAttributedString(string: passwordField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        
        //@TODO: sort the rest of this later.
        let fbLoginButton = FBSDKLoginButton()
        fbLoginButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height - 50)
        view.addSubview(fbLoginButton)
        
    }
    
    @IBAction func loginButton(sender: UIButton) {
    
        let client = OTMClient.sharedInstance()
        client.fetch("https://www.google.com/url?q=https://s3.amazonaws.com/content.udacity-data.com/courses/ud421/post-session.json&sa=D&usg=AFQjCNFh9XsagB24v3KWIHTD14tOqnJIIQ", parameters: [String:AnyObject]()) { (result:Result) in
            
            print(result)
        }
        /**
        let urlString = "https://www.udacity.com/api/session"
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(usernameField.text)\", \"\(passwordField.text)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
        }
        task.resume()*/
    }
    
    @IBAction func signUpButton(sender: UIButton) {
        
        // open the udacity sign up page url
        let urlString = "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signin&sa=D&usg=AFQjCNHOjlXo3QS15TqT0Bp_TKoR9Dvypw"
        UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

