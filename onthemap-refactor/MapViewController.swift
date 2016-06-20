//
//  MapViewController.swift
//  onthemap-refactor
//
//  Created by Daniel Huang on 6/20/16.
//  Copyright © 2016 Daniel Huang. All rights reserved.
//

// Citation: http://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial

import UIKit
import MapKit

class MapViewController: HelperViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedView: MKAnnotationView?
    var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(MapViewController.annotationTapped(_:)))
        
        loadLocationData() {
            self.loadAnnotations()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.reloadMap), name: refreshNotificationName, object: nil)
    }
    
    func reloadMap() {
        self.mapView.removeAnnotations(Location.locations)
        self.loadAnnotations()
    }
    
    func loadAnnotations() {
        let coord = Location.locations[0].coordinate
        let initialLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        
        centerOnMap(initialLocation)
        
        for location in Location.locations {
            mapView.addAnnotation(location)
        }
    }
    
    func centerOnMap(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 10000, 10000)
        mapView.setRegion(coordinateRegion, animated: true)
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
                view.canShowCallout = true
                //view.calloutOffset = CGPoint(x: -5, y: 5)
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        view.addGestureRecognizer(tapGesture)
        selectedView = view
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView!) {
        selectedView = nil
        view.removeGestureRecognizer(tapGesture)
    }

    
    func annotationTapped(sender: MapViewController) {
        if let studentInfo = selectedView!.annotation as? Student,
            let url = NSURL(string: studentInfo.url)
        {
            UIApplication.sharedApplication().openURL(url)
        }
    }

}
