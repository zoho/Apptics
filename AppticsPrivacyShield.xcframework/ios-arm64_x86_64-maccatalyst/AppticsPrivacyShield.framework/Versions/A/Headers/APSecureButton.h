//
//  APSecureButton.h
//  AppticsPrivacyShield
//
//  Created by Saravanan S on 10/06/24.
//

#import <UIKit/UIKit.h>
#import <AppticsPrivacyShield/APSecureContainer.h>

NS_ASSUME_NONNULL_BEGIN

@interface APSecureButton : UIView

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) APSecureContainer *secureContainer;
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
