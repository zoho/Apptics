//
//  AuthenticatorBlurViewController.swift
//  SampleLock
//
//  Created by Raghavendra Panth R on 22/05/19.
//  Copyright © 2019 Jambav. All rights reserved.
//

import Foundation
import UIKit

class AuthenticatorBlurViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let bgColor = AppticsLock.shared.config.blurBackgroundColor{
            if bgColor == .clear{

            let bgImage =  AppticsLock.shared.lastSnapshotImage
            let imgView = UIImageView(frame: self.view.frame)
            imgView.image = bgImage
            self.view.addSubview(imgView)
            imgView.blurView.setup(style: .dark, alpha: 1).enable()
            }
        }
        else{
            self.view.backgroundColor = Bundle.main.icon?.averageColor
        }
        
        let imageView = UIImageView(image: AppticsLock.shared.customAppIcon ?? Bundle.main.icon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        if let bgColor = AppticsLock.shared.config.blurBackgroundColor{
            if bgColor != .clear{
                self.view.addSubview(imageView)
                var constraints = [NSLayoutConstraint]()
                
                constraints.append(NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100))
                constraints.append(NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100))
                
                NSLayoutConstraint.activate(constraints)
                self.view.backgroundColor = bgColor
                
        }
        
        
       
    }
    }
    
    
    open class func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        
        if let bgColor = AppticsLock.shared.config.blurBackgroundColor{
            if bgColor == .clear{
                if #available(iOS 10.0, *) {
                    let renderer = UIGraphicsImageRenderer(bounds: UIScreen.main.bounds)
                    let screenshot = renderer.image { _ in
                        UIApplication.shared.windows.first?.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: true)
                    }
                    return screenshot
                } else {
                    return AuthenticatorBlurViewController.createWhiteImage(size: UIScreen.main.bounds.size)
                }
            }
        }
        return nil

       
    }
    class func createWhiteImage(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        
        let whiteImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return whiteImage
    }
    
}

