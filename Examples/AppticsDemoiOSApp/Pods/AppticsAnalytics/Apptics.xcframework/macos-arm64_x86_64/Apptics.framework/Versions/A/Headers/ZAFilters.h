//
//  ZAFilters.h
//  Apptics
//
//  Created by Saravanan S on 31/12/19.
//  Copyright © 2019 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ACCEPTABLE_CHARACTERS_FOR_EVENTS @"0123456789_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ACCEPTABLE_CHARACTERS_FOR_SCREENS @"0123456789_.- ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define STRING_MAX_LENGTH 250
#define PROPS_STRING_MAX_LENGTH 100000
#define INFO_STRING_MAX_LENGTH 5000

NS_ASSUME_NONNULL_BEGIN

@interface ZAFilters : NSObject
+(bool) filterEventWithName:(NSString*)eventName group:(NSString*)group andProperties:(id)props;
+(bool) validateProperties:(id) props maxLength : (int) maxLength;
+(bool) validateScreenName:(NSString*)screenName;
@end

NS_ASSUME_NONNULL_END
