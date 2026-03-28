//
//  ZAAttachmentUploadOperation.h
//  JAnalytics
//
//  Created by Saravanan S on 04/07/18.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZAAttachmentUploadOperation : NSOperation

@property(retain, nullable) NSString *type;

@property(retain, nullable) NSString *attachmentId;
@property(retain, nullable) NSString *feedbackId;

@property(retain, nullable) NSString *logFilePath;

@property(assign) NSUInteger currentIndex;
@property(assign) NSUInteger totalCount;


- (id)initWithFeedbackId:(NSString*)feedbackId withAttachmentId : (NSString*) attachmentId userID : (NSString*) userId anonID : (NSString*) anonid;

- (id)initWithFeedbackId:(NSString*)feedbackId withLogFilePath : (NSString*)logFilePath userID : (NSString*) userId anonID : (NSString*) anonid;

@end
NS_ASSUME_NONNULL_END
