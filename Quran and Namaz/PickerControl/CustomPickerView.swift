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
    func myPickerViewDidSelectRow(pickerView: UIPickerView,selectRowValue:String?, additionalParam:String?)
}

extension CustomPickerViewProtocol {
    func myPickerViewDidSelectRow(pickerView: UIPickerView, selectRowValue:String?) {
        myPickerViewDidSelectRow(pickerView: pickerView, selectRowValue: selectRowValue, additionalParam:nil)
    }
}



class CustomPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    var oficinas: [NSDictionary] = []
    var calMethod: NSDictionary = [:]
    
    convenience init(data: [NSDictionary]) {
        self.init()
        oficinas = data
    }
    
    convenience init(data: NSDictionary) {
        self.init()
        calMethod = data
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1) {
            return oficinas.count
        } else {
            return calMethod.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1) {
            let row = oficinas[row]
            return row["name"]! as? String
            
        } else {
            let keys = calMethod.allKeys
            return keys[row] as? String
        }
    }
    
    var someArray = [Int]()
    //This Property points to the ViewController conforming to the protocol. This property will only be able to access the stuff you put in the protocol. It won't access everything in your ViewController
    var propertyThatReferencesThisViewController:CustomPickerViewProtocol?
    
    //didSelectRow UIPickerView Delegate method that apple gives us
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //get your picker values that you nee
        let pickerView1: UIPickerView = pickerView
        if(pickerView.tag == 1) {
            let theRowValue = oficinas[row]
            propertyThatReferencesThisViewController?.myPickerViewDidSelectRow(pickerView: pickerView1 ,selectRowValue: theRowValue["name"]! as? String, additionalParam: theRowValue["iso2"] as? String)
            
        } else {
            let key = calMethod.allKeys[row]
            let value = calMethod.allValues[row]
            propertyThatReferencesThisViewController?.myPickerViewDidSelectRow(pickerView: pickerView1 ,selectRowValue: key as? String, additionalParam: value as? String)
        }
        
        
        
        
        //the ViewController func will be called passing the row value along
    }
}
