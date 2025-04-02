//
//  APUserProperties.h
//  Apptics
//
//  Created by Saravanan Selvam on 13/03/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APUserProperties : NSObject

@property (nonatomic, strong, nullable) NSString *firstName;
@property (nonatomic, strong, nullable) NSString *lastName;
@property (nonatomic, strong, nullable) NSString *emailAddress;
@property (nonatomic, strong, nullable) NSString *contactNumber;
@property (nonatomic, strong, nullable) NSString *country;
@property (nonatomic, strong, nullable) NSString *region;
@property (nonatomic, strong, nullable) NSString *city;
@property (nonatomic, strong, nullable) NSString *mapLocation;
@property (nonatomic, strong, nullable) NSNumber *age;
@property (nonatomic, strong, nullable) NSString *gender;
@property (nonatomic, strong, nullable) NSString *utmCampaign;
@property (nonatomic, strong, nullable) NSString *planType;
@property (nonatomic, assign) BOOL blockedUser;
@property (nonatomic, strong, nullable) NSString *timezone;
@property (nonatomic, strong, nullable) NSString *preferredLanguage;

// Dictionary to hold additional custom parameters
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *customParams;

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dict;

- (NSDictionary<NSString *, id> *)toDictionary;

@end

NS_ASSUME_NONNULL_END
