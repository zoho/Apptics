//
//  ZAPrivate.h
//  ZAnalytics
//
//  Created by Saravanan S on 01/07/19.
//  Copyright © 2019 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPrivateObject : NSObject
@property NSString *group;
@property NSString *event;
- (instancetype)initWith:(NSString* _Nullable) group event:(NSString*) event;
@end

NS_ASSUME_NONNULL_END
