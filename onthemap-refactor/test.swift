//
//  test.swift
//  onthemap-refactor
//
//  Created by Daniel Huang on 6/21/16.
//  Copyright © 2016 Daniel Huang. All rights reserved.
//

import Foundation
import MapKit

/*
struct Student {
    
    var coordinate: MapAnnotation
    var firstName: String
    var lastName: String
    var url: String
    
    var title: String?
    var subtitle: String?
    
    init(data: NSDictionary) {
        coordinate = MapAnnotation(
            latitude: data["latitude"] as! Double!,
            longitude: data["longitude"] as! Double
        )
        firstName = data["firstName"] as! String
        lastName = data["lastName"] as! String
        url = data["mediaURL"] as! String
        
        title = "\(firstName) \(lastName)"
        subtitle = url
    }
    
    func isValid(data: NSDictionary) -> Bool {
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


class MapAnnotation: NSObject, MKAnnotation {
    var myCoordinate: CLLocationCoordinate2D
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.myCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var coordinate: CLLocationCoordinate2D {
        return myCoordinate
    }
}
 */