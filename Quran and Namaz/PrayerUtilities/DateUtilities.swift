//
//  DateUtilities.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 9/15/20.
//  Copyright © 2020 Anas khurshid. All rights reserved.
//

import Foundation

internal extension Date {
    
    func roundedMinute() -> Date {
        let cal: Calendar = .gregorianUTC
        var components = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        
        let minute: Double = Double(components.minute ?? 0)
        let second: Double = Double(components.second ?? 0)
        
        components.minute = Int(minute + round(second/60))
        components.second = 0
        
        return cal.date(from: components) ?? self
    }
}

internal extension DateComponents {
    
    func settingHour(_ value: Double) -> DateComponents? {
        guard value.isNormal else {
            return nil
        }
        
        let calculatedHours = floor(value)
        let calculatedMinutes = floor((value - calculatedHours) * 60)
        let calculatedSeconds = floor((value - (calculatedHours + calculatedMinutes/60)) * 60 * 60)
        
        var components = self
        components.hour = Int(calculatedHours)
        components.minute = Int(calculatedMinutes)
        components.second = Int(calculatedSeconds)
        
        return components
    }
}

internal extension Calendar {
    
    /// All calculations are done using a gregorian calendar with the UTC timezone
    static let gregorianUTC: Calendar = {
        guard let utc = TimeZone(identifier: "UTC") else {
            fatalError("Unable to instantiate UTC TimeZone.")
        }
        
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = utc
        return cal
    }()
}
