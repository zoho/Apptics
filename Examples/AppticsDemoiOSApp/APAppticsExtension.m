#import "APAppticsExtension.h"

@implementation Apptics (Extension)

+ (void) setCustomEventsProtocol;{
	[APBundle getInstance].eventsProtocolClass=APEventExtension.class;
}

+ (void) setApiTrackingProtocol;{
	[APBundle getInstance].apiProtocolClass=APAPAPIExtension.class;
}

@end

@implementation APEvent (Extension)

+ (NSString*) eventID :(APEventType) type;{
	NSString *eventId;

	switch (type) {
		case APEventType_bill_transaction_rejected:
			eventId=@"62000000002305";
			break;
		case APEventType_bill_country_code_change:
			eventId=@"62000000002293";
			break;
		case APEventType_bill_menu_click:
			eventId=@"62000000002297";
			break;
		case APEventType_bill_transaction_link_click:
			eventId=@"62000000002301";
			break;
		case APEventTypeNone:
			break;
		default:
			break;
	}
	return eventId;
}

+ (NSString*) groupID :(APEventType) type;{
	NSString *groupId;

	switch (type) {
		case APEventType_bill_transaction_rejected:
			groupId=@"62000000002289";
			break;
		case APEventType_bill_country_code_change:
			groupId=@"62000000002289";
			break;
		case APEventType_bill_menu_click:
			groupId=@"62000000002289";
			break;
		case APEventType_bill_transaction_link_click:
			groupId=@"62000000002289";
			break;
		case APEventTypeNone:
			break;
		default:
			break;
	}
	return groupId;
}

+ (void) trackEventWithType:(APEventType) type;{
	[self trackEventWithType:type andProperties:nil];
}

+ (void) trackEventWithType:(APEventType) type andProperties:(NSDictionary*_Nullable)props;{
	NSString *eventID = [self eventID:type];
	NSString *groupID = [self groupID:type];
	[[APEvent getInstance] trackEvent:eventID groupId : groupID andProperties:props isTimed:false];
}

+ (void) startTimedEventWithType:(APEventType) type;{
	[self startTimedEventWithType:type andProperties:nil];
}

+ (void) startTimedEventWithType:(APEventType) type andProperties:(NSDictionary * _Nullable)props;{
	NSString *eventID = [self eventID:type];
	NSString *groupID = [self groupID:type];
	[[APEvent getInstance] trackEvent:eventID groupId : groupID andProperties:props isTimed:true];
}

+ (void) endTimedEventWithType:(APEventType) type;{
	NSString *eventID = [self eventID:type];
	[[APEvent getInstance] endTimedEvent:eventID];
}

@end

@implementation APEventExtension : NSObject

+ (APPrivateObject *)formatTypeToPrivateObject:(NSString*)group event : (NSString*) event {

	NSString* event_str=[[NSString stringWithFormat:@"%@_%@",group, event] lowercaseString];

	if ([event_str isEqualToString:@"bill_transaction_rejected"]){
		return [[APPrivateObject alloc] initWith:@"62000000002305" andGroupId:@"62000000002289"];
	}else if ([event_str isEqualToString:@"bill_country_code_change"]){
		return [[APPrivateObject alloc] initWith:@"62000000002293" andGroupId:@"62000000002289"];
	}else if ([event_str isEqualToString:@"bill_menu_click"]){
		return [[APPrivateObject alloc] initWith:@"62000000002297" andGroupId:@"62000000002289"];
	}else if ([event_str isEqualToString:@"bill_transaction_link_click"]){
		return [[APPrivateObject alloc] initWith:@"62000000002301" andGroupId:@"62000000002289"];
	}else 	{
	return nil;
	}
}

+ (APPrivateObject *)formatTypeToPrivateObjectFromEventId:(NSString*)eventId{

	if ([eventId isEqualToString:@"62000000002305"]){
		return [[APPrivateObject alloc] initWith:@"bill" event:@"transaction_rejected"];
	}else if ([eventId isEqualToString:@"62000000002293"]){
		return [[APPrivateObject alloc] initWith:@"bill" event:@"country_code_change"];
	}else if ([eventId isEqualToString:@"62000000002297"]){
		return [[APPrivateObject alloc] initWith:@"bill" event:@"menu_click"];
	}else if ([eventId isEqualToString:@"62000000002301"]){
		return [[APPrivateObject alloc] initWith:@"bill" event:@"transaction_link_click"];
	}else 	{
	return nil;
	}
}

@end

@implementation APAPAPIExtension : NSObject

+(BOOL) isMatchString : (NSString* ) source withString : (NSString*) pattern{
	NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
	long n = [regex numberOfMatchesInString:source options:0 range:NSMakeRange(0, [source length])];
	return  (n > 0);
}

+(NSString*) directMatch : (NSString*) url{

	if ([url isEqualToString:@"http://numbersapi.com/random/math"]){
		return @"62000000002355";
	}else 	{
		return nil;
	}

}

+(NSString*) patternMatch : (NSString*) url{

	if ([self isMatchString:url withString:@"https://www.7timer.info/bin/astro.php"]){
		return @"62000000002361";
	}else 	{
		return nil;
	}

}

@end
