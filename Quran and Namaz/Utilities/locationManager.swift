//
//  locationManager.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 9/14/20.
//  Copyright © 2020 Anas khurshid. All rights reserved.
//

import Foundation
import CoreLocation

enum PermissionStatus {
    static let Denied = "Denied"
    static let Authorized = "Authorized"
    static let NA = "NA"
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locManager: CLLocationManager!
    var latitude: Double!
    var longitude: Double!
    override init() {
        super.init()
        locManager = CLLocationManager()
    }
    
    func getLocationPopup() {
        self.locManager.requestWhenInUseAuthorization()
    }
    
    func getCoordinates () {
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        latitude =  locValue.latitude
        longitude =  locValue.longitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func getAuthorizationStatus() -> String {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        switch authorizationStatus {
        case .denied:
            return PermissionStatus.Denied
        case .authorizedAlways:
            return PermissionStatus.Authorized
        case .authorizedWhenInUse:
            return PermissionStatus.Authorized
        default:
            return PermissionStatus.NA
        }
    }
    
    
}
