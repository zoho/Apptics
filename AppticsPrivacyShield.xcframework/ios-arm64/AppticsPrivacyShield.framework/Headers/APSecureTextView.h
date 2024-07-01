//
//  APSecureTextView.h
//  AppticsPrivacyShield
//
//  Created by Saravanan S on 10/06/24.
//

#import <UIKit/UIKit.h>
#import <AppticsPrivacyShield/APSecureContainer.h>

NS_ASSUME_NONNULL_BEGIN

@interface APSecureTextView : UIView

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) APSecureContainer *secureContainer;
@property (nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
