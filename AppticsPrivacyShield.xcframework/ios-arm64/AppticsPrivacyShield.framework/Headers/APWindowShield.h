//
//  APWindowShield.h
//  AppticsPrivacyShield
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Manages window-level screenshot and screen-recording protection.
///
/// ## How it works
///
/// **Screenshot prevention** — an `APSecureContainer` is inserted as the
/// bottom-most subview of the target UIWindow.  All existing (and future)
/// subviews are migrated into its secure canvas.  Because the container
/// uses a passthrough UITextField, **all touches, gestures, scrolls, and
/// drags work normally**.
///
/// **Screen-recording shield** — when `UIScreen.mainScreen.isCaptured`
/// becomes `YES`, a `UIVisualEffectView` blur overlay is placed on top of
/// every visible window so the recording captures only the blur.
///
/// The class is designed to be used as a singleton via `+shared`.
///
@interface APWindowShield : NSObject

+ (instancetype)shared;

// ---- Screenshot prevention (view-level secure rendering) -----------------

/// Protect a single window.  Idempotent — calling twice on the same
/// window is a no-op.
/// @return YES on success.
- (BOOL)enableShieldForWindow:(UIWindow *)window;

/// Remove protection from a specific window, restoring the original
/// view hierarchy.
- (void)disableShieldForWindow:(UIWindow *)window;

/// Remove protection from **all** currently protected windows.
- (void)disableShield;

/// Enable auto-protection: any window that becomes visible in the future
/// will be automatically protected.  Call once at app launch so that
/// scene-based apps (iOS 13+) are covered even when no window exists yet
/// at the time of the call.
- (void)enableAutoProtect;

/// Disable auto-protection.  Already-protected windows stay protected.
- (void)disableAutoProtect;

/// YES after at least one window is protected.
@property (nonatomic, readonly, getter=isShieldEnabled) BOOL shieldEnabled;

/// Optional branding image shown in the screen-recording blur overlay.
@property (nonatomic, strong, nullable) UIImage *placeholderImage;

// ---- Screen-recording shield (blur overlay) ------------------------------

/// Start observing `UIScreenCapturedDidChangeNotification` and show a
/// blur overlay whenever screen recording is active.
- (void)enableScreenRecordingMonitoring;

/// Stop monitoring and remove any visible blur overlays.
- (void)disableScreenRecordingMonitoring;

/// Customisable label shown in the centre of the blur overlay.
@property (nonatomic, strong, nullable) UILabel *label;

/// Customisable image view shown above the label in the blur overlay.
@property (nonatomic, strong, nullable) UIImageView *imageView;

/// Optional full-screen content view to show instead of the default
/// blur label / image.
@property (nonatomic, strong, nullable) UIView *contentView;

/// YES while the blur overlay is on screen.
@property (nonatomic, readonly) BOOL blurViewActive;

/// The current blur overlay (may be nil).
@property (nonatomic, strong, readonly, nullable) UIVisualEffectView *blurView;

@end

NS_ASSUME_NONNULL_END
