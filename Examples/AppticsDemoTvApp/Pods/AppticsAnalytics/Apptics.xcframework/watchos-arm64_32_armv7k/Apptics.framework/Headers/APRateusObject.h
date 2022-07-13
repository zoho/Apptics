//
//  APRateusObject.h
//  JAnalytics
//
//  Created by Saravanan S on 01/10/20.
//  Copyright © 2020 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Apptics/ZAObject.h>

NS_ASSUME_NONNULL_BEGIN

@interface APRateusObject : ZAObject<NSCoding,JSONAble>

@property (strong,nonatomic) NSNumber *criteriaid, *popupsource, *popupaction, *popupnumber, *sessionstarttime;
@property NSString *screen, *ram;

+(void) addObjectToQueueForDictionary:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
