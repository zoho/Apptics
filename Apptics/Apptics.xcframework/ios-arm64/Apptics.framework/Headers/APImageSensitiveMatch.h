/*
 * APImageSensitiveMatch.h
 * Apptics SDK — TokenSanitizer
 *
 * Combines an APSanitizedMatch (text-level PII) with its
 * bounding rectangle in the original image's pixel coordinate space.
 * Used by APImageRedactor to know exactly which pixels to overwrite.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APSanitizedMatch.h"

NS_ASSUME_NONNULL_BEGIN

@interface APImageSensitiveMatch : NSObject

/// The text-level match (detector name, original, masked, NSRange).
@property (nonatomic, strong, readonly) APSanitizedMatch *textMatch;

/// Bounding rectangle in image pixel coordinates (origin top-left, no scale factor applied).
@property (nonatomic, assign, readonly) CGRect imageRect;

- (instancetype)initWithTextMatch:(APSanitizedMatch *)textMatch
                        imageRect:(CGRect)imageRect NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
