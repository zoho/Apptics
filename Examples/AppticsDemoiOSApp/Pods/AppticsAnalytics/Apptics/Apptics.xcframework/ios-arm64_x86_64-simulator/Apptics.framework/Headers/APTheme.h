//
//  APTheme.h
//  JAnalytics
//
//  Created by Saravanan S on 19/07/18.
//

#import <Foundation/Foundation.h>
#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSInteger {
  Dark = 0,
  Light
} DropDownImage;

@interface APThemeUtil : NSObject
#if !TARGET_OS_OSX && !TARGET_OS_WATCH
+ (void)appendAttributes :(NSDictionary *)attributes toButton : (UIButton*) button;
+ (void)appendAttributes :(NSDictionary *)attributes toLabel : (UILabel*) label;
+ (void)appendAttributes :(NSDictionary *)attributes toTextView : (UITextView*) textView;
#endif
@end

@protocol APTheme <NSObject>
#if !TARGET_OS_OSX && !TARGET_OS_WATCH
@optional
-(UIColor *_Nullable)tintColor;
-(UIColor *_Nullable)barTintColor;
-(UINavigationBarAppearance *)standardAppearance API_AVAILABLE(ios(13.0), tvos(13.0));
-(BOOL) translucent;
-(NSDictionary *_Nullable)titleTextAttributes;
-(NSDictionary *_Nullable)barButtontitleTextAttributes;
- (void)za_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection;
#endif
@end

@protocol APSettingsTheme <APTheme>


#if !TARGET_OS_OSX
@optional
#if !TARGET_OS_WATCH
-(UITableViewStyle)tableViewStyle;
#endif
-(UIColor *_Nullable)viewBGColor;
-(UIColor *_Nullable)cellBGColor;
-(UIColor *_Nullable)cellTextColor;
-(UIColor *_Nullable)footerTextColor;
-(UIColor *_Nullable)switchOnTintColor;
-(UIColor *_Nullable)switchOffTintColor;
-(UIColor *_Nullable)switchThumbTintColor;
-(UIColor *_Nullable)switchTintColor;
-(CGFloat) switchScale;
-(UIColor *_Nullable)tableViewSeparatorColor;

-(UIFont *_Nullable)cellTextFont;
-(UIFont *_Nullable)footerTextFont;
#if !TARGET_OS_WATCH
-(UIButton *_Nullable)backButton;
#endif
-(CGFloat) lineSpacing;
-(CGFloat) cellVerticalPadding;
-(CGSize) preferredContentSize;

- (void)za_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection;
#endif
-(NSString *_Nullable)fontName;

@end

@protocol APFeedbackTheme <APTheme>
#if !TARGET_OS_OSX && !TARGET_OS_WATCH
@optional

-(UIColor *_Nullable)viewBGColor;
-(UIColor *_Nullable)contentBGColor;
-(UIColor *_Nullable)switchOnTintColor;
-(UIColor *_Nullable)switchOffTintColor;
-(UIColor *_Nullable)switchThumbTintColor;
-(UIColor *_Nullable)switchTintColor;
-(CGFloat) switchScale;

-(UIColor *_Nullable)textFieldTextColor;
-(UIColor *_Nullable)textFieldPlaceholderColor;
-(UIColor *_Nullable)textViewTextColor;
-(UIColor *_Nullable)textViewPlaceholderColor;

-(UIColor *_Nullable)accessoryViewBGColor;
-(UIColor *_Nullable)accessoryHeaderTextColor;
-(UIColor *_Nullable)accessorySubHeaderTextColor;

-(UIColor *_Nullable)collectionViewCellBorderColor;

-(UIColor *_Nullable)separatorColor;

-(UIFont *_Nullable)textFieldFont;
-(UIFont *_Nullable)textViewFont;
-(UIFont *_Nullable)keyboardAccessoryHeaderFont;
-(UIFont *_Nullable)keyboardAccessorySubHeaderFont;

-(UIFont *_Nullable)noImagePlaceholderFont;
-(CGSize)preferredContentSize;

-(UIColor *_Nullable)attachmentTableHeaderTextColor;
-(UIColor *_Nullable)attachmentTableCellFileNameTextColor;
-(UIColor *_Nullable)attachmentTableCellSizeLabelTextColor;
-(UIColor *_Nullable)attachmentTableCellXButtonColor;

-(UIFont *_Nullable)attachmentTableHeaderTextFont;
-(UIFont *_Nullable)attachmentTableCellFileNameTextFont;
-(UIFont *_Nullable)attachmentTableCellSizeLabelTextFont;

-(UIKeyboardAppearance) keyboardAppearance;

-(UIColor *_Nullable)pickerViewBGColor;
-(UIColor *_Nullable)systemLogViewBGColor;
-(UIColor *_Nullable)systemLogTextColor;
-(UIColor *_Nullable)diagnosticInfoBGColor;
-(UIColor *_Nullable)diagnosticInfoTextColor;

-(DropDownImage) dropDownImage;

- (void)za_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection;

#endif
-(NSString *_Nullable)fontName;
@end

@protocol APFeedbackPrivacyTheme <APTheme>
#if !TARGET_OS_OSX && !TARGET_OS_WATCH
@optional

-(UIColor *_Nullable)viewBGColor;
-(UIColor *_Nullable)switchOnTintColor;
-(UIColor *_Nullable)switchOffTintColor;
-(UIColor *_Nullable)switchThumbTintColor;
-(UIColor *_Nullable)switchTintColor;
-(CGFloat) switchScale;

-(UIColor *_Nullable)separatorColor;

-(NSDictionary *_Nullable)titleTextAttributes;
-(NSDictionary *_Nullable)descriptionTextAttributes;

-(NSDictionary *_Nullable)consoleLogButtonTitleTextAttributes;
-(NSDictionary *_Nullable)diagnosticInfoButtonTitleTextAttributes;

- (void)za_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection;

#endif
-(NSString *_Nullable)fontName;
@end

@protocol APCustomAlertTheme <NSObject>
#if !TARGET_OS_OSX
@optional
-(UIColor *_Nullable)viewBGColor;
-(UIColor *_Nullable)primaryColor;
-(UIColor *_Nullable)secondaryColor;

-(NSDictionary *_Nullable)titleTextAttributes;
-(NSDictionary *_Nullable)descriptionTextAttributes;

-(CGFloat) buttonCornerRadius;

- (void)za_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection;

#endif

@end

@protocol APUserConsentTheme <APCustomAlertTheme>
#if !TARGET_OS_OSX
@optional
-(NSDictionary *_Nullable)buttonTitleTextAttributes;
-(NSDictionary *_Nullable)privacyTextAttributes;
-(UIImage *_Nullable)logoImage;
#endif
@end

@protocol APAppUpdateConsentTheme <APCustomAlertTheme>
#if !TARGET_OS_OSX
@optional
//APCustomAlertTheme's Primary color will be applied to 'Update now' button background and title text color of other two buttons
//APCustomAlertTheme's Secondary color will be applied as title text color of 'Update now' button and background color of other two buttons
//APCustomAlertTheme's titleTextAttributes will be used to customise the title font and color
//APCustomAlertTheme's descriptionTextAttributes will be used to customise the description font and color
//APCustomAlertTheme's buttonCornerRadius will be used to change the button radius using this method
-(UIImage *_Nullable)logoImage;
-(NSDictionary *_Nullable)updateButtonTitleTextAttributes;
-(NSDictionary *_Nullable)remindButtonTitleTextAttributes;
-(NSDictionary *_Nullable)skipButtonTitleTextAttributes;
-(NSDictionary *_Nullable)versionTextAttributes;
-(NSDictionary *_Nullable)readMoreTextAttributes;
-(UIColor *_Nullable)windowBGColor;
#endif
@end

@interface APThemeManager : NSObject

+(id <APTheme>)defaultThemeManager;
+(id <APSettingsTheme>)defaultSettingsThemeManager;
+(id <APFeedbackTheme>)defaultFeedbackThemeManager;
+(id <APFeedbackPrivacyTheme>)defaultFeedbackPrivacyThemeManager;
+(id <APCustomAlertTheme>)defaultCustomAlertThemeManager;
+(id <APUserConsentTheme>)defaultUserConsentThemeManager;
+(id <APAppUpdateConsentTheme>)defaultAppUpdateConsentThemeManager;

+(id <APTheme>)sharedThemeManager;
+(id <APSettingsTheme>)sharedSettingsThemeManager;
+(id <APFeedbackTheme>)sharedFeedbackThemeManager;
+(id <APFeedbackPrivacyTheme>)sharedFeedbackPrivacyThemeManager;
+(id <APCustomAlertTheme>)sharedCustomAlertThemeManager;
+(id <APUserConsentTheme>)sharedUserConsentThemeManager;
+(id <APAppUpdateConsentTheme>)sharedAppUpdateConsentThemeManager;

+(void) setTheme:(id <APTheme>) theme;
+(void) setSettingsTheme:(id <APSettingsTheme>) settingsTheme;
+(void) setFeedbackTheme:(id <APFeedbackTheme>) feedbackTheme;
+(void) setFeedbackPrivacyTheme:(id <APFeedbackPrivacyTheme>) feedbackPrivacyTheme;
+(void) setCustomAlertTheme:(id <APCustomAlertTheme>) customAlertTheme;
+(void) setUserConsentTheme:(id <APUserConsentTheme>) userConsentTheme;
+(void) setAppUpdateConsentTheme:(id <APAppUpdateConsentTheme>) appUpdateConsentTheme;
@end

@interface APDefaultTheme : NSObject <APTheme>
////-(UIColor *_Nullable)tintColor;
//@property (nonatomic, retain) UIColor *_Nullable tintColor;
////-(UIColor *_Nullable)barTintColor;
//@property (nonatomic, retain) UIColor *_Nullable barTintColor;
////-(UINavigationBarAppearance *)standardAppearance API_AVAILABLE(ios(13.0), tvos(13.0));
//@property (nonatomic, retain) UINavigationBarAppearance * standardAppearance API_AVAILABLE(ios(13.0), tvos(13.0));
////-(BOOL) translucent;
//@property (nonatomic) BOOL translucent;
////-(NSDictionary *_Nullable)titleTextAttributes;
//@property (nonatomic, retain) NSDictionary * _Nullable titleTextAttributes;
////-(NSDictionary *_Nullable)barButtontitleTextAttributes;
//@property (nonatomic, retain) NSDictionary * _Nullable barButtontitleTextAttributes;
////- (void)za_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection;

@end

@interface APDefaultSettingsTheme : NSObject <APSettingsTheme>
@end

@interface APDefaultFeedbackTheme : NSObject <APFeedbackTheme>
@end

@interface APDefaultFeedbackPrivacyTheme : NSObject <APFeedbackPrivacyTheme>
@end

@interface APDefaultCustomAlertTheme : NSObject <APCustomAlertTheme>
@end

@interface APDefaultUserConsentTheme : NSObject <APUserConsentTheme>
@end

@interface APDefaultAppUpdateConsentTheme : NSObject <APAppUpdateConsentTheme>
@end

@interface APSharedTheme : NSObject <APTheme>
@end

@interface APSharedSettingsTheme : NSObject <APSettingsTheme>
@end

@interface APSharedFeedbackTheme : NSObject <APFeedbackTheme>
@end

@interface APSharedFeedbackPrivacyTheme : NSObject <APFeedbackPrivacyTheme>
@end

@interface APSharedCustomAlertTheme : NSObject <APCustomAlertTheme>
@end

@interface APSharedUserConsentTheme : NSObject <APUserConsentTheme>
@end

@interface APSharedAppUpdateConsentTheme : NSObject <APAppUpdateConsentTheme>
@end
NS_ASSUME_NONNULL_END
