/*
 * APImageSanitizer.h
 * Apptics SDK — TokenSanitizer
 *
 * Automatically detects and masks PII in screenshots before they are
 * attached to Feedback.
 *
 * Pipeline:
 *   UIImage
 *     → VNRecognizeTextRequest (on-device OCR, iOS 13+)
 *     → APLogSanitizer.findSensitiveMatches: (PII detection via existing rules)
 *     → VNRecognizedText.boundingBoxForRange:error: (precise character-level boxes)
 *     → APImageCoordinateConverter (Vision coords → pixel rects)
 *     → APImageRedactor (new CGImage with sensitive pixels overwritten)
 *     → UIImage (sanitized, ready for upload)
 *
 * The original image is released immediately after sanitization and is
 * never logged, stored, or uploaded.
 *
 * Requires iOS 13 for OCR.  On iOS 9-12 the original image is returned
 * unchanged — callers should rely on the existing manual-mask UI in that case.
 *
 * Thread-safety: all heavy work runs on a background queue.
 * The completion block is always called on the MAIN thread.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APImagePrivacyOptions.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^APImageSanitizerCompletion)(UIImage * _Nullable sanitizedImage,
                                           NSError  * _Nullable error);

@interface APImageSanitizer : NSObject

/// Sanitize `image` with default privacy options (PII + faces, solid mask).
/// `completion` is called on the main thread.
+ (void)sanitizeImage:(UIImage *)image
           completion:(APImageSanitizerCompletion)completion;

/// Sanitize `image` with custom options.
/// `completion` is called on the main thread.
+ (void)sanitizeImage:(UIImage *)image
              options:(APImagePrivacyOptions *)options
           completion:(APImageSanitizerCompletion)completion;

@end

NS_ASSUME_NONNULL_END
