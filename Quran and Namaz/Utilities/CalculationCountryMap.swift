//
//  CalculationCountryMap.swift
//  Quran and Namaz
//
//  Created by PSA User on 14/01/2021.
//  Copyright © 2021 Anas khurshid. All rights reserved.
//

import Foundation

/* Madhab for determining how Asr is calculated */
public struct CalculationMap {
    
    public func selectCalculationMethod(countryCode: String!) -> CalculationParameters? {
        switch(countryCode) {
        case "QA":
            return CalculationMethod.qatar.params
        case "EG":
            return CalculationMethod.egyptian.params
        case "PK":
            return CalculationMethod.karachi.params
        case "SA":
            return CalculationMethod.ummAlQura.params
        case "AE":
            return CalculationMethod.dubai.params
        case "US":
            return CalculationMethod.northAmerica.params
        case "KW":
            return CalculationMethod.kuwait.params
        case "CA":
            return CalculationMethod.northAmerica.params
        case "SG":
            return CalculationMethod.singapore.params
        case "TR":
            return CalculationMethod.turkey.params
        case "IR":
            return CalculationMethod.tehran.params
        default:
            return CalculationMethod.muslimWorldLeague.params
    }
        
    }
    
}
