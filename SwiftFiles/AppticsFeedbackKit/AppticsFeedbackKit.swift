//
//  NewFeedbackKitListner.swift
//  AppticsFeedbackKitSwift
//
//  Created by jai-13322 on 29/11/22.
//

import Foundation
import AppticsFeedbackKit
import Apptics


extension FeedbackKit{
    
    
//MARK: start screen recording action from newbugviewcontroller
    @objc public func start_ScreenRecord(){
        guard let topVC = UIApplication.shared.topMostViewController(),
              let navigationController = topVC.navigationController else {
            print("Navigation controller not found.")
            return
        }
        QuartzKit.configure(delegate: QuartzDataProvider())
        let newVC = IssueRecordingViewController()
        newVC.delegate = self
        navigationController.pushViewController(newVC, animated: true)
        
    }

//MARK: stop screen recording

    @objc public func stop_ScreenRecord(){
        _ = ScreenRecordEditViewController()
        
    }
    
//MARK: Theme Refresh

    @objc public func refreshTheme(){
        if let tintColor = APThemeManager.sharedFeedbackThemeManager().tintColor?(){
            FeedbackTheme.sharedInstance.tintColor = tintColor
        }else if let tintColor = APThemeManager.defaultFeedbackThemeManager().tintColor?(){
            FeedbackTheme.sharedInstance.tintColor = tintColor
        }
        
        if let barButtontitleTextAttributes = APThemeManager.sharedFeedbackThemeManager().barButtontitleTextAttributes?(){
            FeedbackTheme.sharedInstance.barButtontitleTextAttributes = barButtontitleTextAttributes as NSDictionary
            
            if let barButtontitleTextAttributes = barButtontitleTextAttributes as? [NSAttributedString.Key : Any]{
                if let forgroundColor = barButtontitleTextAttributes[.foregroundColor] as? UIColor {
                    FeedbackTheme.sharedInstance.maskColor = forgroundColor
                }
            }
                                                              
        }else if let barButtontitleTextAttributes = APThemeManager.defaultFeedbackThemeManager().barButtontitleTextAttributes?(){
            FeedbackTheme.sharedInstance.barButtontitleTextAttributes = barButtontitleTextAttributes as NSDictionary
            
            if let barButtontitleTextAttributes = barButtontitleTextAttributes as? [NSAttributedString.Key : Any]{
                if let forgroundColor = barButtontitleTextAttributes[.foregroundColor] as? UIColor {
                    FeedbackTheme.sharedInstance.maskColor = forgroundColor
                }
            }
        }
        
        if let viewBgcolor = APThemeManager.sharedFeedbackThemeManager().viewBGColor?(){
            FeedbackTheme.sharedInstance.ViewColor = viewBgcolor
        }else if let viewBgcolor = APThemeManager.defaultFeedbackThemeManager().viewBGColor?(){
            FeedbackTheme.sharedInstance.ViewColor = viewBgcolor
        }
        
        if let textcolor = APThemeManager.sharedFeedbackThemeManager().textFieldTextColor?()  {
            FeedbackTheme.sharedInstance.textColor = textcolor
        }else if let textcolor = APThemeManager.defaultFeedbackThemeManager().textFieldTextColor?()  {
            FeedbackTheme.sharedInstance.textColor = textcolor
        }
        
    }

//MARK: open multiple screen shot floating window

    @objc public func swift_load(){
        if #available(iOS 11.0, *) {
            loadFontForCPResourceBundle()
            refreshTheme()
            FeedbackTheme.sharedInstance.setTransparencySettingsEnabled = FeedbackKit.listener().setTransparencyStatus
            FeedbackTheme.sharedInstance.setMaskTextDefault = FeedbackKit.listener().maskText
            FeedbackTheme.sharedInstance.isfromClass = "FloatScreenshotEditor"
            _ = FloatingBottomView()
        }
    }
    
//MARK: load editor window from newbugviewcontroller for text feedback attachment edit.

    @objc public func getGalleryImages_swift(){
        loadFontForCPResourceBundle()
        refreshTheme()
        if let imageData = UserDefaults.standard.object(forKey: "apptics_imageGallery_swift") as? Data,
         let image = UIImage(data: imageData) {
            FeedbackTheme.sharedInstance.gotImageFromgallery = image
        }
        FeedbackTheme.sharedInstance.setTransparencySettingsEnabled = FeedbackKit.listener().setTransparencyStatus
        FeedbackTheme.sharedInstance.setMaskTextDefault = FeedbackKit.listener().maskText
        FeedbackTheme.sharedInstance.isfromClass = "apptics_ScreenshotImageEditorView"
        if #available(iOS 11.0, *) {
            _ = FloatScreenshotEditor()
        } 
    }
        
    

}



//MARK: Pre setting  data for quartz from getupdates API

struct QuartzDataProvider: QuartzKitDelegate{
    
    
    
    var workspace: String { "\(FeedbackKit.listener().quartzworkspace)" }
    
    var department: String { "\(FeedbackKit.listener().quartzdepartment)" }
    
    var subDomain: String { "\(FeedbackKit.listener().quartzdomain)" }
    
    var shouldRecordNetworkLogs: Bool { true }
 
    
//    var theme: QuartzTheme? {
//        
//        var primaryColorLight: UIColor?
//        var colorOnPrimaryLight: UIColor?
//        var primaryColorDark: UIColor?
//        var colorOnPrimaryDark: UIColor?
//        var switchtintcolor: UIColor?
//        
//        
//        
//        
//        
//        if let switchtint_Color = APThemeManager.sharedFeedbackThemeManager().switchTintColor?(){
//            switchtintcolor = switchtint_Color
//        }else if let switchtint_Color = APThemeManager.defaultFeedbackThemeManager().switchTintColor?(){
//            switchtintcolor = switchtint_Color
//        }
//        
//        if let tintColorprimaryColorDark = APThemeManager.sharedFeedbackThemeManager().recordingprimaryColorDark?(){
//            primaryColorDark = tintColorprimaryColorDark
//        }else if let tintColorprimaryColorDark = APThemeManager.defaultFeedbackThemeManager().recordingprimaryColorDark?(){
//            primaryColorDark = tintColorprimaryColorDark
//        }
//        
//        if let tintColorprimaryColorLight = APThemeManager.sharedFeedbackThemeManager().recordingprimaryColorLight?(){
//            primaryColorLight = tintColorprimaryColorLight
//        }else if let tintColorprimaryColorLight = APThemeManager.defaultFeedbackThemeManager().recordingprimaryColorLight?(){
//            primaryColorLight = tintColorprimaryColorLight
//        }
//        
//        
//        if let tintColorOnPrimaryDark = APThemeManager.sharedFeedbackThemeManager().recordingcolorOnPrimaryDark?(){
//            colorOnPrimaryDark = tintColorOnPrimaryDark
//        }else if let tintColorOnPrimaryDark = APThemeManager.defaultFeedbackThemeManager().recordingcolorOnPrimaryDark?(){
//            colorOnPrimaryDark = tintColorOnPrimaryDark
//        }
//        
//        if let tintColorOnPrimaryLight = APThemeManager.sharedFeedbackThemeManager().recordingcolorOnPrimaryLight?(){
//            colorOnPrimaryLight = tintColorOnPrimaryLight
//        }else if let tintColorOnPrimaryLight = APThemeManager.defaultFeedbackThemeManager().recordingcolorOnPrimaryLight?(){
//            colorOnPrimaryLight = tintColorOnPrimaryLight
//        }
//        
//        let colorSchemeLight = QuartzColorScheme(primaryThemeColor: primaryColorLight!, switchOnTintColor: switchtintcolor!, txtColorOnPrimaryColorBG: colorOnPrimaryLight!)
//        
//        let colorSchemeDark = QuartzColorScheme(primaryThemeColor: primaryColorDark!, switchOnTintColor: switchtintcolor!, txtColorOnPrimaryColorBG: colorOnPrimaryDark!)
//
//
//        return QuartzTheme(colorScheme: colorSchemeLight, darkColorScheme: colorSchemeDark, uiMode: .systemDefault)
//        
//
//
//    }
    
    
    var theme: QuartzTheme? {
        var primaryColorLight: UIColor?
        var colorOnPrimaryLight: UIColor?
        var primaryColorDark: UIColor?
        var colorOnPrimaryDark: UIColor?
        var switchtintcolor: UIColor?

        if let switchtint_Color = APThemeManager.sharedFeedbackThemeManager().switchTintColor?() {
            switchtintcolor = switchtint_Color
        } else if let switchtint_Color = APThemeManager.defaultFeedbackThemeManager().switchTintColor?() {
            switchtintcolor = switchtint_Color
        }

        if let tintColorprimaryColorDark = APThemeManager.sharedFeedbackThemeManager().recordingprimaryColorDark?() {
            primaryColorDark = tintColorprimaryColorDark
        } else if let tintColorprimaryColorDark = APThemeManager.defaultFeedbackThemeManager().recordingprimaryColorDark?() {
            primaryColorDark = tintColorprimaryColorDark
        }

        if let tintColorprimaryColorLight = APThemeManager.sharedFeedbackThemeManager().recordingprimaryColorLight?() {
            primaryColorLight = tintColorprimaryColorLight
        } else if let tintColorprimaryColorLight = APThemeManager.defaultFeedbackThemeManager().recordingprimaryColorLight?() {
            primaryColorLight = tintColorprimaryColorLight
        }

        if let tintColorOnPrimaryDark = APThemeManager.sharedFeedbackThemeManager().recordingprimaryColorDarkStartLabelcolor?() {
            colorOnPrimaryDark = tintColorOnPrimaryDark
        } else if let tintColorOnPrimaryDark = APThemeManager.defaultFeedbackThemeManager().recordingprimaryColorDarkStartLabelcolor?() {
            colorOnPrimaryDark = tintColorOnPrimaryDark
        }

        if let tintColorOnPrimaryLight = APThemeManager.sharedFeedbackThemeManager().recordingprimaryColorLightStartLabelcolor?() {
            colorOnPrimaryLight = tintColorOnPrimaryLight
        } else if let tintColorOnPrimaryLight = APThemeManager.defaultFeedbackThemeManager().recordingprimaryColorLightStartLabelcolor?() {
            colorOnPrimaryLight = tintColorOnPrimaryLight
        }

        let lightPrimary = primaryColorLight ?? UIColor.white
        let darkPrimary = primaryColorDark ?? UIColor.black
        let lightOnPrimary = colorOnPrimaryLight ?? UIColor.white
        let darkOnPrimary = colorOnPrimaryDark ?? UIColor.black
        let switchTintColor = switchtintcolor ?? UIColor.red

        let colorSchemeLight = QuartzColorScheme(primaryThemeColor: lightPrimary, switchOnTintColor: switchTintColor, txtColorOnPrimaryColorBG: lightOnPrimary)
        let colorSchemeDark = QuartzColorScheme(primaryThemeColor: darkPrimary, switchOnTintColor: switchTintColor, txtColorOnPrimaryColorBG: darkOnPrimary)

        return QuartzTheme(colorScheme: colorSchemeLight, darkColorScheme: colorSchemeDark, uiMode: .systemDefault)
    }

    
    
    
    
    
    
}
