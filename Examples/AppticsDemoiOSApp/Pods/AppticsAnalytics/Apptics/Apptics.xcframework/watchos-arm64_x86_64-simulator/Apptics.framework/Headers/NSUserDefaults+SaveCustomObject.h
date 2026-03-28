#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSUserDefaults (SaveCustomObject)

+ (void) saveObject:(id)object key:(NSString *)key;
+ (id _Nullable) loadObjectWithKey:(NSString *)key;
+ (void) removeObjectWithKey:(NSString *)key;

- (void) saveCustomObject:(id)object key:(NSString *)key;
- (id _Nullable) loadCustomObjectWithKey:(NSString *)key;

@end
NS_ASSUME_NONNULL_END
