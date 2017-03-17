//
//  ReportFormViewController.swift
//  Tempest
//
//  Created by Julien on 16/03/2017.
//  Copyright © 2017 Julien. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ReportFormViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let location = CLLocation(latitude: 43.4641441, longitude: 0.025058800000010706)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation: CLLocation = locations.last!
        userLocation = currentLocation
        
        centerMapOnLocation(location: userLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
