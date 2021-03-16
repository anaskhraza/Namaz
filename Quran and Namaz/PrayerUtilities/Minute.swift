//
//  Minute.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 9/15/20.
//  Copyright © 2020 Anas khurshid. All rights reserved.
//

import Foundation

public typealias Minute = Int

internal extension Minute {
    var timeInterval: TimeInterval {
        return TimeInterval(self * 60)
    }
}
