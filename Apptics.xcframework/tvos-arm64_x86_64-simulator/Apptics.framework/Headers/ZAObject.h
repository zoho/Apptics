//
//  ZAObject.h
//  JAnalytics
//
//  Created by Giridhar on 08/02/17.
//  Copyright © 2017 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Apptics/ZAConstants.h>


NS_ASSUME_NONNULL_BEGIN
@protocol JSONAble <NSObject>

@required
- (NSDictionary*)jsonify;

@end

@interface ZAObject : NSObject

@property BOOL isSyncing;
@property NSNumber *starttime, *endtime, *networkstatus, *networkbandwidth, *orientation, *batteryin;
@property NSString *serviceprovider, *edgetype;

-(void) encodeWithCoder:(NSCoder *)aCoder;

@end
NS_ASSUME_NONNULL_END
