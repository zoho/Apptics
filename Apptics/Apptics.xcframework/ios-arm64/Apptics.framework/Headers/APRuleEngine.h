/*
 * APRuleEngine.h
 * Apptics SDK — TokenSanitizer
 *
 * Singleton that owns the ordered list of APDetectionRule objects and applies
 * them to strings.  Thread-safe: reads and writes use a concurrent queue with
 * barrier writes, so concurrent sanitize: calls never block each other.
 */

#import <Foundation/Foundation.h>
#import "APDetectionRule.h"
#import "APSanitizedMatch.h"

NS_ASSUME_NONNULL_BEGIN

@interface APRuleEngine : NSObject

+ (instancetype)sharedEngine;

// ── Core sanitization ──────────────────────────────────────────────────────

/// Apply all enabled rules to `input` and return the sanitized result.
/// Safe to call concurrently from multiple threads.
- (NSString *)sanitize:(NSString *)input;

/// Find all sensitive substrings in `input` without modifying it.
/// Returns APSanitizedMatch objects ordered by their location in the string.
/// Used internally by APImageSanitizer to map PII back to image coordinates.
- (NSArray<APSanitizedMatch *> *)findMatches:(NSString *)input;

// ── Rule management ───────────────────────────────────────────────────────

/// Append a custom rule.  Duplicate names are silently ignored.
- (void)addRule:(APDetectionRule *)rule;

/// Remove a rule by name (built-in or custom).
- (void)removeRuleNamed:(NSString *)name;

/// Enable or disable a rule by name without removing it.
- (void)setEnabled:(BOOL)enabled forRuleNamed:(NSString *)name;

/// Snapshot of all registered rules (enabled and disabled).
- (NSArray<APDetectionRule *> *)allRules;

// ── Ignore-key list ────────────────────────────────────────────────────────
// Keys added here are never sanitized when encountered as dictionary keys.

- (void)addIgnoreKey:(NSString *)key;
- (void)removeIgnoreKey:(NSString *)key;
- (BOOL)isKeyIgnored:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
