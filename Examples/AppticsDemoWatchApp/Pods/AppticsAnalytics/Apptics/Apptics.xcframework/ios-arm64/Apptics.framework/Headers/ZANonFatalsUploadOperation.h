//
//  ZANonFatalsUploadOperation.h
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

extern NSString *kZANonFatalsDataUploadSuccessNotification;
extern NSString *kZANonFatalsDataUploadFailureNotification;

@interface ZANonFatalsUploadOperation : NSOperation<NSURLSessionDownloadDelegate, NSURLSessionDelegate>

@property (nonatomic) BOOL isBGTask;
@property (nonatomic, strong) NSArray * nonfatalsInfo;
@property (nonatomic,retain) NSDictionary *nonFatalsData;
@property (nonatomic,retain) NSString *sessionToken;
@property (nonatomic,retain) NSString *urlString;
@property (nonatomic,retain) NSString *apiToken;
@property (nonatomic, strong) APAAAUtil *aaaUtil;
@property (nonatomic, strong) NSURLSession *session;

#if !TARGET_OS_OSX && !TARGET_OS_WATCH
@property (nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;
#endif

- (id)initWithNonFatalsData:(NSDictionary *)nonFatalsData;

@end

NS_ASSUME_NONNULL_END
