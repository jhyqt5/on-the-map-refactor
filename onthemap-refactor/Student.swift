//
//  Student.swift
//  onthemap-refactor
//
//  Created by Daniel Huang on 6/20/16.
//  Copyright © 2016 Daniel Huang. All rights reserved.
//


import Foundation
import MapKit

class Student: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var firstName: String
    var lastName: String
    var url: String
    
    var title: String?
    var subtitle: String?
    
    init(data: NSDictionary) {
        coordinate = CLLocationCoordinate2D(
        latitude: data["latitude"] as! Double!,
        longitude: data["longitude"] as! Double
        )
        firstName = data["firstName"] as! String
        lastName = data["lastName"] as! String
        url = data["mediaURL"] as! String
        
        title = "\(firstName) \(lastName)"
        subtitle = url
    }
    
    class func isValid(data: NSDictionary) -> Bool {
        if let latitude = data["latitude"] as? Double,
        let longitude = data["longitude"] as? Double,
        let firstName = data["firstName"] as? String,
        let lastName = data["lastName"] as? String,
        let url = data["mediaURL"] as? String
        {
        return true
        }
        return false
    }
    
    
} // end student class
