//
//  AppticsCrashKit.h
//  AppticsCrashKit
//
//  Created by Saravanan S on 05/07/22.
//


#import <Foundation/Foundation.h>

//! Project version number for AppticsCrashKit.
FOUNDATION_EXPORT double AppticsCrashKitVersionNumber;

//! Project version string for AppticsCrashKit.
FOUNDATION_EXPORT const unsigned char AppticsCrashKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <AppticsCrashKit/PublicHeader.h>

#import "ZACrash.h"
#import "ZACrashReportUploadOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppticsCrashKit : NSObject

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
