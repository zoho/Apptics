/*
 * APMaskStrategy.h
 * Apptics SDK — TokenSanitizer
 *
 * Pure transformation functions.  Each method takes a matched substring
 * and returns its masked form.  No state, no side-effects.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMaskStrategy : NSObject

/// john@example.com  →  ****@example.com
+ (NSString *)maskEmail:(NSString *)email;

/// 9876543210  →  98******10
+ (NSString *)maskPhone:(NSString *)phone;

/// 4111 1111 1111 1111  →  ************1111
+ (NSString *)maskCreditCard:(NSString *)card;

/// eyJ…  →  <JWT_TOKEN>
+ (NSString *)maskJWT:(NSString *)token;

/// Bearer eyJ…  →  Bearer ********
+ (NSString *)maskBearerToken:(NSString *)fullMatch;

/// password=secret  →  password=********
+ (NSString *)maskKeyValuePair:(NSString *)fullMatch;

/// ABCDE1234F  →  ******34F
+ (NSString *)maskPAN:(NSString *)pan;

/// 1234 5678 9012  →  XXXX XXXX 9012
+ (NSString *)maskAadhaar:(NSString *)aadhaar;

/// john@ybl  →  ****@ybl
+ (NSString *)maskUPI:(NSString *)upi;

/// DE89 3704 0044 0532 0130 00  →  DE89 **** **** **** **** **
+ (NSString *)maskIBAN:(NSString *)iban;

/// Generic: replace entire match with placeholder
+ (NSString *)maskWithPlaceholder:(NSString *)placeholder;

/// Repeat `*` count times
+ (NSString *)starsOfLength:(NSUInteger)length;

@end

NS_ASSUME_NONNULL_END
