//
//  MyTabBarController.swift
//  Quran and Namaz
//
//  Created by PSA User on 12/01/2021.
//  Copyright © 2021 Anas khurshid. All rights reserved.
//

import Foundation
import UIKit


class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
 override func viewDidLoad() {
    self.selectedIndex = 0
    
  }
    public func setTabBarControl(index: Int!) {
        self.selectedIndex = index
    }
}
