//
//  Test.h
//  HelloZAnalytics
//
//  Created by Saravanan S on 11/01/18.
//  Copyright © 2018 Saravanan S. All rights reserved.
//
#import <Foundation/Foundation.h>
#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#if KSCR_PRIVATE
//#import <KSCrash/KSCrashReportWriter.h>
#if __has_include(<KSCrash/KSCrashFork-umbrella.h>)
@import KSCrashFork;
#elif __has_include(<KSCrash/KSCrash.h>)
#import <KSCrash/KSCrash.h>
#elif __has_include("KSCrash.h")
#import "KSCrash.h"
#endif
#endif

@interface ZACrash : NSObject{
  
}

#if KSCR_PRIVATE
@property(atomic,readwrite,assign) KSReportWriteCallback onCrash;
#endif

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, retain) NSString *apiToken;
@property (nonatomic, retain) NSString *UUID;
@property (nonatomic, retain) NSMutableDictionary *crashMetaInfo;

+ (ZACrash*)sharedManager;

+ (void) installCrashServicesWith:(NSURL*) url apiToken : (NSString*) apiToken UUID : (NSString*) uuid shouldReportOnStartCrash : (BOOL) shouldReportOnStartCrash minSessionDuration : (NSInteger) minSessionDuration;

+ (void) savePendingReports;

+ (void) sendPendingReports;

+ (void) setCrashCustomProperty:(id)object;

+ (void) clearCrashCustomProperty;

+ (void) setCrashInfo:(id)object;

+ (void) clearCrashInfo;
  
+ (void) updateUrl :(NSURL*) url;

+(NSTimeInterval) activeDurationSinceLastCrash;

+(int) sessionsSinceLastCrash;

+(int) launchesSinceLastCrash;

+ (NSInteger) reportCount;

+ (NSArray*) allReports;

+ (void) deleteAllReports;

#if PLCR_PRIVATE
+ (void) disableMachExceptionHandler;
#endif

- (void) sendPendingReports;

@end
