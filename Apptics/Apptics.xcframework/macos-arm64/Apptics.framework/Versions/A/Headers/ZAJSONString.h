//
//  NSDictionary+ZAJSONString.h
//  JAnalytics
//
//  Created by Saravanan S on 07/12/18.
//  Copyright © 2018 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ZAJSONString)
-(NSString*) za_jsonStringWithPrettyPrint:(BOOL) prettyPrint;
@end

@interface NSArray (ZAJSONString)
- (NSString *)za_jsonStringWithPrettyPrint:(BOOL)prettyPrint;
@end

@interface NSString (ZAJSONString)
- (id)za_jsonify;
@end
NS_ASSUME_NONNULL_END
