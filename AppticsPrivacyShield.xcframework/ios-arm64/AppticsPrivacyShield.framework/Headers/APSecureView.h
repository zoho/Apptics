//
//  APSecureView.h
//  AppticsPrivacyShield
//
//  Created by Saravanan S on 10/06/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AppticsPrivacyShield/APSecureContainer.h>

NS_ASSUME_NONNULL_BEGIN

/// A convenience wrapper that places an arbitrary `contentView` inside an
/// `APSecureContainer`.  Use this to protect individual views without
/// adopting a per-type subclass (APSecureLabel, APSecureButton, etc.).
///
/// ```objc
/// APSecureView *guard = [[APSecureView alloc] initWithContentView:myMapView];
/// [self.view addSubview:guard];
/// ```
@interface APSecureView : UIView <APProtectableSecureView>

/// The user-supplied view that lives inside the secure container.
@property (nonatomic, strong, nullable) UIView *contentView;

/// Toggle capture-protection on or off.  Default is YES.
@property (nonatomic, assign) BOOL preventScreenCapture;

/// Designated convenience initializer — wraps `contentView` immediately.
- (instancetype)initWithContentView:(UIView *)contentView;

/// Add or replace the wrapped content view after initialization.
- (void)addContentView:(UIView *)contentView;

@end

NS_ASSUME_NONNULL_END
