//
//  ZACustomAlertController.h
//  JAnalytics
//
//  Created by Saravanan S on 04/09/18.
//  Copyright © 2018 zoho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZAUserConsentAlert.h"
#import "ZAUserConsentAlertV2.h"
#import "ZAAppUpdateAlert.h"
#import "ZAEnums.h"
NS_ASSUME_NONNULL_BEGIN
@interface ZACustomAlertController : UIViewController

@property (nonatomic) ZAAlertType type;
@property (nonatomic, retain) ZAUserConsentAlert *userConsentAlert;
@property (nonatomic, retain) ZAUserConsentAlertV2 *userConsentAlertV2;
@property (nonatomic, retain) ZAAppUpdateAlert *appUpdateAlert;
@property (nonatomic, retain) NSDictionary *info;
@property (nonatomic, retain) NSDictionary *localeInfo;
@end
NS_ASSUME_NONNULL_END
