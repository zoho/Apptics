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

// Public headers -----------------------------------------------------------
#import <AppticsPrivacyShield/APSecureContainer.h>
#import <AppticsPrivacyShield/APSecureView.h>
#import <AppticsPrivacyShield/APSecureImageView.h>
#import <AppticsPrivacyShield/APSecureLabel.h>
#import <AppticsPrivacyShield/APSecureButton.h>
#import <AppticsPrivacyShield/APSecureTextView.h>
#import <AppticsPrivacyShield/APWindowShield.h>

#import <LocalAuthentication/LocalAuthentication.h>

NS_ASSUME_NONNULL_BEGIN

/// Permission state for temporary shield disablement (biometric auth).
typedef NS_ENUM(NSInteger, APPrivacyShieldPermissionState) {
    APPrivacyShieldPermissionStateUnknown  = 0,
    APPrivacyShieldPermissionStateGranted,
    APPrivacyShieldPermissionStateDenied
};



// ---------------------------------------------------------------------------
#pragma mark - AppticsPrivacyShield
// ---------------------------------------------------------------------------

/// Central controller for the Apptics Privacy Shield SDK.
///
/// ## Quick start
///
/// **1. Automatic window protection (protects everything, ObjC / Swift / SwiftUI):**
/// ```objc
/// - (BOOL)application:(UIApplication *)app didFinishLaunchingWithOptions:(NSDictionary *)opts {
///     [AppticsPrivacyShield startMonitoring];
///     [AppticsPrivacyShield protectWindow:self.window];
///     return YES;
/// }
/// ```
///
/// **2. Per-view protection (wrap individual views):**
/// ```objc
/// APSecureView *guard = [[APSecureView alloc] initWithContentView:mySensitiveView];
/// [self.view addSubview:guard];
/// ```
///
/// **SwiftUI:**
/// ```swift
/// // In your App's init or SceneDelegate:
/// AppticsPrivacyShield.startMonitoring()
/// if let window = UIApplication.shared.connectedScenes
///     .compactMap({ $0 as? UIWindowScene }).first?.windows.first {
///     AppticsPrivacyShield.protect(window)
/// }
/// ```
///
@interface AppticsPrivacyShield : NSObject

// ---- Singleton -----------------------------------------------------------

+ (instancetype)listener;

// ---- Monitoring ----------------------------------------------------------

/// Start screenshot / screen-recording monitoring.  Call once at app launch.
+ (void)startMonitoring;

/// Stop monitoring and remove all shields.
+ (void)stopMonitoring;

// ---- Window-level protection ---------------------------------------------

/// Protect an entire window.  All subviews (current and future) are rendered
/// inside a secure container — screenshots / recordings see a blank window.
/// Touches, gestures, scrolls, and navigation continue to work normally.
///
/// Works with UIKit, Objective-C, Swift, and SwiftUI.
+ (void)protectWindow:(UIWindow *)window;

/// Remove window-level protection.
+ (void)unprotectWindow:(UIWindow *)window;

/// Protect **all** currently visible windows across all scenes.
+ (void)protectAllWindows;

// ---- Shield on / off -----------------------------------------------------

/// Master toggle.  Default is YES (shield on).  Persisted across launches.
+ (void)enablePrivacyShield:(BOOL)status;
+ (BOOL)privacyShieldStatus;

// ---- Permission / consent ------------------------------------------------

/// Current biometric-auth permission state.
+ (APPrivacyShieldPermissionState)permissionState;

/// Shared decision point — returns YES when content should be hidden.
+ (BOOL)shouldPreventScreenCapture;

/// Controls whether a consent popup appears when a screenshot/recording is
/// detected.  Default is YES.
+ (void)setScreenCaptureConsentEnabled:(BOOL)enabled;
+ (BOOL)screenCaptureConsentEnabled;

@end

NS_ASSUME_NONNULL_END
