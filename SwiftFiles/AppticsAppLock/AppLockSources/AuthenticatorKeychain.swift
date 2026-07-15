//
//  AuthenticatorKeychain.swift
//  AppShield
//
//  Created by Raghavendra Panth R on 22/05/19.
//


import Foundation
import UIKit
import Security


let serviceName = "AuthenticatorService"
let passcodeStorageCode = "Authenticator.authenticate"

internal class AuthenticatorKeychain: NSObject {
    
    @discardableResult
    func save(asString passcode: String) -> Bool {
        return self.setKeyChain(value: passcode, withKey: passcodeStorageCode, forService: serviceName)
    }
    
    func get() -> String {
        let passcode = self.getValue(forKey: passcodeStorageCode, andService: serviceName) ?? ""
        return passcode
    }
    
    func delete() -> Bool {
        return self.setKeyChain(value: "", withKey: passcodeStorageCode, forService: serviceName)
    }
    
    
    
    // MARK: -
    @discardableResult
    fileprivate func setKeyChain(value: String, withKey key: String, forService service: String) -> Bool {
        guard let valueData: Data = value.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return false
        }
        
        var keychainQuery: [NSObject: AnyObject] =  [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : service as AnyObject,
            kSecAttrAccount : key as AnyObject,
            kSecValueData : valueData as AnyObject]
        
        if let groupID = Bundle.main.object(forInfoDictionaryKey: "App Group Bundle ID") as? String {
            keychainQuery[kSecAttrAccessGroup] = groupID as AnyObject
        }
        
        
        SecItemDelete(keychainQuery as CFDictionary)
        
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        
        return status == noErr
    }
    
    fileprivate func removeKeyChain(havingKey key: String, forService service: String) -> Bool {
        var keychainQuery: [NSObject: AnyObject] =  [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : service as AnyObject,
            kSecAttrAccount : key as AnyObject,
            kSecAttrAccessGroup: (Bundle.main.object(forInfoDictionaryKey: "App Group Bundle ID") as! String) as AnyObject,
            kSecReturnData : kCFBooleanTrue]
        
        if let groupID = Bundle.main.object(forInfoDictionaryKey: "App Group Bundle ID") as? String {
            keychainQuery[kSecAttrAccessGroup] = groupID as AnyObject
        }
        
        
        let status = SecItemDelete(keychainQuery as CFDictionary)
        
        return status == noErr
    }
    
    fileprivate func getValue(forKey key: String, andService service: String) -> String? {
        var keychainQuery: [NSObject: AnyObject] =  [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : service as AnyObject,
            kSecAttrAccount : key as AnyObject,
            kSecReturnData : kCFBooleanTrue,
            kSecMatchLimit : kSecMatchLimitOne]
        
        if let groupID = Bundle.main.object(forInfoDictionaryKey: "App Group Bundle ID") as? String {
            keychainQuery[kSecAttrAccessGroup] = groupID as AnyObject
        }
        
        var dataTypeRef : CFTypeRef?
        
        let status: OSStatus = SecItemCopyMatching(keychainQuery as CFDictionary, &dataTypeRef)
        
        if status == noErr
        {
            guard let contentsOfKeyChain = dataTypeRef as? Data
                else
            {
                return nil
            }
            
            let string = String(data: contentsOfKeyChain, encoding: String.Encoding.utf8)
            
            return string
        }
        else
        {
            return nil
        }
    }
}
