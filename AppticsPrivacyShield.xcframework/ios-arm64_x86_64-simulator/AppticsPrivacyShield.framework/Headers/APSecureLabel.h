//
//  APSecureLabel.h
//  AppticsPrivacyShield
//
//  Created by Saravanan S on 10/06/24.
//

#import <UIKit/UIKit.h>
#import <AppticsPrivacyShield/APSecureContainer.h>
#import <AppticsPrivacyShield/AppticsPrivacyShield.h>

NS_ASSUME_NONNULL_BEGIN

@interface APSecureLabel : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) APSecureContainer *secureContainer;
@property (nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
