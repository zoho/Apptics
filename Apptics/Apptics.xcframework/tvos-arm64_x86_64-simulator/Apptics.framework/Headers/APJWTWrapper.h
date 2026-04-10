//
//  APJWTWrapper.h
//  JAnalytics
//
//  Created by Saravanan S on 11/11/20.
//  Copyright © 2020 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APJWTWrapper : NSObject

+ (APJWTWrapper* _Nonnull) sharedManager;
-(NSData* _Nullable) encodeWithJWT : (NSDictionary*) object;
-(NSData* _Nullable) encodeDataWithJWT : (NSData*) object;
-(NSString* _Nullable) getSignedUUID : (NSString*) uuid withApid:(NSString*) apid;
@end

NS_ASSUME_NONNULL_END
