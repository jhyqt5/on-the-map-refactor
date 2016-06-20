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
