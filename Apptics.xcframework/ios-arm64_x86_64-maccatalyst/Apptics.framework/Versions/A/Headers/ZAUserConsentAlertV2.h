//
//  ZAUserConsentAlertV2.h
//  JAnalytics
//
//  Created by Saravanan S on 03/01/19.
//  Copyright © 2019 zoho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Apptics/APTheme.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZAUserConsentAlertV2 : UIView

@property (nonatomic, copy, nullable) void (^openPrivacySettingsHandler)(id _Nullable sender);

@property (nonatomic, copy, nullable) void (^closeHandler)(id _Nullable sender);

@property (strong, nonatomic) id <APUserConsentTheme> customAlertTheme;
@property (strong, nonatomic) id <APUserConsentTheme> defaultCustomAlertTheme;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *badgeLayer0;
@property (weak, nonatomic) IBOutlet UILabel *badgeLayer1;
@property (weak, nonatomic) IBOutlet UILabel *badgeLayer2;
@property (weak, nonatomic) IBOutlet UILabel *badgeLayer3;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;
@property (weak, nonatomic) IBOutlet UIButton *privacySettingsButton;
@property (weak, nonatomic) IBOutlet UIView *innerView;

-(void) setTheme;

@end

NS_ASSUME_NONNULL_END
