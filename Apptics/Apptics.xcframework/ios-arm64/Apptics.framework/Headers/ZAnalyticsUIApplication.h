//
//  ZAnalyticsUIApplication.h
//  JAnalytics
//
//  Created by Saravanan S on 01/03/18.
//  Copyright © 2018 zoho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Apptics/Analytics.h>

#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif
NS_ASSUME_NONNULL_BEGIN
@class ZAnalyticsPIIManagerController;

@interface ZAnalyticsUIApplication : NSObject

#if (TARGET_OS_IOS || TARGET_OS_TV)

@property (nonatomic, weak) Analytics* _Nullable delegate;

@property (nonatomic) bool analyticsScreenIsActive;

+ (ZAnalyticsUIApplication *_Nonnull )getInstance;

- (void)za_openURL:(NSURL*)url options:(NSDictionary<NSString *, id> * _Nullable)options completionHandler:(void (^ __nullable)(BOOL success))completion;

- (BOOL)za_canOpenURL:(NSURL*)url;

- (void)startListeners : (Analytics* _Nullable) delegate;

+ (UIApplication *_Nullable)sharedApplication;

+ (UINavigationController *_Nullable)navigationController;

+ (UIColor *_Nullable)primaryColor;

+ (UIViewController *_Nullable)topPresentedViewController;

+ (BOOL)canPresentFromViewController:(UIViewController *_Nullable)viewController;

+(void) openPIIManagerController : (id _Nullable) viewController withStyle : (UITableViewStyle) style;;

+(id _Nonnull) getAnalyticSettingsController;

+(id _Nonnull) getAnalyticSettingsController : (UITableViewStyle) style;

+ (UIViewController*_Nullable) getTopMostController;

+ (UIViewController*_Nullable) topVisibleViewController : (UIViewController*_Nullable) topController;

+(UIWindow*_Nullable)keyWindow;

+(BOOL) checkIfViewControllerClass : (Class _Nullable ) vcClass isInNavigationController : (UIViewController*_Nullable) viewController;
#if TARGET_OS_IOS
+(BOOL) isAnalyticsScreenActive;
#endif

#endif

@end
NS_ASSUME_NONNULL_END
