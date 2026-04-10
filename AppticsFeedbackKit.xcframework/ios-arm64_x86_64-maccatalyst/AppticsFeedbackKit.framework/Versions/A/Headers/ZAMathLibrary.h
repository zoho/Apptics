//
//  ZAMathLibrary.h
//  ArrowViewObjC
//
//  Created by charles Samuel DMonte on 18122015.
//  Copyright © 2015 com.jambav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZAMathLibrary : NSObject


+ (float)getDistanceBetween:(CGPoint)p1 and:(CGPoint)p2;

+ (CGFloat)getAngleInRadiansOf:(CGPoint)a withRespectTo:(CGPoint)b;
+ (CGFloat)getAngleInDegreesOf:(CGPoint)a withRespectTo:(CGPoint)b;

+ (double)convertDegreeToRadian:(double)degree;

+ (CGPoint)getPointWithAngle:(float)degree radius:(float)radius andPoint:(CGPoint)point;

@end
NS_ASSUME_NONNULL_END
