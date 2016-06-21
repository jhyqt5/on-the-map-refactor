//
//  TableViewController.swift
//  onthemap-refactor
//
//  Created by Daniel Huang on 6/20/16.
//  Copyright © 2016 Daniel Huang. All rights reserved.
//

import UIKit

class TableViewController: HelperViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocationData() {
            self.tableView.reloadData()
        }
        tableView.delegate = self
        tableView.dataSource = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableViewController.reloadData), name: refreshNotificationName, object: nil)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("listCell")! as UITableViewCell
        if  Location.locations.count > indexPath.row {
            let studentInfo = Location.locations[indexPath.row]
            cell.textLabel!.text = studentInfo.title
            cell.imageView!.image = UIImage(named: "pin")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Location.locations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if  Location.locations.count > indexPath.row {
            let studentInfo = Location.locations[indexPath.row]
            if let url = NSURL(string: studentInfo.url) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
}
