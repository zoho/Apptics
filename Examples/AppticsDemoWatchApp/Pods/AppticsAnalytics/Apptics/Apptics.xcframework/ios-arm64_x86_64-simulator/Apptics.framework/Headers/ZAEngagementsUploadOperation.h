//
//  ZAEngagementsUploadOperation.h
//  JAnalytics
//
//  Created by Saravanan S on 11/09/20.
//  Copyright © 2020 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#endif

#import <Apptics/APAAAUtil.h>

#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif
NS_ASSUME_NONNULL_BEGIN

//extern NSString *kZAEngagementDataUploadSuccessNotification;
//extern NSString *kZAEngagementDataUploadFailureNotification;

extern NSString *kZAEngagementDataUploadSuccessNotificationBg;
extern NSString *kZAEngagementDataUploadFailureNotificationBg;

@interface ZAEngagementsUploadOperation : NSOperation<NSURLSessionDownloadDelegate, NSURLSessionDelegate>

@property (nonatomic) BOOL isBGTask;
@property (nonatomic, strong) NSArray * sessionInfos;
@property (nonatomic, strong) NSDictionary *engagementData;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *apiToken;
@property (nonatomic, strong) NSString *sessionToken;
@property (nonatomic, strong) APAAAUtil *aaaUtil;
@property (nonatomic, strong) NSURLSession *session;

#if !TARGET_OS_OSX && !TARGET_OS_WATCH
@property (nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;
#endif
- (id)initWithEngagementData:(NSDictionary *)engagementData;

-(void) sendEngagementData:(NSDictionary *)engagementsData;

@end

NS_ASSUME_NONNULL_END
