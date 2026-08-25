//
//  APHeatmapModule.h
//  AppticsHeatmap
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APHeatmapModule : NSObject

+ (instancetype)sharedModule;

/// Enable or disable heatmap capture.
/// Passing YES starts capture immediately if a session is active; passing NO
/// stops capture and prevents it from restarting until called with YES again.
/// Default is off — call this explicitly (or wire your own remote flag) to start.
/// Capture also auto-starts later when an Apptics session becomes available
/// (if still enabled).
+ (void)setEnabled:(BOOL)enabled;

/// Optional override when automatic screen tracking is disabled or a custom
/// screen name is required. By default heatmap reads the active screen from
/// `ZAGlobalQueue` (updated automatically via Apptics screen tracking).
+ (void)setCurrentScreenId:(nullable NSString *)screenId;

@end

NS_ASSUME_NONNULL_END
