//
//  APPrivacyGuard.h
//  AppticsPrivacyShield
//
//  Created by Saravanan S on 10/06/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AppticsPrivacyShield/APSecureContainer.h>

NS_ASSUME_NONNULL_BEGIN

@interface APSecureView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL preventScreenCapture;

- (instancetype)initWithContentView:(UIView *)contentView;
- (void)addContentView:(UIView *)contentView;

@end

@interface APSafeContainer : NSObject

- (UIView * _Nullable)findHiddenContainerInView:(UIView *)view;

@end

@interface APWindowShield : NSObject

@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL viewActive;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;

+ (instancetype)shared;
- (void) enableScreenRecordingMonitoring;
- (void) disableScreenRecordingMonitoring;

@end
NS_ASSUME_NONNULL_END
