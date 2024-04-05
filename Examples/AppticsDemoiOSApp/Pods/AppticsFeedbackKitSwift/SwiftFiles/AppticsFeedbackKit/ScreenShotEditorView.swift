//
//  ScreenShotEditorView.swift
//  MyFramework
//
//  Created by jai-13322 on 17/08/22.
//

import UIKit
@objcMembers
class ScreenShotEditorView: UIView {

    @IBOutlet weak var mainview:UIView!
    @IBOutlet weak var closeBttn:UIButton!
    @IBOutlet weak var doneBttn:UIButton!
    @IBOutlet weak var cardView:CardViews!
    @IBOutlet weak var clobttnTopConst:NSLayoutConstraint!
    @IBOutlet weak var doneBttnTopConst:NSLayoutConstraint!
    let DEVICE_SIZE = UIApplication.shared.keyWindow?.rootViewController?.view.convert(UIScreen.main.bounds, from: nil).size

    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func commoninit(color:UIColor){
        let bundles = bundles
        let view = bundles.loadNibNamed("ScreenShotEditorView", owner: self, options: nil)! [0] as! UIView
        view.frame = self.bounds
        view.backgroundColor = .clear
        addSubview(view)
        if DEVICE_SIZE!.height < 670{
            clobttnTopConst.constant = 20
            doneBttnTopConst.constant = 20
        }
        setTranspreancy(view: view)
    }

    func setTranspreancy(view:UIView){
        if FeedbackTheme.sharedInstance.setTransparencySettingsEnabled  == false{
                   view.backgroundColor = .clear
            if #available(iOS 10.0, *) {
                       let blurEffect = UIBlurEffect(style: .regular)
                       let blurEffectView = UIVisualEffectView(effect: blurEffect)
                       blurEffectView.frame = self.bounds
                       view.addSubview(blurEffectView)
                       view.sendSubviewToBack(blurEffectView)
                       blurEffectView.layer.cornerRadius = 10
                       blurEffectView.layer.masksToBounds = true
                       blurEffectView.layer.borderWidth = 2
                       blurEffectView.layer.borderColor = UIColor.clear.cgColor
                   } else {}
               } else {
                   view.backgroundColor = FeedbackTheme.sharedInstance.ViewColor
               }
    }
    
    
}
