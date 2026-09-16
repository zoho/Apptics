//
//  ZAAppupdatePopupInfo.h
//  JAnalytics
//
//  Created by Saravanan S on 06/10/20.
//  Copyright © 2020 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Apptics/ZAObject.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZAAppupdatePopupInfo : ZAObject<NSCoding,JSONAble>

@property (strong,nonatomic) NSNumber *sessionstarttime, *triggeredtime, *updateid;
@property NSString *action, *previousversion, *appreleaseversion;

+(void) addObjectToQueueForDictionary:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
