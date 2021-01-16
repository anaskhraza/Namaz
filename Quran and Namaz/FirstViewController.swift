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
        self.determineLocation(latitude: latitude ?? 25.157167, longitude: longitude ?? 51.517845)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.setLocationCoordinateProtocol = self
        let authStatus = locationManager.getAuthorizationStatus()
        if authStatus == PermissionStatus.NA {
            locationManager.getLocationPopup()
        }
        
    }
    
    private func CalculateTimes(params: CalculationParameters, timeZone: String?, latitude: Double!, longitude: Double!) {
        
        let coordinates = Coordinates(latitude: latitude, longitude: longitude)
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let formatter = DateFormatter()
        let date = cal.dateComponents([.year, .month, .day], from: Date())
        
        let prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params)
        
        formatter.timeStyle = .medium
        
        formatter.timeZone = TimeZone(identifier: timeZone ?? "Asia/Qatar")!
        
        print("fajr \(formatter.string(from: prayers!.fajr))")
        print("sunrise \(formatter.string(from: prayers!.sunrise))")
        print("dhuhr \(formatter.string(from: prayers!.dhuhr))")
        print("asr \(formatter.string(from: prayers!.asr))")
        print("maghrib \(formatter.string(from: prayers!.maghrib))")
        print("isha \(formatter.string(from: prayers!.isha))")
        
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
                
                
            
                var params = CalculationMap().selectCalculationMethod(countryCode: countryCode)
                
                if(countryCode == "PK" || countryCode == "TR") {
                    params.madhab = .hanafi
                } else {
                    params.madhab = .shafi
                }
                
                self.CalculateTimes(params: params, timeZone: timeZone, latitude: latitude, longitude: longitude)
            })
    }
    
    private func displayTime() {
        
    }
    
}


