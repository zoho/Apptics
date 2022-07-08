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
@protocol ARCustomHandler <NSObject>

@optional

-(void) willDisplayReviewPrompt;
-(void) rateUsActionCompletionHandler:(JRateUsAction) action;

@end

@interface ARCustomHandlerManager : NSObject
@property (nonatomic) id <ARCustomHandler> sharedCustomHandler;
+(ARCustomHandlerManager*) sharedHandlerManager;
+(void) setCustomHandler:(id <ARCustomHandler>) handler;

+(void) willDisplayReviewPrompt:(void (^)(void))dispatchBlock;
+(void) rateUsActionCompletionHandler:(JRateUsAction) action;

@end

NS_ASSUME_NONNULL_END
