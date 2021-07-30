//
//  APLog.h
//  JAnalytics
//
//  Created by Giridhar on 18/04/16.
//  Copyright © 2016 zoho. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ZAEnums.h"

/**
 *  Use these method in your own application to log, isntead of NSLog.
 *  This does the same thing as NSLog, but typically, we developers use NSLog during development.
 Don't use this macro for printing URLs with Authtoken, but use it efficiently to track your app's logs.
 So that, we can send these logs to you!
 *  @param msg NSLog message
 *  @param ... NSLog arguments
 *
 *  @return prints on the console.
 */

#define APLogVerbose(args...) ZLogExtension(__FILE__,__LINE__,__func__,"verbose",args);

#define APLogDebug(args...) ZLogExtension(__FILE__,__LINE__,__func__,"debug",args);

#define APLogInfo(args...) ZLogExtension(__FILE__,__LINE__,__func__,"info",args);

#define APLogWarn(args...) ZLogExtension(__FILE__,__LINE__,__func__,"warning",args);

#define APLogError(args...) ZLogExtension(__FILE__,__LINE__,__func__,"error",args);

//For Framework use only
#define IVLog(args...) ZLogExtensionInternal(__FILE__,__LINE__,__func__,"verbose",args);
NS_ASSUME_NONNULL_BEGIN
/**
 *  A Custome Logger for logging both Apptics data and your own app data.
 */

@interface APLog : NSObject

/**
 *  Shows Apptics logs, collected data, and other network calls when set as YES. Apptics doesn't log in Release mode.
 */
@property BOOL shouldLog;

@property (nonatomic, retain) NSDateFormatter *dateFormatter;

@property (nonatomic, retain) NSString *dirLogsPath;

@property (nonatomic) NSStringEncoding logEncoding;

/**
 *  Returns shared APLog instance.
 */

@property (nonatomic) APLogLevel defaultLogLevel;

@property (nonatomic, strong, readonly) dispatch_queue_t loggerQueue;

@property (nonatomic, retain) NSString *logsDirectory;

@property (readwrite, assign, nonatomic) NSUInteger maximumNumberOfLogFiles;

+ (APLog *) getInstance;

- (void) ZLSExtension : (NSString*) file lineNumber : (int) linenumber functionName : (NSString*) functionname type : (NSString*) type format : (NSString*) format;

void ZLogExtension(const char *file, int lineNumber, const char *functionName,const char *type, NSString *format, ...);

void ZLogExtensionInternal(const char *file, int lineNumber, const char *functionName,const char *type, NSString *format, ...);

#pragma mark — Logger apis

/**
 *  Prints the SDK log in console when set as YES. Apptics doesn't log in Release mode.
 */

+ (void) setShouldLog:(BOOL) status;

/**
 Sets the directory path of your custom logs.
 @param dirPath string
 */

+ (void) setCustomLogsDirPath:(nonnull NSString*) dirPath;

/**
 Sets Encoding type for custom logs, .
 @param encoding NSStringEncoding
 */

+ (void) setCustomLogEncoding:(NSStringEncoding) encoding;

/**
 *  Use this method to set log levels, which will be used to filter out logs and send to the server at the time of Feedback and Crash.
 
 *  Use these methods `APLogVerbose`, `APLogDebug`, `APLogInfo`, `APLogWarn`, `APLogError` in your own application to log, isntead of NSLog.
 *  The above method does the same thing as NSLog.
 Don't use this macro for printing URLs with Authtoken or any other user PII info, but use it efficiently to track your app's logs.
 So that, we can send these logs to you!
 
 @param level APLogLevel.
 */

+ (void) setLogLevel: (APLogLevel) level;

/**
 * `setMaximumFileSize`:
 *   Maximum file size to allow log files to grow.
 *   If a log file exceeds this value,
 *   then the log file will be rolled.
 
 @param newMaximumFileSize long long in bytes.
 */

+(void) setMaximumFileSize : (unsigned long long) newMaximumFileSize;

/**
 * `setMaximumNumberOfLogFiles`:
 *   Maximum number of log files to be allowed in logs directory.
 *   If number of log files exceeds this value,
 *   then the older log files will be removed.
 
 @param maximumNumberOfLogFiles NSUInteger.
 */

+(void) setMaximumNumberOfLogFiles:(NSUInteger)maximumNumberOfLogFiles;

/**
 Clear console logs.
 */

+ (void) clearConsoleLogs;

+(BOOL) hasLogData : (NSString*) logsDirPath;

@end
NS_ASSUME_NONNULL_END
