//
//  ZABugNetworkManager.h
//  BugReporterTest
//
//  Created by Giridhar on 24/04/17.
//  Copyright © 2017 Giridhar. All rights reserved.
//

#import <Foundation/Foundation.h>
#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#import "ZAPresenter.h"
#else
#import <Cocoa/Cocoa.h>
#endif
#import <Apptics/ZAEnums.h>
#import <Apptics/APAAAUtil.h>

NS_ASSUME_NONNULL_BEGIN
@interface ZABugNetworkManager : NSObject

@property (nonatomic, strong) NSOperationQueue *operationQueue;
#if !TARGET_OS_OSX && !TARGET_OS_WATCH
@property (nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;
#endif

+(ZABugNetworkManager*) sharedManager;

- (void) sendFeedback:(NSString*)feedbackString
           withImages:(NSArray*) images
           ScreenName: (NSString*) screenName
                email:(NSString* _Nullable) email
           attachLog : (BOOL) attachLog
     attachDignoInfo : (BOOL) attachDignoInfo
           actionType:(ZBActionType) actionType
         feedbackType:(ZBFeedbackType) feedbackType
                  tag: (NSString*) tag
            onSuccess:(void (^)(BOOL status)) success
            onFailure:(void (^)(BOOL status)) failure;

- (APAAAUtil*)getAuthindicatorForUserID : (NSString*) userId anonID : (NSString*) anonid;

- (NSString*)setIdentificationParams : (NSString*) _params userID : (NSString*) userId anonID : (NSString*) anonid;

- (void) uploadAttachmentsForFeedback:(NSDictionary*)feedbackInfo;

- (NSString*)setNewDefaultParams;

-(NSString *)encodeURLParams:(NSString *)paramString;

-(void) processError : (NSDictionary*) response aaaUtil : (APAAAUtil*) aaautil;

@end

NS_ASSUME_NONNULL_END
