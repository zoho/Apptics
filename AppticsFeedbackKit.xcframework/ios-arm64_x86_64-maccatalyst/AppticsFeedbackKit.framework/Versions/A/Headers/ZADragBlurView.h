//
//  ZADragBlurView.h
//  BlurRect
//
//  Created by charles Samuel DMonte on 21122015.
//  Copyright © 2015 com.jambav. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZADragBlurView : UIView <UIGestureRecognizerDelegate>

@property (readonly) BOOL isSelected;
@property (nonatomic,retain) UIImage * backgroundImage;
/// When NO the corner drag handles and resize gestures are disabled (use for automatic PII masks).
/// Default is YES (standard draggable blur view).
@property (nonatomic, assign) BOOL resizable;

- (void)setBlurIntensity:(float)newBlurIntensity;
- (void)setArrowColor:(UIColor *)newArrowColor;

- (void)select;
- (void)unselect;

/// Set a pre-cropped, pre-pixelated image that fills the entire blur view.
/// Use this instead of backgroundImage for fixed PII masks to bypass contentsRect mapping.
- (void)setFixedBlurredImage:(UIImage *)image;

@end
NS_ASSUME_NONNULL_END
