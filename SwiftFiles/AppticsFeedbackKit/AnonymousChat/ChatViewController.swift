//
//  ChatViewController.swift
//  AppticsFeedbackKitSwift
//
//  Created by jai-13322 on 16/05/23.
//

import UIKit
import AppticsFeedbackKit

@available(iOS 11.0, *)
class ChatViewController: UIViewController {

    var overlayView = AnonymousAttachmentView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlayView = AnonymousAttachmentView(frame: CGRect(x: 0, y:0, width:view.frame.size.width, height:view.frame.size.height))
        view.addSubview(overlayView)
        
        overlayView.hideBttn.addTarget(self, action:#selector(self.hidebuttonClicked), for: .touchUpInside)
        
    }

    
    //MARK: Cancel Button Click Action
    @objc func hidebuttonClicked() {
        
        dismiss(animated: true, completion: nil)
        
    }
   

}
