//
//  ZAGlobalQueue.h
//  JAnalytics
//
//  Created by Giridhar on 09/02/17.
//  Copyright © 2017 zoho. All rights reserved.
//


// This singleton queue contains all the arrays that needs to be accessed globally.
// This is put in a single file to minimize singletons later on
// Ideally, JAnalytics.h and this file will be the only singletons needed
// In the current pattern, every ZAObject would need to be a singleton in-order to follow a global mutable state for tracking data
// Please use this if there's a new data set you want to keep track of

#import <Foundation/Foundation.h>
#import <Apptics/ZASession.h>
#import <Apptics/ZAEnums.h>
#import <Apptics/ZAEngagementsUploadOperation.h>
#import <Apptics/ZANonFatalsUploadOperation.h>

#import <Apptics/ZAAppupdatePopupInfo.h>

#import <Apptics/ZAScreenObject.h>

NS_ASSUME_NONNULL_BEGIN
@interface ZAGlobalQueue : NSObject

@property (strong,nonatomic) NSMutableArray *screensQueue, *sessionsQueue, *eventsQueue, *errorsQueue, *apisQueue, *remoteconfigQueue, *rateusQueue, *appupdatePopupQueue, *appupdateDetailQueue, *crosspromoQueue;

@property (strong,nonatomic) NSMutableDictionary *uniqErrors;
@property (nonatomic) long long dataSize;
@property (strong,nonatomic) ZASession *currentSession;

@property (strong,nonatomic) ZAScreenObject *currentScreen;

@property (strong,nonatomic) ZAAppupdatePopupInfo * _Nullable currentAppupdatePopup;

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSOperationQueue *bgOperationQueue;

@property (strong,nonatomic) NSNumber *prevFlushTime;

typedef void (^bgEngagementRequestSuccessBlock)(void);
typedef void (^bgNonFatalRequestSuccessBlock)(void);

+ (ZAGlobalQueue*) sharedQueue;
+ (NSNumber*) sessionStartTime;
+ (NSString*) currentScreenName;

- (void) addToQueue:(ZAObject*)object;
- (void) removeAllData;

- (void) purgeHistoricEngagementsData;
- (void) purgeHistoricNonFatalsData;

- (void) flushHistoricEngagementsDataToServer;
- (void) flushHistoricDataToServerisBG : (BOOL) isBg completionBlock:(bgEngagementRequestSuccessBlock)success;

- (void) flushHistoricNonFatalsDataToServer;
- (void) flushNonFatalsToServerisBG : (BOOL) isBg completionBlock:(bgNonFatalRequestSuccessBlock)success;

- (void) dispatchOnNetworkQueue:(void (^)(void))dispatchBlock;

- (void) trackViewEnter:(NSString*) screenName;
- (void) trackViewExit:(NSString*) screenName;
- (void) startWithTime:(NSNumber*) startTime;
- (void) endWithTime:(NSNumber*)endTime;
- (void) saveSessionData:(NSNumber*) sessionId;
//- (void) saveBgSessionData:(NSNumber*) sessionId;
@end

NS_ASSUME_NONNULL_END
