//
//  KMPCrash.h
//  Apptics
//
//  Created by prakash-1895 on 18/03/25.
//

#import <Foundation/Foundation.h>
#import <Apptics/ZAEnums.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KMPExceptionReporter
//@property (readonly) BOOL isMergeNeeded;
- (void)recordException:(NSArray<NSException *> * _Nonnull)exceptions;
@end

@interface KMPCrashReporter : NSObject <KMPExceptionReporter>
@property (nonatomic, assign) APTrackKMPCrashByStrategy causedByStrategy;
//+(id<KMPExceptionReporter>) withCausedByStrategy:(APTrackKMPCrashByStrategy)causedByStrategy;
@end

NS_ASSUME_NONNULL_END
