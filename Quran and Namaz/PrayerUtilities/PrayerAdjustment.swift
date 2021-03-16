//
//  PrayerAdjustment.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 9/15/20.
//  Copyright © 2020 Anas khurshid. All rights reserved.
//

import Foundation

/* Adjustment value for prayer times, in minutes */
public struct PrayerAdjustments: Codable, Equatable {
    public var fajr: Minute
    public var sunrise: Minute
    public var dhuhr: Minute
    public var asr: Minute
    public var maghrib: Minute
    public var isha: Minute
    
    public init(fajr: Minute = 0, sunrise: Minute = 0, dhuhr: Minute = 0, asr: Minute = 0, maghrib: Minute = 0, isha: Minute = 0) {
        self.fajr = fajr
        self.sunrise = sunrise
        self.dhuhr = dhuhr
        self.asr = asr
        self.maghrib = maghrib
        self.isha = isha
    }
}
