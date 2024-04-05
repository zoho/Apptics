//
//  ScreenshotView.swift
//  MyFramework
//
//  Created by jai-13322 on 21/07/22.
//imageSendFromReportBug

import Foundation
import UIKit
import AppticsFeedbackKit

//MARK: Window setup
public class FloatingscreenshotWindow: UIWindow {
    public var views: UIView?
    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
        self.windowLevel = UIWindow.Level.normal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let button = views else { return false }
        let buttonPoint = convert(point, to: button)
        return button.point(inside: buttonPoint, with: event)
    }
    
}

@available(iOS 11.0, *)
public class FloatScrollview:UIViewController{
    public lazy var window = FloatingscreenshotWindow()
    public var ScreenshotsView = ScreenShotView()
    public var sceneOverlayWindow: UIWindow!
    var floatingscrollController: FloatScreenshotEditor?
    var arrayofGalleryImages: NSMutableArray = []
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
        if #available(iOS 13.0, *) {
            if window.windowScene != nil{
                setRootViewController()
            }else{
                if let currentWindowScene = UIApplication.shared.connectedScenes.first as?  UIWindowScene {
                    window.windowScene = currentWindowScene
                    window.windowLevel = UIWindow.Level.alert
                    window.rootViewController = self
                    window.makeKeyAndVisible()
                }
                else{
                    setRootViewController()
                }
            }
        } else {
            setRootViewController()
        }

    }

//MARK: Make window a root viewController
    func setRootViewController(){
        window.windowLevel = UIWindow.Level.alert
        window.isHidden = false
        window.rootViewController = self
        window.makeKeyAndVisible()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addFloatingView()
    }
    
    
//MARK: theme check in trait
     public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            if #available(iOS 13.0, *) {
                if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                    if traitCollection.userInterfaceStyle == .dark {
                        checkTheme()
                    }
                    else {
                        checkTheme()
                    }
                }
            } else {

            }
        }
//MARK: change theme based on traits
    func checkTheme(){
        
        FeedbackKit.listener().refreshTheme()
        
        ScreenshotsView.pageView.pageIndicatorTintColor = FeedbackTheme.sharedInstance.maskColor.withAlphaComponent(0.5)
        ScreenshotsView.pageView.currentPageIndicatorTintColor = FeedbackTheme.sharedInstance.maskColor
        ScreenshotsView.pageNumberLabel.textColor = FeedbackTheme.sharedInstance.textColor.withAlphaComponent(0.6)
        
//        SetButtonColor()
        setTitleTextAttributesInButtons(textAttributes: FeedbackTheme.sharedInstance.barButtontitleTextAttributes)
    }
    
//MARK: set colors for buttons
    func SetButtonColor(){
        ScreenshotsView.hideBttn.setTitleColor(FeedbackTheme.sharedInstance.tintColor, for: .normal)
        ScreenshotsView.doneBttn.setTitleColor(FeedbackTheme.sharedInstance.tintColor, for: .normal)
        ScreenshotsView.deleteBttn.setTitleColor(FeedbackTheme.sharedInstance.tintColor, for: .normal)
        ScreenshotsView.noDataBttn.setTitleColor(FeedbackTheme.sharedInstance.textColor, for: .normal)
    }
    
    func setTitleTextAttributesInButtons(textAttributes:NSDictionary){
        ScreenshotsView.hideBttn.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
        ScreenshotsView.doneBttn.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
        ScreenshotsView.deleteBttn.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
        ScreenshotsView.noDataBttn.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
    }
//MARK: strings for localization
    func setLocalizableString(){
        ScreenshotsView.doneBttn.setTitle(FeedbackKit.getLocalizableString(forKey: "zanalytics.feedback.navbar.title.compose"), for: .normal)
        ScreenshotsView.hideBttn.setTitle(FeedbackKit.getLocalizableString(forKey: "zanalytics.feedback.common.button.title.back"), for: .normal)
    }
    
    
//MARK: floating view setup
    public func addFloatingView() {
        ScreenshotsView = ScreenShotView(frame: CGRect(x: 0, y: 0, width:view.frame.size.width , height: view.frame.size.height))
        changeScreenshotViewColor(color: FeedbackTheme.sharedInstance.ViewColor)
        ScreenshotsView.doneBttn.addTarget(self, action:#selector(self.donebuttonClicked), for: .touchUpInside)
        ScreenshotsView.hideBttn.addTarget(self, action:#selector(self.cancellbuttonClicked), for: .touchUpInside)
        
//        SetButtonColor()
        setTitleTextAttributesInButtons(textAttributes: FeedbackTheme.sharedInstance.barButtontitleTextAttributes)
        
        ScreenshotsView.noDataBttn.setTitle(FeedbackKit.getLocalizableString(forKey: "zanalytics.feedback.navbar.title.noscreenshots"), for: .normal)
        setLocalizableString()
        view.addSubview(ScreenshotsView)
        window.views = ScreenshotsView
        ScreenshotsView.alpha = 0
        ScreenshotsView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseInOut],animations: {
            self.ScreenshotsView.alpha = 1
            self.ScreenshotsView.transform = .identity
        }, completion: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.imagecloseFromreportBug), name:Notification.Name(notificationReportBugClose) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewHideandDismiss), name:Notification.Name(notificationviewHideandDismiss) , object: nil)

    }
    
//MARK: Notification for close reportBug screens
    @objc func imagecloseFromreportBug() {
        windowCloseReportBug()
       NotificationCenter.default.post(name: Notification.Name("com.appticssdkWindowClose"), object: self)
    }
    
    public func changeScreenshotViewColor(color:UIColor){
        ScreenshotsView.commoninit(color: color, frame: CGRect(x: 0, y: 0, width:view.frame.size.width , height: view.frame.size.height))
        ScreenshotsView.cardView.backgroundColor = .clear
        ScreenshotsView.cardView.layer.borderWidth = 5.0
        ScreenshotsView.pageView.pageIndicatorTintColor = FeedbackTheme.sharedInstance.maskColor.withAlphaComponent(0.5)
        ScreenshotsView.pageView.currentPageIndicatorTintColor = FeedbackTheme.sharedInstance.maskColor
        ScreenshotsView.pageNumberLabel.textColor = FeedbackTheme.sharedInstance.textColor.withAlphaComponent(0.6)
    }
    
//MARK: Compose Button Click Action
    @objc func donebuttonClicked() {
        FeedbackKit.listener().arrayOfimages.removeAllObjects()
        for imgpath in ScreenshotsView.fileArray{
            let image = UIImage(contentsOfFile: imgpath.path) //get image from path
            arrayofGalleryImages.add(image!)
        }
        FeedbackKit.listener().arrayOfimages = arrayofGalleryImages
        FeedbackKit.listener().feedback_KitType = "ZAScreenShot"
        FeedbackKit.listener().feedback_KitScreenCancel = "ZAScreenShotTriggered"
        DispatchQueue.main.async {
            FeedbackKit.setMessageBody("")
            FeedbackKit.showFeedback()
        }
    }
//MARK: Hide Button Click Action
    @objc func cancellbuttonClicked() {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseInOut],animations: {
            FeedbackKit.listener().feedback_KitScreenCancel = "ZAScreenShot_Cancelled"
            FeedbackKit.listener().arrayOfimages.removeAllObjects()
            self.ScreenshotsView.center.y += self.ScreenshotsView.frame.height
        })
        NotificationCenter.default.post(name: Notification.Name(notificationbadgereloadKey), object: self)
        backAction()
    }
    func backAction(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if #available(iOS 13.0, *) {                
                if let _ = self.view.window?.windowScene?.delegate{
                    let keyedWindow = UIApplication.shared.currentUIWindow()
                    keyedWindow?.dismissWindow()
                }
                else{
                    self.window.isHidden = true
                }
            } else {
                self.window.isHidden = true
            }
        }
    }
    
//MARK: Notification for close reportBug screens 2action
    func windowCloseReportBug(){
        self.window.isHidden = true
        self.window.removeFromSuperview()
        FeedbackKit.listener().feedback_KitScreenCancel = "ZAScreenCancel"
        FeedbackKit.listener().feedback_KitType = "ZAScreenShotCancel"
    }
    
//MARK: hide view for next dismiss 1action
    @objc func viewHideandDismiss(){
        self.ScreenshotsView.isHidden = true
    }
}





