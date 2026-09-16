/*
 * APSanitizedMatch.h
 * Apptics SDK — TokenSanitizer
 *
 * Represents a single PII match found in a string.
 * Returned by APLogSanitizer's internal findSensitiveMatches: API.
 * Used by APImageSanitizer to map OCR text matches back to image coordinates.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APSanitizedMatch : NSObject

/// Name of the detector that found this match (e.g. "Email", "Phone").
@property (nonatomic, copy, readonly) NSString *detectorName;

/// The original sensitive substring as it appeared in the input string.
@property (nonatomic, copy, readonly) NSString *originalText;

/// The replacement string produced by the detector's mask block.
@property (nonatomic, copy, readonly) NSString *maskedText;

/// Location of originalText within the input string passed to findSensitiveMatches:.
@property (nonatomic, assign, readonly) NSRange range;

- (instancetype)initWithDetectorName:(NSString *)detectorName
                        originalText:(NSString *)originalText
                          maskedText:(NSString *)maskedText
                               range:(NSRange)range NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
