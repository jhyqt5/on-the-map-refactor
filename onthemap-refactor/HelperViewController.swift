//
//  HelperViewController.swift
//  onthemap-refactor
//
//  Created by Daniel Huang on 6/20/16.
//  Copyright © 2016 Daniel Huang. All rights reserved.
//

import UIKit
import MapKit

class HelperViewController: UIViewController {

    
    internal func showErrorAlert(title: String, defaultMessage: String, errors: [NSError]) {
        var message = defaultMessage
        if !errors.isEmpty {
            message = errors[0].localizedDescription
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OkAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alertController.addAction(OkAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //shared refresh
    @IBAction func didPressRefresh(sender: UIBarButtonItem) {
        self.loadLocationData(true) {
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: self.refreshNotificationName, object: self))
        }
    }
    
    //shared logout
    @IBAction func didPressLogout(sender: UIBarButtonItem) {
        sender.enabled = false
        User.logOut() { success in
            sender.enabled = true
            if !success {
                self.showErrorAlert("Logout Failed", defaultMessage: "Could not log out", errors: User.errors)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
    
    //Table and Map methods
    let refreshNotificationName = "Location Data Refresh Notification"
    
    internal func loadLocationData(forceRefresh: Bool = false, didComplete: (() -> Void)?) {
        Location.getStudentLocations(forceRefresh) { success in
            if !success {
                self.showErrorAlert("Error Loading Locations", defaultMessage: "Loading failed.", errors: Location.errors)
            } else if !Location.locations.isEmpty && didComplete != nil {
                didComplete!()
            }
        }
    }
    

}
