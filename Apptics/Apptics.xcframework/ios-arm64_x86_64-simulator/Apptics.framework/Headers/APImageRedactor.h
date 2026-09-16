/*
 * APImageRedactor.h
 * Apptics SDK — TokenSanitizer
 *
 * Renders a new CGImage where every rect in the redaction list is
 * overwritten with an opaque solid colour.  The original pixels inside
 * sensitive regions are destroyed — they are not stored or recoverable.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APImagePrivacyOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface APImageRedactor : NSObject

/// Redact `rects` from `image`.  Returns a new UIImage; never modifies the input.
/// @param image   Source image.
/// @param rects   Array of NSValue-wrapped CGRects in image pixel coordinates.
/// @param options Controls mask colour/style.
+ (nullable UIImage *)redactImage:(UIImage *)image
                            rects:(NSArray<NSValue *> *)rects
                          options:(APImagePrivacyOptions *)options;

@end

NS_ASSUME_NONNULL_END
