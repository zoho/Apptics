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

- (void)setBlurIntensity:(float)newBlurIntensity;
- (void)setArrowColor:(UIColor *)newArrowColor;

- (void)select;
- (void)unselect;

@end
NS_ASSUME_NONNULL_END
