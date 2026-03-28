//
//  QuartzGlobalHelpers.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 15/04/24.
//

import UIKit

var iPad : Bool
{
    return UIDevice.current.userInterfaceIdiom == .pad
}

func openApplicationSetting(){
    if let url = URL.init(string: UIApplication.openSettingsURLString) {
        let application = UIApplication.shared
        if application.canOpenURL(url) {
            application.open(url)
        }
    }
}
