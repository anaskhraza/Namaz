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
    let locationManager = LocationManager()
    
    func myPickerViewDidSelectRow(pickerView: UIPickerView, selectRowValue: String?, additionalParam: String?) {
        if(pickerView.tag == 1) {
        textField1.text = String(selectRowValue!)
        self.selectedRowValue = String(additionalParam!)
        } else {
            textField3.text = String(selectRowValue!)
        }
    }
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    
    @IBOutlet var autoLocationSwitch: UISwitch!
    @IBOutlet var shafiMadhab: UISwitch!
    @IBOutlet var hanafiMadhab: UISwitch!
    
    
    @IBAction func pushForSearchCity(_ sender: Any) {

        self.performSegue(withIdentifier: "showSearchViewController", sender: self)
    }
    
    var pickerOficinas: CustomPickerView!
    var pickerOficinas1: CustomPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let config = self.locationManager.utils.parseConfig()
        var myEnglishArray: [NSDictionary] = []
        let calculationList: NSDictionary = getCalculationMethod()
        
        autoLocationSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        shafiMadhab.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        hanafiMadhab.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        autoLocationSwitch.isOn = false
        
       
        
        if let URL = Bundle.main.url(forResource: "CountriesDictionary", withExtension: "plist") {
            if let englishFromPlist = NSArray(contentsOf: URL) as? [NSDictionary] {
                myEnglishArray = englishFromPlist
            }
        }
        
        let myPickerView: UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 300))
        let myPickerView1: UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 300))
        
        let toolBarControl = ToolbarControl()
        let toolBarControl1 = ToolbarControl1()
        
        myPickerView.backgroundColor = .white
        myPickerView.tag = 1
        myPickerView.dataSource = pickerOficinas //note: myPickerView is the outlet of type UIPickerView in your ViewController
        myPickerView.delegate = pickerOficinas
        
        myPickerView1.tag = 2
        myPickerView1.dataSource = pickerOficinas1 //note: myPickerView is the outlet of type UIPickerView in your ViewController
        myPickerView1.delegate = pickerOficinas1
        
        pickerOficinas = CustomPickerView(data: myEnglishArray)
        pickerOficinas1 = CustomPickerView(data: calculationList)
        
        pickerOficinas.propertyThatReferencesThisViewController = self
        pickerOficinas1.propertyThatReferencesThisViewController = self
        
        textField1.inputView = myPickerView
        textField3.inputView = myPickerView1
        textField1.inputAccessoryView = toolBarControl.initiateToolBar()
        textField3.inputAccessoryView = toolBarControl1.initiateToolBar1()
        
        
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
    
    @objc func donePicker1() {
        textField3.resignFirstResponder()
        if((textField3.text) != nil) {
            textField2.isUserInteractionEnabled = true
        }
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        let _ = value
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

