//
//  FirstViewController.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 9/7/20.
//  Copyright © 2020 Anas khurshid. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController {
    
    let myTabController = MyTabBarController()
    let locationManager = LocationManager()
    var coordinates: Coordinates!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authStatus = locationManager.getAuthorizationStatus()
        
        
        
        if authStatus == PermissionStatus.NA {
            locationManager.getLocationPopup()
        }
        
        if authStatus == PermissionStatus.Denied {
            coordinates = Coordinates(latitude: 21.4225, longitude: 39.8262)
        }
        if(authStatus == PermissionStatus.Authorized) {
            locationManager.getCoordinates()
        }
                
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let formatter = DateFormatter()
        let date = cal.dateComponents([.year, .month, .day], from: Date())
        let coordinates = Coordinates(latitude: 25.157167, longitude: 51.517845)
        var params = CalculationMethod.qatar.params
        params.madhab = .shafi
        let prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params)
        
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone(identifier: "Asia/Qatar")!
        
        print("fajr \(formatter.string(from: prayers!.fajr))")
        print("sunrise \(formatter.string(from: prayers!.sunrise))")
        print("dhuhr \(formatter.string(from: prayers!.dhuhr))")
        print("asr \(formatter.string(from: prayers!.asr))")
        print("maghrib \(formatter.string(from: prayers!.maghrib))")
        print("isha \(formatter.string(from: prayers!.isha))")
        
        
        
        
        
        let current = prayers!.currentPrayer()
        print("isha", current ?? "not found")
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: 25.157167, longitude: 51.517845)
        geoCoder.reverseGeocodeLocation(location, completionHandler:
            {
                placemarks, error -> Void in
                
                // Place details
                guard let placeMark = placemarks?.first else { return }
                
                // Location name
                if let locationName = placeMark.location {
                    print("location \(locationName)")
                }
                // Street address
                if let street = placeMark.thoroughfare {
                    print("Street \(street)")
                }
                // City
                if let city = placeMark.subAdministrativeArea {
                    print("city \(city)")                }
                // Zip code
                if let zip = placeMark.isoCountryCode {
                    print("zip \(zip)")                }
                // Country
                if let country = placeMark.country {
                    print("country \(country)")                }
        })
    }
    
}


