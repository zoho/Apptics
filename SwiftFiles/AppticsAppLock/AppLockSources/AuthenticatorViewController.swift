//
//  AuthenticatorViewController.swift
//  SampleLock
//
//  Created by Raghavendra Panth R on 22/05/19.
//  Copyright © 2019 Jambav. All rights reserved.
//

import Foundation
import UIKit

class AuthenticatorViewController: UIViewController {
    fileprivate var shoulPrompt = true
    var isPrimaryPrompt: Bool = false
    
    
    var titleLabel: UILabel = {
        let x = UILabel()
        x.font = AppticsLock.shared.defaulTheme?.initialTitleFont()
        //x.textColor = .black
        x.translatesAutoresizingMaskIntoConstraints = false
        return x
    }()
    
    var subTitleLabel: UILabel = {
        let x = UILabel()
        x.font = AppticsLock.shared.defaulTheme?.initialDetailFont()
        // x.textColor = .black
        x.translatesAutoresizingMaskIntoConstraints = false
        return x
    }()
    
    var imageView: UIImageView = {
        let x = UIImageView()
        x.translatesAutoresizingMaskIntoConstraints = false
        return x
    }()
    
    let appName: String = {
        let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as! String
        
        if let name  = displayName {
            
            return name
        }
        return bundleName
        
    }()
    internal var defaultColor = { () -> UIColor in
        if #available(iOS 13.0, *) {
            return UIColor { (trait) -> UIColor in
                switch trait.userInterfaceStyle{
                case .dark :
                    return UIColor.white
                    
                case .light :
                    return UIColor.black
                case .unspecified:
                    return .black
                @unknown default:
                    return .black
                }
            }
        } else {
            // Fallback on earlier versions
            return UIColor.black
        }
    }()
    internal var defaultBgColor = { () -> UIColor in
        if #available(iOS 13.0, *) {
            return UIColor { (trait) -> UIColor in
                switch trait.userInterfaceStyle{
                case .dark :
                    return UIColor.black
                    
                case .light :
                    return UIColor.white
                case .unspecified:
                    return .white
                @unknown default:
                    return .white
                }
            }
        } else {
            // Fallback on earlier versions
            return UIColor.white
        }
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let color = AppticsLock.shared.defaulTheme?.authenticationScreenColor() {
            self.view.backgroundColor = color
        } else {
            self.view.backgroundColor = self.defaultBgColor
        }
        
        self.configureUI()
        
        if !isPrimaryPrompt {
            // secondary VC just waits for unlock
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleUnlocked),
                name: .appDidUnlock,
                object: nil
            )
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if isPrimaryPrompt {
            if Authenticator().canAuthenticate() {
                self.showauthenticator()
            } else if AppticsLock.shared.config.shouldAllowIfPasscodeTurnedoff {
                AuthenticatorKeychain().save(asString: "false")
                AppticsLock.shared.removeEntryAuthenticator()
            } else {
                showsetupTouchID()
            }
        }
        // Note: the `.appDidUnlock` observer for secondary prompts is registered once in
        // viewDidLoad — do not re-add it here (viewDidAppear can fire multiple times).
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
    }
    
    func configureUI() {
        self.view.addSubview(titleLabel)
        
        if let textColor = AppticsLock.shared.defaulTheme?.authenticationScreenTextColor(){
            
            titleLabel.textColor =  textColor
            subTitleLabel.textColor = textColor
            
        }
        
        
        titleLabel.text = String(format: "app.haslocked".getLocalizedString(), appName)
        titleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        subTitleLabel.text = "app.authenticate.authenticate".getLocalizedString()
        self.view.addSubview(subTitleLabel)
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        subTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        
        if let frameworkBundle = Bundle(for: Authenticator.self).resourceURL?.appendingPathComponent("AppShield.bundle"),
           let resourceBundle = Bundle(url: frameworkBundle) {
            // For CocoaPods: Use the resource bundle loaded from the bundle URL
            if let image = UIImage(named: "locker", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate) {
                imageView.image = image
                if let textColor = AppticsLock.shared.defaulTheme?.authenticationScreenTextColor() {
                    imageView.tintColor = textColor
                } else {
                    imageView.tintColor = self.defaultColor
                }
            } else {
                print("Image 'locker' not found in CocoaPods bundle.")
            }
        } else {
            // For Swift Package Manager: Use .module
#if USING_SPM
            if let image = UIImage(named: "locker", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate) {
                imageView.image = image
                if let textColor = AppticsLock.shared.defaulTheme?.authenticationScreenTextColor() {
                    imageView.tintColor = textColor
                } else {
                    imageView.tintColor = self.defaultColor
                }
            } else {
                print("Image 'locker' not found in SPM bundle.")
            }
#endif
        }
        self.view.addSubview(imageView)
        imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -15).isActive = true
        imageView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor, constant: 0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if shoulPrompt{
            self.showauthenticator()
            shoulPrompt = false
        }
    }
    
    func showauthenticator() {
        AppticsLock.shared.isValidating = true
        Authenticator().authenticateWithPasscode { [weak self] (result) in
            DispatchQueue.main.async {

                self?.shoulPrompt = true

                switch result {
                case .success(_):
                    AppticsLock.shared.isUnlocked = true   // ✅ mark unlocked
                    AppticsLock.shared.removeEntryAuthenticator()
                    AppticsLock.shared.hideNewBlur()
                    NotificationCenter.default.post(name: .appDidUnlock, object: nil)

                case .failure(let error):
                    print(Authenticator.parseError(error))
                }
                AppticsLock.shared.isValidating = false
            }
            
            
        }
    }
    
    @objc private func handleUnlocked() {
        // secondary VC dismisses itself when unlock happens
        self.dismiss(animated: true, completion: nil)
    }
    
    func showsetupTouchID() {
        
        let type = Authenticator.isTouchID() ? "Touch" : "Face"
        let titleString = String(format: "app.authenticate.setup".getLocalizedString(), type)  + appName
        let alert = UIAlertController(title: titleString, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "app.settings".getLocalizedString(), style: .default, handler: {action in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
#if os(iOS)
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                } else {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
#endif
        }))
        
        self.present(alert, animated:true, completion:nil)
    }
    
    
    
}


