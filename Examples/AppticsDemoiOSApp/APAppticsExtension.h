#import <Foundation/Foundation.h>
#if __has_include(<Apptics/Apptics-umbrella.h>)
@import Apptics;
#elif __has_include(<Apptics/APEventsEnum.h>)
#import <Apptics/APEventsEnum.h>
#import <Apptics/Apptics.h>
#import <Apptics/APBundle.h>
#else
#import "APEventsEnum.h"
#import "Apptics.h"
#import "APBundle.h"
#endif
#if __has_include(<AppticsEventTracker/Apptics-umbrella.h>)
@import AppticsEventTracker;
#elif __has_include(<AppticsEventTracker/AppticsEventTracker.h>)
#import <AppticsEventTracker/APEvent.h>
#else
#import "APEvent.h"
#endif
typedef enum {
	APEventTypeNone,

	APEventType_bill_transaction_rejected,

	APEventType_bill_country_code_change,

	APEventType_bill_menu_click,

	APEventType_bill_transaction_link_click

}APEventType;

@interface Apptics(Extension)

+ (void) setCustomEventsProtocol;

+ (void) setApiTrackingProtocol;

@end

@interface APEvent(Extension)

+ (NSString*_Nullable) eventID :(APEventType) type;

+ (void) trackEventWithType:(APEventType) type;

+ (void) trackEventWithType:(APEventType) type andProperties:(NSDictionary*_Nullable)props;

+ (void) startTimedEventWithType:(APEventType) type;

+ (void) startTimedEventWithType:(APEventType) type andProperties:(NSDictionary * _Nullable)props;

+ (void) endTimedEventWithType:(APEventType) type;

@end

@interface APEventExtension : NSObject <APEventsProtocol>
@end

@interface APAPAPIExtension : NSObject <APAPIProtocol>
@end
