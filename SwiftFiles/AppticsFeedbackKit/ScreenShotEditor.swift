//
//  ScreenShotEditor.swift
//  MyFramework
//
//  Created by jai-13322 on 02/08/22.
//

import Foundation
import UIKit
import Vision
import AppticsFeedbackKit



//MARK: Window setup
@objcMembers
public class FloatingscreenshotEditorWindow: UIWindow {
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
@objcMembers
public class FloatScreenshotEditor:UIViewController,UIGestureRecognizerDelegate{
    public lazy var window = FloatingscreenshotEditorWindow()
    var floatview = ScreenShotEditorView()
    public var sourceImage = FeedbackTheme.sharedInstance.imageLocation
    public var getImage:URL?
    var img: UIImage?
    var imagevw = UIImageView()
    var iscolorOn = false
    var lastPoint: CGPoint!
    var brush: CGFloat = 3
    let opacity: CGFloat = 0.6
    var red: CGFloat = 255/255.0
    var green: CGFloat = 0/255.0
    var blue: CGFloat = 0/255.0
    var alpha: CGFloat = 1.0
    let btnArrow = UIButton()
    let btncolorpen = UIButton()
    let btnClear = UIButton()
    let bttnBlur = UIButton()
    let btnfullBlur = UIButton()
    let btnColorPalette = UIButton()
    var currentPoint: CGPoint!
    var selectedBtn: UIButton?
    var pencillabelbadge = UILabel()
    var imageviewpathLayer: CALayer?
    var imageWidth: CGFloat = 0
    var imageHeight: CGFloat = 0
    var croppedImage: UIImage!
    var canvasArrow = ZAArrowCanvasView()
    var ZABlurView = ZADragBlurView()
    var lastCheckPoint:CGPoint?
    public var editorSceneOverlayWindow: UIWindow!
    var color1 = UIButton()
    var color2 = UIButton()
    var color3 = UIButton()
    var color4 = UIButton()
    var color5 = UIButton()
    var checkselectedBtn: String?
    var viewPopUpStatus:Bool = false
    var close = UIButton()
    var drawColorView = UIView()
    var drawOptionsView = UIView()
    var gestureForDrawColorView = UIView()
    public var sceneAlertWindow: UIWindow!
    var sizeforview:CGFloat = 55
    var sizeforColorPalette:CGFloat = 100
    var spacingforColorPalette:CGFloat = 10
    var fontSizeForIcon:CGFloat = 30
    var colorCount = 0
    lazy var textDetectionRequest: VNDetectTextRectanglesRequest = {
        let textDetectRequest = VNDetectTextRectanglesRequest(completionHandler: self.handleDetectedText)
        textDetectRequest.reportCharacterBoxes = false
        return textDetectRequest
    }()
    
    lazy var faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleDetectedFaces)
    lazy var observationResults = [VNTextObservation]()
    
    
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
                    editorSceneOverlayWindow = UIWindow(windowScene: currentWindowScene)
                    editorSceneOverlayWindow.windowLevel = UIWindow.Level.alert+1
                    editorSceneOverlayWindow.rootViewController = self
                    editorSceneOverlayWindow.makeKeyAndVisible()
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
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.infinity)
        window.isHidden = false
        window.rootViewController = self
        window.makeKeyAndVisible()
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if TargetDevice.currentDevice == .iPhone {
            fontSizeForIcon = 30.0
        }
        else{
            fontSizeForIcon = 40.0
        }
        addFloatingView()
        if FeedbackTheme.sharedInstance.isfromClass == "apptics_ScreenshotImageEditorView"{
            if FeedbackTheme.sharedInstance.gotImageFromgallery != nil{
                guard let imageobjc = FeedbackTheme.sharedInstance.gotImageFromgallery else {
                    return
                }
                loadpaintView(setImage: imageobjc)
            }
        }
        else{
            if let imagePath = sourceImage?.path {
                guard let image = UIImage(contentsOfFile: imagePath) else {
                    return
                }
                loadpaintView(setImage: image)
            }
        }
        checkTheme()
    }
    
    //MARK: Get image from obj c feedback kit image picker controller
    func GetImageFromgallery()-> UIImage{
        var imgvwImage:UIImage?
        if FeedbackTheme.sharedInstance.gotImageFromgallery != nil{
            if let imageobjc = FeedbackTheme.sharedInstance.gotImageFromgallery{
                imgvwImage = imageobjc
            }
        }
        return imgvwImage!
    }
    
    //MARK: strings for localization
    func setLocalizableString(){
        floatview.doneBttn.setTitle(FeedbackKit.getLocalizableString(forKey: "zanalytics.feedback.navbar.button.title.done"), for: .normal)
        floatview.closeBttn.setTitle(FeedbackKit.getLocalizableString(forKey: "zanalytics.feedback.common.button.title.back"), for: .normal)
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
        
        setTitleTextAttributesInButtons(textAttributes: FeedbackTheme.sharedInstance.barButtontitleTextAttributes)
        
    }
    
    func setTitleTextAttributesInButtons(textAttributes:NSDictionary){
        btnArrow.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
        btncolorpen.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
        bttnBlur.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
        btnClear.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
        btnfullBlur.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
        floatview.doneBttn.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])
        floatview.closeBttn.setAttributedText(attributes: textAttributes as! [NSAttributedString.Key : Any])    }
    
    //MARK: Done Button Click Action
    @objc func donebuttonClicked() {
        blurViewUnselect()
        canvasArrow.unselectAllArrows()
        if (sourceImage?.path) != nil && FeedbackKit.listener().feedback_KitType == "ZAScreenShot" {
            self.saveImagess()
            self.backButtonaction()
            NotificationCenter.default.post(name: Notification.Name(notificationScreenreloadKey), object: self)
        }
        else{
            let image_Capture = imagevw.snapshot
            if let pngRepresentation = image_Capture.pngData() {
                UserDefaults.standard.set(pngRepresentation, forKey: "apptics_imageGallery_swift")
            }
            NotificationCenter.default.post(name: Notification.Name("notificationReloadTbVw"), object: self)
            if FeedbackTheme.sharedInstance.isfromClass == "apptics_ScreenshotImageEditorView"{
                UIView.animate(withDuration: 0.3) {
                    self.floatview.center.y += self.floatview.frame.height + self.floatview.frame.height/1.80
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.floatview.alpha = 0.1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
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
            
        }
    }
    
    
    //MARK: Hide Button Click Action
    @objc func cancellbuttonClicked() {
        if FeedbackTheme.sharedInstance.isfromClass == "apptics_ScreenshotImageEditorView"{
            UIView.animate(withDuration: 0.3) {
                self.floatview.center.y += self.floatview.frame.height + self.floatview.frame.height/1.80
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.floatview.alpha = 0.1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
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
        else{
            backButtonaction()
            NotificationCenter.default.post(name: Notification.Name(notificationScreenreloadKey), object: self)
            
        }
        
    }
    
    //MARK: back clicked
    func backButtonaction(){
        if TargetDevice.currentDevice == .iPhone {
            UIView.animate(withDuration: 0.65, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseInOut],animations: {
                self.drawOptionsView.transform = self.drawOptionsView.transform.translatedBy(x: 0, y: 200)
                self.floatview.doneBttn.transform = self.floatview.doneBttn.transform.translatedBy(x: 0, y: -200)
                self.floatview.closeBttn.transform = self.floatview.closeBttn.transform.translatedBy(x: 0, y: -200)
            }, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
        else {
            UIView.animate(withDuration: 0.3) {
                self.floatview.center.y += self.floatview.frame.height
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.floatview.alpha = 0.1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
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
        
        
        
    }
    
    
    
    
    
    
    //MARK: floating view setup
    
    public func addFloatingView() {
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            floatview = ScreenShotEditorView(frame: CGRect(x: 0, y: 0, width:view.frame.size.width, height: view.frame.size.height ))
            
        }
        else{
            
            if FeedbackTheme.sharedInstance.isfromClass == "apptics_ScreenshotImageEditorView"{
                floatview = ScreenShotEditorView(frame: CGRect(x: 0, y:0, width:view.frame.size.width/1.2, height:view.frame.size.height/1.5))
                
                floatview.center = CGPoint(x: view.frame.size.width  / 2,
                                           y: view.frame.size.height / 2)
            }
            else{
                floatview = ScreenShotEditorView(frame: CGRect(x: 0, y: 0, width:view.frame.size.width, height: view.frame.size.height ))
            }
            
        }
        view.addSubview(floatview)
        changeScreenshotViewColor(color: FeedbackTheme.sharedInstance.ViewColor)
        floatview.closeBttn.addTarget(self, action:#selector(self.cancellbuttonClicked), for: .touchUpInside)
        floatview.doneBttn.addTarget(self, action:#selector(self.donebuttonClicked), for: .touchUpInside)
        setLocalizableString()
        drawOptionsView.isHidden = true
        window.views = floatview
        if FeedbackTheme.sharedInstance.isfromClass == "apptics_ScreenshotImageEditorView"{
            self.floatview.center.y += self.floatview.frame.height
            UIView.animate(withDuration: 0.3) {
                self.floatview.center.y -= self.floatview.frame.height
                self.drawOptionsView.isHidden = false
            }
        }
        else{
            if TargetDevice.currentDevice == .iPhone {
                self.drawOptionsView.transform = self.drawOptionsView.transform.translatedBy(x: 0, y: 100)
                self.floatview.doneBttn.transform = self.floatview.doneBttn.transform.translatedBy(x: 0, y: -100)
                self.floatview.closeBttn.transform = self.floatview.closeBttn.transform.translatedBy(x: 0, y: -100)
            }
            else{
                self.floatview.center.y += self.floatview.frame.height
            }
            changeAlpha(closebttn: floatview.closeBttn, donebttn: floatview.doneBttn, blurbttn: bttnBlur, bttnArrow: btnArrow, bttnClear: btnClear, bttncolorPen: btncolorpen, bttnFullBlur: btnfullBlur, bttnColrPalette: btnColorPalette, alpha: 0)
            if TargetDevice.currentDevice == .iPhone {
                self.imagevw.transform = self.imagevw.transform.scaledBy(x: 0.80, y: 0.80)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: [.curveEaseInOut],animations: {
                        self.imagevw.transform = .identity
                        self.drawOptionsView.isHidden = false
                    }, completion: { success in
                    })
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
                    UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                        self.floatview.doneBttn.transform = .identity
                        self.floatview.closeBttn.transform = .identity
                        self.drawOptionsView.transform = .identity
                        
                    }, completion: nil)
                    self.floatview.doneBttn.layer.add(FadeInAdnimation(), forKey: "fadeIn")
                    self.floatview.closeBttn.layer.add(FadeInAdnimation(), forKey: "fadeIn")
                    self.bttnBlur.layer.add(FadeInAdnimation(), forKey: "fadeIn")
                    self.btnArrow.layer.add(FadeInAdnimation(), forKey: "fadeIn")
                    self.btnClear.layer.add(FadeInAdnimation(), forKey: "fadeIn")
                    self.btncolorpen.layer.add(FadeInAdnimation(), forKey: "fadeIn")
                    self.btnfullBlur.layer.add(FadeInAdnimation(), forKey: "fadeIn")
                    self.btnColorPalette.layer.add(FadeInAdnimation(), forKey: "fadeIn")
                }
            }
            else{
                
                UIView.animate(withDuration: 1.0) {
                    self.floatview.center.y -= self.floatview.frame.height
                    self.drawOptionsView.isHidden = false
                    
                }
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.changeAlpha(closebttn: self.floatview.closeBttn, donebttn: self.floatview.doneBttn, blurbttn: self.bttnBlur, bttnArrow: self.btnArrow, bttnClear: self.btnClear, bttncolorPen: self.btncolorpen, bttnFullBlur: self.btnfullBlur, bttnColrPalette: self.btnColorPalette, alpha: 1.0)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.loadColorPalette()
        }
        
    }
    
    //MARK: change alpha for views
    func changeAlpha (closebttn:UIButton,donebttn:UIButton,blurbttn:UIButton,bttnArrow:UIButton,bttnClear:UIButton,bttncolorPen:UIButton,bttnFullBlur:UIButton,bttnColrPalette:UIButton,alpha:CGFloat){
        
        closebttn.alpha = alpha
        donebttn.alpha = alpha
        blurbttn.alpha = alpha
        bttnArrow.alpha = alpha
        bttnClear.alpha = alpha
        bttncolorPen.alpha = alpha
        bttnFullBlur.alpha = alpha
        bttnColrPalette.alpha = alpha
        
    }
       
    //MARK: change screen view color
    public func changeScreenshotViewColor(color:UIColor){
        floatview.commoninit(color: color)
        floatview.cardView.backgroundColor = .clear
        floatview.mainview.backgroundColor = .clear
        setTitleTextAttributesInButtons(textAttributes: FeedbackTheme.sharedInstance.barButtontitleTextAttributes)
        
//            floatview.doneBttn.setTitleColor(FeedbackTheme.sharedInstance.tintColor, for: .normal)
//            floatview.closeBttn.setTitleColor(FeedbackTheme.sharedInstance.tintColor, for: .normal)
        
        floatview.doneBttn.setAttributedText(attributes: FeedbackTheme.sharedInstance.barButtontitleTextAttributes as! [NSAttributedString.Key : Any])
        floatview.closeBttn.setAttributedText(attributes: FeedbackTheme.sharedInstance.barButtontitleTextAttributes as! [NSAttributedString.Key : Any])
        
    }
     
    //MARK: save image after edit
    func saveImagess()
    {
        let image = imagevw.snapshot
        _ = saveImagess(image: image)
        
    }
    
    @objc func pinchRecognized(pinch: UIPinchGestureRecognizer) {
        
        if let view = pinch.view {
            view.transform = view.transform.scaledBy(x: pinch.scale, y: pinch.scale)
            pinch.scale = 1
        }
    }
    
    @objc func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
        
    }
    
    //MARK: arrow drag gesture
    @objc func dragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            let translation = gestureRecognizer.translation(in: self.view)
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        }
    }
    
    
//MARK: find UIElement in a layer
    func findViewInside<T>(views: [UIView]?, findView: [T] = [], findType: T.Type = T.self) -> [T] {
        var findView = findView
        let views = views ?? []
        guard views.count > .zero else { return findView }
        let firstView = views[0]
        var loopViews = views.dropFirst()
        if let typeView = firstView as? T {
            findView = findView + [typeView]
            return findViewInside(views: Array(loopViews), findView: findView)
        } else if firstView.subviews.count > .zero {
            firstView.subviews.forEach { loopViews.append($0) }
            return findViewInside(views: Array(loopViews), findView: findView)
        } else {
            return findViewInside(views: Array(loopViews), findView: findView)
        }
    }
    
    
//MARK: show alert for Exit window
    
    func showErrorMessage(title:String,message:String) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler: { _ in
            alertWindow.isHidden = true
        }))
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func checkAlertForScene(title:String,message:String){
        if #available(iOS 13.0, *) {
            if let currentWindowScene = UIApplication.shared.connectedScenes.first as?  UIWindowScene {
                sceneAlertWindow = UIWindow(windowScene: currentWindowScene)
                sceneAlertWindow?.windowLevel = UIWindow.Level.alert + 1
                sceneAlertWindow?.rootViewController = UIViewController()
                sceneAlertWindow?.makeKeyAndVisible()
                let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler: { _ in
                    self.sceneAlertWindow.isHidden = true
                    self.sceneAlertWindow.removeFromSuperview()
                }))
                sceneAlertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                
            }
        } else {
            showErrorMessage(title: "Apptics", message: "Save succesfull")
        }
    }
    
    
    //MARK: Load image from source given
    public func getImageLoad(image:URL){
        sourceImage = image
        if let imagePath = sourceImage?.path {
            guard let image = UIImage(contentsOfFile: imagePath) else {
                return
            }
            loadpaintView(setImage: image)
        }
    }
    
    private func addImageView<T: UIImageView>(image: UIImage? = nil) -> T {
        let imageView = T(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        view.addSubview(imageView)
        
        return imageView
    }
    
    //MARK: load paint view with doodle
    public func loadpaintView(setImage:UIImage){
        imagevw.translatesAutoresizingMaskIntoConstraints = false
        imagevw.image = setImage
        imagevw.backgroundColor = .clear
        imagevw.contentMode = .scaleAspectFit
        imagevw.layer.masksToBounds = true
        imagevw.layer.borderColor = UIColor.clear.cgColor
        imagevw.layer.borderWidth = 0.70
        self.floatview.addSubview(imagevw)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageViewhandleTap(_:)))
        floatview.addGestureRecognizer(tap)
        drawOptionsView.translatesAutoresizingMaskIntoConstraints = false
        drawOptionsView.backgroundColor = .clear
        self.floatview.addSubview(drawOptionsView)
        
        btnArrow.translatesAutoresizingMaskIntoConstraints = false
        btnArrow.layer.cornerRadius = 20
//        btnArrow.setTitleColor(FeedbackTheme.sharedInstance.tintColor, for: .normal)
        btnArrow.setAttributedText(attributes: FeedbackTheme.sharedInstance.barButtontitleTextAttributes as! [NSAttributedString.Key : Any])
        btnArrow.addTarget(self, action: #selector(drawArrowView), for: .touchUpInside)
        
        setFontForButton(button: btnArrow, fontName: appticsFontName, title: FontIconText.arrowIcon, size: appFontsize)
        drawOptionsView.addSubview(btnArrow)
        
        btncolorpen.translatesAutoresizingMaskIntoConstraints = false
        btncolorpen.layer.cornerRadius = 20
//        btncolorpen.setTitleColor(FeedbackTheme.sharedInstance.tintColor, for: .normal)
        btncolorpen.setAttributedText(attributes: FeedbackTheme.sharedInstance.barButtontitleTextAttributes as! [NSAttributedString.Key : Any])
        btncolorpen.addTarget(self, action: #selector(colorbuttonClicked), for: .touchUpInside)
        
        setFontForButton(button: btncolorpen, fontName: appticsFontName, title: FontIconText.pencilDraw, size: appFontsize)
        drawOptionsView.addSubview(btncolorpen)
        
        
        bttnBlur.translatesAutoresizingMaskIntoConstraints = false
        bttnBlur.layer.cornerRadius = 20
//        bttnBlur.setTitleColor(FeedbackTheme.sharedInstance.tintColor, for: .normal)
        bttnBlur.setAttributedText(attributes: FeedbackTheme.sharedInstance.barButtontitleTextAttributes as! [NSAttributedString.Key : Any])
        setFontForButton(button: bttnBlur, fontName: appticsFontName, title: FontIconText.blurIcon, size: appFontsize)
        bttnBlur.addTarget(self, action: #selector(blurbuttonclicked), for: .touchUpInside)
        drawOptionsView.addSubview(bttnBlur)
        
        
        btnColorPalette.translatesAutoresizingMaskIntoConstraints = false
        btnColorPalette.layer.cornerRadius = 20
        btnColorPalette.setTitleColor(UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0), for: .normal)
        
        setFontForButton(button: btnColorPalette, fontName: appticsFontName, title: FontIconText.colorPalette, size: appFontsize)

        
        btnColorPalette.addTarget(self, action: #selector(colorPaletteclicked), for: .touchUpInside)
        drawOptionsView.addSubview(btnColorPalette)
        
        
        
        btnClear.translatesAutoresizingMaskIntoConstraints = false
        setFontForButton(button: btnClear, fontName: appticsFontName, title: FontIconText.clearIcon, size: appFontsize)
//        btnClear.setTitleColor(FeedbackTheme.sharedInstance.tintColor, for: .normal)
        btnClear.setAttributedText(attributes: FeedbackTheme.sharedInstance.barButtontitleTextAttributes as! [NSAttributedString.Key : Any])
        btnClear.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        drawOptionsView.addSubview(btnClear)
        
        btnfullBlur.translatesAutoresizingMaskIntoConstraints = false
        btnfullBlur.layer.cornerRadius = 20
//        btnfullBlur.setTitleColor(FeedbackTheme.sharedInstance.tintColor, for: .normal)
        btnfullBlur.setAttributedText(attributes: FeedbackTheme.sharedInstance.barButtontitleTextAttributes as! [NSAttributedString.Key : Any])
        setFontForButton(button: btnfullBlur, fontName: appticsFontName, title: FontIconText.imageMask, size: appFontsize)
        btnfullBlur.addTarget(self, action: #selector(fullBlurClicked), for: .touchUpInside)
        drawOptionsView.addSubview(btnfullBlur)
        
        
        drawOptionsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[arrow]-5-|", options: [], metrics: nil, views: ["arrow":btnArrow]))
        
        drawOptionsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[red]-5-|", options: [], metrics: nil, views: ["red":btncolorpen]))
        
        drawOptionsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[blur]-5-|", options: [], metrics: nil, views: ["blur":bttnBlur]))
        
        drawOptionsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[clear]-5-|", options: [], metrics: nil, views: ["clear":btnClear]))
        
        drawOptionsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[fullBlur]-5-|", options: [], metrics: nil, views: ["fullBlur":btnfullBlur]))
        
        drawOptionsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[colorpalette]-5-|", options: [], metrics: nil, views: ["colorpalette":btnColorPalette]))
        
        var bttnHeight = (view.frame.width/6) - 15
        if TargetDevice.currentDevice == .iPhone {
            self.floatview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[options]-0-|", options: [], metrics: nil, views: ["options":drawOptionsView]))
            sizeforview = 50
            sizeforColorPalette = 40.0
            spacingforColorPalette = 10.0
            self.floatview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-97-[imgv]-26-[options(\(sizeforview))]-40-|", options: [], metrics: nil, views: ["imgv":imagevw, "options":drawOptionsView]))
            imagevw.contentMode = .scaleAspectFit
            self.floatview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-49.5-[imgv]-49-|", options: [], metrics: nil, views: ["imgv":imagevw]))
            drawOptionsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[arrow(\(bttnHeight))]-12-[blur(\(bttnHeight))]-12-[red(\(bttnHeight))]-12-[clear(\(bttnHeight))]-12-[fullBlur(\(bttnHeight))]-12-[colorpalette(\(bttnHeight))]-20-|", options: [], metrics: nil, views: ["red":btncolorpen, "blur": bttnBlur, "clear":btnClear,"fullBlur":btnfullBlur,"arrow":btnArrow,"colorpalette":btnColorPalette]))
        }
        else{
            if FeedbackTheme.sharedInstance.isfromClass == "apptics_ScreenshotImageEditorView"{
                imagevw.contentMode = .scaleAspectFit
            }
            else
            {
                imagevw.contentMode = .scaleToFill
            }
            bttnHeight = bttnHeight - 10
            sizeforview = 80
            sizeforColorPalette = 50.0
            spacingforColorPalette = 40.0
            self.floatview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-103-[imgv]-20-[options(\(sizeforview))]-40-|", options: [], metrics: nil, views: ["imgv":imagevw, "options":drawOptionsView]))
            self.floatview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-75-[imgv]-75-|", options: [], metrics: nil, views: ["imgv":imagevw]))
            
            if FeedbackTheme.sharedInstance.isfromClass == "apptics_ScreenshotImageEditorView"{
                
                self.floatview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[options]-5-|", options: [], metrics: nil, views: ["options":drawOptionsView]))
                
                drawOptionsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[arrow(\(bttnHeight))]-5-[blur(\(bttnHeight))]-5-[red(\(bttnHeight))]-5-[clear(\(bttnHeight))]-5-[fullBlur(\(bttnHeight))]-5-[colorpalette(\(bttnHeight))]-5-|", options: [], metrics: nil, views: ["red":btncolorpen, "blur": bttnBlur, "clear":btnClear,"fullBlur":btnfullBlur,"arrow":btnArrow,"colorpalette":btnColorPalette]))
            }
            else{
                self.floatview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[options]-40-|", options: [], metrics: nil, views: ["options":drawOptionsView]))
                
                drawOptionsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[arrow(\(bttnHeight))]-12-[blur(\(bttnHeight))]-12-[red(\(bttnHeight))]-12-[clear(\(bttnHeight))]-12-[fullBlur(\(bttnHeight))]-12-[colorpalette(\(bttnHeight))]-20-|", options: [], metrics: nil, views: ["red":btncolorpen, "blur": bttnBlur, "clear":btnClear,"fullBlur":btnfullBlur,"arrow":btnArrow,"colorpalette":btnColorPalette]))
                
            }
        }
        
        if FeedbackTheme.sharedInstance.setMaskTextDefault == true{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.openImageRequest()
            }
            buttonSelectedStatus(pencolor: UIColor.clear, blurpenColor: UIColor.clear, arrow: UIColor.clear, masking: FeedbackTheme.sharedInstance.maskColor.withAlphaComponent(0.4))
            btnfullBlur.setTitle(FontIconText.maskSelected, for: .normal)
        }
        else{
            btncolorpen.backgroundColor = FeedbackTheme.sharedInstance.maskColor.withAlphaComponent(0.4)
            checkselectedBtn = "pencilDraw"
            selectedBtn = btncolorpen
            btnfullBlur.isSelected = true
        }
        
    }
    
    //MARK: blur for color palette
    func bottomColorpanel(){
        if !UIAccessibility.isReduceTransparencyEnabled {
            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = drawColorView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.layer.cornerRadius = 10
            blurEffectView.layer.masksToBounds = true
            blurEffectView.layer.borderWidth = 2
            blurEffectView.layer.borderColor = UIColor.clear.cgColor
            drawColorView.addSubview(blurEffectView)
        } else {
            drawColorView.backgroundColor = FeedbackTheme.sharedInstance.ViewColor
        }
        
        
    }
    
    //MARK: Color Palette change pencil color
    func loadColorPalette(){
        bottomColorpanel()
        drawColorView.translatesAutoresizingMaskIntoConstraints = false
        drawColorView.layer.cornerRadius = 5
        self.floatview.addSubview(drawColorView)
        
        color1.translatesAutoresizingMaskIntoConstraints = false
        color1.backgroundColor = UIColor(red: 255.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1.0)
        color1.tag = 94301
        color1.addTarget(self, action: #selector(colorPickerSelected), for: .touchUpInside)
        drawColorView.addSubview(color1)
        
        color2.translatesAutoresizingMaskIntoConstraints = false
        color2.backgroundColor = UIColor(red: 6.0/255, green: 255.0/255, blue: 0.0/255, alpha: 1.0)
        color2.tag = 94302
        color2.addTarget(self, action: #selector(colorPickerSelected), for: .touchUpInside)
        drawColorView.addSubview(color2)
        
        color3.translatesAutoresizingMaskIntoConstraints = false
        color3.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 255.0/255, alpha: 1.0)
        color3.tag = 94303
        color3.addTarget(self, action: #selector(colorPickerSelected), for: .touchUpInside)
        drawColorView.addSubview(color3)
        
        color4.translatesAutoresizingMaskIntoConstraints = false
        color4.tag = 94304
        color4.addTarget(self, action: #selector(colorPickerSelected), for: .touchUpInside)
        color4.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1.0)
        drawColorView.addSubview(color4)
        
        color5.translatesAutoresizingMaskIntoConstraints = false
        color5.tag = 94305
        color5.addTarget(self, action: #selector(colorPickerSelected), for: .touchUpInside)
        color5.backgroundColor = UIColor(red: 255.0/255, green: 255.0/255, blue: 255.0/255, alpha: 1.0)
        drawColorView.addSubview(color5)
        
        close.translatesAutoresizingMaskIntoConstraints = false
        close.tag = 94306
        drawColorView.addSubview(close)
        
        drawColorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[color1]-5-|", options: [], metrics: nil, views: ["color1":color1]))
        drawColorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[color2]-5-|", options: [], metrics: nil, views: ["color2":color2]))
        
        drawColorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[color3]-5-|", options: [], metrics: nil, views: ["color3":color3]))
        
        drawColorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[color4]-5-|", options: [], metrics: nil, views: ["color4":color4]))
        drawColorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[color5]-5-|", options: [], metrics: nil, views: ["color5":color5]))
        
        drawColorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[close]-5-|", options: [], metrics: nil, views: ["close":close]))
        
        let bottomConstant = view.frame.height + 5
        let bttnHeight = 60
        if TargetDevice.currentDevice == .iPad{
            
            drawColorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[color1(60)]-5-|", options: [], metrics: nil, views: ["color1":color1]))
            drawColorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[color2(60)]-5-|", options: [], metrics: nil, views: ["color2":color2]))
            
            drawColorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[color3(60)]-5-|", options: [], metrics: nil, views: ["color3":color3]))
            
            drawColorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[color4(60)]-5-|", options: [], metrics: nil, views: ["color4":color4]))
            drawColorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[color5(60)]-5-|", options: [], metrics: nil, views: ["color5":color5]))
            
            drawColorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[close(60)]-5-|", options: [], metrics: nil, views: ["close":close]))
            drawColorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[color1(\(bttnHeight))]-\(spacingforColorPalette)-[color2(\(bttnHeight))]-\(spacingforColorPalette)-[color3(\(bttnHeight))]-\(spacingforColorPalette)-[color4(\(bttnHeight))]-\(spacingforColorPalette)-[color5(\(bttnHeight))]-\(spacingforColorPalette)-[close(0)]-50-|", options: [], metrics: nil, views: ["color1":color1, "color2": color2, "color3":color3,"color4":color4,"color5":color5,"close":close]))
            setcornerRadius(radius: CGFloat(bttnHeight/2))
            
        }
        else if TargetDevice.currentDevice == .iPhone {
            
            drawColorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-45-[color1(40)]-10-[color2(40)]-10-[color3(40)]-10-[color4(40)]-10-[color5(40)]-10-[close(20)]-45-|", options: [], metrics: nil, views: ["color1":color1, "color2": color2, "color3":color3,"color4":color4,"color5":color5,"close":close]))
            setcornerRadius(radius: 20)
        }
        else{
            setcornerRadius(radius: CGFloat(bttnHeight/2))
        }
        
        
        self.floatview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[options]-30-|", options: [], metrics: nil, views: ["options":drawColorView]))
        
        self.floatview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(bottomConstant)-[options(\(sizeforview))]-0-|", options: [], metrics: nil, views: [ "options":drawColorView]))
    }
    
    
    //MARK: corner radius for color palette buttons
    
    func setcornerRadius(radius:CGFloat){
        color1.layer.cornerRadius = radius
        color2.layer.cornerRadius = radius
        color3.layer.cornerRadius = radius
        color4.layer.cornerRadius = radius
        color5.layer.cornerRadius = radius
        close.layer.cornerRadius = radius
        setBorderForcolour(borderwidth: 1.0)
    }
    //MARK: border color for bottom color panel
    func setBorderForcolour(borderwidth:CGFloat){
        color1.layer.borderColor = UIColor.darkGray.cgColor
        color1.layer.borderWidth = borderwidth
        color2.layer.borderColor = UIColor.darkGray.cgColor
        color2.layer.borderWidth = borderwidth
        color3.layer.borderColor = UIColor.darkGray.cgColor
        color3.layer.borderWidth = borderwidth
        color4.layer.borderColor = UIColor.darkGray.cgColor
        color4.layer.borderWidth = borderwidth
        color5.layer.borderColor = UIColor.darkGray.cgColor
        color5.layer.borderWidth = borderwidth
        
    }

    //MARK: pencil color change action
    @objc func colorPickerSelected(_ sender:UIButton) {
        switch sender.tag {
        case 94301:
            rgbColor(red_C:  255.0/255.0, green_C:  0.0/255.0, blue_C:  0.0/255.0)
            btnColorPalette.setTitleColor(UIColor(red: 255.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1.0), for: .normal)
        case 94302:
            rgbColor(red_C:  6.0/255.0, green_C:  255.0/255.0, blue_C:  0.0/255.0)
            btnColorPalette.setTitleColor(UIColor(red: 6.0/255, green: 255.0/255, blue: 0.0/255, alpha: 1.0), for: .normal)
            
        case 94303:
            rgbColor(red_C:  0.0/255.0, green_C:  0.0/255.0, blue_C:  255.0/255.0)
            btnColorPalette.setTitleColor(UIColor(red: 0.0/255, green: 0.0/255, blue: 255.0/255, alpha: 1.0), for: .normal)
        case 94304:
            rgbColor(red_C:  0.0/255.0, green_C:  0.0/255.0, blue_C:  0.0/255.0)
            btnColorPalette.setTitleColor(UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1.0), for: .normal)
            
        case 94305:
            rgbColor(red_C: 255.0/255.0, green_C: 255.0/255.0, blue_C: 255.0/255.0)
            btnColorPalette.setTitleColor(UIColor(red: 255.0/255, green: 255.0/255, blue: 255.0/255, alpha: 1.0), for: .normal)
        default:
            print("clear")
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {

            self.drawColorView.center.y += self.drawColorView.frame.height + self.sizeforColorPalette
            
        }, completion: nil)
        
        viewPopUpStatus = false
        
    }
    
    //MARK: pencil color change
    
    func rgbColor(red_C:CGFloat,green_C:CGFloat,blue_C:CGFloat){
        red = red_C
        green = green_C
        blue = blue_C
        FeedbackTheme.sharedInstance.arrowcolor = UIColor(red: red_C, green: green_C, blue: blue_C, alpha: 1.0)
    }
    
    //MARK: method to create text mask in an image
    func openImageRequest(){
        if FeedbackTheme.sharedInstance.isfromClass == "apptics_ScreenshotImageEditorView"{
            let image1 =  GetImageFromgallery()
            let heightInPoints = image1.size.height
            let widthInPoints = image1.size.width
            let resizedpic = imagevw.image!.resize(targetSize: CGSize(width: widthInPoints , height: heightInPoints))
            show(resizedpic)
        }
        else{
            let resizedpic = imagevw.image!.resize(targetSize: CGSize(width: view.frame.size.width , height: view.frame.size.height))
            show(resizedpic)
        }
        
        let cgOrientation = CGImagePropertyOrientation(imagevw.image!.imageOrientation)
        guard let cgImage = imagevw.image?.cgImage else {
            return
        }
        performVisionRequest(image: cgImage,
                             orientation: cgOrientation)
        imagevw.isUserInteractionEnabled = true
    }
    
    //MARK: completion handler for text request
    @available(iOS 11.0, *)
    func handleDetectedText(request: VNRequest?, error: Error?) {
        if let nsError = error as NSError? {
            print(nsError)
            return
        }
        DispatchQueue.main.async {
            guard let drawLayer = self.imageviewpathLayer,
                  let results = request?.results as? [VNTextObservation] else{return}
            self.observationResults = results
            self.textMaskdraw(text: results, onImageWithBounds: drawLayer.bounds)
            drawLayer.setNeedsDisplay()
        }
    }
    
    //MARK: face detect request
    @available(iOS 11.0, *)
    func handleDetectedFaces(request: VNRequest?, error: Error?) {
        if let nsError = error as NSError? {
            print(nsError)
            return
        }
        DispatchQueue.main.async {
            guard let drawLayer = self.imageviewpathLayer,
                  let results = request?.results as? [VNFaceObservation] else {
                return
            }
            self.drawFaceBlur(faces: results, onImageWithBounds: drawLayer.bounds)
            drawLayer.setNeedsDisplay()
        }
    }
    //MARK: draw pathlayer over image
    func show(_ image: UIImage){
        imageviewpathLayer?.removeFromSuperlayer()
        imageviewpathLayer = nil
        imagevw.image = nil
        let correctedImage = image
        imagevw.image = correctedImage
        croppedImage = image
        guard let cgImage = correctedImage.cgImage else {
            return
        }
        let fullImageWidth = CGFloat(cgImage.width)
        let fullImageHeight = CGFloat(cgImage.height)
        let imageFrame = imagevw.frame
        let widthRatio = fullImageWidth / imageFrame.width
        let heightRatio = fullImageHeight / imageFrame.height
        let scaleDownRatio = max(widthRatio, heightRatio)
        imageWidth = fullImageWidth / scaleDownRatio
        imageHeight = fullImageHeight / scaleDownRatio
        let xLayer = (imageFrame.width - imageWidth) / 2
        let yLayer = imagevw.frame.minY + (imageFrame.height - imageHeight) / 2
        let drawingLayer = CALayer()
        drawingLayer.frame = CGRect(x: xLayer, y: yLayer, width: imageWidth, height: imageHeight)
        drawingLayer.anchorPoint = CGPoint.zero
        drawingLayer.position = CGPoint(x: xLayer, y: yLayer)
        imageviewpathLayer = drawingLayer
        self.view.layer.addSublayer(imageviewpathLayer!)
    }
    
    // MARK: - Vision request for Text
    @available(iOS 11.0, *)
    func performVisionRequest(image: CGImage, orientation: CGImagePropertyOrientation) {
        let requests = createVisionRequests()
        let imageRequestHandler = VNImageRequestHandler(cgImage: image,
                                                        orientation: orientation,
                                                        options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform(requests)
            } catch let error as NSError {
                print("Failed to perform image request: \(error)")
                return
            }
        }
    }
    //MARK: vision request you can add multiple request
    @available(iOS 11.0, *)
    func createVisionRequests() -> [VNRequest] {
        var requests: [VNRequest] = []
        requests.append(self.textDetectionRequest)
        requests.append(self.faceDetectionRequest)
        return requests
    }
    
    //MARK: calculate rect using bounding box
    func boundingBox(forRegionOfInterest: CGRect, withinImageBounds bounds: CGRect) -> CGRect {
        let imageWidth = bounds.width
        let imageHeight = bounds.height
        var rect = forRegionOfInterest
        rect.origin.x *= imageWidth
        rect.origin.x += bounds.origin.x
        rect.origin.y = (1 - rect.origin.y) * imageHeight + bounds.origin.y
        rect.size.width *= imageWidth
        rect.size.height *= imageHeight
        return rect
    }
    
    //MARK: draw a masking layer above the text
    @available(iOS 11.0, *)
    func textMaskdraw(text: [VNTextObservation], onImageWithBounds bounds: CGRect) {
        CATransaction.begin()
        for wordObservation in text {
            let wordBox = boundingBox(forRegionOfInterest: wordObservation.boundingBox, withinImageBounds: bounds)
            let view = GradientButton()
            view.frame = wordBox
            view.layer.anchorPoint = .zero
            view.layer.cornerRadius = 2.0
            let width = wordBox.width + 6
            let heigt = wordBox.height + 6
            var xval = wordBox.origin.x
            let yval = wordBox.origin.y
            if FeedbackTheme.sharedInstance.isfromClass == "apptics_ScreenshotImageEditorView"{
                if TargetDevice.currentDevice == .iPhone{}
                else{
                    xval = xval + 70
                }
            }
            view.layer.frame = CGRect(x: xval, y: yval, width: width  , height: heigt)
            view.addTarget(self, action:#selector(self.buttonClicked), for: .touchDown)
            view.layer.masksToBounds = true
            if TargetDevice.currentDevice == .iPhone {
                view.layer.transform = CATransform3DMakeScale(1.2, -1, 1)
            }
            else if TargetDevice.currentDevice == .iPad{
                view.layer.transform = CATransform3DMakeScale(2.5, -1.5, 1.4)
            }
            else{
                view.layer.transform = CATransform3DMakeScale(3.1, -1.5, 1.8)
            }
            self.imagevw.addSubview(view)
        }
        CATransaction.commit()
    }
    
    //MARK: draw a masking layer above the Face
    
    @available(iOS 11.0, *)
    func drawFaceBlur(faces: [VNFaceObservation], onImageWithBounds bounds: CGRect) {
        CATransaction.begin()
        for observation in faces {
            let faceblurBox = boundingBox(forRegionOfInterest: observation.boundingBox, withinImageBounds: bounds)
            let buttonMask = GradientButton()
            buttonMask.frame = faceblurBox
            buttonMask.backgroundColor =  UIColor(red: 152.0/255.0, green: 152.0/255.0, blue: 152.0/255.0, alpha: 0.98)
            buttonMask.layer.anchorPoint = .zero
            let width = faceblurBox.width
            let heigt = faceblurBox.height
            let xval = faceblurBox.origin.x
            let yval = faceblurBox.origin.y
            buttonMask.layer.cornerRadius = 0.5 * buttonMask.bounds.size.width
            buttonMask.layer.frame = CGRect(x: xval, y: yval, width: width, height: heigt)
            buttonMask.addTarget(self, action:#selector(self.buttonClicked), for: .touchDown)
            buttonMask.layer.masksToBounds = true
            if TargetDevice.currentDevice == .iPhone {
                buttonMask.layer.transform = CATransform3DMakeScale(1.2, -1, 1)
            }
            else if TargetDevice.currentDevice == .iPad{
                buttonMask.layer.transform = CATransform3DMakeScale(2.1, -1.5, 1.4)
            }
            else{
                buttonMask.layer.transform = CATransform3DMakeScale(2.5, -1.5, 1.8)
            }
            self.imagevw.addSubview(buttonMask)
        }
        CATransaction.commit()
    }
    
    
    
    
    //MARK: masked layer button particular mask click
    @objc func buttonClicked(_ sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
            sender.alpha = 1.0
        } else {
            sender.isSelected = true
            sender.alpha = 0.05
        }
    }
    //MARK: pencil sketch draw
    func pencilSketchDraw(){
        checkselectedBtn = "pencilDraw"
        selectedBtn = btncolorpen
        canvasArrow.isUserInteractionEnabled = false
        canvasArrow.unselectAllArrows()
        blurViewUnselect()
        iscolorOn = false
        btncolorpen.isSelected = true
        bttnBlur.isSelected = false
        btnClear.isSelected = false
        self.imagevw.isUserInteractionEnabled = false
        buttonSelectedStatus(pencolor: FeedbackTheme.sharedInstance.maskColor.withAlphaComponent(0.4), blurpenColor: UIColor.clear, arrow: UIColor.clear, masking: UIColor.clear)
    }
    
    //MARK: button color status change
    
    func buttonSelectedStatus(pencolor:UIColor,blurpenColor:UIColor,arrow:UIColor,masking:UIColor){
        btncolorpen.backgroundColor = pencolor
        bttnBlur.backgroundColor = blurpenColor
        btnArrow.backgroundColor = arrow
        btnfullBlur.backgroundColor = masking
    }
    
    //MARK: pencil draw sketch button click
    @objc func colorbuttonClicked(){
        pencilSketchDraw()
    }
    
    
    //MARK: Draw arrow buttonCLick
    
    @objc func drawArrowView(){
        selectedBtn = btnArrow
        checkselectedBtn = "arrowBttn"
        self.imagevw.isUserInteractionEnabled = true
        buttonSelectedStatus(pencolor: UIColor.clear, blurpenColor: UIColor.clear,
                             arrow: FeedbackTheme.sharedInstance.maskColor.withAlphaComponent(0.4), masking: UIColor.clear)
        canvasArrow.isUserInteractionEnabled = true
        self.canvasArrow.frame = CGRect(x: 0, y: 0, width: self.imagevw.frame.width, height: self.imagevw.frame.height)
        blurViewUnselect()
        self.imagevw.addSubview(self.canvasArrow)
        
    }
    
    //MARK: Blur pencilsketch buttonclick
    
    @objc func blurbuttonclicked(){
        checkselectedBtn = "blurMask"
        canvasArrow.isUserInteractionEnabled = false
        canvasArrow.unselectAllArrows()
        selectedBtn = bttnBlur
        iscolorOn = true
        self.imagevw.isUserInteractionEnabled = true
        buttonSelectedStatus(pencolor: UIColor.clear,
                             blurpenColor: FeedbackTheme.sharedInstance.maskColor.withAlphaComponent(0.4), arrow: UIColor.clear,
                             masking: UIColor.clear)
        let blurViewDimension:Float = Float(min(imagevw.frame.size.width, imagevw.frame.size.height) * 50.0 / 100.0)
        let blurViewRect:CGRect
#if swift(>=5.0)
  blurViewRect = CGRect(x: 0, y: 0, width: CGFloat(blurViewDimension), height: CGFloat(blurViewDimension))
        ZABlurView = ZADragBlurView(frame:blurViewRect)
        ZABlurView.center = CGPoint(x: CGFloat(imagevw.frame.size.width / 2.0), y: CGFloat(imagevw.frame.size.height / 2.0))
#else
  blurViewRect = CGRectMake(0, 0, CGFloat(blurViewDimension), CGFloat(blurViewDimension))
        ZABlurView = ZADragBlurView(frame:blurViewRect)
        ZABlurView.center = CGPointMake(imagevw.frame.size.width / 2.0, imagevw.frame.size.height / 2.0)
#endif
        
        if let blurImage = imagevw.image{
            self.ZABlurView.backgroundImage = blurImage
        }
        self.imagevw.addSubview(self.ZABlurView)
        
    }
    
//MARK: blurView UNselect option from views
    func blurViewUnselect(){
        let allSubviews = imagevw.allSubViewsOf(type: ZADragBlurView.self)
        for i in allSubviews{
            i.unselect()
        }
    }
    
// MARK: open color palette
    @objc func colorPaletteclicked(){
        if viewPopUpStatus == false{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseInOut], animations: {
                if TargetDevice.currentDevice == .iPhone {
                    self.drawColorView.center.y -= self.drawColorView.frame.height + self.sizeforColorPalette
                }
                else{
                    if FeedbackTheme.sharedInstance.isfromClass == "apptics_ScreenshotImageEditorView"{
                        self.drawColorView.isHidden = true
                        self.drawColorView.center.y -= self.drawColorView.frame.height + self.floatview.frame.height/1.80
                        self.drawColorView.isHidden = false
                    }
                    else{
                        self.drawColorView.center.y -= self.drawColorView.frame.height + self.sizeforColorPalette
                    }
                    
                }
            }, completion: nil)
            viewPopUpStatus = true
        }
    }
    
    
//Fixed color paletee hidden isuue
    
//MARK: close color platte based on view touch
    @objc func imageViewhandleTap(_ sender: UITapGestureRecognizer? = nil) {
        if viewPopUpStatus == true{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
//                if TargetDevice.currentDevice == .iPhone {
//                    self.drawColorView.center.y += self.drawColorView.frame.height + self.sizeforColorPalette
//                }
//                else if FeedbackTheme.sharedInstance.isfromClass == "apptics_ScreenshotImageEditorView"{
//                    self.drawColorView.center.y += self.drawColorView.frame.height + self.floatview.frame.height/1.80
//                    self.drawColorView.isHidden = true
//                }
                self.drawColorView.center.y += self.drawColorView.frame.height + self.sizeforColorPalette
                
            }, completion: nil)
            viewPopUpStatus = false
        }
        else{}
        
        
       
        
        
    }
    
//MARK: Image text & face mask button click
    @objc func fullBlurClicked(_ sender: UIButton)
    {
        checkselectedBtn = "fullblur"
        selectedBtn = btnfullBlur
        canvasArrow.unselectAllArrows()
        blurViewUnselect()
        if sender.isSelected {
            sender.isSelected = false
            self.openImageRequest()
            buttonSelectedStatus(pencolor: UIColor.clear, blurpenColor: UIColor.clear, arrow: UIColor.clear, masking: FeedbackTheme.sharedInstance.maskColor.withAlphaComponent(0.4))
            btnfullBlur.setTitle(FontIconText.maskSelected, for: .normal)
            
        } else {
            sender.isSelected = true
            sender.backgroundColor = UIColor.clear
            removMask()
            btnfullBlur.backgroundColor = .clear
            btnfullBlur.setTitle(FontIconText.imageMask, for: .normal)
        }
    }
    
    
//MARK: remove masked layer from Image
    func removMask(){
        let blurFinder = findViewInside(views: self.imagevw.subviews, findType: GradientButton.self)
        for i in blurFinder{
            i.removeFromSuperview()
        }
        btnfullBlur.isSelected = true
    }
    
//MARK: remove elements from the layer
    @objc func clearAll(_ sender: UIButton){
        checkselectedBtn = "clearImage"
        if FeedbackTheme.sharedInstance.isfromClass == "apptics_ScreenshotImageEditorView"{
            if FeedbackTheme.sharedInstance.gotImageFromgallery != nil{
                let image1 =  GetImageFromgallery()
                imagevw.image = image1
            }
        }
        else{
            let image = UIImage(contentsOfFile: sourceImage!.path)
            imagevw.image = image
        }
        selectedBtn = btncolorpen
        btncolorpen.backgroundColor = FeedbackTheme.sharedInstance.maskColor.withAlphaComponent(0.4)
        bttnBlur.backgroundColor = UIColor.clear
        btnfullBlur.backgroundColor = UIColor.clear
        pencilSketchDraw()
        removMask()
        btnfullBlur.setTitle(FontIconText.imageMask, for: .normal)
        let value = findViewInside(views: self.canvasArrow.subviews, findType: ZAArrowView.self)
        for _ in value{
            canvasArrow.undolastArrow()
        }
        let allSubviews = imagevw.allSubViewsOf(type: ZADragBlurView.self)
        for i in allSubviews{
            print(i.removeFromSuperview())
        }
    }
        
//MARK: Gesture touches begin
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        lastPoint = touch?.location(in: self.imagevw)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if checkselectedBtn == "pencilDraw" {
            guard let touch = touches.first else {
                return
            }
            let currentPoint = touch.location(in: self.imagevw)
            if FeedbackTheme.sharedInstance.isfromClass == "apptics_ScreenshotImageEditorView"{
                let imageSize = self.imagevw.image?.size ?? CGSize.zero
                let viewSize = self.imagevw.bounds.size
                let widthRatio = viewSize.width / imageSize.width
                let heightRatio = viewSize.height / imageSize.height
                let scaleFactor = min(widthRatio, heightRatio)
                let scaledSize = CGSize(width: imageSize.width * scaleFactor, height: imageSize.height * scaleFactor)
                UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
                self.imagevw.image?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: scaledSize))
                let x = currentPoint.x * scaleFactor / self.imagevw.frame.size.width * scaledSize.width
                let y = currentPoint.y * scaleFactor / self.imagevw.frame.size.height * scaledSize.height
                let lastX = lastPoint.x * scaleFactor / self.imagevw.frame.size.width * scaledSize.width
                let lastY = lastPoint.y * scaleFactor / self.imagevw.frame.size.height * scaledSize.height
                let context = UIGraphicsGetCurrentContext()
                context?.move(to: CGPoint(x: lastX, y: lastY))
                context?.addLine(to: CGPoint(x: x, y: y))
                context?.setLineCap(.round)
                context?.setLineWidth(brush)
                context?.setBlendMode(.normal)
                context?.setStrokeColor(red: red, green: green, blue: blue, alpha: alpha)
                context?.strokePath()
                self.imagevw.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                lastPoint = currentPoint
            }
            else{
                UIGraphicsBeginImageContextWithOptions(self.imagevw.bounds.size, true, 0)
                imagevw.image?.draw(in: CGRect(x: 0, y: 0, width: self.imagevw.frame.size.width, height: imagevw.frame.size.height))
                UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
                UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
                UIGraphicsGetCurrentContext()?.setLineCap(.round)
                UIGraphicsGetCurrentContext()?.setBlendMode(.normal)
                UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: alpha)
                UIGraphicsGetCurrentContext()?.setLineWidth(brush)
                UIGraphicsGetCurrentContext()?.strokePath()
                self.imagevw.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                lastPoint = currentPoint
            }
        }
        else{
            lastPoint = CGPoint(x: 0, y: 0)
        }
    }
    
//MARK: save image to folder
    public func saveImagess(image:UIImage) -> URL? {
        let resizedpic = image.resize(targetSize: CGSize(width: imagevw.frame.width  , height: imagevw.frame.height))
        guard let imageData = resizedpic.jpegData(compressionQuality: 0.25) else {
            return nil
        }
        do {
            let imageURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(sourceImage!.lastPathComponent)
            try imageData.write(to: imageURL)
            return imageURL
        } catch {
            return nil
        }
    }    
}

extension UIView {
    func subViews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}







