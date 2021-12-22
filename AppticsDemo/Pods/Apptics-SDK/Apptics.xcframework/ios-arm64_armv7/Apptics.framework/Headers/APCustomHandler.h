//
//  APCustomHandler.h
//  JAnalytics
//
//  Created by Saravanan S on 26/07/18.
//  Copyright © 2018 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZAEnums.h"

#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif
NS_ASSUME_NONNULL_BEGIN
@protocol APCustomHandler <NSObject>

@optional
-(void) openURL: (NSURL*) url;
-(void) userConsentPresent : (bool) status withError: (NSError*) error;
-(void) userConsentDismiss : (int) status;

-(void) willSendCrashReport : (bool) status;
-(void) crashConsentPresent : (bool) status withError: (NSError*) error;
-(void) crashConsentDismiss : (int) status;

-(void) feedbackScreenWillOpen: (id) viewController;
-(void) feedbackScreenWillClose;

-(void) sendFeedbackBegan;
-(void) sendFeedbackEndWithSuccess;
-(void) sendFeedbackEndWithFailure;
-(NSString*) setFeedbackTag;

-(void) sendReportBegan;
-(void) sendReportEndWithSuccess;
-(void) sendReportEndWithFailure;

-(void) willDisplayReviewPrompt;
-(void) rateUsActionCompletionHandler:(JRateUsAction) action;

@end

@interface APCustomHandlerManager : NSObject
@property (nonatomic) id <APCustomHandler> sharedCustomHandler;
+(APCustomHandlerManager*) sharedHandlerManager;
+(void) setCustomHandler:(id <APCustomHandler>) handler;

+(void) userConsentPresent : (bool) status withError: (NSError* _Nullable) error;
+(void) userConsentDismiss : (int) status;

+(void) willSendCrashReport : (bool) status;
+(void) crashConsentPresent : (bool) status withError: (NSError* _Nullable) error;
+(void) crashConsentDismiss : (int) status;

+(void) feedbackScreenWillOpen: (id) viewController;
+(void) feedbackScreenWillClose;

+(void) sendFeedbackBegan;
+(void) sendFeedbackEndWithSuccess;
+(void) sendFeedbackEndWithFailure;
+(NSString* _Nullable) setFeedbackTag;

+(void) sendReportBegan;
+(void) sendReportEndWithSuccess;
+(void) sendReportEndWithFailure;

+(void) openURL: (NSURL*) url;

+(void) willDisplayReviewPrompt:(void (^)(void))dispatchBlock ;
+(void) rateUsActionCompletionHandler:(JRateUsAction) action;
@end

NS_ASSUME_NONNULL_END
