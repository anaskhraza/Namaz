//
//  FirstViewController.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 9/7/20.
//  Copyright © 2020 Anas khurshid. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController, SetCoordinateProtocol {
   
    let myTabController = MyTabBarController()
    let locationManager = LocationManager()
    var coordinates: Coordinates!
    
    func setLocationCoordinate(latitude: Double?, longitude: Double?) {
        self.locationManager.prayerCalculation.determineLocation(latitude: latitude ?? 25.157167, longitude: longitude ?? 51.517845)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.setLocationCoordinateProtocol = self
        let authStatus = locationManager.getAuthorizationStatus()
        let config = self.locationManager.utils.parseConfig()
        
    
        if authStatus == PermissionStatus.NA {
            locationManager.getLocationPopup()
        }
        
        if authStatus == PermissionStatus.Denied {
            self.locationManager.prayerCalculation.determineLocation(latitude: Double(config.latitude), longitude: Double(config.longitude))
        }
        
    }
    
    
    
    private func displayTime() {
        
    }
    
}


