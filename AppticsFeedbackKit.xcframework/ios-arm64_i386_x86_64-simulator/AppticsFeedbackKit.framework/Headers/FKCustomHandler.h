//
//  APCustomHandler.h
//  JAnalytics
//
//  Created by Saravanan S on 26/07/18.
//  Copyright © 2018 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Apptics/ZAEnums.h>

#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif
NS_ASSUME_NONNULL_BEGIN
@protocol FKCustomHandler <NSObject>

@optional

-(void) feedbackScreenWillOpen: (id) viewController;
-(void) feedbackScreenWillClose;

-(void) sendFeedbackBegan;
-(void) sendFeedbackEndWithSuccess;
-(void) sendFeedbackEndWithFailure;
-(NSString*) setFeedbackTag;

-(void) sendReportBegan;
-(void) sendReportEndWithSuccess;
-(void) sendReportEndWithFailure;
-(void) sendFeedbackEndWithReportBugActive;

@end

@interface FKCustomHandlerManager : NSObject
@property (nonatomic) id <FKCustomHandler> sharedCustomHandler;
+(FKCustomHandlerManager*) sharedHandlerManager;
+(void) setCustomHandler:(id <FKCustomHandler>) handler;

+(void) feedbackScreenWillOpen: (id) viewController;
+(void) feedbackScreenWillClose;

+(void) sendFeedbackBegan;
+(void) sendFeedbackEndWithSuccess;
+(void) sendFeedbackEndWithFailure;
+(void) sendFeedbackEndWithReportBugActive;

+(NSString* _Nullable) setFeedbackTag;

+(void) sendReportBegan;
+(void) sendReportEndWithSuccess;
+(void) sendReportEndWithFailure;
@end

NS_ASSUME_NONNULL_END
