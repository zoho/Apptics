//
//  AnonymChat.swift
//  AppticsFeedbackKitSwift
//
//  Created by jai-13322 on 11/05/23.
//

import Foundation
import AppticsFeedbackKit

//MARK: Window setup for button
@objc public class AnonymChatWindow: UIWindow {
    
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
public class AnonymChatViewController:UIViewController{
    
    
    public lazy var window = AnonymChatWindow()
    var AnonymChatxib = AnonymChatView()
    
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
        loadFontForCPResourceBundle()
        NotificationCenter.default.addObserver(self, selector: #selector(self.bttnAttachmentPress), name:Notification.Name(notificationLoadAnonymChatConversation) , object: nil)
        
        AnonymChatxib = AnonymChatView(frame: CGRect(x: 0, y: 0, width:view.frame.size.width, height: view.frame.size.height ))
        view.addSubview(AnonymChatxib)
        window.views = AnonymChatxib
        window.center = CGPoint(x: window.center.x + window.frame.size.width, y: window.center.y)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: { [self] in
            self.window.center = CGPoint(x: self.window.center.x - self.window.frame.size.width, y: window.center.y)
        }, completion: nil)
        AnonymChatxib.backBttn.addTarget(self, action:#selector(self.cancellbuttonClicked), for: .touchUpInside)
        AnonymChatxib.backIconBttn.addTarget(self, action:#selector(self.cancellbuttonClicked), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
   
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.size.height
            if keyboardHeight > 300{
                AnonymChatxib.textFieldBottomConstraint.constant = keyboardHeight - 30
            }
            else{
                AnonymChatxib.textFieldBottomConstraint.constant = keyboardHeight
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        AnonymChatxib.textFieldBottomConstraint.constant = 10
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    //MARK: Notification for close reportBug screens 2action
    @objc func bttnAttachmentPress() {
        let destinationViewController = ChatViewController()
        destinationViewController.modalPresentationStyle = .popover
        present(destinationViewController, animated: true, completion: nil)
    }
    

    
    //MARK: Cancel Button Click Action
    @objc func cancellbuttonClicked() {
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: { [self] in
            self.window.center = CGPoint(x: self.window.center.x + self.window.frame.size.width, y: window.center.y)
        }, completion: { success in
            self.window.isHidden = true
            self.window.removeFromSuperview()
            
        })
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(notificationLoadAnonymChatConversation), object: nil)
        NotificationCenter.default.removeObserver(self)

    }
    
    
}

/*
 //MARK: theme check in trait
 public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
 super.traitCollectionDidChange(previousTraitCollection)
 if #available(iOS 13.0, *) {
 if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
 if traitCollection.userInterfaceStyle == .dark {
 
 }
 else {
 
 }
 }
 } else {
 
 }
 }
 */

