//
//  ZAWCSession.h
//  SimpleWatchConnectivity
//
//  Created by Saravanan S on 23/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

#import <WatchConnectivity/WatchConnectivity.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZWMessageType)  {
  ZWMessageTypeAll=0,
  ZWMessageTypeEvent,
  ZWMessageTypeSession,
  ZWMessageTypeScreen,
  ZWMessageTypeNonFatal
};

@interface WCSessionSwizzlerDelegate : NSObject <WCSessionDelegate>
@property (nonatomic, weak, nullable) id <WCSessionDelegate> sessionDelegate;
@property (nonatomic) BOOL trackingStatus;
@property (nonatomic) BOOL crashReportStatus;
@property (nonatomic) BOOL privacyStatus;
@property (nonatomic, strong) NSString* userID;
@property (nonatomic, strong) NSString* groupID;

+(WCSessionSwizzlerDelegate*) getInstance;

@end

@interface WCSession (Trackable)

@end

NS_ASSUME_NONNULL_END
