//
//  ZAPresenter.h
//  BugReporterTest
//
//  Created by Giridhar on 18/05/17.
//  Copyright © 2017 Giridhar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Apptics/ZAEnums.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZAPresenter : NSObject


- (void) showAlert:(UIAlertController*) alert completion:(void (^)(void))completion;

- (void) showActivity:(UIActivityViewController*)alert completion:(void (^)(void))completion;

- (void) showViewController:(UIViewController*) viewController;

- (void) dismissWindow;


@end
NS_ASSUME_NONNULL_END
