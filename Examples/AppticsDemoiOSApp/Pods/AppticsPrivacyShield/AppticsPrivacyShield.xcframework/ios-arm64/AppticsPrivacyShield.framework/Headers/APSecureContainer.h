//
//  APSecureContainer.h
//  AppticsPrivacyShield
//
//  Created by Saravanan S on 10/06/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol APProtectableSecureView <NSObject>
@end

@interface APSecureContainer : UIView <APProtectableSecureView>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, assign) BOOL preventScreenCapture;

+ (BOOL)isSecureContainerAvailable;

@end

NS_ASSUME_NONNULL_END
