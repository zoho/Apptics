//
//  JAEvent.h
//  JAnalytics
//
//  Created by Giridhar on 18/01/17.
//  Copyright © 2017 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Apptics/ZAObject.h>
#import <Apptics/APEventsEnum.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZAEvent : ZAObject<NSCoding,JSONAble>

@property (strong,nonatomic) NSString *eventname;
@property (strong,nonatomic) NSString *groupname;
@property (strong,nonatomic) NSString *group;
@property (strong,nonatomic) NSString *event;
@property (strong,nonatomic) NSString *screen;
@property (strong,nonatomic) NSNumber *sessionstarttime;
@property (strong,nonatomic) NSString *customproperties;
@property BOOL isTimedEvent;

+(void) addEventWithName:(NSString* _Nonnull)eventName group:(NSString* _Nonnull)group andProperties:(NSDictionary* _Nullable)props isTimed:(BOOL)isTimed;

//MARK: Extension Event
+(void) addExtensionEventWithName:(NSString* _Nonnull)eventName
                            group:(NSString* _Nonnull)group
                            startTime : (NSNumber* _Nonnull) event_start_Time
                            endTime : (NSNumber* _Nonnull) event_end_Time
                            andProperties:(NSDictionary* _Nullable)props
                            isTimed:(BOOL)isTimed;

+(void) endTimedEvent:(NSString*_Nonnull)eventName group:(NSString*_Nonnull)group;

- (NSDictionary*)jsonify;

@end
NS_ASSUME_NONNULL_END
