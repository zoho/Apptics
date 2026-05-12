//
//  MultipleDC.h
//  Apptics
//
//  Created by Jaikarthick R on 04/03/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *AppticsDC NS_TYPED_ENUM;

extern AppticsDC const AppticsDCUS NS_SWIFT_NAME(US);
extern AppticsDC const AppticsDCAU NS_SWIFT_NAME(AU);
extern AppticsDC const AppticsDCIN NS_SWIFT_NAME(IN);
extern AppticsDC const AppticsDCCA NS_SWIFT_NAME(CA);
extern AppticsDC const AppticsDCEU NS_SWIFT_NAME(EU);
extern AppticsDC const AppticsDCSA NS_SWIFT_NAME(SA);


@interface MultipleDC : NSObject

@property (nonatomic, strong) AppticsDC _Nullable activeDC;
@property (nonatomic, strong) AppticsDC _Nullable defaultDC;
@property (nonatomic, assign) BOOL syncOnlyToUserDC;


@property (class, readonly) MultipleDC *defaultMultipleDC;

@end

NS_ASSUME_NONNULL_END
