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

- (bool)openTestDatabase;
- (bool)createTestTable;
- (NSMutableSet*)getAllExpectedTables;
- (void)clearTables : (NSArray*) tableList;
    
- (void)archiveEngagements:(id)queue sessionId : (NSNumber*) sessionId mamId:(NSString * _Nullable)mam anonId : (NSString*) anonid;
- (void)getAllHistoricEngagementDataToBeSyncedWithCompletion:(void (^)(NSMutableArray *results))completion;
- (void)getListOfHistoricEngagementDataToBeSyncedWithCompletion:(void (^)(NSMutableArray *results))completion;
- (void)deleteRowFromEngagementInfoTableWithSessionIDs:(NSArray<NSNumber *> *)sessionIDs;
- (void)updateIssyncingStatus: (bool) status forSessionIDs:(NSArray<NSNumber *> *)sessionIDs;
- (NSDictionary*)getEngagementDataForSessionID:(NSNumber*) sessionId;

- (void)archiveNonfatal:(id)queue sessionId : (NSNumber*) sessionId mamId:(NSString * _Nullable)mam anonId : (NSString*) anonid;
- (void)getAllHistoricNonfatalDataToBeSyncedWithCompletion:(void (^)(NSMutableArray *results))completion;
- (void)getListOfHistoricNonfatalDataToBeSyncedWithCompletion:(void (^)(NSMutableArray *results))completion;
- (void)deleteRowFromNonfatalInfoTableWithSessionIDs:(NSArray<NSNumber *> *)sessionIDs;
- (void)updateNonfatalIssyncingStatus: (bool) status forSessionIDs:(NSArray<NSNumber *> *)sessionIDs;
- (NSDictionary*)getNonfatalDataForSessionID:(NSNumber*) sessionId;

- (void)archiveConsoleLog:(id)queue sessionId : (NSNumber*) sessionId mamId:(NSString * _Nullable)mam anonId : (NSString*) anonid;
- (void)getAllHistoricConsoleLogDataToBeSyncedWithCompletion:(void (^)(NSMutableArray *results))completion;
- (void)getListOfHistoricConsoleLogDataToBeSyncedWithCompletion:(void (^)(NSMutableArray *results))completion;
- (void)deleteRowFromConsoleLogInfoTableWithSessionIDs:(NSArray<NSNumber *> *)sessionIDs;
- (void)updateConsoleLogIssyncingStatus: (bool) status forSessionIDs:(NSArray<NSNumber *> *)sessionIDs;
- (NSDictionary*)getConsoleLogDataForSessionID:(NSNumber*) sessionId;

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
- (void)getCrashReportIDsWithCompletion:(void (^)(NSArray *iDs, NSString *appversion))completion;
- (id)getCrashDataForSessionID:(NSNumber*) sessionId;
- (void)deleteRowFromCrashesTableWithSessionIDs:(NSArray<NSNumber *> *)sessionIDs;
- (void)deleteOldCrashesIfNeeded;
- (void)deleteAllCrashes;

- (void)saveDeviceDetails:(NSDictionary*) details;
- (void)saveAppRegVersionDetails:(NSDictionary*) details;
- (NSDictionary*)getMetaForVersion:(NSString *)version;// withCompletion:(void (^)(NSDictionary *results))completion;
- (void)fetchAppRegVersionDetailsFor:(NSString *)version withCompletion:(void (^)(NSDictionary *results))completion;
- (void)deleteDetailsByVersion:(NSString *)version;

- (void)saveUserInfo : (NSDictionary*) userInfo;
- (NSDictionary *)getUserJSONByUser:(NSString *)user withGroup:(NSString * _Nullable)group status : (Boolean) status;

@end

NS_ASSUME_NONNULL_END
