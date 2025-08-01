//
//  KMPCrash.h
//  Apptics
//
//  Created by prakash-1895 on 18/03/25.
//

#import <Foundation/Foundation.h>

@interface KMPCrash : NSObject

@property (nonatomic, retain) NSMutableDictionary *crashMetaInfo;

+ (KMPCrash*)sharedManager;


- (NSString *)getPlatformArchitecture;

- (NSDictionary *)getInfoForBinaryName:(NSString *)binaryName;


@end
