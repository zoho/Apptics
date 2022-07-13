//
//  CrashMaster.h
//  AppticsDemo
//
//  Created by Saravanan S on 20/01/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CrashMaster : NSObject

@end

@interface CrashNULL : NSObject
- (void)crash;
@end

@interface CrashGarbage : NSObject
- (void)crash;
@end

@interface CrashAsyncSafeThread : NSObject
- (void)crash;
@end

@interface CrashObjCException : NSObject
- (void)crash;
@end

@interface CrashReadOnlyPage : NSObject
- (void)crash;
@end

@interface CrashAbort : NSObject
- (void)crash;
@end


NS_ASSUME_NONNULL_END
