//
//  CustomPickerView.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 03/01/2021.
//  Copyright © 2021 Anas khurshid. All rights reserved.
//

import Foundation
import UIKit


protocol CustomPickerViewProtocol {
    func myPickerViewDidSelectRow(selectRowValue:String?, additionalParam:String?)
}

extension CustomPickerViewProtocol {
    func myPickerViewDidSelectRow(selectRowValue:String?) {
        myPickerViewDidSelectRow(selectRowValue: selectRowValue, additionalParam:nil)
    }
}



class CustomPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    var oficinas: [NSDictionary] = []
    
    convenience init(data: [NSDictionary]) {
        self.init()
        oficinas = data
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return oficinas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          let row = oficinas[row]
        return row["name"]! as? String
       }

    var someArray = [Int]()
    //This Property points to the ViewController conforming to the protocol. This property will only be able to access the stuff you put in the protocol. It won't access everything in your ViewController
    var propertyThatReferencesThisViewController:CustomPickerViewProtocol?

    //didSelectRow UIPickerView Delegate method that apple gives us
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //get your picker values that you need
        let theRowValue = oficinas[row]
        propertyThatReferencesThisViewController?.myPickerViewDidSelectRow(selectRowValue: theRowValue["name"]! as? String, additionalParam: theRowValue["iso2"] as? String)

        //the ViewController func will be called passing the row value along
    }
}
