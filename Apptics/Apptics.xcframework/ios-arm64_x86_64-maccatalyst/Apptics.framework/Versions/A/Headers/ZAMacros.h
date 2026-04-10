//
//  ZAMacros.h
//  JAnalytics
//
//  Created by Giridhar on 15/05/17.
//  Copyright © 2017 zoho. All rights reserved.
//

#ifndef ZAMacros_h
#define ZAMacros_h

#if !defined(za_isNotEmpty)
#define za_isNotEmpty(A)  ({ NSString *__a = A; ( ![__a isEqual:[NSNull null]] ) && ( [__a length] != 0 ); })
#endif

#if !defined(za_safeString)
#define za_safeString(A)  ({ NSString *__a = A; (__a != nil) ? __a : @""; })
#endif

#if !defined(za_safeLong)
#define za_safeLong(A)  ({ __typeof__(A) __a = (A); (__a != nil) ? __a : 0; })
#endif

#if !defined(za_safeNumber)
#define za_safeNumber(A)  ({ NSNumber *__a = A; (__a != nil) ? __a : @0; })
#endif

#if !defined(za_safeDictionary)
#define za_safeDictionary(A)  ({ NSDictionary *__a = A; (__a != nil) ? __a : @{}; })
#endif

#if !defined(za_Number)
#define za_Number(A)  (@([A integerValue]))
#endif

#define ap_formatter(args...) [NSString stringWithFormat:args];

#endif /* ZAMacros_h */
