//
//  ZAAppUpdateAlert.h
//  JAnalytics
//
//  Created by Saravanan S on 07/09/18.
//  Copyright © 2018 zoho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Apptics/APTheme.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZAAppUpdateAlert : UIView
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remindLaterButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updateNowButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skipButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skipBButtonBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerImageTop;

@property (nonatomic, retain) NSDictionary *updateInfo;
@property (nonatomic, retain) NSDictionary *localeInfo;

@property (nonatomic, retain) NSNumber *option;
@property (nonatomic, retain) NSString *titleString;
@property (nonatomic, retain) NSString *descriptionString;

@property (nonatomic, copy, nullable) void (^updateNowHandler)(id _Nullable sender);

@property (nonatomic, copy, nullable) void (^remindLaterHandler)(id _Nullable sender);

@property (nonatomic, copy, nullable) void (^skipHandler)(id _Nullable sender);

@property (nonatomic, copy, nullable) void (^readMoreHandler)(id _Nullable sender);

@property (nonatomic, copy, nullable) void (^closeHandler)(id _Nullable sender);

@property (strong, nonatomic) id <APAppUpdateConsentTheme> _Nonnull customAlertTheme;
@property (strong, nonatomic) id <APAppUpdateConsentTheme> _Nonnull defaultCustomAlertTheme;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *updateNowButton;
@property (weak, nonatomic) IBOutlet UIButton *reminderButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *readMoreButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

-(void) setTheme;

@end
NS_ASSUME_NONNULL_END
