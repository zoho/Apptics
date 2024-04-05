//
//  APEvent.h
//  Apptics
//
//  Created by Saravanan S on 27/10/21.
//

#import <Foundation/Foundation.h>


#define PROPERTY_KEYS_MAX_COUNT 25
#define PROPERTY_OVERALL_LENGTH 7666

#define PROPERTY_KEY_REGEX @"^[a-zA-Z][a-zA-Z0-9_]{0,49}$"
#define PROPERTY_EVENT_GROUP_REGEX @"^[a-zA-Z][a-zA-Z0-9_]{0,99}$"

#define OBSERVER_APPUPDATE @"ap_app_update_Notification"
#define OBSERVER_USERSIGNUP @"ap_user_signup_Notification"
#define OBSERVER_NETWORKCHANGE @"ap_network_reachability_change_Notification"
#define OBSERVER_USERLOGIN @"ap_user_login_Notification"
#define OBSERVER_USERLOGOUT @"ap_user_logout_Notification"
#define OBSERVER_USERClEARDATA @"ap_app_clear_data_Notification"







NS_ASSUME_NONNULL_BEGIN


//AP_EVENT_APP_LIFE_CYCLE
extern NSString * _Nullable const  AP_EVENT_APP_INSTALL;
extern NSString * _Nullable const  AP_EVENT_APP_UNINSTALL;
extern NSString * _Nullable const  AP_EVENT_APP_UPDATE;
extern NSString * _Nullable const  AP_EVENT_APP_CLEARDATA;
extern NSString * _Nullable const  AP_EVENT_APP_OPEN;
extern NSString * _Nullable const  AP_EVENT_APP_FOREGROUND;
extern NSString * _Nullable const  AP_EVENT_APP_BACKGROUND;
extern NSString * _Nullable const  AP_EVENT_APP_TERMINATE;
extern NSString * _Nullable const  AP_EVENT_APP_OUT_OF_MEMORY;
extern NSString * _Nullable const  AP_EVENT_APP_FIRST_OPEN;
extern NSString * _Nullable const  AP_EVENT_APP_LAUNCHING;
extern NSString * _Nullable const  AP_EVENT_APP_RESIGN_ACTIVE;
extern NSString * _Nullable const  AP_EVENT_APP_WILL_CONNECT;



//AP_EVENT_APPLICATION
extern NSString *const AP_EVENT_DEEP_LINK_OPEN;
extern NSString *const AP_EVENT_DEEP_LINK_UPDATE;
extern NSString *const AP_EVENT_DEEP_LINK_FIRST_OPEN;
extern NSString *const AP_EVENT_FIRST_OPEN;
extern NSString *const AP_EVENT_IN_APP_PURCHASE;
extern NSString *const AP_EVENT_NOTIFICATION_AUTHORIZATION_STATUS;
extern NSString *const AP_EVENT_NOTIFICATION_RECEIVE;
extern NSString *const AP_EVENT_NOTIFICATION_OPEN;
extern NSString *const AP_EVENT_NOTIFICATION_DISMISS;
extern NSString *const AP_EVENT_NOTIFICATION_FOREGROUND;
extern NSString *const AP_EVENT_SEARCH;
extern NSString *const AP_EVENT_SHARE;
extern NSString *const AP_EVENT_BATTERY_LOW;
extern NSString *const AP_EVENT_BATTERY_FULL;
extern NSString *const AP_EVENT_LOW_POWER_MODE_ON;
extern NSString *const AP_EVENT_LOW_POWER_MODE_OFF;
extern NSString *const AP_EVENT_DYNAMIC_LINK_OPEN;
extern NSString *const AP_EVENT_DYNAMIC_LINK_UPDATE;


//Other

extern NSString *const AP_EVENT_NETWORK_REACHABILITY_CHANGE;
extern NSString *const AP_EVENT_NETWORK_BANDWIDTH_CHANGE;
extern NSString *const AP_EVENT_SWITCH_THEME_LIGHT;
extern NSString *const AP_EVENT_SWITCH_THEME_DARK;
extern NSString *const AP_EVENT_SWITCH_THEME_CUSTOM;
extern NSString *const AP_EVENT_SWITCH_ORIENTATION_LANDSCAPE;
extern NSString *const AP_EVENT_SWITCH_ORIENTATION_PORTRAIT;


// AP_EVENT_USER_LIFE_CYCLE

extern NSString *const AP_EVENT_USER_SIGNUP;
extern NSString *const AP_EVENT_USER_LOGIN;
extern NSString *const AP_EVENT_USER_LOGOUT;

//AP_EVENT_OS
extern NSString *const AP_EVENT_OS_UNSUPPORTED;
extern NSString *const AP_EVENT_OS_UPDATE;



//Group Name

extern NSString *const AP_GROUP_OS;
extern NSString *const AP_GROUP_OTHERS;
extern NSString *const AP_GROUP_APPLICATION;
extern NSString *const AP_GROUP_APP_LIFE_CYCLE;
extern NSString *const AP_GROUP_USER_LIFE_CYCLE;



@interface APEvent : NSObject


@property (nonatomic, retain) NSDictionary *events;
@property (nonatomic, retain) NSDictionary *groups;
@property (nonatomic, retain) NSDictionary *events_Dict_Plist;
@property (nonatomic, retain) NSDictionary *events_Dict;
@property (nonatomic, retain) NSDictionary *properties_dict;


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

+ (void) trackEvent:(nonnull NSString *)eventName withProperties:(_Nullable id )properties;

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

+ (void) trackEvent:(nonnull NSString *)eventName andGroupName : (nonnull NSString*) groupName withProperties:(_Nullable id)properties;

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

+ (void) startTimedEvent:(nonnull NSString*)eventName group:(nonnull NSString*)group andProperties:(_Nullable id)properties;

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

+ (void) addExtensionEventWithName:(NSString* _Nonnull)_eventName
                            group:(NSString* _Nonnull)_group
                            startTime : (NSNumber* _Nonnull) event_start_Time
                            endTime : (NSNumber* _Nonnull) event_end_Time
                            andProperties:(id _Nullable)props
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

- (void) trackEvent:(NSString *_Nonnull)eventName withProperties:(id _Nullable)properties;


/**
 *   Group your events if you have to, its a good practise. We recommend you to use const strings for groupName so that you don't, by mistake, send a wrong groupname.
 *
 *  @param eventName  Name of the event
 *  @param groupName  Name of the group
 *  @param properties Key-Value pair NSDictionary for tracking custom properties for the given event.
 */

- (void) trackEvent:(NSString *_Nonnull)eventName andGroupName : (NSString*_Nonnull) groupName withProperties:(id _Nullable)properties;

/**
 *  This method notifies the start of an event. Use this for events that take time to execute, like image uploads etc. To stop the timer, call the either of the "trackEvent" methods with the same Event name you passed to start the event.
 *
 *  @param eventName Name of the event
 */


- (void) startTimedEvent:(NSString*_Nonnull)eventName;

- (void) startTimedEvent:(NSString*_Nonnull)eventName group:(NSString*_Nullable)group;

- (void) startTimedEvent:(NSString*_Nonnull)eventName group:(NSString*_Nullable)group andProperties:(id _Nullable)props;

- (void) endTimedEvent:(NSString *_Nonnull)eventName withGroup:(NSString*_Nullable)group;

@end

NS_ASSUME_NONNULL_END
