//
//  KeyChainAuthentication.swift
//  AppShield
//
//  Created by Asif on 10/05/24.
//  Credits: IAM


import Foundation
import UIKit
import LocalAuthentication


@objc
public enum AuthenticationStatus : Int {
    // -25291 = errSecNotAvailable -> Add failed due to passcode turned off,
    // -25293 = errSecAuthFailed -> Add failed due to passcode turned off but data already saved,
    // -128 = errSecUserCanceled -> Cancelled,
    // -25300 = errSecItemNotFound -> No saved item in keychain or passcode turned off.
    case allow
    case cancelled
    case fallback
}
public enum OABiometricEnabledStatus {
    case enabled
    case passcodeNotSet
    case failed
}



extension UIViewController {
    /// Presents an alert with a title, message, and two action buttons.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message of the alert.
    ///   - primaryTitle: The title of the primary button.
    ///   - secondaryTitle: The title of the secondary button.
    ///   - primaryAction: The closure to execute when the primary button is tapped.
    ///   - secondaryAction: The closure to execute when the secondary button is tapped.
    func showAlert(title: String?, message: String?, primaryTitle: String, primaryAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Primary action
        let primaryButton = UIAlertAction(title: primaryTitle, style: .default) { _ in
            primaryAction()
        }
        
        // Secondary action
        
        
        // Adding actions to the alert controller
        alert.addAction(primaryButton)
        
        
        // Present the alert
        var xalert = presentedViewController
        if xalert != nil && (xalert is UIAlertController) {
            
        }
        else{
            self.present(alert, animated: true)
        }
    }
}




class AppLockManager {
    static let shared = AppLockManager()
    private let serviceIdentifier = "com.AppShield.app"
    private let accountBiometric = "biometricAccess"
    private let accountPasscode = "passcodeAccess"
    
    // Setup Access Control for Biometric
    private func accessControlBiometric() -> SecAccessControl? {
        var error: Unmanaged<CFError>?
        let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .biometryCurrentSet, &error)
        return (error == nil) ? access : nil
    }
    
    // Setup Access Control for Passcode
    private func accessControlPasscode() -> SecAccessControl? {
        var error: Unmanaged<CFError>?
        let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .devicePasscode, &error)
        return (error == nil) ? access : nil
    }
    
    // Add or Update Keychain Item
    private func addOrUpdateItem(account: String, data: String, using accessControl: SecAccessControl?) -> OSStatus {
        let data = data.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessControl as String: accessControl!,
            kSecUseAuthenticationUI as String: kSecUseAuthenticationUIAllow
        ]
        
        SecItemDelete(query as CFDictionary) // Remove old item if it exists
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    // Access Keychain Item
    func accessItem(account: String, completion: @escaping (Bool) -> Void) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount as String: account,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecUseOperationPrompt as String: "Authenticate to access your secure data"
        ]
        
        // SecItemCopyMatching on a biometric-protected item presents the Face ID / passcode
        // sheet and blocks the calling thread until the user responds. Run it off the main
        // thread so the UI/CFRunLoop isn't stalled, then deliver results on main.
        DispatchQueue.global(qos: .userInitiated).async {
            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)

            DispatchQueue.main.async {
                completion(status == errSecSuccess)
                self.handleError(status)
            }
        }
    }
    
    func handleError(_ status:OSStatus){
      
        
        switch status {
        case -25293 :
            let appName: String = {
                let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
                let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as! String
                
                if let name  = displayName {
                    
                    return name
                }
                return bundleName
                
            }()
            let type = Authenticator.isTouchID() ? "Touch" : "Face"
            let titleString = String(format: "app.authenticate.setup".getLocalizedString(), type)  + appName
            AppticsLock.shared.window.rootViewController?.showAlert(title: titleString, message: "", primaryTitle: "Ok", primaryAction: {
                
            })
        case -25300 :
            AppLockManager.shared.enableAppLock()
        default:
            break
        }
        
    }
    
    // Enable Biometric and Passcode Lock
    func enableAppLock() {
        if let acBiometric = accessControlBiometric() {
            _ = addOrUpdateItem(account: accountBiometric, data: "biometricProtected", using: acBiometric)
        }
        
        if let acPasscode = accessControlPasscode() {
            _ = addOrUpdateItem(account: accountPasscode, data: "passcodeProtected", using: acPasscode)
        }
    }
    
    // Access Biometric
    func accessBiometric(completion: @escaping (Bool) -> Void) {
        
        
        accessItem(account: accountBiometric) { success in
            if success {
                completion(true)
            } else {
                // Biometric failed, try passcode
                self.accessPasscode(completion: completion)
            }
        }
        
        
        
    }
    
    // Access Passcode
    func accessPasscode(completion: @escaping (Bool) -> Void) {
        accessItem(account: accountPasscode, completion: completion)
    }
    
    
    private func accessControlForPasscodeVerification() -> SecAccessControl? {
        var error: Unmanaged<CFError>?
        let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .devicePasscode, &error)
        return (error == nil) ? access : nil
    }
    
    // Separate function to setup and store the passcode verification key at launch
  
    @discardableResult  func removeAllItems() -> Bool {
        let statusBiometric = deleteItem(account: accountBiometric)
        let statusPasscode = deleteItem(account: accountPasscode)
        return (statusBiometric == errSecSuccess || statusBiometric == errSecItemNotFound) &&
        (statusPasscode == errSecSuccess || statusPasscode == errSecItemNotFound)
    }
    
    // Helper method to delete a Keychain item
    private func deleteItem(account: String) -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount as String: account
        ]
        
        return SecItemDelete(query as CFDictionary)
    }
}
