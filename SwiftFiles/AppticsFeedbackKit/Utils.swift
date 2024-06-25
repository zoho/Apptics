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

public func loadFontForCPResourceBundle() {
    
    guard let url = bundles.url(forResource: appticsFontName, withExtension: "ttf") else {
        return
    }
    guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
        return
    }
    guard let font = CGFont(fontDataProvider) else {
        return
    }
    var error: Unmanaged<CFError>?
    if !CTFontManagerRegisterGraphicsFont(font, &error) {
        print(error!.takeUnretainedValue())
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


public var appticsFontName = "AppticsSdkIcons"
public var appFontsize:CGFloat = 30.0
public let bundles = Bundle(for: GradientButton.self)
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

extension UIWindow {
    func dismissWindow() {
        if ((self as? FloatingscreenshotWindow) != nil) {
            isHidden = true
            if #available(iOS 13, *) {                                
                    windowScene = nil
            }
        }
        if #available(iOS 11.0, *) {
            if ((self.rootViewController as? FloatScreenshotEditor) != nil) {
                isHidden = true
                if #available(iOS 13, *) {
                        windowScene = nil
                }
            }
        }
    }
}

public extension UIApplication {
    @available(iOS 13.0, *)
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }
        return window
        
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


enum TrailingContent {
    case readmore
    case readless

    var text: String {
        switch self {
        case .readmore: return " ...More"
        case .readless: return "  Less"
        }
    }
}

extension UILabel {

    private var minimumLines: Int { return 4 }
    private var highlightedColor: UIColor { return .blue }

    private var attributes: [NSAttributedString.Key: Any] {
        return [.font: self.font ?? .systemFont(ofSize: 16)]
    }
    
    public func requiredHeight(for text: String) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = minimumLines
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
      }

    func highlight(_ text: String, color: UIColor) {
        guard let labelText = self.text else { return }
        let range = (labelText as NSString).range(of: text)

        let mutableAttributedString = NSMutableAttributedString.init(string: labelText)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.attributedText = mutableAttributedString
    }

    func appendReadmore(after text: String, trailingContent: TrailingContent,highledcolor:UIColor) {
        self.numberOfLines = minimumLines
        let fourLineText = "\n\n\n"
        let fourlineHeight = requiredHeight(for: fourLineText)
        let sentenceText = NSString(string: text)
        let sentenceRange = NSRange(location: 0, length: sentenceText.length)
        var truncatedSentence: NSString = sentenceText
        var endIndex: Int = sentenceRange.upperBound
        let size: CGSize = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        while truncatedSentence.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.height >= fourlineHeight {
            if endIndex == 0 {
                break
            }
            endIndex -= 1

            truncatedSentence = NSString(string: sentenceText.substring(with: NSRange(location: 0, length: endIndex)))
            truncatedSentence = (String(truncatedSentence) + trailingContent.text) as NSString

        }
        self.text = truncatedSentence as String
        self.highlight(trailingContent.text, color: highledcolor)
    }

    func appendReadLess(after text: String, trailingContent: TrailingContent,highledcolor:UIColor) {
        self.numberOfLines = 0
        self.text = text + trailingContent.text
        self.highlight(trailingContent.text, color: highledcolor)
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

















