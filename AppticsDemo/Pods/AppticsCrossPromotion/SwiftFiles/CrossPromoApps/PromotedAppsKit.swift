//
//  PromotedAppsKit.swift
//  Pods
//
//  Created by Prakash R on 10/09/20.
//

import Foundation
import UIKit
import Apptics

@objc public protocol PromotedAppsKitDelegate : NSObjectProtocol {
    
    @objc func promoAppselected(crossPromoId:NSNumber, status: NSNumber) // This is to send call back of what app is selected.
    @objc func ap_openURL(url: URL)
    @objc func ap_canOpenURL(url: URL) -> Bool
    
}

@objcMembers
@objc public class PromotedAppsKit: NSObject, PromotedAppsKitDelegate{
           
       @objc public static var shared: PromotedAppsKit = {
            let instance = PromotedAppsKit()
       
            return instance
        }()
    
    @objc public var delegate : PromotedAppsKitDelegate?
    @objc public static var callback : CrossPromoCallbacks = APSwiftCallbackHandlers.crosspromocallbacks
//    var textColour : UIColor?
//    var bgColour : UIColor?
    var sectionLabel1 : String?
    var sectionLabel2 : String?
    var promotedAppsController : PromotedAppsController?
    
    @objc public var hasInternet : Bool = Analytics.getInstance().isReachable()
    @objc public func presentPromotedAppsController(sectionHeader1:String? , sectionHeader2:String?) {
        let vc = self.getPromotionalAppsViewController(sectionHeader1: sectionHeader1, sectionHeader2: sectionHeader2)
        Analytics.getInstance().presentPromotionalAppsController(vc)
    }
    @objc public func getPromotionalAppsViewController(sectionHeader1:String? , sectionHeader2:String?) -> UIViewController {
//        self.bgColour = bgColor
//        self.textColour = textColour
        
//        PromotedAppsKit.loadFontWith(name: "icon")
        loadFontForCPResourceBundle()
        self.sectionLabel1 = sectionHeader1
        self.sectionLabel2 = sectionHeader2
        let bundler = self.getcurrentBundle()
        let vc = PromotedAppsController.init(nibName: "PromotedAppsController", bundle: bundler)
        vc.awakeFromNib()
        vc.delegate = self
//        vc.delegate = self.delegate
        vc.hasInternet = self.hasInternet
        vc.isRefresh = false
        let response = Analytics.getInstance().getPromotionalAppsData { appsData in
            self.refreshPromotedAppsList(data: appsData as! NSObject)
        }
        vc.loadScreenWith(AppsData: response as NSObject, sectionHeader1: sectionHeader1, sectionHeader2: sectionHeader2)
        self.promotedAppsController = vc
        return vc
        
    }        
    
    public func ap_canOpenURL(url: URL) -> Bool {
//        if let bool = self.delegate?.ap_canOpenURL(url: url) {
        let bool = Analytics.getInstance().ap_canOpenURL(with: url)
        return bool
    }
    
    public func promoAppselected(crossPromoId: NSNumber, status: NSNumber) {

//        self.delegate?.promoAppselected(crossPromoId: crossPromoId, status: status)
        Analytics.getInstance().promoAppselected(withCrossPromoId: crossPromoId, status: status)
    }
    
    public func ap_openURL(url: URL) {            
//        self.delegate?.ap_openURL(url: url)
        Analytics.getInstance().ap_openURL(with: url)
    }
    
    func getcurrentBundle() -> Bundle {
        
        let bundle = Bundle(for: type(of: self))
        if let url = bundle.url(forResource: "Apptics_SwiftResources", withExtension: "bundle") {
        if let bundl = Bundle.init(url: url) {
        return bundl
            }
        }
        return bundle
    }
    
    
    public func refreshPromotedAppsList(data:NSObject) {
        
        if let vc = promotedAppsController {
        vc.dataSource = []
//        vc.noData = false
        vc.isRefresh = true
            vc.loadScreenWith(AppsData: data,sectionHeader1: self.sectionLabel1,sectionHeader2: self.sectionLabel2)
        }
    }
            
    func loadFontForCPResourceBundle() {
        let fontName = "Apptics-CP"
            let resourceBundle = getcurrentBundle()
            guard let url = resourceBundle.url(forResource: fontName, withExtension: "ttf") else {
//                print("could not find font file")
                return
            }
            guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
//                print("Could not create font data provider for \(url).")
                return
            }
            guard let font = CGFont(fontDataProvider) else {
//                print("could not create font")
                return
            }
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
//                print(error!.takeUnretainedValue())
            }
        }
        
}

extension PromotedAppsKit{
    @objc public class func presentPromotedAppsController(sectionHeader1:String? , sectionHeader2:String?) {
        if AppticsConfig.default.enableCrossPromotionAppsList{
            let vc = self.getPromotionalAppsViewController(sectionHeader1: sectionHeader1, sectionHeader2: sectionHeader2)
            Analytics.getInstance().presentPromotionalAppsController(vc)
        }else{
#if DEBUG
            print("Please enable Cross Promotion Apps List in Apptic or AppticsConfig.default.enableCrossPromotionAppsList")
#endif
        }
    }
    
    @objc public class func getPromotionalAppsViewController(sectionHeader1:String? , sectionHeader2:String?) -> UIViewController {
        let crossPromotionKit = PromotedAppsKit.shared
        let vc = crossPromotionKit.getPromotionalAppsViewController(sectionHeader1: sectionHeader1, sectionHeader2: sectionHeader2)
        return vc
    }
}
