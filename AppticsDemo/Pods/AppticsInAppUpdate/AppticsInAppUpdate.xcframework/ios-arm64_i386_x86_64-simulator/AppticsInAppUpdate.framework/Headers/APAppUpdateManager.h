//
//  APAppUpdateManager.h
//  JAnalytics
//
//  Created by Saravanan S on 12/01/18.
//  Copyright © 2018 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<Apptics/Apptics.h>)
#import <Apptics/ZAEnums.h>
#endif
#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#endif
NS_ASSUME_NONNULL_BEGIN
@interface APAppUpdateManager : NSObject
{
  #if !TARGET_OS_OSX
  UIAlertController* alert;
  #endif
  NSNumber *option;
}

@property (nonatomic, retain) NSDictionary * updateInfo;

+(APAppUpdateManager*) sharedManager;
-(void) checkForUpdateAvailability :(void(^)(NSDictionary * updateInfo))completionHandler;
-(void) launchAppStore : (NSString*) storeurl;
-(void) remindMeIn : (NSNumber*) reminder forUpdate : (NSString*) updateKey;
-(void) updateStatsWithAction : (NSString*) action AndUpdateId : (NSNumber*) updateid;
-(void) updateStatsWithAction : (NSString*) action AndUpdateId : (NSNumber*) updateid previousAppVersion : (NSString*) previousversion previousAppReleaseVersion : (NSString*) previousReleaseVersion;
//-(void) fetchAppUpdateInfo;
-(void) updateTheUI:(void(^ _Nullable)(NSDictionary * updateInfo))completionHandler;

- (void) setAppUpdateAction : (ZAUpdateAction) type updateInfo : (NSDictionary *) updateInfo;

/**
 
 Check update available on AppStore within your application.
 
 - Note :
 You should configure the update details in the [ZAnalytic web](https://apptics.zoho.com) and conform openURL protocol by extending APCustomHandler and set back to us.

 */

+ (void)checkForAppUpdate:(void(^_Nullable)(NSDictionary *_Nullable updateInfo))completionHandler;

/**
 Set back the actions for custom app update.
 @param type ZAUpdateAction
 */

+ (void) setAppUpdateAction : (ZAUpdateAction) type updateInfo : (NSDictionary *_Nullable) updateInfo;


@end

NS_ASSUME_NONNULL_END
