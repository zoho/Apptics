//
//  ZASystemLogsViewController.h
//  JAnalytics
//
//  Created by Saravanan S on 05/07/18.
//

#import <UIKit/UIKit.h>
#import <Apptics/APTheme.h>
NS_ASSUME_NONNULL_BEGIN

@protocol APReviewViewControllerDelegate <NSObject>

@optional -(void)cancelButtonPressed;
@optional -(void)sendButtonPressed:(BOOL)alwaysOn;

@end

@interface APReviewViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) id <APTheme> theme;
@property (strong, nonatomic) id <APFeedbackTheme> feedbackTheme;

@property (strong, nonatomic) id <APTheme> defaultTheme;
@property (strong, nonatomic) id <APFeedbackTheme> defaultFeedbackTheme;

@property (nullable, nonatomic, retain) NSString *logText;
@property (nonatomic, assign) BOOL isReviewScreen;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSArray *logtextarray;
@property (weak, nonatomic) id<APReviewViewControllerDelegate> delegate;
@end
NS_ASSUME_NONNULL_END
