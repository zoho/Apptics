//
//  ZAKeyChainWrapper.h
//  IAM_SSO
//
//  Created by Saravanan Selvam on 18/04/18.
//  Copyright (c) 2015 Zoho. All rights reserved.
//


#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZAKeyChainWrapper : NSObject

@property (nonatomic, readonly) NSString *service;
@property (nonatomic, readonly) NSString *accessGroup;
@property (nonatomic, readonly) NSMutableDictionary *itemsToUpdate;

+ (void)setString:(NSString *)string forKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key;
+ (void)setData:(NSData *)data forKey:(NSString *)key;
+ (NSData *)dataForKey:(NSString *)key;
+ (void)setDictionary:(NSDictionary*)dictionary forKey:(NSString *)key;
+ (NSDictionary*)dictionaryForKey:(NSString *)key;
+ (void)setArray:(NSArray*)array forKey:(NSString *)key;
+ (NSArray*)arrayForKey:(NSString *)key;
+ (void)setNumber:(NSNumber*)number forKey:(NSString *)key;
+ (NSNumber*)numberForKey:(NSString *)key;
+ (void)setBool:(BOOL)string forKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

+ (void)removeItemForKey:(NSString *)key;
+ (void)removeAllItems;

+ (NSString *)objectForKeyedSubscript:(NSString <NSCopying> *)key;
+ (void)setObject:(NSString *)obj forKeyedSubscript:(NSString <NSCopying> *)key;


- (NSString *)defaultService;
- (void)setDefaultService:(NSString *)defaultService;

+ (ZAKeyChainWrapper *)keyChainStore;

- (NSString *)stringForKey:(NSString *)key;
- (BOOL)setString:(NSString *)value forKey:(NSString *)key;

- (NSData *)dataForKey:(NSString *)key;
- (BOOL)setData:(NSData *)data forKey:(NSString *)key;

- (void)setNumber:(NSNumber*)number forKey:(NSString *)key;

- (void)setNumber:(NSNumber*)number forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

- (NSNumber*)numberForKey:(NSString *)key;

- (NSNumber*)numberForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

- (void)setDictionary:(NSDictionary*)dictionary forKey:(NSString *)key;

- (void)setDictionary:(NSDictionary*)dictionary forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

- (NSDictionary*)dictionaryForKey:(NSString *)key;

- (NSDictionary*)dictionaryForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

- (void)setBool:(BOOL)string forKey:(NSString *)key;
- (void)setBool:(BOOL)string forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
- (BOOL)boolForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

- (NSArray *)itemsForService:(NSString *)service accessGroup:(NSString *)accessGroup;
- (BOOL)removeItemForKey:(NSString *)key;
- (BOOL)removeAllItems;

- (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

// object subscripting

- (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
- (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

- (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
- (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup
;

@end
NS_ASSUME_NONNULL_END
