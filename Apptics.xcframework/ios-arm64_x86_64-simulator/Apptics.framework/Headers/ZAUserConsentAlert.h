//
//  ZAUserConsentAlert.h
//  JAnalytics
//
//  Created by Saravanan S on 04/09/18.
//  Copyright © 2018 zoho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Apptics/APTheme.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZAUserConsentAlert : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skipButtonBottom;

@property (nonatomic, copy, nullable) void (^withEmailHandler)(id _Nullable sender);

@property (nonatomic, copy, nullable) void (^anonymousHandler)(id _Nullable sender);

@property (nonatomic, copy, nullable) void (^donotTrackHandler)(id _Nullable sender);

@property (nonatomic, copy, nullable) void (^openPrivacyHandler)(id _Nullable sender);

@property (nonatomic, copy, nullable) void (^closeHandler)(id _Nullable sender);

@property (strong, nonatomic) id <APUserConsentTheme> customAlertTheme;
@property (strong, nonatomic) id <APUserConsentTheme> defaultCustomAlertTheme;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabbel;
@property (weak, nonatomic) IBOutlet UIButton *withEmailLabel;
@property (weak, nonatomic) IBOutlet UIButton *anonymousLabel;
@property (weak, nonatomic) IBOutlet UIButton *donotTrackLabel;
@property (weak, nonatomic) IBOutlet UIButton *privacyPolicyLabel;

-(void) setTheme;

@end
NS_ASSUME_NONNULL_END
