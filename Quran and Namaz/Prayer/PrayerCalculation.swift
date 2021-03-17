//
//  PrayerCalculation.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 16/03/2021.
//  Copyright © 2021 Anas khurshid. All rights reserved.
//

import Foundation
import MapKit

class PrayerCalculation {
    
    private func calculateTimes(params: CalculationParameters, timeZone: String?, latitude: Double!, longitude: Double!) {
        
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
    
    public func determineLocation(latitude: Double!, longitude: Double! ) {
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
                
                if let zip = placeMark.isoCountryCode {
                    countryCode = zip
                }
                
                if let _country = placeMark.country {
                    country = _country
                }
                
                if let _timeZone = placeMark.timeZone?.identifier {
                    timeZone = _timeZone
                }
                
                var params = CalculationMap().selectCalculationMethod(countryCode: countryCode)
                
                if(countryCode == "PK" || countryCode == "TR") {
                    params.madhab = .hanafi
                } else {
                    params.madhab = .shafi
                }
                
                self.calculateTimes(params: params, timeZone: timeZone, latitude: latitude, longitude: longitude)
            })
    }
    
}
