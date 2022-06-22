//
//  ZASession.h
//  JAnalytics
//
//  Created by Giridhar on 10/02/17.
//  Copyright © 2017 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Apptics/ZAObject.h>
#import <Apptics/ZASystemProperties.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZASession : ZAObject<NSCoding,JSONAble>
@property BOOL isCurrentSession, firstsession;

@property (strong,nonatomic) NSString *ram, *rom;
@property (strong,nonatomic) NSNumber *batteryout;

// The below properities will be available in ZAObject
//      "networkstatus"
//      "networkbandwidth"
//      "serviceprovider"
//      "orientation"
//      "batteryin"
//      "edgetype"
//      "starttime"
//      "endtime"

-(NSDictionary*)jsonify;

- (id) initWithStartTime:(NSNumber*)startTime asCurrentSession:(BOOL) isCurrentSession;
-(void) session_setEndTime:(NSNumber*)endTime;

+ (void) endWithTime:(NSNumber*)endTime;
+ (void) startWithTime:(NSNumber*) startTime;


@end
NS_ASSUME_NONNULL_END
