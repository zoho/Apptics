//
//  APAppState.h
//  AppticsCrashKit
//
//  Created by Saravanan S on 05/06/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APAppState : NSObject <NSSecureCoding>

@property (nonatomic) double activeDurationSinceLastCrash;
@property (nonatomic) double backgroundDurationSinceLastCrash;
@property (nonatomic) int launchesSinceLastCrash;
@property (nonatomic) int sessionsSinceLastCrash;
@property (nonatomic) double activeDurationSinceLaunch;
@property (nonatomic) double backgroundDurationSinceLaunch;
@property (nonatomic) int sessionsSinceLaunch;
@property (nonatomic) BOOL crashedLastLaunch;
@property (nonatomic) BOOL crashedThisLaunch;
@property (nonatomic) double appStateTransitionTime;
@property (nonatomic) BOOL applicationIsActive;
@property (nonatomic) BOOL applicationIsInForeground;

- (BOOL)saveStateToFile;
+ (APAppState *)loadStateFromFile;
- (NSDictionary*)jsonify;

@end

NS_ASSUME_NONNULL_END
