//
//  AppticsPrivacyShield.h
//  AppticsPrivacyShield
//
//  Created by Saravanan S on 10/06/24.
//

#import <Foundation/Foundation.h>

//! Project version number for AppticsPrivacyShield.
FOUNDATION_EXPORT double AppticsPrivacyShieldVersionNumber;

//! Project version string for AppticsPrivacyShield.
FOUNDATION_EXPORT const unsigned char AppticsPrivacyShieldVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <AppticsPrivacyShield/PublicHeader.h>
//

#import <AppticsPrivacyShield/APSecureImageView.h>
#import <AppticsPrivacyShield/APSecureLabel.h>
#import <AppticsPrivacyShield/APSecureButton.h>
#import <AppticsPrivacyShield/APSecureTextView.h>
#import <AppticsPrivacyShield/APSecureView.h>

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

/**
 *  Use this class to integrate Apptics Privacy Shield with your app.

 */
@interface AppticsPrivacyShield : NSObject

@property (nonatomic, assign) BOOL hasCheckedPermissionThisSession;
@property (nonatomic, assign) BOOL isAlertActive;

@property (nonatomic, assign) BOOL isWindowShieldEnabled;

+ (instancetype)listener;

/**
 Call this method to start monitoring for screenshots.
 */
+ (void) startMonitoring;

/**
 Call this method to stop monitoring for screenshots.
 */
+ (void) stopMonitoring;

/**
 Returns the status of Apptics Privacy Shield.
 */
+ (bool) privacyShieldStatus;

/**
 Set the Apptics Privacy Shield status.
 Default value is TRUE.
 
 @param status boolean
 */
+ (void) enablePrivacyShield:(bool) status;

@end
