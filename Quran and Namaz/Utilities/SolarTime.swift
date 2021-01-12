//
//  SolarTime.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 9/15/20.
//  Copyright © 2020 Anas khurshid. All rights reserved.
//

import Foundation

struct SolarTime {
    let date: DateComponents
    let observer: Coordinates
    let solar: SolarCoordinates
    let transit: DateComponents
    let sunrise: DateComponents
    let sunset: DateComponents
    
    private let prevSolar: SolarCoordinates
    private let nextSolar: SolarCoordinates
    private let approxTransit: Double
    
    init?(date: DateComponents, coordinates: Coordinates) {
        // calculations need to occur at 0h0m UTC
        var date = date
        date.hour = 0
        date.minute = 0
        
        guard let currentDate = Calendar.gregorianUTC.date(from: date),
            let nextDate = Calendar.gregorianUTC.date(byAdding: .day, value: 1, to: currentDate),
            let previousDate = Calendar.gregorianUTC.date(byAdding: .day, value: -1, to: currentDate) else {
                return nil
        }
        
        let nextDay = Calendar.gregorianUTC.dateComponents([.year, .month, .day], from: nextDate)
        let previousDay = Calendar.gregorianUTC.dateComponents([.year, .month, .day], from: previousDate)
        
        let prevSolar = SolarCoordinates(julianDay: Astronomical.julianDay(dateComponents: previousDay))
        let solar = SolarCoordinates(julianDay: Astronomical.julianDay(dateComponents: date))
        let nextSolar = SolarCoordinates(julianDay: Astronomical.julianDay(dateComponents: nextDay))
        let m0 = Astronomical.approximateTransit(longitude: coordinates.longitudeAngle, siderealTime: solar.apparentSiderealTime, rightAscension: solar.rightAscension)
        let solarAltitude = Angle(-50.0 / 60.0)
        
        self.date = date
        self.observer = coordinates
        self.solar = solar
        self.prevSolar = prevSolar
        self.nextSolar = nextSolar
        self.approxTransit = m0
        
        
        let transitTime = Astronomical.correctedTransit(approximateTransit: m0, longitude: coordinates.longitudeAngle, siderealTime: solar.apparentSiderealTime,
                                                        rightAscension: solar.rightAscension, previousRightAscension: prevSolar.rightAscension, nextRightAscension: nextSolar.rightAscension)
        let sunriseTime = Astronomical.correctedHourAngle(approximateTransit: m0, angle: solarAltitude, coordinates: coordinates, afterTransit: false, siderealTime: solar.apparentSiderealTime,
                                                          rightAscension: solar.rightAscension, previousRightAscension: prevSolar.rightAscension, nextRightAscension: nextSolar.rightAscension,
                                                          declination: solar.declination, previousDeclination: prevSolar.declination, nextDeclination: nextSolar.declination)
        let sunsetTime = Astronomical.correctedHourAngle(approximateTransit: m0, angle: solarAltitude, coordinates: coordinates, afterTransit: true, siderealTime: solar.apparentSiderealTime,
                                                         rightAscension: solar.rightAscension, previousRightAscension: prevSolar.rightAscension, nextRightAscension: nextSolar.rightAscension,
                                                         declination: solar.declination, previousDeclination: prevSolar.declination, nextDeclination: nextSolar.declination)
        
        guard let transitDate = date.settingHour(transitTime), let sunriseDate = date.settingHour(sunriseTime), let sunsetDate = date.settingHour(sunsetTime) else {
            return nil
        }
        
        self.transit = transitDate
        self.sunrise = sunriseDate
        self.sunset = sunsetDate
    }
    
    func timeForSolarAngle(_ angle: Angle, afterTransit: Bool) -> DateComponents? {
        let hours = Astronomical.correctedHourAngle(approximateTransit: approxTransit, angle: angle, coordinates: observer, afterTransit: afterTransit, siderealTime: solar.apparentSiderealTime,
                                                    rightAscension: solar.rightAscension, previousRightAscension: prevSolar.rightAscension, nextRightAscension: nextSolar.rightAscension,
                                                    declination: solar.declination, previousDeclination: prevSolar.declination, nextDeclination: nextSolar.declination)
        return date.settingHour(hours)
    }
    
    // hours from transit
    func afternoon(shadowLength: Double) -> DateComponents? {
        // TODO source shadow angle calculation
        let tangent = Angle(fabs(observer.latitude - solar.declination.degrees))
        let inverse = shadowLength + tan(tangent.radians)
        let angle = Angle(radians: atan(1.0 / inverse))
        
        return timeForSolarAngle(angle, afterTransit: true)
    }
}
