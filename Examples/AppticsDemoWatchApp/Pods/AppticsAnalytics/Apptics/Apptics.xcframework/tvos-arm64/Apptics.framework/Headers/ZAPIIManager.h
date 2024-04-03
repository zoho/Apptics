//
//  ZAPIIManager.h
//  JAnalytics
//
//  Created by Saravanan S on 26/02/18.
//  Copyright Â© 2018 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Apptics/ZAConstants.h>
#import <Apptics/ZAEnums.h>
#import <Apptics/ZAMacros.h>

typedef NS_ENUM(NSInteger, CARType) // Crash Authorization Result Type
{
  CARTypeSend = 0,
  CARTypeDonotSend
};
@class APDeviceInfo;

NS_ASSUME_NONNULL_BEGIN

@interface ZAPIIManager : NSObject 

@property (copy) void(^ _Nullable crashAlertCompletion) (CARType type);

@property (copy) void(^ _Nullable setBaseUrl) (NSString *url);

@property (nonatomic,strong) NSString *zauid;//Zoho Analytics User Id

@property (nonatomic,strong) NSString *customergroupid;//Zoho Analytics Group Id

@property (nonatomic,strong) NSString *regDeviceId;//Registered Device Id

@property (nonatomic,strong) NSString *anonid;//Anonymous Id

@property (nonatomic,strong) NSNumber *devicestatus;

@property (nonatomic,strong) APDeviceInfo *_Nullable apDeviceInfo;

@property (nonatomic,strong) NSString *_Nullable dc;

@property (nonatomic,strong) NSString *_Nullable mam;//Encrypted email id (Mail id)

@property (nonatomic,strong) NSString *_Nullable groupID;//OrganizationID (optional)

@property (nonatomic,strong) NSString *_Nullable mamKey;//Encrypted email id (Mail id) and dc value

@property (nonatomic,strong) NSMutableDictionary *_Nullable mamInfo;//Encrypted email id (Mail id)

@property (nonatomic,strong) NSMutableDictionary *_Nullable userids;//users associated with this device

@property (nonatomic,strong) NSMutableDictionary *_Nullable groupids;//user groups associated with the respective users

@property (nonatomic,strong) NSMutableDictionary *_Nullable mamTrackingInfo;//Here we save all Tracking info

@property (nonatomic,strong) NSMutableDictionary *_Nullable mamCrashInfo;//Here we save all Crash info

@property (nonatomic,strong) NSMutableDictionary *_Nullable mamLogInfo;//Here we save all Log info

@property (nonatomic,strong) NSMutableDictionary *_Nullable mamPIIInfo;//Here we save all PII info

@property (nonatomic,strong) NSMutableDictionary *_Nullable mamDCInfo;//Here we save all DC info

@property (nonatomic,strong) NSMutableDictionary *_Nullable processQueue;//Pending process will be handled here.

@property (nonatomic, strong) NSMutableArray *regSuccessblocks;

@property BOOL regDeviceInprogress;

@property BOOL shouldSendPersonalizedData;

@property BOOL shouldCollectData;

@property BOOL shouldSendCrashData;

@property BOOL shouldSendLogData;

@property (readonly) BOOL shouldCollectCustomProps;

+ (ZAPIIManager* _Nonnull) getInstance;

- (void) collectCustomProps : (BOOL) status;

- (void) initializer;

- (void) saveData;

- (void) removeAllUsers;

- (void) updateShouldCollectDataForCurrentUser;

- (void) setCurrentUser:(NSString * _Nullable)email groupId:(NSString * _Nullable)groupID;

- (void) newRegisterDevice:(void (^_Nullable)(NSString* deviceId))success;

- (void) setTrackingStatus:(APTrackingStatus)status;

- (void) setCrashStatus:(APCrashStatus)status;

- (void) setLogStatus:(APLogStatus)status;

- (void) setSendPersonalizedData:(APPrivacyStatus)status;

- (void) trackLogIn:(NSString* _Nullable)email groupId:(NSString * _Nullable)groupID;

- (void) trackLogOut:(NSString* _Nullable)email groupId:(NSString * _Nullable)groupID withDc : (NSString*_Nullable) dc;

- (NSString *) getMamIdFor : (NSString *)mamKey;

- (NSString *_Nonnull) getCurrentMamId;

- (NSString *_Nonnull) getDeviceMamId;

- (NSString *_Nonnull) getMamForRequest;

- (NSString *) getCurrentUserId;

- (NSString *) getUserGroupId : (NSString*) userId;
    
- (NSString *_Nullable) getUserIdForMamId : (NSString*) mamId;

- (void) regMamInfoForKey : (NSString*_Nonnull) key;

- (void) showPrivacyConsent : (id _Nullable) viewController;

- (APPrivacyStatus) getPrivacyStatusForUser : (NSString* _Nonnull) email withDc : (NSString*_Nullable) dc;

- (APPrivacyStatus) getPrivacyStatusForUser : (NSString* _Nonnull) email;

- (APPrivacyStatus) getPIIStatusForCurrentUser;

- (BOOL) engagementtracking;

- (BOOL) errortracking;

- (BOOL) isUserLoggedIn;

- (BOOL) isAnonymousUser;

- (void) setSendDataInMobileNetwork : (BOOL) sendData;

- (BOOL) sendDataInMobileNetwork;

- (void) askPermissionToSendCrashReport : (void(^_Nullable ) (CARType type)) crashAlertCompletion;

- (BOOL) shouldAskPermissionForCrashReport;

- (void) setCrashReportPermissionStatus : (BOOL) status;

- (BOOL) shouldSendCrashReport;

- (BOOL) shouldSendLog;

- (void) registerForCrash;

-(void) clearCrashUserInfo;

-(void) setDCInfoForKey : (NSString*_Nonnull) key withBaseUrl : (NSString*_Nullable) baseUrl;

- (NSString *) getBaseUrl;

-(NSString*_Nullable) getDCInfoForKey : (NSString* _Nonnull) key;

-(NSString*) regDeviceId : (NSString*_Nonnull) mam;

-(void) registerIfCurrentUserIsNotRegisteredWithDeviceId : (NSString*) deviceId;

-(void) migrateUserPreferenceToDevice;

@end

NS_ASSUME_NONNULL_END
