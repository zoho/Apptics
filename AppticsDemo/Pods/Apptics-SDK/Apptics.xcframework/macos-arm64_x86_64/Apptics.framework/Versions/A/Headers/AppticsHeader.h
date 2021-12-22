//
//  AppticsHeader.h
//  Apptics
//
//  Created by Saravanan S on 01/03/21.
//

#ifndef AppticsHeader_h
#define AppticsHeader_h

#if __has_include(<Apptics/Apptics.h>)

#import <Apptics/Apptics.h>
#import <Apptics/Analytics.h>
#import <Apptics/APLog.h>
#import <Apptics/APRateusObject.h>
#import <Apptics/APRemoteConfig.h>
#import <Apptics/APRemoteConfigValue.h>
#import <Apptics/APAPIManager.h>
#import <Apptics/APCustomHandler.h>
#import <Apptics/APEvent.h>
#import <Apptics/APAppUpdateManager.h>

#else

#import "Apptics.h"
#import "Analytics.h"
#import "APLog.h"
#import "APRateusObject.h"
#import "APRemoteConfig.h"
#import "APRemoteConfigValue.h"
#import "APAPIManager.h"
#import "APCustomHandler.h"
#import "APEvent.h"
#import "APAppUpdateManager.h"

#endif




#endif /* AppticsHeader_h */
