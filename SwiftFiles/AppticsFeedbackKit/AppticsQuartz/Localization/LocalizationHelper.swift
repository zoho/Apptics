//
//  LocalizationHelper.swift
//  
//
//  Created by Jaffer Sheriff Usman on 21/05/25.
//

//import Foundation
//import AppticsFeedbackKit
//
//
//enum QuartzKitStrings {
//    static func localized(_ key: String, comment: String = "") -> String {
//        NSLocalizedString(key, bundle: .module, comment: comment)
//    }
//}



import Foundation
import AppticsFeedbackKit

enum QuartzKitStrings {
    static func localized(_ key: String, comment: String = "") -> String {
        FeedbackKit.getLocalizableString(forKey: key)!
    }
}
