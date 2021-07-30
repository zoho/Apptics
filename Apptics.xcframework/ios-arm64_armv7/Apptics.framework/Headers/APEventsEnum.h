#import <Foundation/Foundation.h>
#import "ZAPrivate.h"
//#import "APEventsEnum.h"
#import "Apptics.h"

NS_ASSUME_NONNULL_BEGIN
@protocol APEventsProtocol <NSObject>
+ (APPrivateObject * _Nullable)formatTypeToPrivateObject:(NSString*)group event : (NSString*) event;

+ (APPrivateObject * _Nullable)formatTypeToPrivateObjectFromEventId:(NSString*)eventId;
@end

@protocol APAPIProtocol <NSObject>
+ (NSString* _Nullable) directMatch : (NSString*) url;

+ (NSString* _Nullable) patternMatch : (NSString*) url;
@end
NS_ASSUME_NONNULL_END
