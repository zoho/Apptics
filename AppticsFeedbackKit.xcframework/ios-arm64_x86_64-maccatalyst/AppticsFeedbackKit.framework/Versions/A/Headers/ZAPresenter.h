//
//  ZAPresenter.h
//  BugReporterTest
//
//  Created by Giridhar on 18/05/17.
//  Copyright © 2017 Giridhar. All rights reserved.
//

#import <Foundation/Foundation.h>
#if !TARGET_OS_OSX

#import <UIKit/UIKit.h>
#endif

#import <Apptics/ZAEnums.h>
NS_ASSUME_NONNULL_BEGIN
#if !TARGET_OS_OSX

@interface ZAPresenter : NSObject


- (void) showAlert:(UIAlertController*) alert completion:(void (^)(void))completion;

- (void) showActivity:(UIActivityViewController*)alert completion:(void (^)(void))completion;

- (void) showViewController:(UIViewController*) viewController;

- (void) dismissWindow;
@end
#endif

NS_ASSUME_NONNULL_END


