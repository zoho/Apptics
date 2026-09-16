/*
 * APDetectionRule.h
 * Apptics SDK — TokenSanitizer
 *
 * A single detection rule: a compiled regex and a block that transforms
 * each match into its masked form.  Rules are immutable after construction;
 * only the `enabled` flag may change at runtime.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Block that receives a matched substring and returns the replacement.
typedef NSString * _Nonnull (^APMaskBlock)(NSString *match);

/// Names of all built-in rules (use these with setEnabled:forRuleNamed:).
extern NSString *const APRuleNameEmail;
extern NSString *const APRuleNamePhone;
extern NSString *const APRuleNameCreditCard;
extern NSString *const APRuleNameJWT;
extern NSString *const APRuleNameBearerToken;
extern NSString *const APRuleNameAuthHeader;
extern NSString *const APRuleNamePassword;
extern NSString *const APRuleNameSecret;
extern NSString *const APRuleNameToken;
extern NSString *const APRuleNameAPIKey;
extern NSString *const APRuleNameAWSAccessKey;
extern NSString *const APRuleNameAWSSecretKey;
extern NSString *const APRuleNameGoogleAPIKey;
extern NSString *const APRuleNameFirebaseToken;
extern NSString *const APRuleNameStripeKey;
extern NSString *const APRuleNameOpenAIKey;
extern NSString *const APRuleNameGitHubToken;
extern NSString *const APRuleNameSessionID;
extern NSString *const APRuleNameUUID;
extern NSString *const APRuleNameCookie;
extern NSString *const APRuleNameUPI;
extern NSString *const APRuleNamePAN;
extern NSString *const APRuleNameAadhaar;
extern NSString *const APRuleNameIBAN;
extern NSString *const APRuleNameBankAccount;

@interface APDetectionRule : NSObject

/// Human-readable identifier; also used as the key to enable/disable.
@property (nonatomic, copy,   readonly) NSString             *name;
/// Pre-compiled regex — never nil on a successfully built rule.
@property (nonatomic, strong, readonly) NSRegularExpression  *regex;
/// The masking transformation applied to every match.
@property (nonatomic, copy,   readonly) APMaskBlock           maskBlock;
/// Toggle this rule without removing it. Thread-safe via APRuleEngine's queue.
@property (nonatomic, assign)           BOOL                  enabled;

/// Designated initialiser.  Returns nil and populates *error on bad pattern.
- (nullable instancetype)initWithName:(NSString *)name
                               pattern:(NSString *)pattern
                             maskBlock:(APMaskBlock)maskBlock
                                 error:(NSError *__autoreleasing _Nullable *)error NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/// Convenience factory; returns nil (logs) on invalid regex.
+ (nullable instancetype)ruleWithName:(NSString *)name
                               pattern:(NSString *)pattern
                             maskBlock:(APMaskBlock)maskBlock;

@end

NS_ASSUME_NONNULL_END
