//
//  utils.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 16/03/2021.
//  Copyright © 2021 Anas khurshid. All rights reserved.
//

import Foundation

class Utils {
    public func parseConfig() -> Config {
        let url = Bundle.main.url(forResource: "Config", withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        return try! decoder.decode(Config.self, from: data)
    }
}
