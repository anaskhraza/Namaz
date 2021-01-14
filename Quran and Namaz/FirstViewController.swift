//
//  FirstViewController.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 9/7/20.
//  Copyright © 2020 Anas khurshid. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController, SetCoordinateProtocol, CalculationMap {
   
    
    let myTabController = MyTabBarController()
    let locationManager = LocationManager()
    var coordinates: Coordinates!
    
    func setLocationCoordinate(latitude: Double?, longitude: Double?) {
        self.determineLocation(latitude: latitude ?? 25.157167, longitude: longitude ?? 51.517845)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.setLocationCoordinateProtocol = self
        let authStatus = locationManager.getAuthorizationStatus()
        if authStatus == PermissionStatus.NA {
            locationManager.getLocationPopup()
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
                    print("country \(country)")
                }
                if let timeZone = placeMark.timeZone {
                        print("timeZone \(timeZone)")
                }
        })
    }
    
    private func CalculateTimes() {
        
    }
    

    private func determineLocation(latitude: Double!, longitude: Double! ) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        var timeZone: String!
        var countryCode: String!
        var country: String!
        
        
        geoCoder.reverseGeocodeLocation(location, completionHandler:
            {
                placemarks, error -> Void in
                
                // Place details
                guard let placeMark = placemarks?.first else { return }
                
                // Zip code
                if let zip = placeMark.isoCountryCode {
                    print("zip \(zip)")
                    countryCode = zip
                }
                // Country
                if let _country = placeMark.country {
                    print("country \(_country)")
                    country = _country
                }
                
                if let _timeZone = placeMark.timeZone?.identifier {
                        print("timeZone \(_timeZone)")
                    timeZone = _timeZone
                }
            })
        
        
        
    }
    
    private func displayTime() {
        
    }
    
}


