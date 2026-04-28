//
//  ZAnalyticsNSApplication.h
//  JAnalytics_macOS
//
//  Created by Saravanan S on 20/03/18.
//  Copyright © 2018 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <Apptics/Analytics.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZAnalyticsNSApplication : NSObject

@property (nonatomic, weak) Analytics* _Nullable delegate;

+ (ZAnalyticsNSApplication *)getInstance;

-(void) startListeners : (Analytics*) delegate;

+(void) openPIIManagerController;

+ (NSViewController*_Nullable) getTopMostController;

+ (NSViewController*_Nullable) topVisibleViewController : (NSViewController*_Nullable) topController;

@end
NS_ASSUME_NONNULL_END
