/*
 * APLogSanitizer.h
 * Apptics SDK — TokenSanitizer
 *
 * Public entry point for all sanitization in the analytics SDK.
 * Thread-safe; safe to call from any queue.
 *
 * Quick-start:
 *
 *   // Sanitize a log string
 *   NSString *safe = [APLogSanitizer sanitizeLog:rawMessage];
 *
 *   // Sanitize a dictionary (e.g. c   ustom event properties)
 *   NSDictionary *safe = [APLogSanitizer sanitizeDictionary:props];
 *
 *   // Add a custom rule
 *   [APLogSanitizer addCustomRuleWithName:@"EmployeeID"
 *                                 pattern:@"EMP[0-9]{6}"
 *                               maskBlock:^NSString *(NSString *m) {
 *                                   return @"<EMPLOYEE_ID>";
 *                               }];
 *
 *   // Disable a built-in detector
 *   [APLogSanitizer setEnabled:NO forDetectorNamed:APRuleNameUUID];
 *
 *   // Add a key that should never be sanitized
 *   [APLogSanitizer addIgnoreKey:@"appVersion"];
 */

#import <Foundation/Foundation.h>
#import "APDetectionRule.h"
#import "APSanitizedMatch.h"

NS_ASSUME_NONNULL_BEGIN

@interface APLogSanitizer : NSObject

// ── Core API ──────────────────────────────────────────────────────────────────

/// Sanitize a plain log message.  Returns the input unchanged if it is nil
/// or empty.  Always returns a non-nil string.
+ (NSString *)sanitizeLog:(nullable NSString *)message;

/// Recursively sanitize string values in a dictionary.  Keys listed in the
/// ignore list are passed through untouched.  Non-string values (NSNumber,
/// NSNull, nested NSDictionary, nested NSArray) are handled recursively.
+ (NSDictionary *)sanitizeDictionary:(nullable NSDictionary *)dictionary;

/// Recursively sanitize an array.  String elements are sanitized; nested
/// dictionaries and arrays are processed recursively.
+ (NSArray *)sanitizeArray:(nullable NSArray *)array;

// ── Custom rules ──────────────────────────────────────────────────────────────

/// Register a custom detection rule.  Duplicate names are ignored.
+ (void)addCustomRuleWithName:(NSString *)name
                      pattern:(NSString *)pattern
                    maskBlock:(NSString *(^)(NSString *match))maskBlock;

// ── Internal PII detection (used by APImageSanitizer) ─────────────────────────

/// Find all sensitive substrings in `text` without modifying it.
/// Returns APSanitizedMatch objects ordered by location.
/// Reuses all enabled APRuleEngine rules — custom rules are automatically included.
+ (NSArray<APSanitizedMatch *> *)findSensitiveMatches:(NSString *)text;

// ── Fine-grained control ──────────────────────────────────────────────────────

/// Enable or disable a built-in or custom detector by name.
/// Use the APRuleName* constants from APDetectionRule.h.
+ (void)setEnabled:(BOOL)enabled forDetectorNamed:(NSString *)name;

/// Keys added here are never sanitized when they appear as dictionary keys.
+ (void)addIgnoreKey:(NSString *)key;
+ (void)removeIgnoreKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
