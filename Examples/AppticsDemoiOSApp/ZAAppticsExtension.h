#import <Foundation/Foundation.h>
#if __has_include(<Apptics/Apptics-umbrella.h>)
@import Apptics;
#elif __has_include(<Apptics/APEventsEnum.h>)
#import <Apptics/APEventsEnum.h>
#import <Apptics/Apptics.h>
#import <Apptics/APBundle.h>
#else
#import "APEventsEnum.h"
#import "Apptics.h"
#import "APBundle.h"
#endif
#if __has_include(<AppticsEventTracker/Apptics-umbrella.h>)
@import AppticsEventTracker;
#elif __has_include(<AppticsEventTracker/AppticsEventTracker.h>)
#import <AppticsEventTracker/APEvent.h>
#else
#import "APEvent.h"
#endif
typedef enum {
	APEventTypeNone,

	APEventType_vendorcredits_mark_void,

	APEventType_vendorcredits_approve,

	APEventType_vendorcredits_add_comment,

	APEventType_vendorcredits_create,

	APEventType_vendorcredits_mark_draft,

	APEventType_vendorcredits_print_pdf,

	APEventType_vendorcredits_submitForApproval,

	APEventType_vendorcredits_update,

	APEventType_vendorcredits_download_pdf,

	APEventType_vendorcredits_mark_open,

	APEventType_vendorcredits_save_payment,

	APEventType_test1234_testphase,

	APEventType_test_testphase,

	APEventType_IN_APP_UPDATE_dismiss_install_alert,

	APEventType_IN_APP_UPDATE_update_install_event,

	APEventType_DetailsFragment_rename_notify_via_sms,

	APEventType_DetailsFragment_rename_test,

	APEventType_DetailsFragment_rename_get_contact_details_to_send_sms,

	APEventType_DetailsFragment_rename_Renamedevents,

	APEventType_DetailsFragment_rename_reject_transaction,

	APEventType_ICICI_Vendor_Payments_add_vendor_bank_account,

	APEventType_ICICI_Vendor_Payments_show_otp_dialog,

	APEventType_ICICI_Vendor_Payments_vendor_payment,

	APEventType_ICICI_Vendor_Payments_bill_payment,

	APEventType_ICICI_Vendor_Payments_Failure,

	APEventType_ICICI_Vendor_Payments_Success,

	APEventType_ICICI_Vendor_Payments_otp_validation_failure,

	APEventType_pretestgroup_pretestevent,

	APEventType_pretestgroup_Pre_Test_Event,

	APEventType_complaints_DON,

	APEventType_bill_transaction_pdf_click,

	APEventType_bill_country_code,

	APEventType_bill_mobile_number_change,

	APEventType_bill_share_click,

	APEventType_bill_country_code_change,

	APEventType_bill_menu_click,

	APEventType_bill_transaction_link_click,

	APEventType_TEST_RATE_US_GROUP_tt,

	APEventType_TEST_RATE_US_GROUP_testEvent,

	APEventType_TEST_RATE_US_GROUP_NEW_TEST_EVENT_FOR_RATE_US,

	APEventType_j_applifecycle_ja_application_launched,

	APEventType_j_applifecycle_ja_did_become_active,

	APEventType_PRE_TEST_EVENT_B,

	APEventType_PRE_TEST_EVENT_A,

	APEventType_Group_A_Event_A,

	APEventType_Group_A_Event_B,

	APEventType_Group_A_Event_C,

	APEventType_Group_A_Event_ZZ,

	APEventType_texst5_Testevent,

	APEventType_j_default_apptics_android_demo_event,

	APEventType_j_default_TEST,

	APEventType_j_default_this_is_an_demo_event,

	APEventType_TESTGROUP_NEW_TEST_EVENT_FOR_RATE_US,

	APEventType_TESTGROUP_TESTEVENT,

	APEventType_PRE_GROUP_PRE_EVENT,

	APEventType_Test_Group_Test_Event,

	APEventType_test_group_ek_test_event_dho,

	APEventType_Bills_mark_void,

	APEventType_Bills_transaction_rejected,

	APEventType_Bills_view_attachment,

	APEventType_Bills_add_comment,

	APEventType_Bills_mark_draft,

	APEventType_Bills_print_pdf,

	APEventType_Bills_update,

	APEventType_Bills_create_payment,

	APEventType_Bills_submitforapproval,

	APEventType_Bills_print_pdf_from_buildin_option,

	APEventType_Bills_save_attachment,

	APEventType_Bills_SATHISH1234,

	APEventType_Bills_TEst,

	APEventType_Bills_approve,

	APEventType_Bills_dfadsf,

	APEventType_Bills_create,

	APEventType_Bills_dfsfdsfdsfdsfdfdsfdsfsdfds,

	APEventType_Bills_details,

	APEventType_Bills_export_pdf,

	APEventType_Bills_download_pdf,

	APEventType_Bills_mark_open,

	APEventType_Bills_save_payment

}APEventType;

@interface Apptics(Extension)

+ (void) setCustomEventsProtocol;

+ (void) setApiTrackingProtocol;

@end

@interface APEvent(Extension)

+ (NSString*_Nullable) eventID :(APEventType) type;

+ (void) trackEventWithType:(APEventType) type;

+ (void) trackEventWithType:(APEventType) type andProperties:(NSDictionary*_Nullable)props;

+ (void) startTimedEventWithType:(APEventType) type;

+ (void) startTimedEventWithType:(APEventType) type andProperties:(NSDictionary * _Nullable)props;

+ (void) endTimedEventWithType:(APEventType) type;

@end

@interface APEventExtension : NSObject <APEventsProtocol>
@end

@interface ZAAPAPIExtension : NSObject <APAPIProtocol>
@end
