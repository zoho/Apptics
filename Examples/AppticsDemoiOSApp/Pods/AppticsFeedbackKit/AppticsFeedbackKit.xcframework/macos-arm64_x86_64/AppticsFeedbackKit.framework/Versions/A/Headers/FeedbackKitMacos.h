//
//  FeedbackKitMacOS.h
//  AppticsFeedback
//
//  Created by jai-13322 on 14/02/24.
//

#import <Foundation/Foundation.h>
#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#import <AppticsFeedbackKit/ZAPresenter.h>
#import <AppticsFeedbackKit/FKCustomHandler.h>
#import <MessageUI/MessageUI.h>
#import "ZAArrowCanvasView.h"
#import "ZADragBlurView.h"
#else
#import <Cocoa/Cocoa.h>
#endif
#import <Apptics/APTheme.h>
#import <AppticsFeedbackKit/FeedbackDiagosticInfo.h>


NS_ASSUME_NONNULL_BEGIN

@interface FeedbackKitMacOS : NSObject

@property (nonatomic, strong) NSString *emailAddress;

@property (nonatomic, assign) BOOL anonymStatus;
@property (nonatomic,strong) NSMutableArray*arrayOfimages;

+(FeedbackKitMacOS* _Nonnull)listener;

/**
 Set diagnostic information in the format of dictionary @[@"key":@"<value>"] of array.
 */

+(void) setDiagnosticInfo : (NSArray<NSArray<NSDictionary*>*>* _Nonnull) info __deprecated_msg("use setDiagnosticInfoDict method instead.");;

/**
 Set diagnostic information in the format of dictionary [@"key":@"value"]
 */

+(void) setDiagnosticInfoObject : (FeedbackDiagosticInfo* _Nonnull) diagnosticInfo;


/**
Set sender email address to which the support emails will be sent from feedback screen.
*/

+ (void) setSenderEmailAddress:(NSString*_Nonnull) email;

+ (void) setFromEmailAddress:(NSString*_Nonnull) email __deprecated_msg("use setSenderEmailAddress method instead.");

+ (void) enableAnonymousUserAlert:(BOOL)status;

+ (NSString*_Nullable) getLocalizableStringForKey : (NSString*_Nonnull) key;


@property NSString* feedback_KitType;

@property (nonatomic, strong) FeedbackDiagosticInfo *feedbackDiagosticInfo;

@property (nonatomic, strong) NSArray *diagnoInfo;
@property (nonatomic, strong) NSString *baseUrl;

@property (strong,nonatomic) NSNumber *networkReachableStatus;
@property (nonatomic, assign) BOOL isReachable;

@end

NS_ASSUME_NONNULL_END
