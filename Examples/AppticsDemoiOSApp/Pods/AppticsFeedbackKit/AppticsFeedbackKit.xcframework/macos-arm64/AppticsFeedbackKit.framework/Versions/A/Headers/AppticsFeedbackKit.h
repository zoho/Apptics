//
//  AppticsFeedbackKit.h
//  AppticsFeedbackKit
//
//  Created by Saravanan S on 29/06/22.
//

#import <Foundation/Foundation.h>

//! Project version number for AppticsFeedbackKit.
FOUNDATION_EXPORT double AppticsFeedbackKitVersionNumber;

//! Project version string for AppticsFeedbackKit.
FOUNDATION_EXPORT const unsigned char AppticsFeedbackKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <AppticsFeedbackKit/PublicHeader.h>

//#import <AppticsFeedbackKit/FeedbackKit.h>
//#import <AppticsFeedbackKit/ZAPresenter.h>
//#import <AppticsFeedbackKit/FKCustomHandler.h>


#if TARGET_OS_IOS || TARGET_OS_MACCATALYST
#import <AppticsFeedbackKit/ZAPresenter.h>
#import <AppticsFeedbackKit/FeedbackKit.h>
#import <AppticsFeedbackKit/FKCustomHandler.h>
#endif

#if TARGET_OS_OSX
#import <AppticsFeedbackKit/FeedbackKit.h>
#import <AppticsFeedbackKit/FKCustomHandler.h>
#import <AppticsFeedbackKit/FeedbackKitMacos.h>
#import <AppticsFeedbackKit/ZAAttachmentUploadOperation.h>
#import <AppticsFeedbackKit/ZABugNetworkManager.h>
#endif
