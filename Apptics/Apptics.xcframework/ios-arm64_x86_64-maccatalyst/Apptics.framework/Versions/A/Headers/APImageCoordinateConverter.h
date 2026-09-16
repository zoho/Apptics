/*
 * APImageCoordinateConverter.h
 * Apptics SDK — TokenSanitizer
 *
 * Converts Vision's normalized bounding boxes (origin bottom-left, y-up)
 * into pixel rectangles in UIImage coordinate space (origin top-left, y-down).
 *
 * Handles:
 *   - Portrait and landscape screenshots
 *   - UIImage orientation (EXIF and UIImageOrientation)
 *   - Retina scale (image.scale)
 *   - Partial-word bounding boxes from VNRecognizedText
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APImageCoordinateConverter : NSObject

/// Image size in pixels (image.size * image.scale).
@property (nonatomic, assign, readonly) CGSize pixelSize;

/// UIImage orientation used to build the correct affine transform.
@property (nonatomic, assign, readonly) UIImageOrientation orientation;

- (instancetype)initWithImage:(UIImage *)image NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

/// Convert a Vision normalized rect (bottom-left origin) to a pixel rect (top-left origin).
/// The returned rect is in the image's native pixel space — NOT screen points.
- (CGRect)convertNormalizedRect:(CGRect)visionRect;

@end

NS_ASSUME_NONNULL_END
