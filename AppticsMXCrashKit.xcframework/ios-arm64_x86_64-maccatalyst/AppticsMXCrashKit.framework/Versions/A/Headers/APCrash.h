//
//  APCrash.h
//  AppticsCrashKit
//
//  Created by Saravanan S on 12/06/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APCrash : NSObject

@property (nonatomic, retain) NSMutableDictionary *crashMetaInfo;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSURL *url;

+ (APCrash*)sharedManager;

@end

NS_ASSUME_NONNULL_END
