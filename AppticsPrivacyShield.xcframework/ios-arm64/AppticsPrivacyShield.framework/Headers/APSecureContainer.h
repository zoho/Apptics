//
//  APSecureContainer.h
//  AppticsPrivacyShield
//
//  Created by Saravanan S on 10/06/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Protocol adopted by all secure view wrappers so the SDK can detect
/// whether any protected surface is currently visible on screen.
@protocol APProtectableSecureView <NSObject>
@end

/// A container view that renders its children inside a secure rendering
/// context derived from UITextField's `secureTextEntry` flag.
///
/// ## How it works
/// 1. An internal UITextField with `secureTextEntry = YES` is created.
/// 2. iOS places the text field's content inside a private
///    `_UITextLayoutCanvasView` (iOS 15+) whose backing CALayer carries a
///    "do-not-capture" flag — screenshots and screen-recordings see a blank
///    region instead of the actual pixels.
/// 3. All child views added via `-addSubview:` are redirected into that
///    canvas view, so they inherit the capture-protection automatically.
/// 4. A custom `hitTest:withEvent:` chain ensures **every touch, gesture,
///    scroll, and drag event reaches the child views exactly as if the
///    container were not there**.
///
/// ## Usage
///
/// **View-level (wrap a single view):**
/// ```objc
/// APSecureContainer *container = [[APSecureContainer alloc] init];
/// [container addSubview:mySensitiveView];
/// [self.view addSubview:container];
/// ```
///
/// **Window-level — see `APWindowShield`.**
///
@interface APSecureContainer : UIView <APProtectableSecureView>

/// The internal canvas view (read-only) where child views actually live.
/// May be `nil` on unsupported OS versions — in that case the container
/// still works as a plain UIView but without capture-protection.
@property (nonatomic, strong, readonly, nullable) UIView *contentView;

/// Toggle capture-protection on or off.  Default is `YES`.
@property (nonatomic, assign) BOOL preventScreenCapture;

/// Returns `YES` when the private canvas view is available on this
/// device / OS combination.
+ (BOOL)isSecureContainerAvailable;

@end

NS_ASSUME_NONNULL_END
