//
//  FeedIDView.swift
//  AppticsFeedbackKitSwift
//
//  Created by jai-13322 on 29/05/23.
//
import Foundation
import AppticsFeedbackKit

//MARK: Window setup for button
@objc public class AnonymFeedIDWindow: UIWindow {
    
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
public class AnonymFeedIDViewController:UIViewController{
    
    
    public lazy var window = AnonymFeedIDWindow()
    var AnonymChatxib = FeedIDChatView()
    
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
        AnonymChatxib = FeedIDChatView(frame: CGRect(x: 0, y: 0, width:view.frame.size.width, height: view.frame.size.height ))
        view.addSubview(AnonymChatxib)
        window.views = AnonymChatxib
        window.center = CGPoint(x: window.center.x + window.frame.size.width, y: window.center.y)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: { [self] in
            self.window.center = CGPoint(x: self.window.center.x - self.window.frame.size.width, y: window.center.y)
        }, completion: nil)
     
        AnonymChatxib.backBttn.addTarget(self, action:#selector(self.cancellbuttonClicked), for: .touchUpInside)
        AnonymChatxib.backIconBttn.addTarget(self, action:#selector(self.cancellbuttonClicked), for: .touchUpInside)


    }
    
    
  
    
    
   
 
    
    
    
    //MARK: Cancel Button Click Action
    @objc func cancellbuttonClicked() {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: { [self] in
            self.window.center = CGPoint(x: self.window.center.x + self.window.frame.size.width, y: window.center.y)
        }, completion: { success in
            self.window.isHidden = true
            self.window.removeFromSuperview()
            
        })
        
    }
    
  
    
    
}
