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
@property (strong,nonatomic) NSNumber *group;
@property (strong,nonatomic) NSNumber *event;
@property (strong,nonatomic) NSString *screen;
@property (strong,nonatomic) NSNumber *sessionstarttime;
@property (strong,nonatomic) NSString *customproperties;
@property BOOL isTimedEvent;

+(void) addEventWithName:(NSString* _Nullable)eventName group:(NSString* _Nullable)group eventId : (NSString* _Nullable) eventId groupId : (NSString* _Nullable) groupId andProperties:(NSDictionary* _Nullable)props isTimed:(BOOL)isTimed;

//MARK: Extension Event
+(void) addExtensionEventWithName:(NSString* _Nullable)eventName
                            group:(NSString* _Nullable)group
                            eventId : (NSString* _Nullable) event_id
                            groupId : (NSString* _Nullable) group_Id
                            startTime : (NSNumber* _Nullable) event_start_Time
                            endTime : (NSNumber* _Nullable) event_end_Time
                            andProperties:(NSDictionary* _Nullable)props
                            isTimed:(BOOL)isTimed;

+(void) endTimedEvent:(NSString*_Nullable)eventName group:(NSString*_Nullable)group eventId : (NSString* _Nullable) eventId;

- (NSDictionary*)jsonify;

@end
NS_ASSUME_NONNULL_END
