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
// Record-time visibility marker: 1 foreground, 2 background (incl. grace), 0 headless. Set alongside
// sessionstarttime when the object is created; used only to partition uploads by status (it is written
// to the temp table's STATUS column, never to the object's wire JSON).
@property NSNumber *sessionstatus;

-(void) encodeWithCoder:(NSCoder *)aCoder;

@end
NS_ASSUME_NONNULL_END
