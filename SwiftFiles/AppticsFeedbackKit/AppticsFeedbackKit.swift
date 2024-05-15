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


//ipad             let imageURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("Apptics01-December-2022-12-19-20.png")

//            let imageURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("Apptics01-December-2022-12-42-00.png")
//            print(imageURL)
//            FeedbackTheme.sharedInstance.imageLocation = imageURL
//            screenshoteditor = FloatScreenshotEditor()
