//
//  PostViewController.swift
//  onthemap-refactor
//
//  Created by Daniel Huang on 6/20/16.
//  Copyright © 2016 Daniel Huang. All rights reserved.
//

import UIKit
import MapKit

class PostViewController: HelperViewController, MKMapViewDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var geoCodeIndicator: UIActivityIndicatorView!
    @IBOutlet weak var entryView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var locationTextContainer: UIView!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var urlContainer: UIView!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var map: MKMapView!
    
    
    var location: CLLocation?
    var mapString: String = ""
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        entryView.hidden = false
        mapView.hidden = true
        geoCodeIndicator.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tap
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("didTapTextContainer:"))

        
        //textfields
        locationText.delegate = self
        urlField.delegate = self
        
        //map
        map.delegate = self
        
        //url 
        urlContainer.addGestureRecognizer(tapGesture)
        
    }
    
    func didTapTextContainer(sender: AnyObject) {
        urlField.becomeFirstResponder()
    }


    @IBAction func findLocationOnMap(sender: AnyObject) {
        let text = locationText.text
        
        if !text!.isEmpty {
            
            startGeocoding()
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(text!, completionHandler: { (placemarks, error) in
                self.didFinishGeocoding(placemarks, error: error)
            })
        }
    
    }
    
    
    func didFinishGeocoding(placemarks: [AnyObject]!, error: NSError!) {
        stopGeoLoading()
        
        if error == nil && placemarks.count > 0 {
            // show the map
            entryView.hidden = true
            mapView.hidden = false
            
            // center the map and set the pin
            let placemark = placemarks[0] as! CLPlacemark
            let geocodedLocation = placemark.location!
            centerMapOnLocation(geocodedLocation)
            
            let studentInfo = Student(data: [
                "firstName": User.firstName,
                "lastName": User.lastName,
                "latitude": geocodedLocation.coordinate.latitude,
                "longitude": geocodedLocation.coordinate.longitude,
                "mediaURL": ""
                ])
            
            map.addAnnotation(studentInfo)
            
            mapString = locationText.text!
            location = geocodedLocation
        } else {
            showErrorAlert("Error Geocoding", defaultMessage: "The location could not be found.", errors: [error])
        }
    }
    
    func startGeocoding() {
        geoCodeIndicator.startAnimating()
        entryView.alpha = 0.5
    }
    
    func stopGeoLoading() {
        geoCodeIndicator.stopAnimating()
        entryView.alpha = 1
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Student {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = false
            }
            return view
        }
        return nil
    }
    
    @IBAction func cancelPost(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 200000, 200000)
        map.setRegion(coordinateRegion, animated: true)
    }
 
    @IBAction func submitPost(sender: AnyObject) {
        if !urlField.text!.isEmpty && location != nil {
            let coord = location!.coordinate
            let text = urlField.text
            
            Location.postNewLocation(coord.latitude, longitude: coord.longitude, mediaURL: text!, mapString: mapString) { success in
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // Mark: Textfield Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
