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
    
    func myPickerViewDidSelectRow(selectRowValue: String?, additionalParam: String?) {
        textField1.text = String(selectRowValue!)
        self.selectedRowValue = String(additionalParam!)
    }
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    
    
    
    @IBAction func pushForSearchCity(_ sender: Any) {

        self.performSegue(withIdentifier: "showSearchViewController", sender: self)
    }
    
    var pickerOficinas: CustomPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var myEnglishArray: [NSDictionary] = []
        if let URL = Bundle.main.url(forResource: "CountriesDictionary", withExtension: "plist") {
            if let englishFromPlist = NSArray(contentsOf: URL) as? [NSDictionary] {
                myEnglishArray = englishFromPlist
            }
        }
        
        
        let myPickerView: UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 300))
        let toolBarControl = ToolbarControl()
        myPickerView.backgroundColor = .white
        pickerOficinas = CustomPickerView(data: myEnglishArray)
        myPickerView.dataSource = pickerOficinas //note: myPickerView is the outlet of type UIPickerView in your ViewController
        myPickerView.delegate = pickerOficinas
        //HERE'S THE PROPERTY from our PickerView subclass that will point to this ViewController's protocol methods that we implemented. From the MyPickerViewProtocol
        pickerOficinas.propertyThatReferencesThisViewController = self
        
        textField1.inputView = myPickerView
        textField1.inputAccessoryView = toolBarControl.initiateToolBar()
//        textField2.delegate = self
        textField2.isUserInteractionEnabled = false
 
//        self.view.addSubview(myPickerView)
//        myPickerView.center = self.view.center
        // Do any additional setup after loading the view.
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

