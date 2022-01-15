//
//  ViewController.swift
//  AppticsDemo
//
//  Created by Saravanan S on 10/11/21.
//

import UIKit
import Apptics
//import AppticsCrossPromotion
//import Apptics_Swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

   @IBAction func openSettings() {
    Apptics.openAnalyticSettingsController(self.navigationController)
//    PromotedAppsKit.presentPromotedAppsController(sectionHeader1: "Header1", sectionHeader2: "Header2")
    
    }
    
    @IBAction func crash() {
//     Apptics.crash()
//        FeedbackKit.showFeedback()
     }
}

