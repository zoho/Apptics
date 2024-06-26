//
//  ZAArrowView.h
//  ArrowViewObjC
//
//  Created by charles Samuel DMonte on 17122015.
//  Copyright © 2015 com.jambav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZAMathLibrary.h"
#import "ZAArrowCanvasView.h"
NS_ASSUME_NONNULL_BEGIN
@class ZAArrowCanvasView;

extern float maxArrowWidth;
extern float minArrowWidth;
extern float dragpointDimension;

@interface ZAArrowView : UIView <UIGestureRecognizerDelegate>

- (void)unselect;
- (void)select;

+ (UIBezierPath *)getArrowBezierPathBetween:(CGPoint)p1 and:(CGPoint)p2;

@property (nonatomic) UIColor * fillColor;
@property (nonatomic) UIColor * strokeColor;

@property (nonatomic) ZAArrowCanvasView * parentCanvas;

@property (nonatomic, readonly) BOOL isSelected;

@end
NS_ASSUME_NONNULL_END
