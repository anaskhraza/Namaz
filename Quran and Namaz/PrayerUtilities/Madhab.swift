//
//  Madhab.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 9/15/20.
//  Copyright © 2020 Anas khurshid. All rights reserved.
//

import Foundation

/* Madhab for determining how Asr is calculated */
public enum Madhab: Int, Codable, CaseIterable {
    
    // Also for Maliki, Hanbali, and Jafari
    case shafi = 1
    
    case hanafi = 2
    
    var shadowLength: Double {
        return Double(self.rawValue)
    }
}
