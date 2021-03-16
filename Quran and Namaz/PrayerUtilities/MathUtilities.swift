//
//  MathUtilities.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 9/15/20.
//  Copyright © 2020 Anas khurshid. All rights reserved.
//

import Foundation

internal extension Double {
    
    func normalizedToScale(_ max: Double) -> Double {
        return self - (max * (floor(self / max)))
    }
}
