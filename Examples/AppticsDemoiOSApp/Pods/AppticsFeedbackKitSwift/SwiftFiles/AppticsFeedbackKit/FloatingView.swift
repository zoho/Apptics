//
//  FloatingView.swift
//  MyFramework
//
//  Created by jai-13322 on 21/07/22.
//

import UIKit

@objcMembers
class FloatingView: UIView {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cancelBttn:UIButton!
    @IBOutlet weak var snapBttn:UIButton!
    @IBOutlet weak var screenshotBttn:UIButton!
    
    @IBOutlet weak var cancelImage:UIButton!
    @IBOutlet weak var snapImage:UIButton!
    @IBOutlet weak var screenshotsImage:UIButton!
    @IBOutlet weak var badgeLabel:UILabel!
    @IBOutlet weak var cardView:CardViews!
    var cornerRadius:CGFloat = 9

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func commoninit(){
        let bundles = bundles
        let view = bundles.loadNibNamed("FloatingView", owner: self, options: nil)! [0] as! UIView
        view.frame = self.bounds
        addSubview(view)
        if UIDevice.current.userInterfaceIdiom == .phone {
            appFontsize = 30.0
            cornerRadius = 9
        }
        else{
            appFontsize = 40.0
            cornerRadius = 15
        }
        badgeLabel.layer.masksToBounds = true
        badgeLabel.layer.cornerRadius = cornerRadius
        setFontForButton(button: cancelImage, fontName: appticsFontName, title: FontIconText.cancelIcon, size: appFontsize)
        setFontForButton(button: snapImage, fontName: appticsFontName, title: FontIconText.snapIcon, size: appFontsize)
        setFontForButton(button: screenshotsImage, fontName: appticsFontName, title: FontIconText.screenshotsIcon, size: appFontsize)

    }
}


//MARK: card view layout for views
@objcMembers
@IBDesignable
class CardViews: UIView {
    @IBInspectable var cornerRadius: CGFloat = 5
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0
    @IBInspectable var cornerradiusColor: UIColor? = UIColor.black
    @IBInspectable var borderWidth: CGFloat = 0

    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.borderColor = cornerradiusColor?.cgColor
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.borderWidth = borderWidth
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}


