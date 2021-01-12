//
//  Sunnah.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 9/15/20.
//  Copyright © 2020 Anas khurshid. All rights reserved.
//

import Foundation

/* Sunnah times for a location and date using the given prayer times.
 All prayer times are in UTC and should be displayed using a DateFormatter that
 has the correct timezone set. */
public struct SunnahTimes {
    
    /* The midpoint between Maghrib and Fajr */
    public let middleOfTheNight: Date
    
    /* The beginning of the last third of the period between Maghrib and Fajr,
     a recommended time to perform Qiyam */
    public let lastThirdOfTheNight: Date
    
    public init?(from prayerTimes: PrayerTimes) {
        guard let date = Calendar.gregorianUTC.date(from: prayerTimes.date),
            let nextDay = Calendar.gregorianUTC.date(byAdding: .day, value: 1, to: date),
            let nextDayPrayerTimes = PrayerTimes(
                coordinates: prayerTimes.coordinates,
                date: Calendar.gregorianUTC.dateComponents([.year, .month, .day], from: nextDay),
                calculationParameters: prayerTimes.calculationParameters)
            else {
                // unable to determine tomorrow prayer times
                return nil
        }
        
        let nightDuration = nextDayPrayerTimes.fajr.timeIntervalSince(prayerTimes.maghrib)
        self.middleOfTheNight = prayerTimes.maghrib.addingTimeInterval(nightDuration / 2).roundedMinute()
        self.lastThirdOfTheNight = prayerTimes.maghrib.addingTimeInterval(nightDuration * (2 / 3)).roundedMinute()
    }
}
