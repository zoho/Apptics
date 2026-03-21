//
//  ZALoader.h
//  JAnalytics
//
//  Created by Saravanan S on 18/03/19.
//  Copyright © 2019 zoho. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZALoader : UIView
@property (nonatomic, assign) BOOL renderStatic;
@property (nonatomic, strong) UIColor *tint;
@property (nonatomic, strong) CALayer *tintLayer;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UILabel *progressLabel;

- (void)renderLayerWithView:(UIView*)superview;

-(void)displayLoadingView;
-(void)hideLoadingView;
-(void)updateProgressText:(nullable NSString *)text;
+ (ZALoader*) sharedInstance;

@end

NS_ASSUME_NONNULL_END
