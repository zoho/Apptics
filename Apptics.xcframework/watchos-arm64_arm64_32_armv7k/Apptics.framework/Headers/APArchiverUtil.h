//
//  APArchiverUtil.h
//  Apptics
//
//  Created by jai-13322 on 26/06/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APArchiverUtil : NSObject


+ (NSData *)archieveKeyedObject:(id)object error:(NSError **)error;

+ (NSSet *)setObjectClassesForKeyedUnArchiver;

+ (nullable id)unarchiveKeyedObject:(NSString *)filePath error:(NSError **)error;


+ (nullable id)unarchiveDictionaryFromData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
