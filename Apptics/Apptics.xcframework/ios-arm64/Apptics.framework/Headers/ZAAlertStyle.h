//
//  ZAAlertStyle.h
//  JAnalytics
//
//  Created by Saravanan S on 23/05/18.
//  Copyright © 2018 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif
NS_ASSUME_NONNULL_BEGIN
@interface ZAAlertStyle : NSObject
#if !TARGET_OS_OSX
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIFont *descriptionFont;
@property (nonatomic, retain) UIFont *optionFont;
@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) NSTextAlignment alignment;
@property (nonatomic) bool removeNewLine;
#endif

@end
NS_ASSUME_NONNULL_END
