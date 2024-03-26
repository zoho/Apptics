//
//  JAStoreReviewManager.h
//  JAnalytics
//
//  Created by Saravanan S on 17/01/18.
//  Copyright © 2018 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#if !TARGET_OS_WATCH
#import <StoreKit/StoreKit.h>
#endif
#if __has_include(<Apptics/Apptics.h>)
#import <Apptics/ZAEnums.h>
#import <Apptics/APEventsEnum.h>
#endif
NS_ASSUME_NONNULL_BEGIN
@interface APStoreReviewManager : NSObject

#if OS_OBJECT_HAVE_OBJC_SUPPORT == 1
@property (nonatomic, strong) dispatch_queue_t zaSerialQueue;
#else
@property (nonatomic, assign) dispatch_queue_t zaSerialQueue;
#endif

@property (nonatomic) bool enableRateUsAndReview;

@property (nonatomic) bool shouldPauseRateUsAndReview;

+(APStoreReviewManager*_Nonnull) getInstance;

-(void) saveAggrigatedEngagementsData;
    
-(void) loadRuleBook;

-(void) incrementAppRuns;

-(void) incrementSessionHitCount : (NSInteger) sessionDuration;

-(void) incrementEventHitCount : (NSString*_Nonnull) name;

-(void) incrementScreenHitCount : (NSString*_Nonnull) name;

-(void) storeReviewMasterReset;

-(void) enableRateUsAndReview:(BOOL)status;

-(void) setAppRatingShown;

//-(void) staticStoreReviewPrompt;

-(void) showCustomReviewPrompt;

-(void) takeToAppStoreReviewScreen;

-(void) updateActionForAppStoreReview;

-(void) takeToFeedbackScreen;

-(void) updateActionForFeedback;

-(void) getAppStoreReviewUrl:(void (^_Nonnull)(NSURL * _Nullable storeReviewUrl))completionHandler;

-(void) showPromptOnFulfillingCriteria;

-(void) disableAutoPromptOnFulfillingCriteria : (bool) status;

@end

NS_ASSUME_NONNULL_END
