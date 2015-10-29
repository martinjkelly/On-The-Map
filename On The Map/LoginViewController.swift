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
        
        
        let fbLoginButton = FBSDKLoginButton()
        fbLoginButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height - 50)
        view.addSubview(fbLoginButton)
        
    }
    
    @IBAction func loginButton(sender: UIButton) {
    
    }
    
    @IBAction func signUpButton(sender: UIButton) {
        // open the sign up page url
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

