//
//  ZAnalyticsPIIManagerController.h
//  HelloAnalytics
//
//  Created by Saravanan S on 26/02/18.
//  Copyright © 2018 Saravanan S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Analytics.h"
#import "ZAPIIMTableViewCell.h"
#import "APTheme.h"
NS_ASSUME_NONNULL_BEGIN
@interface ZAnalyticsPIIManagerController : UITableViewController <ZAPIIMTableViewCellDelegate>

@property (nonatomic, retain) UIColor *cellTextColor;
@property (nonatomic, retain) id <APTheme> theme;
@property (nonatomic, retain) id <APSettingsTheme> settingsTheme;
@end
NS_ASSUME_NONNULL_END
