//
//  APCrashReporter.h
//  AppticsCrashKit
//
//  Created by Saravanan S on 12/06/24.
//

#import <Foundation/Foundation.h>

#import <APCrash.h>
#import <ZACrashReportUploadOperation.h>
#import "APAppState.h"

#import <MetricKit/MetricKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APCrashReporter : NSObject <MXMetricManagerSubscriber, UIApplicationDelegate>

+ (instancetype)sharedInstance;

- (void) installCrashLogger;
    
@property (nonatomic, strong) APAppState *appState;
@property (nonatomic, strong) NSDictionary *previousAppState;
@property (nonatomic, strong) NSArray *crashReports;
@property (nonatomic, strong) NSDictionary *crashMetaInfo;
@property (nonatomic, strong) NSDate *backgroundEntryTime;
@property (nonatomic) BOOL crashedLastLaunch;
@property (nonatomic) BOOL isAppLaunched;
@property (nonatomic, strong) NSArray *previousCrash;

+(NSTimeInterval) activeDurationSinceLastCrash;

+(NSTimeInterval) backgroundDurationSinceLastCrash;
    
+(int) launchesSinceLastCrash;

+(int) sessionsSinceLastCrash;

+(NSTimeInterval) activeDurationSinceLaunch;

+(NSTimeInterval) backgroundDurationSinceLaunch;

+(int) sessionsSinceLaunch;

+(int) crashedLastLaunch;

@end


NS_ASSUME_NONNULL_END
