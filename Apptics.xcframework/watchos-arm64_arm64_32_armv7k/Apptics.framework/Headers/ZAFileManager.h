//
//  ZAFileManager.h
//  JAnalytics
//
//  Created by Giridhar on 08/02/17.
//  Copyright © 2017 zoho. All rights reserved.
//


// This class is responsible for archiving and unarchiving data into file in case of network failures

#import <Foundation/Foundation.h>
//#import "ZAConstants.h"
#import <Apptics/ZAEnums.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZAFileManager : NSObject

@property (nonatomic, strong) NSString *extensionAppGroup;

@property ZAPrivacyConsentType privacyConsentType;

@property (nonatomic) BOOL isAppExtension;
@property (nonatomic) BOOL enableGzip;

+ (ZAFileManager *)sharedInstance;

//+(void) migrateDataToNewPath : (NSString*) dir;
+(NSString *)oldRootDir;
//+(BOOL)renameDir:(NSString *)dirPath asDir:(NSString *)newDirPath cleanOld:(BOOL)clean;

+(NSString *_Nullable)filePathForAnalytics:(NSString *_Nullable)data forMamId: (NSString * _Nullable) mam;
+ (void) archive:(JURLPath) type data:(NSArray* _Nullable)queue forMamId : ( NSString* _Nullable) mamId;
+ (id _Nullable) unarchieve:(JURLPath)type forMamId : ( NSString* _Nullable) mamId;
//+(BOOL) createAnalyticsDir : (NSString*) dirName;
+(BOOL) createEngagementDir;
+(BOOL) createNonFatalDir;
+(BOOL) createCrashDir : (NSString*) dirName;
+(BOOL) createFeedbackDir : (NSString*) dirName;
+(BOOL) renameAnalyticsDir:(NSString * _Nullable)dir asDir:(NSString * _Nullable)newDir cleanOld:(BOOL)clean;

+ (NSString *) dirPathForAnalytics;
+ (NSString *) dirPathForCrash;
+ (NSString *) dirPathForFeedback;
+ (NSString *) dirPathForEngagements;
+ (NSString *) dirPathForNonFatals;
+ (NSString *) dirPathForConsoleLogs;

+ (void) archiveFeedback: (NSDictionary*) feedbackInfo;
+ (id) unarchiveFeedback : (NSString*) feedbackId;
+ (BOOL) removeFileFromPath : (NSString*) filePath;
+ (void) removeFilesFromPath : (NSString*) path;
+ (long) filesCount : (NSString*) feedbackId;
+ (NSArray*) getListOfFeedbacks;
+ (BOOL) bs_fileExistsAtPath : (NSString*) dirPath;

+ (NSArray*) getListOfCrashes;
+ (NSArray*) getCrashCount;
+ (void) archiveCrashReport:(NSDictionary*)crashReport withFileName : fileName;
+ (id) unarchiveCrashReportForFileName : fileName;

-(NSString*) getZaInfoFilePath;
+ (void) archiveData:(NSArray*)queue fileName : (NSString*) filename;
+ (id) unarchieveDataWithFileName : (NSString*) filename;

+ (void) archiveEngagements:(id)queue sessionId : (NSNumber*) sessionId mamId: (NSString * _Nullable) mam anonId : (NSString*) anonid;
//+ (void) archiveBGSession:(id)queue sessionId : (NSNumber*) sessionId mamId:(NSString * _Nullable)mam anonId : (NSString*) anonid;
+ (id) unarchieveEngagementsDataForFileName: (NSString*) fileName;
+ (id) unarchieveNonFatalsDataForFileName: (NSString*) fileName;
+ (id) unarchieveConsoleLogsDataForFileName: (NSString*) fileName;

+ (id) unarchieveDataForFileName: (NSString*) fileName;
+ (void) rotateEngagementsData;

+ (void) archiveNonFatals:(id)queue sessionId : (NSNumber*) sessionId mamId:(NSString * _Nullable)mam anonId : (NSString*) anonid;
+ (void) rotateNonFatalsData;
    
+ (void) archiveConsoleLogs:(id)queue sessionId : (NSNumber*) sessionId mamId:(NSString * _Nullable)mam anonId : (NSString*) anonid;
+ (void) rotateConsoleLogsData;
    
+(NSMutableArray* _Nullable)   getListOfHistoricEngagementDataToPurge;
+(NSMutableArray* _Nullable) getListOfHistoricEngagementDataToBeSynced;
+(NSMutableArray* _Nullable) getListOfHistoricEngagementData;

+(NSMutableArray* _Nullable) getListOfNonFatalsDataToBeSynced;
+(NSMutableArray* _Nullable) getListOfNonFatalsData;

+(NSMutableArray* _Nullable) getListOfConsoleLogsDataToBeSynced;
+(NSMutableArray* _Nullable) getListOfConsoleLogsData;

//+(void) archiveEngagementInfo: (NSArray*) feedbackInfo;
+(void) archiveHistoricEngagementInfo: (NSArray*) feedbackInfo;
+(void) archiveNonFatalsInfo: (NSArray*) nonfatalsInfo;
+(void) archiveConsoleLogsInfo: (NSArray*) nonfatalsInfo;
//+(void) removeEngagementInfo : (NSArray*) engagementsInfo;
+(void) removeHistoricEngagementInfos : (NSArray*) engagementsInfos;
+(void) removeNonFatalsInfos : (NSArray*) engagementsInfos;
+(void) removeConsoleLogsInfos : (NSArray*) consoleLogsInfos;

//+(void) addEngagementInfo: (NSArray*) feedbackInfo;
+(void) addHistoricEngagementInfo: (NSArray*) feedbackInfo;
+ (NSArray*) sortArrayAsending : (NSArray*) array forKey : (NSString*) key;
@end
NS_ASSUME_NONNULL_END
