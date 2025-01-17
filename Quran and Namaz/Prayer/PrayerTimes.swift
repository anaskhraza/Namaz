//
//  PrayerTimes.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 9/15/20.
//  Copyright © 2020 Anas khurshid. All rights reserved.
//

import Foundation

/**
 Prayer times for a location and date using the given calculation parameters.
 All prayer times are in UTC and should be displayed using a DateFormatter that
 has the correct timezone set.
 */
public struct PrayerTimes {
    public let fajr: Date
    public let sunrise: Date
    public let dhuhr: Date
    public let asr: Date
    public let maghrib: Date
    public let isha: Date
    
    public let coordinates: Coordinates
    public let date: DateComponents
    public let calculationParameters: CalculationParameters
    
    public init?(coordinates: Coordinates, date: DateComponents, calculationParameters: CalculationParameters) {
        
        var tempFajr: Date? = nil
        var tempSunrise: Date? = nil
        var tempDhuhr: Date? = nil
        var tempAsr: Date? = nil
        var tempMaghrib: Date? = nil
        var tempIsha: Date? = nil
        let cal: Calendar = .gregorianUTC
        
        guard let prayerDate = cal.date(from: date),
            let tomorrowDate = cal.date(byAdding: .day, value: 1, to: prayerDate),
            let year = date.year,
            let dayOfYear = cal.ordinality(of: .day, in: .year, for: prayerDate) else {
                return nil
        }
        
        let tomorrow = cal.dateComponents([.year, .month, .day], from: tomorrowDate)
        
        self.coordinates = coordinates
        self.date = date
        self.calculationParameters = calculationParameters
        
        guard let solarTime = SolarTime(date: date, coordinates: coordinates),
            let tomorrowSolarTime = SolarTime(date: tomorrow, coordinates: coordinates),
            let sunriseDate = cal.date(from: solarTime.sunrise),
            let sunsetDate = cal.date(from: solarTime.sunset),
            let tomorrowSunrise = cal.date(from: tomorrowSolarTime.sunrise) else {
                // unable to determine transit, sunrise or sunset aborting calculations
                return nil
        }
        
        tempSunrise = cal.date(from: solarTime.sunrise)
        tempMaghrib = cal.date(from: solarTime.sunset)
        tempDhuhr = cal.date(from: solarTime.transit)
        
        if let asrComponents = solarTime.afternoon(shadowLength: calculationParameters.madhab.shadowLength) {
            tempAsr = cal.date(from: asrComponents)
        }
        
        // get night length
        let night = tomorrowSunrise.timeIntervalSince(sunsetDate)
        
        if let fajrComponents = solarTime.timeForSolarAngle(Angle(-calculationParameters.fajrAngle), afterTransit: false) {
            tempFajr = cal.date(from: fajrComponents)
        }
        
        // special case for moonsighting committee above latitude 55
        if calculationParameters.method == .moonsightingCommittee && coordinates.latitude >= 55 {
            let nightFraction = night / 7
            tempFajr = sunriseDate.addingTimeInterval(-nightFraction)
        }
        
        let safeFajr: Date = {
            guard calculationParameters.method != .moonsightingCommittee else {
                return Astronomical.seasonAdjustedMorningTwilight(latitude: coordinates.latitude, day: dayOfYear, year: year, sunrise: sunriseDate)
            }
            
            let portion = calculationParameters.nightPortions().fajr
            let nightFraction = portion * night
            
            return sunriseDate.addingTimeInterval(-nightFraction)
        }()
        
        if tempFajr == nil || tempFajr?.compare(safeFajr) == .orderedAscending {
            tempFajr = safeFajr
        }
        
        // Isha calculation with check against safe value
        if calculationParameters.ishaInterval > 0 {
            tempIsha = tempMaghrib?.addingTimeInterval(calculationParameters.ishaInterval.timeInterval)
        } else {
            if let ishaComponents = solarTime.timeForSolarAngle(Angle(-calculationParameters.ishaAngle), afterTransit: true) {
                tempIsha = cal.date(from: ishaComponents)
            }
            
            // special case for moonsighting committee above latitude 55
            if calculationParameters.method == .moonsightingCommittee && coordinates.latitude >= 55 {
                let nightFraction = night / 7
                tempIsha = sunsetDate.addingTimeInterval(nightFraction)
            }
            
            let safeIsha: Date = {
                guard calculationParameters.method != .moonsightingCommittee else {
                    return Astronomical.seasonAdjustedEveningTwilight(latitude: coordinates.latitude, day: dayOfYear, year: year, sunset: sunsetDate)
                }
                
                let portion = calculationParameters.nightPortions().isha
                let nightFraction = portion * night
                
                return sunsetDate.addingTimeInterval(nightFraction)
            }()
            
            if tempIsha == nil || tempIsha?.compare(safeIsha) == .orderedDescending {
                tempIsha = safeIsha
            }
        }
        
        // Maghrib calculation with check against safe value
        if let maghribAngle = calculationParameters.maghribAngle,
            let maghribComponents = solarTime.timeForSolarAngle(Angle(-maghribAngle), afterTransit: true),
            let maghribDate = cal.date(from: maghribComponents),
            // maghrib is considered safe if it falls between sunset and isha
            sunsetDate < maghribDate, (tempIsha?.compare(maghribDate) == .orderedDescending || tempIsha == nil) {
            tempMaghrib = maghribDate
        }
        
        // if we don't have all prayer times then initialization failed
        guard let fajr = tempFajr,
            let sunrise = tempSunrise,
            let dhuhr = tempDhuhr,
            let asr = tempAsr,
            let maghrib = tempMaghrib,
            let isha = tempIsha else {
                return nil
        }
        
        // Assign final times to public struct members with all offsets
        self.fajr = fajr.addingTimeInterval(calculationParameters.adjustments.fajr.timeInterval)
            .addingTimeInterval(calculationParameters.methodAdjustments.fajr.timeInterval)
            .roundedMinute()
        self.sunrise = sunrise.addingTimeInterval(calculationParameters.adjustments.sunrise.timeInterval)
            .addingTimeInterval(calculationParameters.methodAdjustments.sunrise.timeInterval)
            .roundedMinute()
        self.dhuhr = dhuhr.addingTimeInterval(calculationParameters.adjustments.dhuhr.timeInterval)
            .addingTimeInterval(calculationParameters.methodAdjustments.dhuhr.timeInterval)
            .roundedMinute()
        self.asr = asr.addingTimeInterval(calculationParameters.adjustments.asr.timeInterval)
            .addingTimeInterval(calculationParameters.methodAdjustments.asr.timeInterval)
            .roundedMinute()
        self.maghrib = maghrib.addingTimeInterval(calculationParameters.adjustments.maghrib.timeInterval)
            .addingTimeInterval(calculationParameters.methodAdjustments.maghrib.timeInterval)
            .roundedMinute()
        self.isha = isha.addingTimeInterval(calculationParameters.adjustments.isha.timeInterval)
            .addingTimeInterval(calculationParameters.methodAdjustments.isha.timeInterval)
            .roundedMinute()
    }
    
    public func currentPrayer(at time: Date = Date()) -> Prayer? {
        if isha.timeIntervalSince(time) <= 0 {
            return .isha
        } else if maghrib.timeIntervalSince(time) <= 0 {
            return .maghrib
        } else if asr.timeIntervalSince(time) <= 0 {
            return .asr
        } else if dhuhr.timeIntervalSince(time) <= 0 {
            return .dhuhr
        } else if sunrise.timeIntervalSince(time) <= 0 {
            return .sunrise
        } else if fajr.timeIntervalSince(time) <= 0 {
            return .fajr
        }
        
        return nil
    }
    
    public func nextPrayer(at time: Date = Date()) -> Prayer? {
        if isha.timeIntervalSince(time) <= 0 {
            return nil
        } else if maghrib.timeIntervalSince(time) <= 0 {
            return .isha
        } else if asr.timeIntervalSince(time) <= 0 {
            return .maghrib
        } else if dhuhr.timeIntervalSince(time) <= 0 {
            return .asr
        } else if sunrise.timeIntervalSince(time) <= 0 {
            return .dhuhr
        } else if fajr.timeIntervalSince(time) <= 0 {
            return .sunrise
        }
        
        return .fajr
    }
    
    public func time(for prayer: Prayer) -> Date {
        switch prayer {
        case .fajr:
            return fajr
        case .sunrise:
            return sunrise
        case .dhuhr:
            return dhuhr
        case .asr:
            return asr
        case .maghrib:
            return maghrib
        case .isha:
            return isha
        }
    }
}
