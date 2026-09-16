/*
 * APImagePrivacyOptions.h
 * Apptics SDK — TokenSanitizer
 *
 * Configuration for APImageSanitizer.
 * Default behavior is privacy-first: all detection enabled.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Style of the redaction rectangle drawn over sensitive regions.
typedef NS_ENUM(NSInteger, APImageMaskStyle) {
    APImageMaskStyleSolid = 0,  ///< Opaque black rectangle (default, irreversible)
};

@interface APImagePrivacyOptions : NSObject

/// Detect and mask PII text found via OCR. Default: YES.
@property (nonatomic, assign) BOOL detectTextPII;

/// Detect and mask human faces. Default: YES.
@property (nonatomic, assign) BOOL detectFaces;

/// Visual style of the redaction rectangle. Default: APImageMaskStyleSolid.
@property (nonatomic, assign) APImageMaskStyle maskStyle;

/// Color of the solid redaction rectangle. Default: black.
/// Ignored unless maskStyle == APImageMaskStyleSolid.
@property (nonatomic, strong) UIColor *maskColor;

/// Returns a default options object with privacy-first settings.
+ (instancetype)defaultOptions;

@end

NS_ASSUME_NONNULL_END
