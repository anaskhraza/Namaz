//
//  ThirdViewController.swift
//  Quran and Namaz
//
//  Created by PSA User on 20/01/2021.
//  Copyright © 2021 Anas khurshid. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet var ivCompassBack: UIImageView!
    @IBOutlet var ivCompassNeedle: UIImageView!
    
    var compassManager  : CompassDirectionManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        compassManager =  CompassDirectionManager(dialerImageView: ivCompassBack, pointerImageView: ivCompassNeedle)
        compassManager.initManager()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
