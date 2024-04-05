//
//  ZACustomAlertController.h
//  JAnalytics
//
//  Created by Saravanan S on 04/09/18.
//  Copyright © 2018 zoho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Apptics/ZAUserConsentAlert.h>
#import <Apptics/ZAUserConsentAlertV2.h>
#import <Apptics/ZAAppUpdateAlert.h>
#import <Apptics/ZAEnums.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZACustomAlertController : UIViewController

@property (nonatomic) ZAAlertType type;
@property (nonatomic, retain) ZAUserConsentAlert *userConsentAlert;
@property (nonatomic, retain) ZAUserConsentAlertV2 *userConsentAlertV2;
@property (nonatomic, retain) ZAAppUpdateAlert *appUpdateAlert;
@property (nonatomic, retain) NSDictionary *info;
@property (nonatomic, retain) NSDictionary *localeInfo;
@property (nonatomic,retain) NSNumber *option;
@end
NS_ASSUME_NONNULL_END
