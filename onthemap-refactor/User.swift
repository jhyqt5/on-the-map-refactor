//
//  User.swift
//  onthemap-refactor
//
//  Created by Daniel Huang on 6/20/16.
//  Copyright © 2016 Daniel Huang. All rights reserved.
//

import Foundation

class User {
    
    static var username = ""
    static var key = ""
    static var sessionID = ""
    static var loading = true
    
    static var firstName = ""
    static var lastName = ""
    
    static var errors: [NSError] = []
    
    class func loginUser(username: String, password: String, didComplete: (success: Bool, errorMessage: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                self.errors.append(error!)
                didComplete(success: false, errorMessage: "A network error has occurred.")
                return
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            let success = User.getUserData(newData)
            let errorMessage: String? = success ? nil : "The email or password was not valid."
            didComplete(success: success, errorMessage: errorMessage)
        }
        task.resume()
    }
    
    class func getUserData(data: NSData) -> Bool {
        var success = true
        
        if let userData = (try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)) as? NSDictionary,
            let account = userData["account"] as? [String: AnyObject],
            let session = userData["session"] as? [String: String]
        {
            User.key = account["key"] as! String
            User.sessionID = session["id"]!
            
            //get user information
            User.getUserDetail() { success in
                if success {
                    self.loading = false
                }
            }
        } else {
            success = false
        }
        return success;
    }
    
    class func getUserDetail(didComplete: (success: Bool) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(User.key)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                self.errors.append(error!)
                didComplete(success: false)
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            if let userData = (try? NSJSONSerialization.JSONObjectWithData(newData, options: .MutableContainers)) as? NSDictionary,
                let user = userData["user"] as? [String: AnyObject],
                let firstName = user["first_name"] as? String,
                let lastName = user["last_name"] as? String
            {
                self.firstName = firstName
                self.lastName = lastName
                didComplete(success: true)
            }
        }
        task.resume()
    }    
    
    
    //Add logout
    class func logOut(didComplete: (success: Bool) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in (sharedCookieStorage.cookies! as [NSHTTPCookie]) {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-Token")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                self.errors.append(error!)
                didComplete(success: false)
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            didComplete(success: true)
        }
        task.resume()
    }
    
} //end user Class