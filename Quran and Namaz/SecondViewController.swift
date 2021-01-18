//
//  SecondViewController.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 9/7/20.
//  Copyright © 2020 Anas khurshid. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, CustomPickerViewProtocol, UITextFieldDelegate {
    
    var selectedRowValue: String?
    
    func myPickerViewDidSelectRow(pickerView: UIPickerView, selectRowValue: String?, additionalParam: String?) {
        textField1.text = String(selectRowValue!)
        self.selectedRowValue = String(additionalParam!)
    }
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    
    @IBOutlet var autoLocationSwitch: UISwitch!
    
    
    @IBAction func pushForSearchCity(_ sender: Any) {

        self.performSegue(withIdentifier: "showSearchViewController", sender: self)
    }
    
    var pickerOficinas: CustomPickerView!
    var pickerOficinas1: CustomPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoLocationSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        autoLocationSwitch.isOn = false
        
        var myEnglishArray: [NSDictionary] = []
        let calculationList: NSDictionary = getCalculationMethod()
        if let URL = Bundle.main.url(forResource: "CountriesDictionary", withExtension: "plist") {
            if let englishFromPlist = NSArray(contentsOf: URL) as? [NSDictionary] {
                myEnglishArray = englishFromPlist
            }
        }
        
        
        let myPickerView: UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 300))
        let myPickerView1: UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 300))
        let toolBarControl = ToolbarControl()
        myPickerView.backgroundColor = .white
        myPickerView.tag = 1
        
        pickerOficinas = CustomPickerView(data: myEnglishArray)
        
        pickerOficinas1 = CustomPickerView(data: calculationList)
        
        myPickerView.dataSource = pickerOficinas //note: myPickerView is the outlet of type UIPickerView in your ViewController
        myPickerView.delegate = pickerOficinas
        
        myPickerView1.dataSource = pickerOficinas1 //note: myPickerView is the outlet of type UIPickerView in your ViewController
        myPickerView1.delegate = pickerOficinas1
        
        pickerOficinas.propertyThatReferencesThisViewController = self
        pickerOficinas1.propertyThatReferencesThisViewController = self
        
        textField1.inputView = myPickerView
        textField3.inputView = myPickerView1
        myPickerView1.tag = 2
        
        textField1.inputAccessoryView = toolBarControl.initiateToolBar()
        textField3.inputAccessoryView = toolBarControl.initiateToolBar()
        
        textField2.isUserInteractionEnabled = false
 
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    @objc func donePicker() {
        textField1.resignFirstResponder()
        if((textField1.text) != nil) {
            textField2.isUserInteractionEnabled = true
        }
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        let _ = value
        // Do something
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
//        let _: String! = "HELLO"

           // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC = segue.destination as! SearchViewController
        destinationVC.countryCode = self.selectedRowValue
        destinationVC.callBack = { result in
            self.textField2.text = result
            self.textField2.resignFirstResponder()
        }
        
    }
    


}

