//
//  Config.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 16/03/2021.
//  Copyright © 2021 Anas khurshid. All rights reserved.
//

import Foundation

struct Config: Decodable {
    private enum CodingKeys: String, CodingKey {
        case useLocation, madhab, calculationMethod,dateAdjustment,country,city,latitude,longitude
    }

    let useLocation: Bool
    let madhab: Int
    let calculationMethod: String
    let dateAdjustment: Int
    let country: String
    let city: String
    let latitude: String
    let longitude: String
}
