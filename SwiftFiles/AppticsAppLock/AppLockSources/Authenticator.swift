//
//  Authenticator.swift
//  SampleLock
//
//  Created by Raghavendra Panth R on 22/05/19.
//  Copyright © 2019 Asif. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

@objcMembers public class Authenticator: NSObject {

    public func authenticateWithPasscode(then: @escaping (Result<Any, Error>) -> Void){
        
        
        
        AppLockManager.shared.accessBiometric { success in
            if success {
                then(.success(success))
            } else {
                then(.failure(self.getCustomLAError()))
            }
        }

        

    }
    
    func getCustomLAError() -> Error {
        // Choose the appropriate error code based on your scenario
        let errorCode = LAError.Code.authenticationFailed

        // Create an LAError instance using the chosen error code
        let error = LAError(errorCode)

        // Return this error, which is automatically treated as an Error due to protocol conformance
        return error
    }
    
    func canAuthenticate() -> Bool{
        let localAuthenticationContext = LAContext()
        var authError: NSError?
        return localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError)
    }
    
    class func isTouchID() -> Bool {
        if #available(iOS 11.0, *) {
            switch LAContext().biometryType {
            case .none:
                if UIDevice().hasNotch{
                    return false
                }
                else{
                    return true
                }
            case .touchID:
                return true
            case .faceID:
                return false
            case .opticID:
                return false
            @unknown default:
                return true
            }
        } else {
            return true
        }
    }
    

    
}
extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {

            let bottom = AppticsLock.shared.window.safeAreaInsets.bottom
            return bottom > 0

        }
        else{
            return false
        }

    }
}

extension Authenticator {
    
    public class func parseError(_ error: Error) -> String {
        
        let code = (error as NSError).code

        var message = ""
        switch code {
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = parseFailureError(code: code)
        }
        
        return message
    }
    
    internal class func parseFailureError(code: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch code {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch code {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }

}
@objcMembers open class AuthenticationConfiguration : NSObject{
    
    var delayTime:Double!
    internal var userdefaultKeyName : String!
    internal var blurBackgroundColor : UIColor!
    internal var shouldAllowIfPasscodeTurnedoff : Bool!
    internal var lockTintColor:UIColor!
    internal var defaultColor = { () -> UIColor in
        if #available(iOS 13.0, *) {
            if (UIScreen.main.traitCollection.userInterfaceStyle == .dark){
                return UIColor.white
            }
            else{
                return UIColor.black
            }
        } else {
            // Fallback on earlier versions
            return UIColor.black
        }
    }()
    internal var defaultBgColor = { () -> UIColor in
        if #available(iOS 13.0, *) {
            if (UIScreen.main.traitCollection.userInterfaceStyle == .dark){
                return UIColor.black
            }
            else{
                return UIColor.white
            }
        } else {
            // Fallback on earlier versions
            return UIColor.white
        }
    }()
    
    public convenience init(blurBackgroundColor:UIColor?,delayTime:Double? = 0,shouldAllowIfPasscodeTurnedoff:Bool?,lockTint:UIColor? = nil,userDefaultPrefix:String? = nil) {
        self.init()
        self.delayTime = delayTime ?? 0
        self.blurBackgroundColor = blurBackgroundColor ?? nil
        self.shouldAllowIfPasscodeTurnedoff = shouldAllowIfPasscodeTurnedoff ?? false
        self.lockTintColor = lockTint ?? defaultColor
        self.userdefaultKeyName = userDefaultPrefix ?? nil
    }
    public override init() {
        super.init()
    }
    internal func setDelay(_ delay:Double){

        self.delayTime = delay
    }
    
    
    
    
    
    
}


