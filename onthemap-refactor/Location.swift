//
//  Location.swift
//  onthemap-refactor
//
//  Created by Daniel Huang on 6/20/16.
//  Copyright © 2016 Daniel Huang. All rights reserved.
//

import Foundation

class Location {
    
    static let appId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    static var locations: [Student] = []
    static var errors: [NSError] = []
   
    
    
    class func getStudentLocations(refresh: Bool = false, didComplete: (success: Bool) -> Void) {
        if refresh || locations.isEmpty {
            locations = []
            
            let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
            request.addValue(Location.appId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Location.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil {
                    self.errors.append(error!)
                    didComplete(success: false)
                    return
                }
                
                let success = Location.getLocationData(data!)
                didComplete(success: success)
            }
            task.resume()
        }
        else if !locations.isEmpty {
            didComplete(success: true)
        }
    }
    

    class func getLocationData(data: NSData) -> Bool {
        var success = false
        if let locationData = (try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)) as? NSDictionary {
            if let data = locationData["results"] as? [NSDictionary] {
                success = true
                for studentInfo in data {
                    if !Student.isValid(studentInfo) {
                        success = false
                        break
                    }
                    locations.append(Student(data: studentInfo))
                }
            }
        }
        if !success {
            errors.append(NSError(domain: "Location data could not be parsed.", code: 1, userInfo: nil))
        }
        return success
    }
    

    class func postNewLocation(latitude: Double, longitude: Double, mediaURL: String, mapString: String, didComplete: (success: Bool) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue(Location.appId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Location.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = "{\"uniqueKey\": \"\(User.key)\", \"firstName\": \"\(User.firstName)\", \"lastName\": \"\(User.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                self.errors.append(error!)
                didComplete(success: false)
                return
            }
            didComplete(success: true)
        }
        task.resume()
    }
}