//
//  File.swift
//  Apptics_Swift
//
//  Created by Prakash R on 28/10/20.
//

import Foundation
import UIKit

class ZAColorSwift: NSObject {
    
    class func setAppearanceForDark(_ dark: UIColor, light: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            let traits = UITraitCollection.current
            if traits.userInterfaceStyle == .dark {
                return dark
            } else {
                return light
            }
        } else {
            return light
        }
    }
}

@objcMembers
@objc public class APThemeSwiftManager : NSObject {
    
  @objc public static var crosspromotheme = CrossPromoTheme()
    
   @objc public static var sharedTheme = APThemeSwift()
    
//    @objc public static let instance = APThemeSwiftManager()
    
//    func instance() ->  APThemeSwiftManager {
//
//        if let themeManager = themeManagerSwift {
//            return themeManager
//        } else {
//            self.themeManagerSwift = APThemeSwiftManager()
//            return themeManagerSwift!
//        }
//
//
//    }
//    func sharedThemeManagerSwift() -> APThemeSwift {
//
//        if let theme = sharedTheme {
//            return theme
//        } else {
//           sharedTheme = APThemeSwift()
//            return sharedTheme!
//        }
//
//    }
    
//    func crossPromoTheme() -> CrossPromoTheme {
//
////        if let theme = crosspromotheme {
////            return theme
////        } else {
//            return CrossPromoTheme()
////        }
//
//    }
    
//    func setTheme(_ theme : APThemeSwift) {
//
//        self.sharedTheme = theme
//
//    }
    
//    func setCrossPromoTheme(_ theme : CrossPromoTheme) {
//
//        APThemeSwiftManager.crosspromotheme = theme
//
//    }
    
    
    
    
}


protocol APThemeSwiftDelegate : NSObject {
    
    #if !TARGET_OS_OSX
    var tintColor : UIColor? { get set }
    var barTintColor : UIColor? { get set}
    var translucent : Bool? {get set}
    var titleTextAttributes : [NSAttributedString.Key : Any]? {get set}
    var barButtontitleTextAttributes : [NSAttributedString.Key : Any]? {get set}
    
//    func getTintColor() -> UIColor?
//    func getBarTintColor() -> UIColor?
//    func getTranslucent() -> Bool?
//    func getTitleTextAttributes() -> [NSAttributedString.Key : Any]?
//    func getBarButtontitleTextAttributes() -> [NSAttributedString.Key : Any]?
//    func za_traitCollectionDidChange(_ previousTraitCollection : UITraitCollection)
    #endif
    
}

@objcMembers
@objc open class APThemeSwift: NSObject, APThemeSwiftDelegate {
    
    #if !TARGET_OS_OSX && !TARGET_OS_WATCH
    
    open var tintColor : UIColor?
    open var barTintColor : UIColor?
    open var translucent : Bool?
    open var titleTextAttributes : [NSAttributedString.Key : Any]?
    open var barButtontitleTextAttributes : [NSAttributedString.Key : Any]?
    
    
    
    #endif
    
}


@objcMembers
@objc open class CrossPromoTheme : APThemeSwift {
    
    
    #if !TARGET_OS_OSX && !TARGET_OS_WATCH
    
    private var _contentBGColor : UIColor?
    open var contentBGColor : UIColor? {
        get {
            return self._contentBGColor
        }
        set {
            self._contentBGColor = newValue
        }
    }

    open var leftBarButtonItem : UIBarButtonItem?
    
    open var viewBGColor : UIColor?

    open var cellTextFont : UIFont?

    open var cellBGColor : UIColor?
 
    open var cellTextColor : UIColor?
 
    open var footerTextColor : UIColor?
   
    open var footerTextFont : UIFont?
  
    open var lineSpacing : CGFloat = 5
    
    open var switchOnTintColor : UIColor?
    
    open var switchOffTintColor : UIColor?
   
    open var switchThumbTintColor : UIColor?
    
    open var switchTintColor : UIColor?
    
    open var buttonBGColor : UIColor?
    
    open var buttonTextColor : UIColor?
    
    open var switchScale : CGFloat = 1
   
    open var tableViewSeparatorColor : UIColor?
    
    open var preferredContentSize : CGSize = CGSize(width: 414, height: 740)

    open var fontName : String?
   
    open var cellCaptionFont : UIFont?
    
    open var sectionHeaderTextFont : UIFont?
    
    open var sectionHeaderTextColor : UIColor?
    
    open var sectionHeaderBGColor : UIColor?
   
    open var viewAllAppsTextColor : UIColor?
    
    #endif
    
}

@objcMembers
@objc public class APSwiftCallbackHandlers : NSObject {
    @objc public static var crosspromocallbacks = CrossPromoCallbacks.shared
}

@objcMembers
@objc open class CrossPromoCallbacks : NSObject{
    
    static var shared: CrossPromoCallbacks = {
            let instance = CrossPromoCallbacks()
            return instance
        }()
    
    public typealias CompletionBlock = (NSError?) -> Void
    @objc public var failure: CompletionBlock = { error in }
}
