//
//  APScreentracker.h
//  jplay
//
//  Created by Giridhar on 11/11/16.
//  Copyright © 2016 Giridhar. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ZAObject.h"
NS_ASSUME_NONNULL_BEGIN
@interface APScreentracker : NSObject
+(void) trackViewEnter:(NSString*) screenName;
+(void) trackViewExit:(NSString*) screenName;

@end

NS_ASSUME_NONNULL_END
