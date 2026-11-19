//
//  ZAConsoleLogsUploadOperation.h
//  JAnalytics
//
//  Created by Saravanan S on 27/11/20.
//  Copyright © 2020 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif
#import <Apptics/APAAAUtil.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *kZAConsoleLogsDataUploadSuccessNotification;
extern NSString *kZAConsoleLogsDataUploadFailureNotification;

@interface ZAConsoleLogsUploadOperation : NSOperation<NSURLSessionDownloadDelegate, NSURLSessionDelegate>

@property (nonatomic) BOOL isBGTask;
@property (nonatomic, strong) NSArray * consoleLogsInfo;
@property (nonatomic,retain) NSDictionary *consoleLogsData;
@property (nonatomic,retain) NSString *sessionToken;
@property (nonatomic,retain) NSString *urlString;
@property (nonatomic,retain) NSString *apiToken;
@property (nonatomic, weak) APAAAUtil *aaaUtil;
/// Called once per foreground upload attempt with what came back.
@property (nonatomic, copy, nullable) void (^resultHandler)(NSURLResponse * _Nullable response, NSDictionary * _Nullable json, NSError * _Nullable error);
/// Called when the rows are kept for another attempt (for the current session: give its temp rows back).
@property (nonatomic, copy, nullable) void (^retryHandler)(void);
@property (nonatomic, strong) NSURLSession *session;

#if !TARGET_OS_OSX && !TARGET_OS_WATCH
@property (nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;
#endif

- (id)initWithConsoleLogsData:(NSDictionary *)consoleLogsData;

@end

NS_ASSUME_NONNULL_END
