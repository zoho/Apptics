//
//  ZAArrowCanvasView.h
//  ArrowViewObjC
//
//  Created by charles Samuel DMonte on 18122015.
//  Copyright © 2015 com.jambav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZAArrowView.h"
NS_ASSUME_NONNULL_BEGIN
@class ZAArrowView;

@interface ZAArrowCanvasView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic) UIColor * fillColor;
@property (nonatomic) UIColor * strokeColor;

@property NSMutableArray * arrowsArray;

@property (nonatomic, nullable) ZAArrowView * selectedArrow;

- (void)unselectAllArrows;

- (void)arrowSelected:(ZAArrowView *)newArrowView;
- (void)arrowUnselected:(ZAArrowView *)newArrowView;

- (void)undolastArrow;

@end
NS_ASSUME_NONNULL_END
