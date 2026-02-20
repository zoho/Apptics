//
//  Utils.swift
//  AppticsFeedback
//
//  Created by jai-13322 on 10/01/24.
//

import Foundation
import Cocoa

@objcMembers
public class AppticsFeedback_Swift {
    public static let sharedInstance = AppticsFeedback_Swift()
    public var pageTitle:String = "Feedback"

    init() {}
    
    public func showFeedback() {
        let nibName = "AppticsFeedbackViewController"
        if let mainViewController = NSApplication.shared.mainWindow?.contentViewController {
            let myViewController = AppticsFeedbackViewController(nibName: nibName, bundle: macbundles)
            mainViewController.presentAsModalWindow(myViewController)
        }
        
    }
}




extension NSView {
    var backgroundColor: NSColor? {
        get {
            guard let color = layer?.backgroundColor else { return nil }
            return NSColor(cgColor: color)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
}







//Attachment file upload class

class Attachment {
    var imageIcon: String?
    
    init(imageIcon: String) {
        self.imageIcon = imageIcon
    }

}





//@objc(RoundedButton)
//public final class RoundedButton: NSButton {
//
//    @IBInspectable public var cornerRadius: CGFloat = 10.0
//
//    public override func awakeFromNib() {
//        super.awakeFromNib()
//        wantsLayer = true
//        layer?.cornerRadius = cornerRadius
//        layer?.masksToBounds = true
//        layer?.borderColor = NSColor.white.cgColor
//        layer?.borderWidth = 3.0
//    }
//}





#if SWIFT_PACKAGE
public let macbundles = Bundle.module
#else
public let macbundles = Bundle(for: Attachment.self)
#endif

//Shake text view for empty string
extension NSTextView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(point: NSPoint(x: self.frame.origin.x - 15, y: self.frame.origin.y))
        animation.toValue = NSValue(point: NSPoint(x: self.frame.origin.x + 15, y: self.frame.origin.y))
        self.layer?.add(animation, forKey: "position")
    }
}

