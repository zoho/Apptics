//
//  CrashReportUploadOperation.h
//  HelloAnalytics
//
//  Created by Saravanan S on 08/08/18.
//  Copyright © 2018 Saravanan S. All rights reserved.
//

#import <Foundation/Foundation.h>
#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif
#if __has_include(<Apptics/Apptics.h>)
#import <Apptics/APAAAUtil.h>
#endif

@interface ZACrashReportUploadOperation : NSOperation

@property(retain) NSString *fileName;
@property (nonatomic,retain) NSDictionary *crashReport;
@property(retain) NSArray *reportIds;
@property (nonatomic,retain) NSURL *url;
@property (nonatomic,retain) NSString *params;
@property (nonatomic, strong) APAAAUtil *aaaUtil;

#if !TARGET_OS_OSX && !TARGET_OS_WATCH
@property (nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;
#endif

- (id)initWithCrashReport:(NSDictionary *)crashReport;
- (id)initWithFileName:(NSString*)fileName;

@end
