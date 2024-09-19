//
//  APSecureImageView.h
//  AppticsPrivacyShield
//
//  Created by Saravanan S on 10/06/24.
//

#import <UIKit/UIKit.h>
#import <AppticsPrivacyShield/APSecureContainer.h>
#import <AppticsPrivacyShield/AppticsPrivacyShield.h>

NS_ASSUME_NONNULL_BEGIN

@interface APSecureImageView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) APSecureContainer *secureContainer;
@property (nonatomic, strong, nullable) UIImage *image;

@end

NS_ASSUME_NONNULL_END
