//
//  APUser.h
//  Apptics
//
//  Created by Saravanan Selvam on 05/05/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const APUserPropertyFirstName;
FOUNDATION_EXPORT NSString * const APUserPropertyLastName;
FOUNDATION_EXPORT NSString * const APUserPropertyCompanyName;
FOUNDATION_EXPORT NSString * const APUserPropertyEmailAddress;
FOUNDATION_EXPORT NSString * const APUserPropertyContactNumber;
FOUNDATION_EXPORT NSString * const APUserPropertyCountry;
FOUNDATION_EXPORT NSString * const APUserPropertyRegion;
FOUNDATION_EXPORT NSString * const APUserPropertyCity;
FOUNDATION_EXPORT NSString * const APUserPropertyGeoLocation;
FOUNDATION_EXPORT NSString * const APUserPropertyGender;
FOUNDATION_EXPORT NSString * const APUserPropertyPlanType;
FOUNDATION_EXPORT NSString * const APUserPropertyTimezone;
FOUNDATION_EXPORT NSString * const APUserPropertyLanguage;
FOUNDATION_EXPORT NSString * const APUserPropertyDOB;
FOUNDATION_EXPORT NSString * const APUserPropertyEngagementScore;

@interface APUser : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong, nullable) NSString *customerGroupId;
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, id> *userProperties;
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, id> *data;
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, id> *dataType;
@property (nonatomic, strong) NSNumber *isValid;
@property (nonatomic, strong, nullable) NSMutableArray *failedKeys101;
@property (nonatomic, strong, nullable) NSMutableArray *failedKeys102;
@property (nonatomic, strong, nullable) NSMutableArray *failedKeys103;
@property (nonatomic, strong, nullable) NSMutableArray *failedKeys104;

- (instancetype)initWithUserId:(NSString *)userId customerGroupId : (NSString*) customerGroupId;
- (void)addStringProperty:(NSString *)key value:(NSString *)value;
- (void)addBooleanProperty:(NSString *)key value:(BOOL)value;
- (void)addFloatProperty:(NSString *)key value:(float)value;
- (void)addLongProperty:(NSString *)key value:(long)value;
- (void)addDoubleProperty:(NSString *)key value:(double)value;
- (void)addIntegerProperty:(NSString *)key value:(NSInteger)value;

- (NSDictionary *)validUserProperties;
- (NSDictionary*)jsonify;

@end

NS_ASSUME_NONNULL_END
