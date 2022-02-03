//
//  ThemeManager.swift
//  AppticsDemo
//
//  Created by Saravanan S on 10/08/21.
//

import Apptics

class APColorSwift: NSObject {
    
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
    
    class func isDarkMode() -> Bool {
        if #available(iOS 13, *) {
            let traits = UITraitCollection.current
//            print("traits.userInterfaceStyle \(traits.userInterfaceStyle.rawValue)")
            if traits.userInterfaceStyle == .dark {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}

class AppThemeManager: NSObject{
    @objc public static var shared = AppThemeManager()
    
    var isDarkMode : Bool {
        return APColorSwift.isDarkMode()
    }
    var darkStrong : UIColor {
        return .black
    }
    var darkWeak : UIColor {
        return .black
    }
    var lightWeak : UIColor {
        return .white
    }
    var lightStrong : UIColor {
        return .white
    }
    
    var title : UIColor {
        return (isDarkMode) ? .white : .black
    }
    var text : UIColor {
        return (isDarkMode) ? .white : .black
    }
    var barButton : UIColor {
        return (isDarkMode) ? .white : .black
    }
    
    
    
}
// TODO: Check theme colors
class AppFeedbackTheme: NSObject, APFeedbackTheme {
    var isDarkMode: Bool {
        return AppThemeManager.shared.isDarkMode
    }

    func viewBGColor() -> UIColor? {
        return isDarkMode ? AppThemeManager.shared.darkStrong : AppThemeManager.shared.lightWeak
    }
    
    func textFieldTextColor() -> UIColor? {
        return AppThemeManager.shared.title
    }
    
    func textViewTextColor() -> UIColor? {
        return AppThemeManager.shared.title
    }
    
    func textFieldPlaceholderColor() -> UIColor? {
        return AppThemeManager.shared.title
    }
    // TODO: Both places have replaced searchBarPlaceHolderText with just text! Check color
    func textViewPlaceholderColor() -> UIColor? {
        return AppThemeManager.shared.text
    }
    // TODO: Both places have replaced searchBarPlaceHolderText with just text! Check color
    func accessoryViewBGColor() -> UIColor? {
        return isDarkMode ? AppThemeManager.shared.darkWeak : AppThemeManager.shared.lightWeak
    }
    
    func accessoryHeaderTextColor() -> UIColor? {
        return AppThemeManager.shared.title
    }
    
    func accessorySubHeaderTextColor() -> UIColor? {
        return AppThemeManager.shared.title
    }
}

class AppTheme: NSObject, APTheme {
    func translucent() -> Bool {
        return false
    }
    var isDarkMode: Bool {
        AppThemeManager.shared.isDarkMode
    }

    func barTintColor() -> UIColor? {
        return isDarkMode ? AppThemeManager.shared.darkWeak : AppThemeManager.shared.lightWeak
    }
    
    func tintColor() -> UIColor? {
        return AppThemeManager.shared.barButton
    }
//    @available(iOS 13.0, *)
    func standardAppearance() -> UINavigationBarAppearance{
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        return appearance
    }
    func titleTextAttributes() -> [AnyHashable : Any]? {
        return [NSAttributedString.Key.foregroundColor: AppThemeManager.shared.title]
    }
    
    func barButtontitleTextAttributes() -> [AnyHashable : Any]? {
        return [NSAttributedString.Key.foregroundColor: AppThemeManager.shared.title]
    }
}

