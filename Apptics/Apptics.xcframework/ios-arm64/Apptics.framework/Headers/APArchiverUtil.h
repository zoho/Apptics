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
+ (nullable id)unarchiveObject:(id)input error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
