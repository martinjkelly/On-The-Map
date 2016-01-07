//
//  TableViewController.swift
//  On The Map
//
//  Created by Martin Kelly on 29/10/2015.
//  Copyright © 2015 Martin Kelly. All rights reserved.
//

import UIKit

class TableViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    let studentLocations = StudentLocations.sharedInstance()
    var locations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadStudentLocations(false)
    }
    
    // MARK: Methods
    func loadStudentLocations(freshData:Bool) {
        
        showActivityIndicator()
        
        self.locations.removeAll()
        
        studentLocations.getStudentLocations(freshData, completion: { (success:Bool, locations: [StudentLocation]?) in
            if (success) {
                self.locations = locations!
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
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
    @IBAction func reloadDataButtonPressed(sender: UIBarButtonItem) {
        loadStudentLocations(true)
    }
    
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
}

extension TableViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        let studentLocation = locations[indexPath.row]
        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        if let link = studentLocation.mediaUrl {
            cell.detailTextLabel?.text = "\(link)"
        }
        cell.imageView?.image = UIImage(named: "pin")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentLocation = locations[indexPath.row]
        if let link = studentLocation.mediaUrl {
            UIApplication.sharedApplication().openURL(link)
        }
    }
    
}