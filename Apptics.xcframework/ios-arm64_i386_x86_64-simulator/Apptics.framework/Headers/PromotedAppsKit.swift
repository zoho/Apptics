//
//  PromotedAppsKit.swift
//  Pods
//
//  Created by Prakash R on 10/09/20.
//

import Foundation
import UIKit
@objc public protocol PromotedAppsKitDelegate : NSObjectProtocol {
    
    @objc func promoAppselected(crossPromoId:NSNumber, status: NSNumber) // This is to send call back of what app is selected.
    @objc func ap_openURL(url: URL)
    @objc func ap_canOpenURL(url: URL) -> Bool
    
}

@objcMembers
@objc public class PromotedAppsKit: NSObject, PromotedAppsKitDelegate{
           
    @objc public var delegate : PromotedAppsKitDelegate?
    @objc public static var callback : CrossPromoCallbacks = APSwiftCallbackHandlers.crosspromocallbacks
//    var textColour : UIColor?
//    var bgColour : UIColor?
    var sectionLabel1 : String?
    var sectionLabel2 : String?
    var promotedAppsController : PromotedAppsController?
    
    @objc public var hasInternet : Bool = true
    
    @objc public func loadPromotedAppsConntroller(_ response: NSObject, sectionHeader1:String? , sectionHeader2:String?) -> UIViewController {
//        self.bgColour = bgColor
//        self.textColour = textColour
        
//        PromotedAppsKit.loadFontWith(name: "icon")
        self.sectionLabel1 = sectionHeader1
        self.sectionLabel2 = sectionHeader2
        let bundler = self.getcurrentBundle()
        let vc = PromotedAppsController.init(nibName: "PromotedAppsController", bundle: bundler)
        vc.awakeFromNib()
        vc.delegate = self
        vc.delegate = self.delegate
        vc.hasInternet = self.hasInternet
        vc.isRefresh = false
        vc.loadScreenWith(AppsData: response, sectionHeader1: sectionHeader1, sectionHeader2: sectionHeader2)
        self.promotedAppsController = vc
        return vc
        
    }        
    
    public func ap_canOpenURL(url: URL) -> Bool {
        if let bool = self.delegate?.ap_canOpenURL(url: url) {
            return bool
        } else {
            return false
        }
        
    }
    
    public func promoAppselected(crossPromoId: NSNumber, status: NSNumber) {

        self.delegate?.promoAppselected(crossPromoId: crossPromoId, status: status)
        
    }
    
    public func ap_openURL(url: URL) {
        self.delegate?.ap_openURL(url: url)
    }
    
    func getcurrentBundle() -> Bundle {
        
        let bundle = Bundle(for: type(of: self))
        if let url = bundle.url(forResource: "AppticsResources", withExtension: "bundle") {
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
    
}
