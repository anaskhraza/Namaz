//
//  Coordinates.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 9/15/20.
//  Copyright © 2020 Anas khurshid. All rights reserved.
//

import Foundation

public struct Coordinates: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var latitudeAngle: Angle {
        return Angle(latitude)
    }
    
    var longitudeAngle: Angle {
        return Angle(longitude)
    }
}
