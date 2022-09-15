//
//  AppticsHeader.h
//  Apptics
//
//  Created by Saravanan S on 28/02/21.
//

#ifndef AppticsHeader_h
#define AppticsHeader_h
#if __has_include(<Apptics/Apptics.h>)

#import <Apptics/Apptics.h>
#import <Apptics/Analytics.h>
#import <Apptics/APLog.h>
#import <Apptics/APBundle.h>
#import <Apptics/WCSessionSwizzlerDelegate.h>
#import <Apptics/APCustomHandler.h>

#else

#import "Apptics.h"
#import "Analytics.h"
#import "APLog.h"
#import "APBundle.h"
#import "WCSessionSwizzlerDelegate.h"
#import "APCustomHandler.h"

#endif

#endif /* AppticsHeader_h */
