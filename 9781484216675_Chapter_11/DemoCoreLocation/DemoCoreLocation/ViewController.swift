//
//  ViewController.swift
//  DemoCoreLocation
//
//  Created by Hristo Lesev on 7/13/15.
//  Copyright (c) 2015 DiaDraw. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate
{
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    // Create an instance of the location manager class:
    let locationManager : CLLocationManager = CLLocationManager()

    @IBAction func buttonTouched(sender: AnyObject) {
        
        label.text = "Searching location..."
        
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        // This line was generated for us by Xcode:
        super.viewDidLoad()

        //Set this ViewController instance as the delegate
        //that will recieve the location service callbacks:
        locationManager.delegate = self

        //Set the desired accuracy level:
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Ask the user for permission to use location services:
        locationManager.requestAlwaysAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Print out the location array:
        label.text = "locations = \(locations)"
        
        // Read the first set of locations from the array:
        let location = locations.first!
        
        //Show the device's location on the map:
        setMapViewLocation( location: location )
    }

    func setMapViewLocation( location location : CLLocation ) {
        
        //Define a distance in meters:
        let locationDistance : CLLocationDistance = 100;
        
        //Create a region on the map, the center of which is our location and radius the defined distance
        //and its radius - the distance we defined above:
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, locationDistance, locationDistance)
        
        //Show the region on the map:
        mapView.setRegion(region, animated: true)
    }

}

