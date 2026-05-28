//
//  APDBManager.h
//  Apptics
//
//  Created by Saravanan Selvam on 06/01/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class APDatabase;

@interface APDBManager : NSObject{

@private
    NSString *logDirectory;
    NSMutableArray *pendingLogEntries;
    
    APDatabase *database;
    
@protected
    NSUInteger saveThreshold;
    NSTimeInterval saveInterval;
    NSTimeInterval maxAge;
    NSTimeInterval deleteInterval;
    BOOL deleteOnEverySave;
    
    BOOL saveTimerSuspended;
    NSUInteger unsavedCount;
    dispatch_time_t unsavedTime;
    dispatch_source_t saveTimer;
    dispatch_time_t lastDeleteTime;
    dispatch_source_t deleteTimer;
}

+ (instancetype)shared;
- (void)setDBDirectory:(NSString*) aDirectory;
- (void)closeDBConnection;

- (bool)openTestDatabase;
- (bool)createTestTable;
- (NSMutableSet*)getAllExpectedTables;
- (void)clearTables : (NSArray*) tableList;
    
- (void)archiveEngagements:(id)queue sessionId : (NSNumber*) sessionId mamId:(NSString * _Nullable)mam anonId : (NSString*) anonid;
- (void)getAllHistoricEngagementDataToBeSyncedWithCompletion:(void (^)(NSMutableArray *results))completion;
- (void)getListOfHistoricEngagementDataToBeSyncedWithCompletion:(void (^)(NSMutableArray *results, NSDictionary* meta))completion;
- (void)deleteRowFromEngagementInfoTableWithSessionIDs:(NSArray<NSNumber *> *)sessionIDs;
- (void)updateIssyncingStatus: (bool) status forSessionIDs:(NSArray<NSNumber *> *)sessionIDs;
- (void)getEngagementDataForSessionID:(NSNumber*) sessionId completionHandler:(void (^)(NSDictionary * engagementdata))completion;

- (void)archiveNonfatal:(id)queue sessionId : (NSNumber*) sessionId mamId:(NSString * _Nullable)mam anonId : (NSString*) anonid;
- (void)getAllHistoricNonfatalDataToBeSyncedWithCompletion:(void (^)(NSMutableArray *results))completion;
- (void)getListOfHistoricNonfatalDataToBeSyncedWithCompletion:(void (^)(NSMutableArray *results, NSDictionary* meta))completion;
- (void)deleteRowFromNonfatalInfoTableWithSessionIDs:(NSArray<NSNumber *> *)sessionIDs;
- (void)updateNonfatalIssyncingStatus: (bool) status forSessionIDs:(NSArray<NSNumber *> *)sessionIDs;
- (void)getNonfatalDataForSessionID:(NSNumber*) sessionId completionHandler:(void (^)(NSDictionary * nonfataldata))completion;

- (void)archiveConsoleLog:(id)queue sessionId : (NSNumber*) sessionId mamId:(NSString * _Nullable)mam anonId : (NSString*) anonid;
- (void)getAllHistoricConsoleLogDataToBeSyncedWithCompletion:(void (^)(NSMutableArray *results))completion;
- (void)getListOfHistoricConsoleLogDataToBeSyncedWithCompletion:(void (^)(NSMutableArray *results, NSDictionary* meta))completion;
- (void)deleteRowFromConsoleLogInfoTableWithSessionIDs:(NSArray<NSNumber *> *)sessionIDs;
- (void)updateConsoleLogIssyncingStatus: (bool) status forSessionIDs:(NSArray<NSNumber *> *)sessionIDs;
- (void)getConsoleLogDataForSessionID:(NSNumber*) sessionId completionHandler:(void (^)(NSDictionary * consoledata))completion;

- (void)saveAPIInfoToDatabase:(NSDictionary*)APIs;
- (void)fetchDirectAndPatternMatchAPIsWithCompletion:(void (^)(NSMutableDictionary *results))completion;
- (void)deleteRowFromAPITrackingInfoTableWithAPIDs:(NSArray<NSNumber *> *)APIDs;

- (void)saveAppUpdateInfoToDatabase:(NSDictionary*)appUpdate;
- (void)getAppUpdateWithCompletion:(void (^)(NSMutableDictionary *results))completion;
- (void)deleteAllAppUpdateRecords;
    
- (void)saveRateUsInfoToDatabase:(NSDictionary*)rateUsData;
- (void)getRateUsDataWithCompletion:(void (^)(NSMutableDictionary *results))completion;
- (void)deleteAllRateUsRecords;

- (void)saveRemoteConfigInfoToDatabase:(NSDictionary *)data;
- (void)getRemoteConfigDataWithCompletion:(void (^)(NSDictionary *results))completion;
- (void)deleteFromAllRemoteConfigTables;

- (void)saveFeedbackData:(NSDictionary*) feedbackInfo;
- (void)getFeedbackDataWithCompletion:(void (^)(NSMutableArray *results))completion;
- (void)deleteFeedbackDataWithFeedbackId:(NSNumber*)feedbackId;
    
- (void)saveCrashForSessionID:(NSNumber*) sessionID crashInfo:(id) crashInfo version:(NSString*) appversion;
- (void)getCrashCountWithCompletion:(void (^)(NSInteger count))completion;
- (void)getCrashReportIDsWithCompletion:(void (^)(NSArray *iDs, NSArray *crashes, NSDictionary *meta))completion;
- (void)getCrashDataForSessionID:(NSNumber*) sessionId completionHandler:(void (^)(id crashInfo))completion;
- (void)deleteRowFromCrashesTableWithSessionIDs:(NSArray<NSNumber *> *)sessionIDs;
- (void)deleteOldCrashesIfNeeded;
- (void)deleteAllCrashes;

- (void)saveDeviceDetails:(NSDictionary*) details;
- (void)saveAppRegVersionDetails:(NSDictionary*) details;
- (NSDictionary *)getMetaForVersion:(NSString *)version;
- (void)fetchAppRegVersionDetailsFor:(NSString *)version completionHandler:(void (^)(NSDictionary * appVersionInfo))completion;
- (void)deleteDetailsByVersion:(NSString *)version;

- (void)saveSessionInfo:(NSDictionary *)sessionInfo;
- (void)updateSessionEndTime:(NSNumber *)endTime forSession: (NSNumber *)startTime;
- (void)getSessionInfo : (NSNumber*) sessionID completionHandler:(void (^)(NSDictionary * sessionInfo))completion;
- (void)getAllSessionStartTimes:(void (^)(NSMutableArray<NSNumber *> * sessions))completion;
- (void)deleteRowsFromSessionInfoTableWithSessionIDs:(NSArray<NSNumber *> *)sessionIDs;
- (void)deleteHistoricSessionData : (NSNumber*) maxtime;

- (void)saveUserInfo : (NSDictionary*) userInfo;
- (void)getUserJSONByUser:(NSString *)user withGroup:(NSString * _Nullable)group status : (Boolean) status completionHandler:(void (^)(NSDictionary * userInfo))completion;

- (void)insertTempEngagementWithSessionID:(NSNumber *)sessionID
                                  data:(NSData *)data
                                  type:(NSString *)type;
-(void) getTempEngagementDataToBeSavedForSessionID : (NSNumber*) sessionID shouldDiscard : (bool) shouldDiscard completionHandler:(void (^)(NSMutableDictionary * sessionData))completion;
- (void)getAllSessionStartTimesFromTempEngagements:(void (^)(NSMutableArray<NSNumber *> * sessions))completion;

- (void)insertTempNonFatalDataWithSessionID:(NSNumber *)sessionID
                                       data:(NSData *)data;
-(void) getTempNonFatalDataToBeSavedForSessionID : (NSNumber*) sessionID shouldDiscard : (bool) shouldDiscard completionHandler:(void (^)(NSMutableArray * nonfatals))completion;
- (void)getAllSessionStartTimesFromTempNonfatals:(void (^)(NSMutableArray<NSNumber *> * sessions))completion;

- (void)insertTempConsoleLogDataWithSessionID:(NSNumber *)sessionID
                                       data:(NSData *)data;
-(void) getTempConsoleLogDataToBeSavedForSessionID : (NSNumber*) sessionID shouldDiscard : (bool) shouldDiscard completionHandler:(void (^)(NSMutableArray * consoleLogs))completion;
- (void)getAllSessionStartTimesFromTempConsoleLogs:(void (^)(NSMutableArray<NSNumber *> * sessions))completion;

- (void)deleteTempDataWithoutSessionDetails:(NSArray *) sessionIds;

@end

NS_ASSUME_NONNULL_END
