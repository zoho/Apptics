//
//  ZAScreenObject.h
//  JAnalytics
//
//  Created by Giridhar on 09/02/17.
//  Copyright © 2017 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Apptics/ZAObject.h>

NS_ASSUME_NONNULL_BEGIN
@interface ZAScreenObject : ZAObject<NSCoding,JSONAble>

@property (strong,nonatomic) NSString *screen;
@property (strong,nonatomic) NSNumber *sessionstarttime, *batteryout;

- (void) z_setEndTime;
- (NSDictionary*)jsonify;
- (id) initWithScreenName:(NSString*)screenName;

@end
NS_ASSUME_NONNULL_END
