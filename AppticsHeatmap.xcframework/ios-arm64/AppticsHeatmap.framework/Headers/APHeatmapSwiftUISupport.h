//
//  APHeatmapSwiftUISupport.h
//  AppticsHeatmap
//
//  ObjC bridge used by the iOS 15+ SwiftUI View modifiers.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Bridge between SwiftUI modifiers and the heatmap capture pipeline.
/// Prefer the Swift View modifiers (`.appticsHeatmapScreen`, etc.) over calling these directly.
@interface APHeatmapSwiftUISupport : NSObject

/// Push a SwiftUI screen onto the heatmap screen stack and sync ScreenTracker.
/// Empty / whitespace names are rejected (logged; no silent empty `screen`).
+ (void)enterScreen:(NSString *)screenName;

/// Pop a SwiftUI screen (must match the name pushed). Restores prior screen if any.
+ (void)exitScreen:(NSString *)screenName;

/// Current top of the SwiftUI screen stack (may be nil).
+ (nullable NSString *)currentSwiftUIScreenName;

/// Observe a UIScrollView discovered under a SwiftUI `.appticsHeatmapScroll()` anchor.
+ (void)registerScrollView:(UIScrollView *)scrollView;

/// Stop observing when the SwiftUI scroll anchor is removed.
+ (void)unregisterScrollView:(UIScrollView *)scrollView;

/// Emit an annotated tap from `.appticsHeatmapInteraction` (forces clickable / non-dead / label).
+ (void)emitInteractionTapAtWindowPoint:(CGPoint)windowPoint
                                  label:(NSString *)label
                            isClickable:(BOOL)isClickable;

/// Clears the SwiftUI screen stack. Intended for unit tests.
+ (void)resetScreenStackForTests;

@end

NS_ASSUME_NONNULL_END
