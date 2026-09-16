/*
 * APVisionTextDetector.h
 * Apptics SDK — TokenSanitizer
 *
 * Runs VNRecognizeTextRequest (iOS 13+) on a UIImage and returns
 * recognized-text observations for downstream PII analysis.
 *
 * All work is performed off the calling thread.
 * The completion block is called on an internal background queue.
 *
 * Availability: iOS 13+.  The public API is unconditionally declared
 * so it can be referenced in pre-iOS-13 code; the caller is responsible
 * for guarding with @available(iOS 13, *) before invoking.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Vision/Vision.h>

NS_ASSUME_NONNULL_BEGIN

/// One OCR result: the full recognized string and its Vision observation.
@interface APOCRResult : NSObject
/// The complete text string recognized in this observation.
@property (nonatomic, copy,   readonly) NSString              *text;
/// The Vision observation that produced this result (iOS 13+).
/// Type is id to avoid forced iOS-13 import in headers used on older targets.
@property (nonatomic, strong, readonly) id                     observation; // VNRecognizedTextObservation*
@end

// ─────────────────────────────────────────────────────────────────────────────

typedef void (^APVisionTextDetectorCompletion)(NSArray<APOCRResult *> * _Nullable results,
                                               NSError                * _Nullable error);

@interface APVisionTextDetector : NSObject

/// Run OCR on `image` in the background and call `completion` when done.
/// `completion` is called on a background queue — dispatch to main if needed.
+ (void)detectTextInImage:(UIImage *)image
               completion:(APVisionTextDetectorCompletion)completion;

/// Convert UIImageOrientation to CGImagePropertyOrientation for Vision requests.
+ (CGImagePropertyOrientation)cgOrientationFrom:(UIImageOrientation)uiOrientation;

@end

NS_ASSUME_NONNULL_END
