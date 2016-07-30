//
//  LocationManager.swift
//  Smart Roads V2
//
//  Created by Jack Carey on 30/07/2016.
//  Copyright © 2016 Smart Roads. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedManager = LocationManager()
    
    var locationManager: CLLocationManager!
    typealias LocationChange = (CLLocation) -> (Void)
    var locationClosure: LocationChange = {_ in }
    typealias StatusChange = (CLAuthorizationStatus) -> (Void)
    var statusChange: StatusChange = {_ in }
    
    var status: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func getCurrentLocation() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 500
        
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        statusChange(status)
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation = locations.last!
        self.locationClosure(latestLocation)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Error: \(error)")
    }
    
}