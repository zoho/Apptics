//  FloatingSetup.swift
//  MyFramework
//  Created by jai-13322 on 06/07/22.

import Foundation
import UIKit
import AppticsFeedbackKit

//MARK: Window setup for button
@objc public class FloatingBottomWindow: UIWindow {
    
    public var views: UIView?
    
    public func isAppticsWindow() -> ObjCBool
    {
        return true
    }
    
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

//MARK: Window setup


@available(iOS 11.0, *)
@objc public class FloatingBottomView:UIViewController,UIGestureRecognizerDelegate{
    public lazy var window = FloatingBottomWindow()
    var floatingscrollController: FloatScrollview?
    var height: CGFloat = 110
    var yValue:CGFloat?
    var count = 0
    var floatview = FloatingView()
    var fileArray = [URL]()
    var filesCount = 0
    public var sceneAlertWindow: UIWindow!
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.bttnCheckBadgeCount), name:Notification.Name(notificationbadgereloadKey) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.imagecloseFromreportBug), name:Notification.Name("com.appticssdkWindowClose") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewHideandDismiss), name:Notification.Name(notificationviewHideandDismiss) , object: nil)
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
    
//MARK: set color for the text in view // need to add theme switch inbetween
    
    func setTextColorInViews(textColor:UIColor){
        floatview.cancelBttn.setTitleColor(textColor, for: .normal)
        floatview.snapBttn.setTitleColor(textColor, for: .normal)
        floatview.screenshotBttn.setTitleColor(textColor, for: .normal)
        floatview.cancelImage.setTitleColor(textColor, for: .normal)
        floatview.snapImage.setTitleColor(textColor, for: .normal)
        floatview.screenshotsImage.setTitleColor(textColor, for: .normal)
    }

    func setTitleTextAttributesInButtons(textAttributes:NSDictionary){
        floatview.cancelBttn.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
        floatview.snapBttn.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
        floatview.screenshotBttn.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
        floatview.cancelImage.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
        floatview.snapImage.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
        floatview.screenshotsImage.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
    }
    
    //MARK: change theme accouding to traits
    
    func checkTheme(){
        
        FeedbackKit.listener().refreshTheme()
//        setTextColorInViews(textColor: FeedbackTheme.sharedInstance.tintColor)
        setTitleTextAttributesInButtons(textAttributes: FeedbackTheme.sharedInstance.barButtontitleTextAttributes)
    }
    
//MARK: hide view for next dismiss 1action
    @objc func viewHideandDismiss(){
        DispatchQueue.main.async {
            self.floatview.isHidden = true
        }
        
    }
    
//MARK: Notification for close reportBug screens 2action
    @objc func imagecloseFromreportBug() {
        DispatchQueue.main.async {
            self.window.isHidden = true
            self.window.removeFromSuperview()
            FeedbackKit.listener().feedback_KitScreenCancel = "ZAScreenCancel"
            FeedbackKit.listener().feedback_KitType = "ZAScreenShotCancel"
            clearAllImages()
            FeedbackKit.startMonitoring()
        }
        
    }
    
//MARK: Make window a root viewController
    func setRootViewController(){
        window.windowLevel = UIWindow.Level.alert
        window.isHidden = false
        window.rootViewController = self
        window.makeKeyAndVisible()
    }
    
//MARK: Notification for check bage count after deletion of image in curosel view
    @objc func bttnCheckBadgeCount() {
        getallImages()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        FeedbackKit.stopMonitoring()
        loadFontForCPResourceBundle()
        addFloatingView()
    }
  
//MARK: Bottom floating view setup
    
    public func addFloatingView() {
        var xvalue = 20.0
        var width = view.frame.size.width - 40
        if TargetDevice.currentDevice == .iPhone {
            height = view.frame.size.height/10
            yValue = view.frame.size.height - 110
            xvalue = 20
        }
        else if TargetDevice.currentDevice == .iPad{
            height = view.frame.size.height/10
            yValue = view.frame.size.height - 150
            xvalue = 20
        }
        else{
            height = view.frame.size.height/10
            yValue = view.frame.size.height
            width = view.frame.size.width - 100
            xvalue = 300
        }
        floatview = FloatingView(frame: CGRect(x: xvalue, y:yValue!, width:width, height:height))
        floatview.cancelImage.addTarget(self, action:#selector(self.cancellbuttonClicked), for: .touchUpInside)
        floatview.screenshotsImage.addTarget(self, action:#selector(self.viewScreenshotbuttonClicked), for: .touchUpInside)
        floatview.snapImage.addTarget(self, action:#selector(self.snapbuttonClicked), for: .touchUpInside)
        floatview.cancelBttn.addTarget(self, action:#selector(self.cancellbuttonClicked), for: .touchUpInside)
        floatview.snapBttn.addTarget(self, action:#selector(self.snapbuttonClicked), for: .touchUpInside)
        floatview.screenshotBttn.addTarget(self, action:#selector(self.viewScreenshotbuttonClicked), for: .touchUpInside)
        setLocalizableString()
//        setTextColorInViews(textColor: FeedbackTheme.sharedInstance.tintColor)
        setTitleTextAttributesInButtons(textAttributes: FeedbackTheme.sharedInstance.barButtontitleTextAttributes)
        view.addSubview(floatview)
        window.views = floatview
                
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panDidMove(pan:)))
        pan.delegate = self
        floatview.addGestureRecognizer(pan)
        bottomPanelColor()
        getallImages()
        self.floatview.center.y += self.floatview.frame.height
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [.curveEaseIn],animations: {
            self.floatview.center.y -= self.floatview.frame.height + 40
        })
        
    }
 //MARK: change bottom panel border color and width
    func bottomPanelColor(){
        if FeedbackTheme.sharedInstance.setTransparencySettingsEnabled  == false{
            view.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.floatview.mainView.bounds
            floatview.mainView.addSubview(blurEffectView)
            floatview.mainView.sendSubviewToBack(blurEffectView)
            blurEffectView.layer.cornerRadius = 10
            blurEffectView.layer.masksToBounds = true
            blurEffectView.layer.borderWidth = 2
            blurEffectView.layer.borderColor = UIColor.clear.cgColor
        } else {
            floatview.cardView.backgroundColor = FeedbackTheme.sharedInstance.ViewColor
        }
    }
    
    @objc fileprivate func panDidMove(pan: UIPanGestureRecognizer) {
        let offset = pan.translation(in: view)
        pan.setTranslation(CGPoint.zero, in: view)
        var center = floatview.center
        center.x += offset.x
        center.y += offset.y
        floatview.center = center
        if pan.state == .ended || pan.state == .cancelled {
            UIView.animate(withDuration: 0.3) {
                self.floatingViewPanTopBottom()
            }
        }
    }
    //MARK: Floating button position in Window
    public func floatingViewPanTopBottom() {
        var bestSocket = CGPoint.zero
        var distanceToBestSocket = CGFloat.infinity
        let center = floatview.center
        for socketTB in panSockets {
            let distance = hypot(center.x - socketTB.x, center.y - socketTB.y)
            if distance < distanceToBestSocket {
                distanceToBestSocket = distance
                bestSocket = socketTB
            }
        }
        floatview.center = bestSocket
    }

//MARK: place floating button 4 sides
    public var panSockets: [CGPoint] {
        let buttonSize = floatview.bounds.size
        let rect = view.bounds.insetBy(dx: 2 + buttonSize.width / 2, dy: 2 + buttonSize.height / 2)
        let sockets: [CGPoint] = [
            CGPoint(x: rect.minX + 15, y: rect.minY + 80),
            CGPoint(x: rect.minX + 15, y: rect.maxY - 50),
            CGPoint(x: rect.maxX - 15, y: rect.minY + 80),
            CGPoint(x: rect.maxX - 15, y: rect.maxY - 50)
        ]
        return sockets
    }
//MARK: strings for localization
    func setLocalizableString(){
        floatview.snapBttn.setTitle(FeedbackKit.getLocalizableString(forKey: "zanalytics.feedback.navbar.title.snap"), for: .normal)
        floatview.cancelBttn.setTitle(FeedbackKit.getLocalizableString(forKey: "zanalytics.feedback.privacy.consent.cancel"), for: .normal)
        floatview.screenshotBttn.setTitle(FeedbackKit.getLocalizableString(forKey: "zanalytics.feedback.navbar.title.screenshots"), for: .normal)
    }
    
//MARK: shake badge Label
    func shakeLabel(count : Float = 3,for duration : TimeInterval = 0.3,withTranslation translation : Float = 6) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        floatview.badgeLabel.layer.add(animation, forKey: "shakes")
    }
    
//MARK: hide view on cancel click
    
    func floatviewHide(){
        
        UIView.animate(withDuration: 1.20, animations: {
            self.floatview.center.y += self.view.frame.height
        }) { (completed) in
            if completed {
                FeedbackKit.listener().feedback_KitScreenCancel = "ZAScreenCancel"
                FeedbackKit.listener().feedback_KitType = "ZAScreenShotCancel"
                FeedbackKit.startMonitoring()
                clearAllImages()
                self.filesCount = 0

            }
        }
        
        
        
        
        
        
        
//        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseOut],animations: {
//        })
    }
    
//MARK: show alert for window
    
    func showErrorMessage(title:String,message:String) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: FeedbackKit.getLocalizableString(forKey: "zanalytics.bug.alert.detectscreen.yes"), style: UIAlertAction.Style.cancel, handler: { _ in
            
            self.floatviewHide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.window.isHidden = true
            }
        }))
        alertController.addAction(UIAlertAction(title: FeedbackKit.getLocalizableString(forKey: "zanalytics.feedback.privacy.consent.cancel")!, style: UIAlertAction.Style.default, handler: { _ in
            alertWindow.isHidden = true
        }))
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: Alert for scene window present
    func checkAlertForScene(title:String,message:String){
        if #available(iOS 13.0, *) {
            if let currentWindowScene = UIApplication.shared.connectedScenes.first as?  UIWindowScene {
                sceneAlertWindow = UIWindow(windowScene: currentWindowScene)
                sceneAlertWindow?.windowLevel = UIWindow.Level.alert + 1
                sceneAlertWindow?.rootViewController = UIViewController()
                sceneAlertWindow?.makeKeyAndVisible()
                let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: FeedbackKit.getLocalizableString(forKey: "zanalytics.bug.alert.detectscreen.yes"), style: UIAlertAction.Style.cancel, handler: { _ in
                    self.floatviewHide()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.window.isHidden = true
                        self.window.removeFromSuperview()
                        self.sceneAlertWindow.isHidden = true
                        self.sceneAlertWindow.removeFromSuperview()
                    }
                }))
                alertController.addAction(UIAlertAction(title: FeedbackKit.getLocalizableString(forKey: "zanalytics.feedback.privacy.consent.cancel")!, style: UIAlertAction.Style.default, handler: { _ in
                    self.sceneAlertWindow.isHidden = true
                }))
                sceneAlertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                
            }
        } else {
            showErrorMessage(title: FeedbackKit.getLocalizableString(forKey: "zanalytics.feedback.navbar.title.feedback")!, message: FeedbackKit.getLocalizableString(forKey: "zanalytics.bug.alert.quitfeedback")!)
        }
    }
    
    
    //MARK: Cancel Button Click Action
    @objc func cancellbuttonClicked() {
        if #available(iOS 13.0, *) {
            checkAlertForScene(title: FeedbackKit.getLocalizableString(forKey: "zanalytics.feedback.navbar.title.feedback")!, message: FeedbackKit.getLocalizableString(forKey: "zanalytics.bug.alert.quitfeedback")!)
        } else {
            showErrorMessage(title: FeedbackKit.getLocalizableString(forKey: "zanalytics.feedback.navbar.title.feedback")!, message: FeedbackKit.getLocalizableString(forKey: "zanalytics.bug.alert.quitfeedback")!)
        }
        
    }
    
    
    //MARK: Button Take ScreenShot Action
    @objc func snapbuttonClicked(_ sender:UIButton) {
        if count <= 9{
            sender.preventRepeatedPress()
            window.isHidden = true
            _ = saveImage(image: screenshot())
            window.isHidden = false
            count = (count + 1)
            if count == 0{
                floatview.badgeLabel.isHidden = true
            }
            else{
                floatview.badgeLabel.isHidden = false
            }
            floatview.badgeLabel.text = "\(count)"
            self.shakeLabel()
        }
        
    }
    //MARK: open screenshots page
    @objc func viewScreenshotbuttonClicked() {
        if count > 0{
            floatingscrollController = FloatScrollview()
        }
    }
    
    //MARK: Screenshot Flash Animation
    func ScreenshotFlashEffect(duration:CGFloat) {
        let screenshotView = UIView()
        screenshotView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(screenshotView)
        let constraints:[NSLayoutConstraint] = [
            screenshotView.topAnchor.constraint(equalTo: view.topAnchor),
            screenshotView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenshotView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenshotView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        screenshotView.backgroundColor = UIColor.white
        UIView.animate(withDuration: duration, animations: {
            screenshotView.alpha = 0
        }) { _ in
            screenshotView.removeFromSuperview()
        }
    }
    
//MARK: Take Screenshot Method
    func screenshot() -> UIImage {
        let imageSize = UIScreen.main.bounds.size as CGSize
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        for obj : AnyObject in UIApplication.shared.windows {
            if let window = obj as? UIWindow {
                if window.responds(to: #selector(getter: UIWindow.screen)) || window.screen == UIScreen.main {
                    context!.saveGState();
                    context!.translateBy(x: window.center.x, y: window.center
                        .y);
                    context!.concatenate(window.transform);
                    context!.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x,
                                         y: -window.bounds.size.height * window.layer.anchorPoint.y);
                    window.layer.render(in: context!)
                    context!.restoreGState();
                }
            }
        }
        ScreenshotFlashEffect(duration: 0.4)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
    
    //MARK: save image to cache folder
    public func saveImage(image:UIImage) -> URL? {
        let  image = UIApplication.shared.takeScreenshot()
        let resizedpic = image!.resize(targetSize: CGSize(width: view.frame.size.width  , height: view.frame.size.height))
        guard let imageData = resizedpic.jpegData(compressionQuality: 0.25) else {
            return nil
        }
        do {
            let imageURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("Appticssdk\(setDate()).png")
            try imageData.write(to: imageURL)
            return imageURL
        } catch {
            return nil
        }
    }
    
    //MARK: get current date
    func setDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMMM-yyyy-HH-mm-ss"
        return formatter.string(from: date).capitalized
    }
    
    
    
    //MARK: Get All Images from Directory
    func getallImages(){
        fileArray.removeAll()
        let docsDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.path
        let dirEnum = FileManager.default.enumerator(atPath: docsDir)
        while let file = dirEnum?.nextObject() as? String {
            if file.hasPrefix("Appticssdk") == true{
                let fileUrl = URL(fileURLWithPath: docsDir.appending("/\(file)"))
                filesCount = (filesCount + 1)
                fileArray.append(fileUrl)
            }
        }
        count = fileArray.count
        floatview.badgeLabel.text = "\(fileArray.count)"
        if count == 0{
            floatview.badgeLabel.isHidden = true
        }
        else{
            floatview.badgeLabel.isHidden = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(notificationbadgereloadKey), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("com.appticssdkWindowClose"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(notificationviewHideandDismiss), object: nil)

    }
}


//MARK: Screenshot Extension Methods

extension UIApplication {
    func getKeyWindow() -> UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene })
                .flatMap({ $0 as? UIWindowScene })?.windows
                .first(where: \.isKeyWindow)
        } else {
            return keyWindow
        }
    }
    
    public  func takeScreenshot() -> UIImage? { return getKeyWindow()?.layer.takeScreenshot() }
}


extension CALayer {
    public func takeScreenshot() -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }
    
}

extension UIView {
    func takeScreenshot() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: frame.size)
            return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: true) }
        } else {
            return layer.takeScreenshot()
        }
    }
}

extension UIImage {
    convenience init?(snapshotOf view: UIView) {
        guard let image = view.takeScreenshot(), let cgImage = image.cgImage else { return nil }
        self.init(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}

