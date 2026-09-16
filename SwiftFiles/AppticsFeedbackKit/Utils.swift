//
//  MyFramework
//
//  Created by jai-13322 on 19/07/22.
//

import UIKit
import Apptics

//MARK: screenshot resizer
public extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        if #available(iOS 10.0, *) {
            return UIGraphicsImageRenderer(size:targetSize).image { _ in
                self.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        }
        else{
            return UIImage()
        }
    }
}


extension UIView {
public func captureView() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
    
public var snapshot: UIImage {
    if #available(iOS 10.0, *) {
        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }else {
        UIGraphicsBeginImageContext(self.frame.size)
        self.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: image!.cgImage!)
    }

    }
    
    
}


@objcMembers
public class GradientButton: UIButton {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    private lazy var gradientLayer: CAGradientLayer = {
        let gL = CAGradientLayer()
        gL.frame = self.bounds
        gL.colors = [UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0).cgColor, UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0).cgColor]
        gL.startPoint = CGPoint(x: 0, y: 0.5)
        gL.endPoint = CGPoint(x: 1.50, y: 0.5)
        gL.cornerRadius = 3
        layer.insertSublayer(gL, at: 0)
        return gL
    }()
}



enum TargetDevice {
    case nativeMac
    case iPad
    case iPhone
    case iWatch
    
    public static var currentDevice: Self {
        var currentDeviceModel = UIDevice.current.model
#if targetEnvironment(macCatalyst)
        currentDeviceModel = "nativeMac"
#elseif os(watchOS)
        currentDeviceModel = "watchOS"
#endif
        if currentDeviceModel.starts(with: "iPhone") {
            return .iPhone
        }
        if currentDeviceModel.starts(with: "iPad") {
            return .iPad
        }
        if currentDeviceModel.starts(with: "watchOS") {
            return .iWatch
        }
        return .nativeMac
    }
}


//MARK: load font from bundle

//public func loadFontForCPResourceBundle() {
//    
//    guard let url = bundles1.url(forResource: appticsFontName, withExtension: "ttf") else {
//        return
//    }
//    guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
//        return
//    }
//    guard let font = CGFont(fontDataProvider) else {
//        return
//    }
//    var error: Unmanaged<CFError>?
//    if !CTFontManagerRegisterGraphicsFont(font, &error) {
//        print(error!.takeUnretainedValue())
//    }
//}

public func loadFontForCPResourceBundle() {
    struct Static {
        static var didLoadFont: Bool = false
    }
    guard !Static.didLoadFont else { return }
    Static.didLoadFont = true
    guard let url = bundles.url(forResource: appticsFontName, withExtension: "ttf"),
          let fontDataProvider = CGDataProvider(url: url as CFURL),
          
          let font = CGFont(fontDataProvider) else {
        return
    }
     
    var error: Unmanaged<CFError>?
       if !CTFontManagerRegisterGraphicsFont(font, &error) {
           if let cfError = error?.takeUnretainedValue() {
               let nsError = cfError as Error
               print("❌ Font registration failed: \(nsError.localizedDescription)")
           } else {
               print("❌ Font registration failed: Unknown error")
           }
       } else {
           let postScriptName = font.postScriptName as String? ?? "unknown"
           print("✅ Font '\(postScriptName)' loaded successfully.")
       }
}

public func printAllLoadedFonts() {
    for family in UIFont.familyNames.sorted() {
        print("Family: \(family)")
        let fontNames = UIFont.fontNames(forFamilyName: family).sorted()
        for name in fontNames {
            print("  Font: \(name)")
        }
    }
}


public struct FontIconText {
    static let pencilDraw = "\u{e902}"
    static let pencilDrawSelected = "\u{e90e}"
    static let arrowIcon = "\u{e900}"
    static let arrowIconSelected = "\u{e90c}"
    static let blurIcon = "\u{e901}"
    static let blurIconSelected = "\u{e90d}"
    static let imageMask = "\u{e904}"
    static let imagemaskSelected = "\u{e90a}"
    static let clearIcon = "\u{e903}"
    static let snapIcon = "\u{e906}"
    static let screenshotsIcon = "\u{e907}"
    static let cancelIcon = "\u{e905}"
    static let deleteIcon = "\u{e908}"
    static let colorPalette = "\u{e90b}"
    static let maskSelected = "\u{e909}"
    
    static let supportIcon = "\u{e90f}"
    static let anonymousIcon = "\u{e90d}"
    static let backnativeIcon = "\u{e90c}"
    static let attachmentIcon = "\u{e90e}"
    static let cellArrowIcon = "\u{e911}"
    static let sendArrowIcon = "\u{e912}"
    static let celllogIcon = "\u{e910}"

}


//#if SWIFT_PACKAGE
//public let bundles = Bundle.module
//#else
//public let bundles = Bundle(for: GradientButton.self)
//#endif


#if SWIFT_PACKAGE
public let bundles = Bundle.module
#else
public let bundles1 = Bundle(for: GradientButton.self)
public let bundles = Bundle(url: Bundle(for: GradientButton.self).url(forResource: "APFeedbackSwift", withExtension: "bundle") ?? Bundle(for: GradientButton.self).bundleURL) ?? Bundle(for: GradientButton.self)

#endif


public var appticsFontName = "AppticsSdkIcons"
public var appFontsize:CGFloat = 30.0
public let notificationLoadAnonymChatConversation = "com.apticssdk.AnonymChatConversation"
public let notificationbadgereloadKey = "com.apticssdk.badgereload"
public let notificationScreenreloadKey = "com.appticssdk.Screenshots.reload"
public let notificationComposeclickKey = "com.appticssdk.Composeimageclicked"
public let notificationReportBugClose = "com.appticssdk.imageSendFromReportBug"
public let notificationimageReloadInCV = "com.appticssdk.reloadImageincollectionView"
public let notificationImageReloadfromReportBug = "com.appticssdk.reloadImageWithIndex"
public let notificationviewHideandDismiss = "com.appticssdk.viewHideandDismiss"

//MARK: singleton class for detail sharing
@objcMembers
public class FeedbackTheme{
    public static let sharedInstance = FeedbackTheme()
    init()
    {}
    public var maskColor = UIColor.lightGray
    public var tintColor = (UINavigationBar.appearance().tintColor != nil) ? UINavigationBar.appearance().tintColor! : UIColor.systemBlue
    public var barButtontitleTextAttributes : NSDictionary = ((UIBarButtonItem.appearance().titleTextAttributes(for: .normal)) != nil) ? UIBarButtonItem.appearance().titleTextAttributes(for: .normal)! as NSDictionary : [NSAttributedString.Key.foregroundColor : (UINavigationBar.appearance().tintColor != nil) ? UINavigationBar.appearance().tintColor! : UIColor.systemBlue]
    public var textColor = UIColor.black
    public var ViewColor = UIColor.lightGray
    public var arrowcolor = UIColor(red: 160.0/255.0, green: 50.0/255.0, blue: 105.0/255.0, alpha: 1.0)
    public var cellborderColor = UIColor.white.cgColor
    public var imageLocation:URL?
    public var index_Value =  0
    public var isfromClass = "Default"
    public var gotImageFromgallery:UIImage?
    public var setTransparencySettingsEnabled:Bool?
    public var setMaskTextDefault:Bool?
        
}


extension CGImagePropertyOrientation {
    init(_ uiImageOrientation: UIImage.Orientation) {
        switch uiImageOrientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        default: self = .up
        }
    }
}

/// Single owner for FeedbackKit overlay windows (floating bar, carousel, editor).
/// Prevents stacked/ghost windows from stealing key status or touches from Report Bug.
@available(iOS 11.0, *)
@objcMembers
public final class FeedbackOverlayCoordinator: NSObject {
    public static let shared = FeedbackOverlayCoordinator()

    private weak var floatingBarWindow: UIWindow?
    private weak var carouselWindow: UIWindow?
    private var editorWindows = NSHashTable<UIWindow>.weakObjects()

    private override init() {
        super.init()
    }

    // MARK: - Scene / host

    @available(iOS 13.0, *)
    public func foregroundWindowScene() -> UIWindowScene? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        return scenes.first(where: { $0.activationState == .foregroundActive })
            ?? scenes.first(where: { $0.activationState == .foregroundInactive })
            ?? scenes.first
    }

    /// Host app window, excluding Apptics screenshot/floating overlay windows.
    public func applicationHostWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            var fallback: UIWindow?
            let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            let activeScenes = scenes.filter {
                $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive
            }
            for scene in (activeScenes.isEmpty ? scenes : activeScenes) {
                for window in scene.windows where !window.isHidden {
                    if isAppticsOverlayWindow(window) {
                        continue
                    }
                    if window.isKeyWindow {
                        return window
                    }
                    if fallback == nil {
                        fallback = window
                    }
                }
            }
            return fallback ?? scenes.flatMap(\.windows).first(where: { $0.isKeyWindow && !$0.isHidden })
        }
        var fallback: UIWindow?
        for window in UIApplication.shared.windows where !window.isHidden {
            if isAppticsOverlayWindow(window) {
                continue
            }
            if window.isKeyWindow {
                return window
            }
            if fallback == nil {
                fallback = window
            }
        }
        return fallback ?? UIApplication.shared.keyWindow
    }

    public func restoreHostKeyWindow() {
        DispatchQueue.main.async {
            self.applicationHostWindow()?.makeKeyAndVisible()
        }
    }

    // MARK: - Registration

    public func registerFloatingBar(_ window: UIWindow) {
        floatingBarWindow = window
    }

    public func registerCarousel(_ window: UIWindow) {
        carouselWindow = window
    }

    public func registerEditor(_ window: UIWindow) {
        editorWindows.add(window)
    }

    // MARK: - Phase transitions

    /// Hide floating bar before carousel/editor. Does not destroy the bar window.
    public func prepareForCarousel() {
        setFloatingBarHidden(true)
    }

    /// Hide floating bar + carousel before editor so only the editor receives touches.
    public func prepareForEditor() {
        setFloatingBarHidden(true)
        setCarouselHidden(true)
    }

    /// Tear down carousel (and any editor) before presenting Report Bug on the host.
    public func prepareForCompose() {
        tearDownEditor(restoreHost: false)
        tearDownCarousel(restoreHost: false)
        setFloatingBarHidden(true)
        restoreHostKeyWindow()
    }

    /// Full SDK overlay cleanup (cancel / send success).
    public func tearDownAllOverlays(restoreHost: Bool = true) {
        tearDownEditor(restoreHost: false)
        tearDownCarousel(restoreHost: false)
        tearDownFloatingBar(restoreHost: false)
        if restoreHost {
            restoreHostKeyWindow()
        }
    }

    // MARK: - Visibility

    public func setFloatingBarHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            if let window = self.floatingBarWindow {
                window.isHidden = hidden
            }
            FloatingBottomView.ap_setFloatingBarHidden(hidden)
            if !hidden, let window = self.floatingBarWindow {
                window.makeKeyAndVisible()
            }
        }
    }

    public func setCarouselHidden(_ hidden: Bool) {
        guard let carouselWindow = carouselWindow else { return }
        carouselWindow.isHidden = hidden
        if !hidden {
            carouselWindow.makeKeyAndVisible()
        }
    }

    // MARK: - Teardown

    public func tearDownFloatingBar(restoreHost: Bool = true) {
        detachHitTesting(on: floatingBarWindow)
        destroy(floatingBarWindow)
        floatingBarWindow = nil
        if restoreHost {
            restoreHostKeyWindow()
        }
    }

    public func tearDownCarousel(restoreHost: Bool = true) {
        detachHitTesting(on: carouselWindow)
        destroy(carouselWindow)
        carouselWindow = nil
        if restoreHost {
            restoreHostKeyWindow()
        }
    }

    public func tearDownEditor(restoreHost: Bool = true) {
        for case let window as UIWindow in editorWindows.allObjects {
            detachHitTesting(on: window)
            destroy(window)
        }
        editorWindows.removeAllObjects()
        guard restoreHost else { return }
        if carouselWindow != nil {
            setCarouselHidden(false)
        } else {
            restoreHostKeyWindow()
        }
    }

    /// Destroy a known overlay window. Never destroys the host app window.
    public func dismissOverlayWindow(_ window: UIWindow?) {
        guard let window = window else { return }
        if window === floatingBarWindow {
            tearDownFloatingBar(restoreHost: true)
            return
        }
        if window === carouselWindow {
            tearDownCarousel(restoreHost: false)
            setFloatingBarHidden(false)
            return
        }
        if editorWindows.contains(window) {
            tearDownEditor(restoreHost: true)
            return
        }
        guard isAppticsOverlayWindow(window) else {
            return
        }
        detachHitTesting(on: window)
        destroy(window)
        if carouselWindow != nil {
            setCarouselHidden(false)
        } else {
            restoreHostKeyWindow()
        }
    }

    // MARK: - Internals

    private func isAppticsOverlayWindow(_ window: UIWindow) -> Bool {
        if window is FloatingBottomWindow || window is FloatingscreenshotWindow || window is FloatingscreenshotEditorWindow {
            return true
        }
        if window.rootViewController is FloatingBottomView {
            return true
        }
        if window.rootViewController is FloatScrollview {
            return true
        }
        if window.rootViewController is FloatScreenshotEditor {
            return true
        }
        return false
    }

    private func detachHitTesting(on window: UIWindow?) {
        guard let window = window else { return }
        if let w = window as? FloatingBottomWindow {
            w.views = nil
        }
        if let w = window as? FloatingscreenshotWindow {
            w.views = nil
        }
        if let w = window as? FloatingscreenshotEditorWindow {
            w.views = nil
        }
    }

    private func destroy(_ window: UIWindow?) {
        guard let window = window else { return }
        window.isHidden = true
        window.rootViewController = nil
        if #available(iOS 13.0, *) {
            window.windowScene = nil
        }
    }
}

extension UIWindow {
    func dismissWindow() {
        if #available(iOS 11.0, *) {
            FeedbackOverlayCoordinator.shared.dismissOverlayWindow(self)
            return
        }
        isHidden = true
        rootViewController = nil
    }
}

public extension UIApplication {
    @available(iOS 13.0, *)
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
            .compactMap { $0 as? UIWindowScene }
        return connectedScenes.first?.windows.first { $0.isKeyWindow }
    }
}



//MARK: animation for view back
class FadeInAdnimation: CABasicAnimation {
    override init() {
        super.init()
        keyPath = "opacity"
        duration = 0.5
        fromValue = 0
        toValue = 1
        fillMode = CAMediaTimingFillMode.forwards
        isRemovedOnCompletion = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


//MARK: Clear images at the time of close

public func clearAllImages(){
    
    let docsDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.path
    let dirEnum = FileManager.default.enumerator(atPath: docsDir)
    while let file = dirEnum?.nextObject() as? String {
        if file.hasPrefix("Appticssdk") == true{
            let fileUrl = URL(fileURLWithPath: docsDir.appending("/\(file)"))
            do {
                try FileManager.default.removeItem(at: fileUrl)
            } catch {
                print(error)
            }
        }
    }
    
}



//MARK: collection view flowLayout
class PaginginationCVLayout: UICollectionViewFlowLayout {
    var theVelocityThresholdPerPage: CGFloat = 4
    var numOfItemsPerPage: CGFloat = 1
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        let pageLength: CGFloat
        let approxPage: CGFloat
        let currentPage: CGFloat
        let speedRate: CGFloat
        
        if scrollDirection == .horizontal {
            pageLength = (self.itemSize.width + self.minimumLineSpacing) * numOfItemsPerPage
            approxPage = collectionView.contentOffset.x / pageLength
            speedRate = velocity.x
        } else {
            pageLength = (self.itemSize.height + self.minimumLineSpacing) * numOfItemsPerPage
            approxPage = collectionView.contentOffset.y / pageLength
            speedRate = velocity.y
        }
        
        if speedRate < 0 {
            currentPage = ceil(approxPage)
        } else if speedRate > 0 {
            currentPage = floor(approxPage)
        } else {
            currentPage = round(approxPage)
        }
        
        guard speedRate != 0 else {
            if scrollDirection == .horizontal {
                return CGPoint(x: currentPage * pageLength, y: 0)
            } else {
                return CGPoint(x: 0, y: currentPage * pageLength)
            }
        }
        
        var nextPage: CGFloat = currentPage + (speedRate > 0 ? 1 : -1)
        let increment = speedRate / theVelocityThresholdPerPage
        nextPage += (speedRate < 0) ? ceil(increment) : floor(increment)
        if scrollDirection == .horizontal {
            return CGPoint(x: nextPage * pageLength , y: 0)
        } else {
            return CGPoint(x: 0, y: nextPage * pageLength)
        }
    }
}



public extension UIButton {
    func preventRepeatedPress(inNext seconds: Double = 0.90) {
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            self.isUserInteractionEnabled = true
        }
    }
    
    func setAttributedText(attributes: [NSAttributedString.Key: Any]) {
        if let text = self.titleLabel?.text{
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            self.setAttributedTitle(attributedText, for: .normal)
        }
    }
}



extension UITextView {
    func leftSpace() {
        self.textContainerInset = UIEdgeInsets(top: 10, left: 7, bottom: 4, right: 55)
    }
}


//MARK: change Font for buttons
   
   func setFontForButton(button:UIButton,fontName:String,title:String,size:CGFloat){
       button.titleLabel?.font = UIFont(name: fontName, size: 25)
       button.setTitle(title, for: .normal)
   }



func setFontForButtonedit(
    button: UIButton,
    fontName: String,
    title: String,
    size: CGFloat
) {
    if button.buttonType != .custom {
        button.setTitle(nil, for: .normal)
    }
    guard let font = UIFont(name: fontName, size: size) else {
        return
    }
    button.setImage(nil, for: .normal)
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = font
    button.titleLabel?.textAlignment = .center
    button.titleLabel?.lineBreakMode = .byClipping
}













