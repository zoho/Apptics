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
#import <Apptics/ZAConsoleLogsUploadOperation.h>

#import <Apptics/ZAAppupdatePopupInfo.h>

#import <Apptics/ZAScreenObject.h>

NS_ASSUME_NONNULL_BEGIN

#define maxDataRetentionTime ((24 * 60 * 60 * 1000) * 7)

@interface ZAGlobalQueue : NSObject

@property (strong,nonatomic) NSMutableArray *screensQueue, *sessionsQueue, *eventsQueue, *nonfatalQueue, *apisQueue, *remoteconfigQueue, *rateusQueue, *appupdatePopupQueue, *appupdateDetailQueue, *crosspromoQueue, *consoleLogsQueue;

@property (nonatomic) long long dataSize;
@property (nonatomic) long long nonfatalDataSize;
@property (nonatomic) long long logsDataSize;
@property (strong,nonatomic) ZASession *currentSession;

@property (strong,nonatomic) ZAScreenObject *currentScreen;

@property (strong,nonatomic) ZAAppupdatePopupInfo * _Nullable currentAppupdatePopup;

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSOperationQueue *bgOperationQueue;

@property (strong,nonatomic) NSNumber *prevFlushTime;

typedef void (^bgEngagementRequestSuccessBlock)(void);
typedef void (^bgNonFatalRequestSuccessBlock)(void);
typedef void (^bgConsoleLogsRequestSuccessBlock)(void);

+ (ZAGlobalQueue*) sharedQueue;
+ (NSNumber*) sessionStartTime;
+ (NSString*) currentScreenName;

- (void) addToNonfatalQueue:(id)errorObject;
- (void) addToQueue:(ZAObject*)object;
- (void) addLogsToQueue:(ZAObject*)object;
- (void) removeAllData;
- (void) removeConsoleLogsData;
- (void) removeNonFatalData;

- (void) purgeHistoricEngagementsData;
- (void) purgeHistoricNonFatalsData;
- (void) purgeHistoricConsoleLogsData;

- (void) flushHistoricEngagementsDataToServer;
- (void) flushHistoricDataToServerisBG : (BOOL) isBg completionBlock:(bgEngagementRequestSuccessBlock)success;

- (void) flushHistoricNonFatalsDataToServer;
- (void) flushNonFatalsToServerisBG : (BOOL) isBg completionBlock:(bgNonFatalRequestSuccessBlock)success;

- (void) flushHistoricConsoleLogsDataToServer;
- (void) flushConsoleLogsToServerisBG : (BOOL) isBg completionBlock:(bgConsoleLogsRequestSuccessBlock)success;

- (void) dispatchOnNetworkQueue:(void (^)(void))dispatchBlock;

- (void) trackViewEnter:(NSString*) screenName;
- (void) trackViewExit:(NSString*) screenName;
- (void) startWithTime:(NSNumber*) startTime;
- (void) endWithTime:(NSNumber*)endTime;
- (void) saveData;
- (void) saveSessionData:(NSNumber*) sessionId;
- (void) saveNonFatalData:(NSNumber*) sessionId;
//- (void) saveBgSessionData:(NSNumber*) sessionId;
@end

NS_ASSUME_NONNULL_END
