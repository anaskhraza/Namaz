//
//  HighAltitudeRule.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 9/15/20.
//  Copyright © 2020 Anas khurshid. All rights reserved.
//

import Foundation

/**
 Rule for approximating Fajr and Isha at high latitudes
 *Values*
 **middleOfTheNight**
 Fajr won't be earlier than the midpoint of the night and isha won't be later than the midpoint of the night. This is the default
 value to prevent fajr and isha crossing boundaries.
 **seventhOfTheNight**
 Fajr is at the end of the first seventh of the night and isha is at the beginning of the last seventh of the night. This is
 recommended to use for locations above 55° latitude to prevent prayer times that would be difficult to perform.
 **twilightAngle**
 The night is divided into portions of roughly 1/3. The exact value is derived by dividing the fajr/isha angles by 60.
 This can be used to prevent difficult fajr and isha times at locations below 55° latitude.
 */
public enum HighLatitudeRule: String, Codable, CaseIterable {
    case middleOfTheNight
    case seventhOfTheNight
    case twilightAngle
}
