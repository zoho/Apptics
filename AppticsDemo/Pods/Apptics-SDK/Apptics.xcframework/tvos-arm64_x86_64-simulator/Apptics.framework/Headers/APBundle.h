//
//  APBundle.h
//  Pods
//
//  Created by Saravanan S on 17/07/18.
//

#import <Foundation/Foundation.h>
#import "APEventsEnum.h"
NS_ASSUME_NONNULL_BEGIN
@interface APBundle : NSBundle

@property (nonatomic, retain) NSString * _Nullable lang;
@property (nonatomic, retain) NSString * _Nullable location;
@property (nonatomic, retain) NSString * _Nullable timeZone;
@property (nonatomic, retain) NSBundle *analyticLanguageBundle;
@property (nonatomic, retain) NSBundle *bugSquashLanguageBundle;
@property (nonatomic, retain) Class<APEventsProtocol> _Nullable eventsProtocolClass;
@property (nonatomic, retain) Class<APAPIProtocol> _Nullable apiProtocolClass;

+(NSBundle * _Nullable) getMainBundle;

+(APBundle * _Nullable) getInstance;

-(NSBundle * _Nullable) getAnalyticLanguageBundle;

-(NSBundle * _Nullable) getBugSquashLanguageBundle;

-(NSBundle * _Nullable) getAnalyticBundle;

-(NSBundle * _Nullable) getBugSquashBundle;

@end
NS_ASSUME_NONNULL_END
