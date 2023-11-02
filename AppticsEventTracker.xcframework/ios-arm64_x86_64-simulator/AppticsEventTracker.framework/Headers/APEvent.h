//
//  APEvent.h
//  Apptics
//
//  Created by Saravanan S on 27/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APEvent : NSObject

@property (nonatomic, retain) NSDictionary *events;
@property (nonatomic, retain) NSDictionary *groups;

#pragma mark — Events apis

+(APEvent*) getInstance;

/**
 * An event is recorded when you call this method. Make sure you give meaningful names for your events. So that everyone, not just developers understand the event names.
 *  Call this when the event is completed. Put it in a success block if you have to, or put this line just below the line that calls the event, if blocks and closures aren't your thing.
 *
 *  @param eventName Name of the Occuring Event
 */

+ (void) trackEvent:(nonnull NSString *)eventName;


/**
 *  This methods allows you to set custom properties.
 *  Custom Properties are Dictionary/Hashmap/NSDictionary/Key value pair. Make sure the custom properties you send have meaningful keys for the values you send (duh!).
 *
 *  @param eventName  Name of the event
 *  @param properties A Key-Value pair NSDictionary for tracking custom properties
 */

+ (void) trackEvent:(nonnull NSString *)eventName withProperties:(nonnull NSDictionary *)properties;

/**
 Use this method to track events. Make sure you give meaningful names for events and their groups
 
 @param eventName Name of the Occuring Event
 @param group Name of the Group
 */

+ (void) trackEvent:(nonnull NSString *)eventName withGroupName:(nonnull NSString*)group;


/**
 *   Group your events if you have to, its a good practise. We recommend you to use const strings for groupName so that you don't, by mistake, send a wrong groupname.
 *
 *  @param eventName  Name of the event
 *  @param groupName  Name of the group
 *  @param properties Key-Value pair NSDictionary for tracking custom properties for the given event.Remember, the properties should be NSJSONSerializable, so use only data types that conforms the standard JSON protocol, like NSStrings, Integer, long etc.
 */

+ (void) trackEvent:(nonnull NSString *)eventName andGroupName : (nonnull NSString*) groupName withProperties:(nonnull NSDictionary *)properties;

/**
 *
 *  Starts a timed event with a specified name
 
 The duration of the event will be calculated added as a property when a
 corresponding endTimed event is called.
 
 This kind of method is used to track events that have duration.
 
 Usage : In a file upload task, call startTimedEvent method before upload and invoking the endTimedEvent at the end of the task, make sure you give the same event and group name for both methods.
 
 *
 *  @param eventName Name of the event
 */

+ (void) startTimedEvent:(nonnull NSString*)eventName;

/**
 *  Starts a timed event with an Event name and a group name. Use groupnames to group events.
 
 *  @param eventName Name of the event
 *  @param group Name of the group for the given event
 */

+ (void) startTimedEvent:(nonnull NSString*)eventName group:(nonnull NSString*)group;


/**
 *  Starts a timed event with an Event name, group name, and custom properties.
 *  Remember, the properties should be NSJSONSerializable, so use only data types that conforms the standard JSON protocol, like NSStrings, Integer, long etc.
 *
 *  @param eventName Name of the Event
 *  @param group Name of the Group
 *  @param properties Key-Value pair NSDictionary for tracking custom properties for the given event.Remember, the properties should be NSJSONSerializable, so use only data types that conforms the standard JSON protocol, like NSStrings, Integer, long etc
 */

+ (void) startTimedEvent:(nonnull NSString*)eventName group:(nonnull NSString*)group andProperties:(nonnull NSDictionary*)properties;

/**
 *  Ends the Timed event. Make sure you give the same name of the event.
 *
 *  - Warning:
 *  Calling this method will end all the timed events with the same event name.
 *
 *  @param eventName Name of the Timed Event.
 */

+ (void) endTimedEvent:(NSString *_Nonnull)eventName;

/**
 *  Ends the Timed event. Make sure you give the same event and group name.
 *
 *  - Warning:
 *  Calling this method will end all the timed events with the same event and group name.
 *
 *  @param eventName Name of the Timed Event.
 *  @param group Name of the Group
 */

+ (void) endTimedEvent:(NSString *_Nonnull)eventName withGroup:(NSString*_Nonnull)group;

+ (void) addExtensionEventWithName:(NSString* _Nullable)_eventName
                            group:(NSString* _Nullable)_group
                            startTime : (NSNumber* _Nullable) event_start_Time
                            endTime : (NSNumber* _Nullable) event_end_Time
                            andProperties:(NSDictionary* _Nullable)props
                           isTimed:(BOOL)isTimed;

/**
 *  Use this method to track events. Make sure you give meaningful names for events. So that everyone, not just developers understand the event names.
 *  Call this when the event is completed. Put it in a success block if you have to, or put this line just below the line that calls the event, if blocks and closures aren't your thing.
 *
 *  @param eventName Name of the Occuring Event
 */
- (void) trackEvent:(NSString *_Nonnull)eventName;


/**
 *  This methods allows you to set custom properties.
 *  Custom Properties are Dictionary/Hashmap/NSDictionary/Key value pair. Make sure the custom properties you send have meaningful keys for the values you send (duh!).
 *
 *  @param eventName  Name of the event
 *  @param properties A Key-Value pair NSDictionary for tracking custom properties
 */

- (void) trackEvent:(NSString *_Nonnull)eventName withProperties:(NSDictionary *_Nullable)properties;


/**
 *   Group your events if you have to, its a good practise. We recommend you to use const strings for groupName so that you don't, by mistake, send a wrong groupname.
 *
 *  @param eventName  Name of the event
 *  @param groupName  Name of the group
 *  @param properties Key-Value pair NSDictionary for tracking custom properties for the given event.
 */

- (void) trackEvent:(NSString *_Nonnull)eventName andGroupName : (NSString*_Nullable) groupName withProperties:(NSDictionary *_Nullable)properties;

/**
 *  This method notifies the start of an event. Use this for events that take time to execute, like image uploads etc. To stop the timer, call the either of the "trackEvent" methods with the same Event name you passed to start the event.
 *
 *  @param eventName Name of the event
 */


- (void) startTimedEvent:(NSString*_Nonnull)eventName;

- (void) startTimedEvent:(NSString*_Nonnull)eventName group:(NSString*_Nullable)group;

- (void) startTimedEvent:(NSString*_Nonnull)eventName group:(NSString*_Nullable)group andProperties:(NSDictionary*_Nullable)props;

- (void) endTimedEvent:(NSString *_Nonnull)eventName withGroup:(NSString*_Nullable)group;

- (void) trackEvent:(NSString *_Nullable) eventId groupId : (NSString *_Nullable) groupId andProperties:(NSDictionary*_Nullable)props isTimed:(BOOL)isTimed;

- (void) startTimedEvent:(NSString *_Nullable) eventId groupId : (NSString *_Nullable) groupId andProperties:(NSDictionary * _Nullable)props;

- (void) endTimedEvent:(NSString *_Nonnull) eventId;
@end

NS_ASSUME_NONNULL_END
