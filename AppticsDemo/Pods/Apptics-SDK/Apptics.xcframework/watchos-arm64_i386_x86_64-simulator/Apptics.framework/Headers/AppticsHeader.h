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
#import <Apptics/APCustomHandler.h>
#import <Apptics/WCSessionSwizzlerDelegate.h>

#else

#import "Apptics.h"
#import "Analytics.h"
#import "APLog.h"
#import "APCustomHandler.h"
#import "WCSessionSwizzlerDelegate.h"

#endif

#endif /* AppticsHeader_h */
