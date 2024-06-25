//
//  APSecureImageView.h
//  AppticsPrivacyProtector
//
//  Created by Saravanan S on 10/06/24.
//

#import <UIKit/UIKit.h>
#import <AppticsPrivacyProtector/APSecureContainer.h>

NS_ASSUME_NONNULL_BEGIN

@interface APSecureImageView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) APSecureContainer *secureContainer;
@property (nonatomic, strong) UIImage *image;

@end

NS_ASSUME_NONNULL_END
