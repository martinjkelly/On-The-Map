//
//  TableViewController.swift
//  On The Map
//
//  Created by Martin Kelly on 29/10/2015.
//  Copyright © 2015 Martin Kelly. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    // MARK: TableViewDelegate
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
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected row at indexPath: \(indexPath)")
        
        let studentLocation = locations[indexPath.row]
        if let link = studentLocation.mediaUrl {
            UIApplication.sharedApplication().openURL(link)
        }
    }
    
    // MARK: Methods
    func loadStudentLocations(freshData:Bool) {
        print("loading student locations, with freshData: \(freshData)")
        studentLocations.getStudentLocations(freshData, completion: { (success:Bool, locations: [StudentLocation]?) in
            if (success) {
                self.locations = locations!
                print(locations!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showErrorAlert("Unable to download locations", message: "No locations were found, please check your network connection")
                }
            }
        })
    }
    
    // MARK: Actions
    @IBAction func reloadDataButtonPressed(sender: UIBarButtonItem) {
        self.locations.removeAll()
        loadStudentLocations(true)
    }
}
