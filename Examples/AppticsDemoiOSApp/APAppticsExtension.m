#import "APAppticsExtension.h"

@implementation Apptics (Extension)

+ (void) setCustomEventsProtocol;{
	[APBundle getInstance].eventsProtocolClass=APEventExtension.class;
}

+ (void) setApiTrackingProtocol;{
	[APBundle getInstance].apiProtocolClass=APAPAPIExtension.class;
}

@end

@implementation APEvent (Extension)

+ (NSString*) eventID :(APEventType) type;{
	NSString *eventId;

	switch (type) {
		case APEventType_vendorcredits_mark_void:
			eventId=@"2089979387833";
			break;
		case APEventType_vendorcredits_approve:
			eventId=@"2089979387815";
			break;
		case APEventType_vendorcredits_add_comment:
			eventId=@"2089979387811";
			break;
		case APEventType_vendorcredits_create:
			eventId=@"2089979387817";
			break;
		case APEventType_vendorcredits_mark_draft:
			eventId=@"2089979387827";
			break;
		case APEventType_vendorcredits_print_pdf:
			eventId=@"2089979387837";
			break;
		case APEventType_vendorcredits_submitForApproval:
			eventId=@"2089979387845";
			break;
		case APEventType_vendorcredits_update:
			eventId=@"2089979387849";
			break;
		case APEventType_vendorcredits_download_pdf:
			eventId=@"2089979387821";
			break;
		case APEventType_vendorcredits_mark_open:
			eventId=@"2089979387831";
			break;
		case APEventType_vendorcredits_save_payment:
			eventId=@"2089979387841";
			break;
		case APEventType_test1234_testphase:
			eventId=@"2092532233855";
			break;
		case APEventType_test_testphase:
			eventId=@"2085072955573";
			break;
		case APEventType_IN_APP_UPDATE_dismiss_install_alert:
			eventId=@"2089979387867";
			break;
		case APEventType_IN_APP_UPDATE_update_install_event:
			eventId=@"2089979387871";
			break;
		case APEventType_DetailsFragment_rename_notify_via_sms:
			eventId=@"2089979387905";
			break;
		case APEventType_DetailsFragment_rename_test:
			eventId=@"2103432686513";
			break;
		case APEventType_DetailsFragment_rename_get_contact_details_to_send_sms:
			eventId=@"2089979387901";
			break;
		case APEventType_DetailsFragment_rename_Renamedevents:
			eventId=@"2132945117861";
			break;
		case APEventType_DetailsFragment_rename_reject_transaction:
			eventId=@"2089979387909";
			break;
		case APEventType_ICICI_Vendor_Payments_add_vendor_bank_account:
			eventId=@"2089979387397";
			break;
		case APEventType_ICICI_Vendor_Payments_show_otp_dialog:
			eventId=@"2089979387399";
			break;
		case APEventType_ICICI_Vendor_Payments_vendor_payment:
			eventId=@"2089979387389";
			break;
		case APEventType_ICICI_Vendor_Payments_bill_payment:
			eventId=@"2089979387393";
			break;
		case APEventType_ICICI_Vendor_Payments_Failure:
			eventId=@"2089979387381";
			break;
		case APEventType_ICICI_Vendor_Payments_Success:
			eventId=@"2089979387385";
			break;
		case APEventType_ICICI_Vendor_Payments_otp_validation_failure:
			eventId=@"2089979387403";
			break;
		case APEventType_pretestgroup_pretestevent:
			eventId=@"2080773705279";
			break;
		case APEventType_pretestgroup_Pre_Test_Event:
			eventId=@"2070425425057";
			break;
		case APEventType_complaints_DON:
			eventId=@"2104093950203";
			break;
		case APEventType_bill_transaction_pdf_click:
			eventId=@"2089979387383";
			break;
		case APEventType_bill_country_code:
			eventId=@"2089979387409";
			break;
		case APEventType_bill_mobile_number_change:
			eventId=@"2089979387401";
			break;
		case APEventType_bill_share_click:
			eventId=@"2089979387405";
			break;
		case APEventType_bill_country_code_change:
			eventId=@"2089979387395";
			break;
		case APEventType_bill_menu_click:
			eventId=@"2089979387391";
			break;
		case APEventType_bill_transaction_link_click:
			eventId=@"2089979387387";
			break;
		case APEventType_TEST_RATE_US_GROUP_tt:
			eventId=@"2092530813791";
			break;
		case APEventType_TEST_RATE_US_GROUP_testEvent:
			eventId=@"2082870435169";
			break;
		case APEventType_TEST_RATE_US_GROUP_NEW_TEST_EVENT_FOR_RATE_US:
			eventId=@"2066883995575";
			break;
		case APEventType_j_applifecycle_ja_application_launched:
			eventId=@"2068511119033";
			break;
		case APEventType_j_applifecycle_ja_did_become_active:
			eventId=@"2070425425003";
			break;
		case APEventType_PRE_TEST_EVENT_B:
			eventId=@"2089778301319";
			break;
		case APEventType_PRE_TEST_EVENT_A:
			eventId=@"2089778301317";
			break;
		case APEventType_Group_A_Event_A:
			eventId=@"2089726594145";
			break;
		case APEventType_Group_A_Event_B:
			eventId=@"2089726594147";
			break;
		case APEventType_Group_A_Event_C:
			eventId=@"2089726594149";
			break;
		case APEventType_Group_A_Event_ZZ:
			eventId=@"2092899795007";
			break;
		case APEventType_texst5_Testevent:
			eventId=@"2102416636963";
			break;
		case APEventType_j_default_apptics_android_demo_event:
			eventId=@"2089621848204";
			break;
		case APEventType_j_default_TEST:
			eventId=@"2068207172008";
			break;
		case APEventType_j_default_this_is_an_demo_event:
			eventId=@"2089621848232";
			break;
		case APEventType_TESTGROUP_NEW_TEST_EVENT_FOR_RATE_US:
			eventId=@"2066883935317";
			break;
		case APEventType_TESTGROUP_TESTEVENT:
			eventId=@"2064750929005";
			break;
		case APEventType_PRE_GROUP_PRE_EVENT:
			eventId=@"2070425425077";
			break;
		case APEventType_Test_Group_Test_Event:
			eventId=@"2080773705283";
			break;
		case APEventType_test_group_ek_test_event_dho:
			eventId=@"2085415402309";
			break;
		case APEventType_Bills_mark_void:
			eventId=@"2089979448411";
			break;
		case APEventType_Bills_transaction_rejected:
			eventId=@"2089979448369";
			break;
		case APEventType_Bills_view_attachment:
			eventId=@"2089979448437";
			break;
		case APEventType_Bills_add_comment:
			eventId=@"2089979448389";
			break;
		case APEventType_Bills_mark_draft:
			eventId=@"2089979448405";
			break;
		case APEventType_Bills_print_pdf:
			eventId=@"2089979448417";
			break;
		case APEventType_Bills_update:
			eventId=@"2089979448433";
			break;
		case APEventType_Bills_create_payment:
			eventId=@"2089979448373";
			break;
		case APEventType_Bills_submitforapproval:
			eventId=@"2089979448429";
			break;
		case APEventType_Bills_print_pdf_from_buildin_option:
			eventId=@"2089979448385";
			break;
		case APEventType_Bills_save_attachment:
			eventId=@"2089979448421";
			break;
		case APEventType_Bills_SATHISH1234:
			eventId=@"2132945117865";
			break;
		case APEventType_Bills_TEst:
			eventId=@"2135925115883";
			break;
		case APEventType_Bills_approve:
			eventId=@"2089979448393";
			break;
		case APEventType_Bills_dfadsf:
			eventId=@"2132945117869";
			break;
		case APEventType_Bills_create:
			eventId=@"2089979448397";
			break;
		case APEventType_Bills_dfsfdsfdsfdsfdfdsfdsfsdfds:
			eventId=@"2132961833717";
			break;
		case APEventType_Bills_details:
			eventId=@"2089979448377";
			break;
		case APEventType_Bills_export_pdf:
			eventId=@"2089979448381";
			break;
		case APEventType_Bills_download_pdf:
			eventId=@"2089979448401";
			break;
		case APEventType_Bills_mark_open:
			eventId=@"2089979448409";
			break;
		case APEventType_Bills_save_payment:
			eventId=@"2089979448425";
			break;
		case APEventTypeNone:
			break;
		default:
			break;
	}
	return eventId;
}

+ (NSString*) groupID :(APEventType) type;{
	NSString *groupId;

	switch (type) {
		case APEventType_vendorcredits_mark_void:
			groupId=@"2089979387807";
			break;
		case APEventType_vendorcredits_approve:
			groupId=@"2089979387807";
			break;
		case APEventType_vendorcredits_add_comment:
			groupId=@"2089979387807";
			break;
		case APEventType_vendorcredits_create:
			groupId=@"2089979387807";
			break;
		case APEventType_vendorcredits_mark_draft:
			groupId=@"2089979387807";
			break;
		case APEventType_vendorcredits_print_pdf:
			groupId=@"2089979387807";
			break;
		case APEventType_vendorcredits_submitForApproval:
			groupId=@"2089979387807";
			break;
		case APEventType_vendorcredits_update:
			groupId=@"2089979387807";
			break;
		case APEventType_vendorcredits_download_pdf:
			groupId=@"2089979387807";
			break;
		case APEventType_vendorcredits_mark_open:
			groupId=@"2089979387807";
			break;
		case APEventType_vendorcredits_save_payment:
			groupId=@"2089979387807";
			break;
		case APEventType_test1234_testphase:
			groupId=@"2092532233853";
			break;
		case APEventType_test_testphase:
			groupId=@"2085072955483";
			break;
		case APEventType_IN_APP_UPDATE_dismiss_install_alert:
			groupId=@"2089979387863";
			break;
		case APEventType_IN_APP_UPDATE_update_install_event:
			groupId=@"2089979387863";
			break;
		case APEventType_DetailsFragment_rename_notify_via_sms:
			groupId=@"2089979387895";
			break;
		case APEventType_DetailsFragment_rename_test:
			groupId=@"2089979387895";
			break;
		case APEventType_DetailsFragment_rename_get_contact_details_to_send_sms:
			groupId=@"2089979387895";
			break;
		case APEventType_DetailsFragment_rename_Renamedevents:
			groupId=@"2089979387895";
			break;
		case APEventType_DetailsFragment_rename_reject_transaction:
			groupId=@"2089979387895";
			break;
		case APEventType_ICICI_Vendor_Payments_add_vendor_bank_account:
			groupId=@"2089979387377";
			break;
		case APEventType_ICICI_Vendor_Payments_show_otp_dialog:
			groupId=@"2089979387377";
			break;
		case APEventType_ICICI_Vendor_Payments_vendor_payment:
			groupId=@"2089979387377";
			break;
		case APEventType_ICICI_Vendor_Payments_bill_payment:
			groupId=@"2089979387377";
			break;
		case APEventType_ICICI_Vendor_Payments_Failure:
			groupId=@"2089979387377";
			break;
		case APEventType_ICICI_Vendor_Payments_Success:
			groupId=@"2089979387377";
			break;
		case APEventType_ICICI_Vendor_Payments_otp_validation_failure:
			groupId=@"2089979387377";
			break;
		case APEventType_pretestgroup_pretestevent:
			groupId=@"2070425425051";
			break;
		case APEventType_pretestgroup_Pre_Test_Event:
			groupId=@"2070425425051";
			break;
		case APEventType_complaints_DON:
			groupId=@"2064727740041";
			break;
		case APEventType_bill_transaction_pdf_click:
			groupId=@"2089979387379";
			break;
		case APEventType_bill_country_code:
			groupId=@"2089979387379";
			break;
		case APEventType_bill_mobile_number_change:
			groupId=@"2089979387379";
			break;
		case APEventType_bill_share_click:
			groupId=@"2089979387379";
			break;
		case APEventType_bill_country_code_change:
			groupId=@"2089979387379";
			break;
		case APEventType_bill_menu_click:
			groupId=@"2089979387379";
			break;
		case APEventType_bill_transaction_link_click:
			groupId=@"2089979387379";
			break;
		case APEventType_TEST_RATE_US_GROUP_tt:
			groupId=@"2066883977631";
			break;
		case APEventType_TEST_RATE_US_GROUP_testEvent:
			groupId=@"2066883977631";
			break;
		case APEventType_TEST_RATE_US_GROUP_NEW_TEST_EVENT_FOR_RATE_US:
			groupId=@"2066883977631";
			break;
		case APEventType_j_applifecycle_ja_application_launched:
			groupId=@"2068511119031";
			break;
		case APEventType_j_applifecycle_ja_did_become_active:
			groupId=@"2068511119031";
			break;
		case APEventType_PRE_TEST_EVENT_B:
			groupId=@"2089778301315";
			break;
		case APEventType_PRE_TEST_EVENT_A:
			groupId=@"2089778301315";
			break;
		case APEventType_Group_A_Event_A:
			groupId=@"2089726594143";
			break;
		case APEventType_Group_A_Event_B:
			groupId=@"2089726594143";
			break;
		case APEventType_Group_A_Event_C:
			groupId=@"2089726594143";
			break;
		case APEventType_Group_A_Event_ZZ:
			groupId=@"2089726594143";
			break;
		case APEventType_texst5_Testevent:
			groupId=@"2102416636961";
			break;
		case APEventType_j_default_apptics_android_demo_event:
			groupId=@"2066470065005";
			break;
		case APEventType_j_default_TEST:
			groupId=@"2066470065005";
			break;
		case APEventType_j_default_this_is_an_demo_event:
			groupId=@"2066470065005";
			break;
		case APEventType_TESTGROUP_NEW_TEST_EVENT_FOR_RATE_US:
			groupId=@"2064750929003";
			break;
		case APEventType_TESTGROUP_TESTEVENT:
			groupId=@"2064750929003";
			break;
		case APEventType_PRE_GROUP_PRE_EVENT:
			groupId=@"2070425425073";
			break;
		case APEventType_Test_Group_Test_Event:
			groupId=@"2080773705281";
			break;
		case APEventType_test_group_ek_test_event_dho:
			groupId=@"2085415402295";
			break;
		case APEventType_Bills_mark_void:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_transaction_rejected:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_view_attachment:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_add_comment:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_mark_draft:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_print_pdf:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_update:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_create_payment:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_submitforapproval:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_print_pdf_from_buildin_option:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_save_attachment:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_SATHISH1234:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_TEst:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_approve:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_dfadsf:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_create:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_dfsfdsfdsfdsfdfdsfdsfsdfds:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_details:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_export_pdf:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_download_pdf:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_mark_open:
			groupId=@"2089979448363";
			break;
		case APEventType_Bills_save_payment:
			groupId=@"2089979448363";
			break;
		case APEventTypeNone:
			break;
		default:
			break;
	}
	return groupId;
}

+ (void) trackEventWithType:(APEventType) type;{
	[self trackEventWithType:type andProperties:nil];
}

+ (void) trackEventWithType:(APEventType) type andProperties:(NSDictionary*_Nullable)props;{
	NSString *eventID = [self eventID:type];
	NSString *groupID = [self groupID:type];
	[[APEvent getInstance] trackEvent:eventID groupId : groupID andProperties:props isTimed:false];
}

+ (void) startTimedEventWithType:(APEventType) type;{
	[self startTimedEventWithType:type andProperties:nil];
}

+ (void) startTimedEventWithType:(APEventType) type andProperties:(NSDictionary * _Nullable)props;{
	NSString *eventID = [self eventID:type];
	NSString *groupID = [self groupID:type];
	[[APEvent getInstance] trackEvent:eventID groupId : groupID andProperties:props isTimed:true];
}

+ (void) endTimedEventWithType:(APEventType) type;{
	NSString *eventID = [self eventID:type];
	[[APEvent getInstance] endTimedEvent:eventID];
}

@end

@implementation APEventExtension : NSObject

+ (APPrivateObject *)formatTypeToPrivateObject:(NSString*)group event : (NSString*) event {

	NSString* event_str=[[NSString stringWithFormat:@"%@_%@",group, event] lowercaseString];

	if ([event_str isEqualToString:@"vendorcredits_mark_void"]){
		return [[APPrivateObject alloc] initWith:@"2089979387833" andGroupId:@"2089979387807"];
	}else if ([event_str isEqualToString:@"vendorcredits_approve"]){
		return [[APPrivateObject alloc] initWith:@"2089979387815" andGroupId:@"2089979387807"];
	}else if ([event_str isEqualToString:@"vendorcredits_add_comment"]){
		return [[APPrivateObject alloc] initWith:@"2089979387811" andGroupId:@"2089979387807"];
	}else if ([event_str isEqualToString:@"vendorcredits_create"]){
		return [[APPrivateObject alloc] initWith:@"2089979387817" andGroupId:@"2089979387807"];
	}else if ([event_str isEqualToString:@"vendorcredits_mark_draft"]){
		return [[APPrivateObject alloc] initWith:@"2089979387827" andGroupId:@"2089979387807"];
	}else if ([event_str isEqualToString:@"vendorcredits_print_pdf"]){
		return [[APPrivateObject alloc] initWith:@"2089979387837" andGroupId:@"2089979387807"];
	}else if ([event_str isEqualToString:@"vendorcredits_submitforapproval"]){
		return [[APPrivateObject alloc] initWith:@"2089979387845" andGroupId:@"2089979387807"];
	}else if ([event_str isEqualToString:@"vendorcredits_update"]){
		return [[APPrivateObject alloc] initWith:@"2089979387849" andGroupId:@"2089979387807"];
	}else if ([event_str isEqualToString:@"vendorcredits_download_pdf"]){
		return [[APPrivateObject alloc] initWith:@"2089979387821" andGroupId:@"2089979387807"];
	}else if ([event_str isEqualToString:@"vendorcredits_mark_open"]){
		return [[APPrivateObject alloc] initWith:@"2089979387831" andGroupId:@"2089979387807"];
	}else if ([event_str isEqualToString:@"vendorcredits_save_payment"]){
		return [[APPrivateObject alloc] initWith:@"2089979387841" andGroupId:@"2089979387807"];
	}else if ([event_str isEqualToString:@"test1234_testphase"]){
		return [[APPrivateObject alloc] initWith:@"2092532233855" andGroupId:@"2092532233853"];
	}else if ([event_str isEqualToString:@"test_testphase"]){
		return [[APPrivateObject alloc] initWith:@"2085072955573" andGroupId:@"2085072955483"];
	}else if ([event_str isEqualToString:@"in_app_update_dismiss_install_alert"]){
		return [[APPrivateObject alloc] initWith:@"2089979387867" andGroupId:@"2089979387863"];
	}else if ([event_str isEqualToString:@"in_app_update_update_install_event"]){
		return [[APPrivateObject alloc] initWith:@"2089979387871" andGroupId:@"2089979387863"];
	}else if ([event_str isEqualToString:@"detailsfragment_rename_notify_via_sms"]){
		return [[APPrivateObject alloc] initWith:@"2089979387905" andGroupId:@"2089979387895"];
	}else if ([event_str isEqualToString:@"detailsfragment_rename_test"]){
		return [[APPrivateObject alloc] initWith:@"2103432686513" andGroupId:@"2089979387895"];
	}else if ([event_str isEqualToString:@"detailsfragment_rename_get_contact_details_to_send_sms"]){
		return [[APPrivateObject alloc] initWith:@"2089979387901" andGroupId:@"2089979387895"];
	}else if ([event_str isEqualToString:@"detailsfragment_rename_renamedevents"]){
		return [[APPrivateObject alloc] initWith:@"2132945117861" andGroupId:@"2089979387895"];
	}else if ([event_str isEqualToString:@"detailsfragment_rename_reject_transaction"]){
		return [[APPrivateObject alloc] initWith:@"2089979387909" andGroupId:@"2089979387895"];
	}else if ([event_str isEqualToString:@"icici_vendor_payments_add_vendor_bank_account"]){
		return [[APPrivateObject alloc] initWith:@"2089979387397" andGroupId:@"2089979387377"];
	}else if ([event_str isEqualToString:@"icici_vendor_payments_show_otp_dialog"]){
		return [[APPrivateObject alloc] initWith:@"2089979387399" andGroupId:@"2089979387377"];
	}else if ([event_str isEqualToString:@"icici_vendor_payments_vendor_payment"]){
		return [[APPrivateObject alloc] initWith:@"2089979387389" andGroupId:@"2089979387377"];
	}else if ([event_str isEqualToString:@"icici_vendor_payments_bill_payment"]){
		return [[APPrivateObject alloc] initWith:@"2089979387393" andGroupId:@"2089979387377"];
	}else if ([event_str isEqualToString:@"icici_vendor_payments_failure"]){
		return [[APPrivateObject alloc] initWith:@"2089979387381" andGroupId:@"2089979387377"];
	}else if ([event_str isEqualToString:@"icici_vendor_payments_success"]){
		return [[APPrivateObject alloc] initWith:@"2089979387385" andGroupId:@"2089979387377"];
	}else if ([event_str isEqualToString:@"icici_vendor_payments_otp_validation_failure"]){
		return [[APPrivateObject alloc] initWith:@"2089979387403" andGroupId:@"2089979387377"];
	}else if ([event_str isEqualToString:@"pretestgroup_pretestevent"]){
		return [[APPrivateObject alloc] initWith:@"2080773705279" andGroupId:@"2070425425051"];
	}else if ([event_str isEqualToString:@"pretestgroup_pre_test_event"]){
		return [[APPrivateObject alloc] initWith:@"2070425425057" andGroupId:@"2070425425051"];
	}else if ([event_str isEqualToString:@"complaints_don"]){
		return [[APPrivateObject alloc] initWith:@"2104093950203" andGroupId:@"2064727740041"];
	}else if ([event_str isEqualToString:@"bill_transaction_pdf_click"]){
		return [[APPrivateObject alloc] initWith:@"2089979387383" andGroupId:@"2089979387379"];
	}else if ([event_str isEqualToString:@"bill_country_code"]){
		return [[APPrivateObject alloc] initWith:@"2089979387409" andGroupId:@"2089979387379"];
	}else if ([event_str isEqualToString:@"bill_mobile_number_change"]){
		return [[APPrivateObject alloc] initWith:@"2089979387401" andGroupId:@"2089979387379"];
	}else if ([event_str isEqualToString:@"bill_share_click"]){
		return [[APPrivateObject alloc] initWith:@"2089979387405" andGroupId:@"2089979387379"];
	}else if ([event_str isEqualToString:@"bill_country_code_change"]){
		return [[APPrivateObject alloc] initWith:@"2089979387395" andGroupId:@"2089979387379"];
	}else if ([event_str isEqualToString:@"bill_menu_click"]){
		return [[APPrivateObject alloc] initWith:@"2089979387391" andGroupId:@"2089979387379"];
	}else if ([event_str isEqualToString:@"bill_transaction_link_click"]){
		return [[APPrivateObject alloc] initWith:@"2089979387387" andGroupId:@"2089979387379"];
	}else if ([event_str isEqualToString:@"test_rate_us_group_tt"]){
		return [[APPrivateObject alloc] initWith:@"2092530813791" andGroupId:@"2066883977631"];
	}else if ([event_str isEqualToString:@"test_rate_us_group_testevent"]){
		return [[APPrivateObject alloc] initWith:@"2082870435169" andGroupId:@"2066883977631"];
	}else if ([event_str isEqualToString:@"test_rate_us_group_new_test_event_for_rate_us"]){
		return [[APPrivateObject alloc] initWith:@"2066883995575" andGroupId:@"2066883977631"];
	}else if ([event_str isEqualToString:@"j_applifecycle_ja_application_launched"]){
		return [[APPrivateObject alloc] initWith:@"2068511119033" andGroupId:@"2068511119031"];
	}else if ([event_str isEqualToString:@"j_applifecycle_ja_did_become_active"]){
		return [[APPrivateObject alloc] initWith:@"2070425425003" andGroupId:@"2068511119031"];
	}else if ([event_str isEqualToString:@"pre_test_event_b"]){
		return [[APPrivateObject alloc] initWith:@"2089778301319" andGroupId:@"2089778301315"];
	}else if ([event_str isEqualToString:@"pre_test_event_a"]){
		return [[APPrivateObject alloc] initWith:@"2089778301317" andGroupId:@"2089778301315"];
	}else if ([event_str isEqualToString:@"group_a_event_a"]){
		return [[APPrivateObject alloc] initWith:@"2089726594145" andGroupId:@"2089726594143"];
	}else if ([event_str isEqualToString:@"group_a_event_b"]){
		return [[APPrivateObject alloc] initWith:@"2089726594147" andGroupId:@"2089726594143"];
	}else if ([event_str isEqualToString:@"group_a_event_c"]){
		return [[APPrivateObject alloc] initWith:@"2089726594149" andGroupId:@"2089726594143"];
	}else if ([event_str isEqualToString:@"group_a_event_zz"]){
		return [[APPrivateObject alloc] initWith:@"2092899795007" andGroupId:@"2089726594143"];
	}else if ([event_str isEqualToString:@"texst5_testevent"]){
		return [[APPrivateObject alloc] initWith:@"2102416636963" andGroupId:@"2102416636961"];
	}else if ([event_str isEqualToString:@"j_default_apptics_android_demo_event"]){
		return [[APPrivateObject alloc] initWith:@"2089621848204" andGroupId:@"2066470065005"];
	}else if ([event_str isEqualToString:@"j_default_test"]){
		return [[APPrivateObject alloc] initWith:@"2068207172008" andGroupId:@"2066470065005"];
	}else if ([event_str isEqualToString:@"j_default_this_is_an_demo_event"]){
		return [[APPrivateObject alloc] initWith:@"2089621848232" andGroupId:@"2066470065005"];
	}else if ([event_str isEqualToString:@"testgroup_new_test_event_for_rate_us"]){
		return [[APPrivateObject alloc] initWith:@"2066883935317" andGroupId:@"2064750929003"];
	}else if ([event_str isEqualToString:@"testgroup_testevent"]){
		return [[APPrivateObject alloc] initWith:@"2064750929005" andGroupId:@"2064750929003"];
	}else if ([event_str isEqualToString:@"pre_group_pre_event"]){
		return [[APPrivateObject alloc] initWith:@"2070425425077" andGroupId:@"2070425425073"];
	}else if ([event_str isEqualToString:@"test_group_test_event"]){
		return [[APPrivateObject alloc] initWith:@"2080773705283" andGroupId:@"2080773705281"];
	}else if ([event_str isEqualToString:@"test_group_ek_test_event_dho"]){
		return [[APPrivateObject alloc] initWith:@"2085415402309" andGroupId:@"2085415402295"];
	}else if ([event_str isEqualToString:@"bills_mark_void"]){
		return [[APPrivateObject alloc] initWith:@"2089979448411" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_transaction_rejected"]){
		return [[APPrivateObject alloc] initWith:@"2089979448369" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_view_attachment"]){
		return [[APPrivateObject alloc] initWith:@"2089979448437" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_add_comment"]){
		return [[APPrivateObject alloc] initWith:@"2089979448389" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_mark_draft"]){
		return [[APPrivateObject alloc] initWith:@"2089979448405" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_print_pdf"]){
		return [[APPrivateObject alloc] initWith:@"2089979448417" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_update"]){
		return [[APPrivateObject alloc] initWith:@"2089979448433" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_create_payment"]){
		return [[APPrivateObject alloc] initWith:@"2089979448373" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_submitforapproval"]){
		return [[APPrivateObject alloc] initWith:@"2089979448429" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_print_pdf_from_buildin_option"]){
		return [[APPrivateObject alloc] initWith:@"2089979448385" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_save_attachment"]){
		return [[APPrivateObject alloc] initWith:@"2089979448421" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_sathish1234"]){
		return [[APPrivateObject alloc] initWith:@"2132945117865" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_test"]){
		return [[APPrivateObject alloc] initWith:@"2135925115883" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_approve"]){
		return [[APPrivateObject alloc] initWith:@"2089979448393" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_dfadsf"]){
		return [[APPrivateObject alloc] initWith:@"2132945117869" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_create"]){
		return [[APPrivateObject alloc] initWith:@"2089979448397" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_dfsfdsfdsfdsfdfdsfdsfsdfds"]){
		return [[APPrivateObject alloc] initWith:@"2132961833717" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_details"]){
		return [[APPrivateObject alloc] initWith:@"2089979448377" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_export_pdf"]){
		return [[APPrivateObject alloc] initWith:@"2089979448381" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_download_pdf"]){
		return [[APPrivateObject alloc] initWith:@"2089979448401" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_mark_open"]){
		return [[APPrivateObject alloc] initWith:@"2089979448409" andGroupId:@"2089979448363"];
	}else if ([event_str isEqualToString:@"bills_save_payment"]){
		return [[APPrivateObject alloc] initWith:@"2089979448425" andGroupId:@"2089979448363"];
	}else 	{
	return nil;
	}
}

+ (APPrivateObject *)formatTypeToPrivateObjectFromEventId:(NSString*)eventId{

	if ([eventId isEqualToString:@"2089979387833"]){
		return [[APPrivateObject alloc] initWith:@"vendorcredits" event:@"mark_void"];
	}else if ([eventId isEqualToString:@"2089979387815"]){
		return [[APPrivateObject alloc] initWith:@"vendorcredits" event:@"approve"];
	}else if ([eventId isEqualToString:@"2089979387811"]){
		return [[APPrivateObject alloc] initWith:@"vendorcredits" event:@"add_comment"];
	}else if ([eventId isEqualToString:@"2089979387817"]){
		return [[APPrivateObject alloc] initWith:@"vendorcredits" event:@"create"];
	}else if ([eventId isEqualToString:@"2089979387827"]){
		return [[APPrivateObject alloc] initWith:@"vendorcredits" event:@"mark_draft"];
	}else if ([eventId isEqualToString:@"2089979387837"]){
		return [[APPrivateObject alloc] initWith:@"vendorcredits" event:@"print_pdf"];
	}else if ([eventId isEqualToString:@"2089979387845"]){
		return [[APPrivateObject alloc] initWith:@"vendorcredits" event:@"submitForApproval"];
	}else if ([eventId isEqualToString:@"2089979387849"]){
		return [[APPrivateObject alloc] initWith:@"vendorcredits" event:@"update"];
	}else if ([eventId isEqualToString:@"2089979387821"]){
		return [[APPrivateObject alloc] initWith:@"vendorcredits" event:@"download_pdf"];
	}else if ([eventId isEqualToString:@"2089979387831"]){
		return [[APPrivateObject alloc] initWith:@"vendorcredits" event:@"mark_open"];
	}else if ([eventId isEqualToString:@"2089979387841"]){
		return [[APPrivateObject alloc] initWith:@"vendorcredits" event:@"save_payment"];
	}else if ([eventId isEqualToString:@"2092532233855"]){
		return [[APPrivateObject alloc] initWith:@"test1234" event:@"testphase"];
	}else if ([eventId isEqualToString:@"2085072955573"]){
		return [[APPrivateObject alloc] initWith:@"test" event:@"testphase"];
	}else if ([eventId isEqualToString:@"2089979387867"]){
		return [[APPrivateObject alloc] initWith:@"IN_APP_UPDATE" event:@"dismiss_install_alert"];
	}else if ([eventId isEqualToString:@"2089979387871"]){
		return [[APPrivateObject alloc] initWith:@"IN_APP_UPDATE" event:@"update_install_event"];
	}else if ([eventId isEqualToString:@"2089979387905"]){
		return [[APPrivateObject alloc] initWith:@"DetailsFragment_rename" event:@"notify_via_sms"];
	}else if ([eventId isEqualToString:@"2103432686513"]){
		return [[APPrivateObject alloc] initWith:@"DetailsFragment_rename" event:@"test"];
	}else if ([eventId isEqualToString:@"2089979387901"]){
		return [[APPrivateObject alloc] initWith:@"DetailsFragment_rename" event:@"get_contact_details_to_send_sms"];
	}else if ([eventId isEqualToString:@"2132945117861"]){
		return [[APPrivateObject alloc] initWith:@"DetailsFragment_rename" event:@"Renamedevents"];
	}else if ([eventId isEqualToString:@"2089979387909"]){
		return [[APPrivateObject alloc] initWith:@"DetailsFragment_rename" event:@"reject_transaction"];
	}else if ([eventId isEqualToString:@"2089979387397"]){
		return [[APPrivateObject alloc] initWith:@"ICICI_Vendor_Payments" event:@"add_vendor_bank_account"];
	}else if ([eventId isEqualToString:@"2089979387399"]){
		return [[APPrivateObject alloc] initWith:@"ICICI_Vendor_Payments" event:@"show_otp_dialog"];
	}else if ([eventId isEqualToString:@"2089979387389"]){
		return [[APPrivateObject alloc] initWith:@"ICICI_Vendor_Payments" event:@"vendor_payment"];
	}else if ([eventId isEqualToString:@"2089979387393"]){
		return [[APPrivateObject alloc] initWith:@"ICICI_Vendor_Payments" event:@"bill_payment"];
	}else if ([eventId isEqualToString:@"2089979387381"]){
		return [[APPrivateObject alloc] initWith:@"ICICI_Vendor_Payments" event:@"Failure"];
	}else if ([eventId isEqualToString:@"2089979387385"]){
		return [[APPrivateObject alloc] initWith:@"ICICI_Vendor_Payments" event:@"Success"];
	}else if ([eventId isEqualToString:@"2089979387403"]){
		return [[APPrivateObject alloc] initWith:@"ICICI_Vendor_Payments" event:@"otp_validation_failure"];
	}else if ([eventId isEqualToString:@"2080773705279"]){
		return [[APPrivateObject alloc] initWith:@"pretestgroup" event:@"pretestevent"];
	}else if ([eventId isEqualToString:@"2070425425057"]){
		return [[APPrivateObject alloc] initWith:@"pretestgroup" event:@"Pre_Test_Event"];
	}else if ([eventId isEqualToString:@"2104093950203"]){
		return [[APPrivateObject alloc] initWith:@"complaints" event:@"DON"];
	}else if ([eventId isEqualToString:@"2089979387383"]){
		return [[APPrivateObject alloc] initWith:@"bill" event:@"transaction_pdf_click"];
	}else if ([eventId isEqualToString:@"2089979387409"]){
		return [[APPrivateObject alloc] initWith:@"bill" event:@"country_code"];
	}else if ([eventId isEqualToString:@"2089979387401"]){
		return [[APPrivateObject alloc] initWith:@"bill" event:@"mobile_number_change"];
	}else if ([eventId isEqualToString:@"2089979387405"]){
		return [[APPrivateObject alloc] initWith:@"bill" event:@"share_click"];
	}else if ([eventId isEqualToString:@"2089979387395"]){
		return [[APPrivateObject alloc] initWith:@"bill" event:@"country_code_change"];
	}else if ([eventId isEqualToString:@"2089979387391"]){
		return [[APPrivateObject alloc] initWith:@"bill" event:@"menu_click"];
	}else if ([eventId isEqualToString:@"2089979387387"]){
		return [[APPrivateObject alloc] initWith:@"bill" event:@"transaction_link_click"];
	}else if ([eventId isEqualToString:@"2092530813791"]){
		return [[APPrivateObject alloc] initWith:@"TEST_RATE_US_GROUP" event:@"tt"];
	}else if ([eventId isEqualToString:@"2082870435169"]){
		return [[APPrivateObject alloc] initWith:@"TEST_RATE_US_GROUP" event:@"testEvent"];
	}else if ([eventId isEqualToString:@"2066883995575"]){
		return [[APPrivateObject alloc] initWith:@"TEST_RATE_US_GROUP" event:@"NEW_TEST_EVENT_FOR_RATE_US"];
	}else if ([eventId isEqualToString:@"2068511119033"]){
		return [[APPrivateObject alloc] initWith:@"j_applifecycle" event:@"ja_application_launched"];
	}else if ([eventId isEqualToString:@"2070425425003"]){
		return [[APPrivateObject alloc] initWith:@"j_applifecycle" event:@"ja_did_become_active"];
	}else if ([eventId isEqualToString:@"2089778301319"]){
		return [[APPrivateObject alloc] initWith:@"PRE_TEST" event:@"EVENT_B"];
	}else if ([eventId isEqualToString:@"2089778301317"]){
		return [[APPrivateObject alloc] initWith:@"PRE_TEST" event:@"EVENT_A"];
	}else if ([eventId isEqualToString:@"2089726594145"]){
		return [[APPrivateObject alloc] initWith:@"Group_A" event:@"Event_A"];
	}else if ([eventId isEqualToString:@"2089726594147"]){
		return [[APPrivateObject alloc] initWith:@"Group_A" event:@"Event_B"];
	}else if ([eventId isEqualToString:@"2089726594149"]){
		return [[APPrivateObject alloc] initWith:@"Group_A" event:@"Event_C"];
	}else if ([eventId isEqualToString:@"2092899795007"]){
		return [[APPrivateObject alloc] initWith:@"Group_A" event:@"Event_ZZ"];
	}else if ([eventId isEqualToString:@"2102416636963"]){
		return [[APPrivateObject alloc] initWith:@"texst5" event:@"Testevent"];
	}else if ([eventId isEqualToString:@"2089621848204"]){
		return [[APPrivateObject alloc] initWith:@"j_default" event:@"apptics_android_demo_event"];
	}else if ([eventId isEqualToString:@"2068207172008"]){
		return [[APPrivateObject alloc] initWith:@"j_default" event:@"TEST"];
	}else if ([eventId isEqualToString:@"2089621848232"]){
		return [[APPrivateObject alloc] initWith:@"j_default" event:@"this_is_an_demo_event"];
	}else if ([eventId isEqualToString:@"2066883935317"]){
		return [[APPrivateObject alloc] initWith:@"TESTGROUP" event:@"NEW_TEST_EVENT_FOR_RATE_US"];
	}else if ([eventId isEqualToString:@"2064750929005"]){
		return [[APPrivateObject alloc] initWith:@"TESTGROUP" event:@"TESTEVENT"];
	}else if ([eventId isEqualToString:@"2070425425077"]){
		return [[APPrivateObject alloc] initWith:@"PRE_GROUP" event:@"PRE_EVENT"];
	}else if ([eventId isEqualToString:@"2080773705283"]){
		return [[APPrivateObject alloc] initWith:@"Test_Group" event:@"Test_Event"];
	}else if ([eventId isEqualToString:@"2085415402309"]){
		return [[APPrivateObject alloc] initWith:@"test_group_ek" event:@"test_event_dho"];
	}else if ([eventId isEqualToString:@"2089979448411"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"mark_void"];
	}else if ([eventId isEqualToString:@"2089979448369"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"transaction_rejected"];
	}else if ([eventId isEqualToString:@"2089979448437"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"view_attachment"];
	}else if ([eventId isEqualToString:@"2089979448389"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"add_comment"];
	}else if ([eventId isEqualToString:@"2089979448405"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"mark_draft"];
	}else if ([eventId isEqualToString:@"2089979448417"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"print_pdf"];
	}else if ([eventId isEqualToString:@"2089979448433"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"update"];
	}else if ([eventId isEqualToString:@"2089979448373"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"create_payment"];
	}else if ([eventId isEqualToString:@"2089979448429"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"submitforapproval"];
	}else if ([eventId isEqualToString:@"2089979448385"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"print_pdf_from_buildin_option"];
	}else if ([eventId isEqualToString:@"2089979448421"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"save_attachment"];
	}else if ([eventId isEqualToString:@"2132945117865"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"SATHISH1234"];
	}else if ([eventId isEqualToString:@"2135925115883"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"TEst"];
	}else if ([eventId isEqualToString:@"2089979448393"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"approve"];
	}else if ([eventId isEqualToString:@"2132945117869"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"dfadsf"];
	}else if ([eventId isEqualToString:@"2089979448397"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"create"];
	}else if ([eventId isEqualToString:@"2132961833717"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"dfsfdsfdsfdsfdfdsfdsfsdfds"];
	}else if ([eventId isEqualToString:@"2089979448377"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"details"];
	}else if ([eventId isEqualToString:@"2089979448381"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"export_pdf"];
	}else if ([eventId isEqualToString:@"2089979448401"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"download_pdf"];
	}else if ([eventId isEqualToString:@"2089979448409"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"mark_open"];
	}else if ([eventId isEqualToString:@"2089979448425"]){
		return [[APPrivateObject alloc] initWith:@"Bills" event:@"save_payment"];
	}else 	{
	return nil;
	}
}

@end

@implementation APAPAPIExtension : NSObject

+(BOOL) isMatchString : (NSString* ) source withString : (NSString*) pattern{
	NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
	long n = [regex numberOfMatchesInString:source options:0 range:NSMakeRange(0, [source length])];
	return  (n > 0);
}

+(NSString*) directMatch : (NSString*) url{

	if ([url isEqualToString:@"http://notebook.zoho.com/ui/search?param1=windows"]){
		return @"2077491134897";
	}else if ([url isEqualToString:@"https://www.google.com/maps/"]){
		return @"2079961640855";
	}else if ([url isEqualToString:@"https://notebook.zoho.com/search?param1=testParam"]){
		return @"2079961640905";
	}else if ([url isEqualToString:@"http://fdj.com"]){
		return @"2085330724487";
	}else if ([url isEqualToString:@"https://jsonplaceholder.typicode.com/todos/1"]){
		return @"2087903231799";
	}else if ([url isEqualToString:@"https://jproxy.zoho.com/api/janalytic/v3/addevents"]){
		return @"2087903231825";
	}else if ([url isEqualToString:@"https://jproxy.zoho.com/api/janalytic/v3/addscreens?identifier=com.zoho.zanalyticsapp"]){
		return @"2088206072929";
	}else if ([url isEqualToString:@"https://jproxy.zoho.com/api/janalytic/v3/addscreens"]){
		return @"2088214272449";
	}else if ([url isEqualToString:@"https://apptics.zoho.com/ac/660807468/2000017429321/api/1/2"]){
		return @"2102060815571";
	}else if ([url isEqualToString:@"https://preapptics.zoho.com/ac/660807468/2000017429321/1/api/9"]){
		return @"2102416239581";
	}else if ([url isEqualToString:@"https://preapptics.zoho.com/ac/660807468/2000017429321/1/api/10"]){
		return @"2102416239585";
	}else if ([url isEqualToString:@"https://preapptics.zoho.com/ac/660807468/2000017429321/1/api/9?param=value"]){
		return @"2102416239589";
	}else if ([url isEqualToString:@"https://preapptics.zoho.com/ac/660807468/2000017429321/1/api/9?Param=value"]){
		return @"2102416341527";
	}else if ([url isEqualToString:@"https://apptics.zoho.com/ac?param=value1"]){
		return @"2125132031739";
	}else if ([url isEqualToString:@"https://apptics.zoho.com/ac?param=value2"]){
		return @"2125132101077";
	}else if ([url isEqualToString:@"https://test.com/testapi"]){
		return @"2128537170283";
	}else if ([url isEqualToString:@"https://apptics.zoho.com/ac/660807468/2000017429321/1/api/2"]){
		return @"2128551619179";
	}else if ([url isEqualToString:@"https://template.com/test31"]){
		return @"2128921646819";
	}else if ([url isEqualToString:@"https://template.com/test33"]){
		return @"2128921831835";
	}else if ([url isEqualToString:@"https://template.com/test34"]){
		return @"2128922358970";
	}else if ([url isEqualToString:@"https://template.com/test35"]){
		return @"2128922696996";
	}else if ([url isEqualToString:@"https://template.com/test36"]){
		return @"2128922977558";
	}else if ([url isEqualToString:@"https://apptics.localzoho.com/ac/56513647/51000000002015/1/api/2"]){
		return @"2128949315251";
	}else if ([url isEqualToString:@"https://apptics.localzoho.com/ac/56513647/51000000002015/1/api/1"]){
		return @"2129518180443";
	}else if ([url isEqualToString:@"http://numbersapi.com/random/math"]){
		return @"2138768520939";
	}else if ([url isEqualToString:@"https://list.ly/api/v4/meta?url=http://www.zoho.com"]){
		return @"2138768572991";
	}else if ([url isEqualToString:@"https://ip-fast.com/api/ip/"]){
		return @"2138769408909";
	}else 	{
		return nil;
	}

}

+(NSString*) patternMatch : (NSString*) url{

	if ([self isMatchString:url withString:@"https://notebook.zoho.com/ui/[a-z]+/[0-9]+/search"]){
		return @"2077262005812";
	}else if ([self isMatchString:url withString:@"https://jproxy.zoho.com/api/janalytic/v3/[a-z]+"]){
		return @"2088206072777";
	}else if ([self isMatchString:url withString:@"https://apptics.zoho.com/api/janalytic/v3/[a-z]+"]){
		return @"2089597534687";
	}else if ([self isMatchString:url withString:@"https://www.google.com/[a-z]+"]){
		return @"2102273666655";
	}else if ([self isMatchString:url withString:@"https://preapptics.zoho.com/ac/660807468/2000017429321/1/[a-z]+/9"]){
		return @"2102416341523";
	}else if ([self isMatchString:url withString:@"https://lens.zoho.com/api/v2/session/schedule/[0-9]+"]){
		return @"2119368842917";
	}else if ([self isMatchString:url withString:@"http(s)?://.*[/]api[/]json[/]alarm[/]listAlarms"]){
		return @"2133883604831";
	}else if ([self isMatchString:url withString:@"http(s)?://.*[\/]api[\/]json[\/]alarm[\/]listAlarms"]){
		return @"2133883690441";
	}else if ([self isMatchString:url withString:@"https://www.7timer.info/bin/astro.php"]){
		return @"2138769174953";
	}else if ([self isMatchString:url withString:@"https://[a-z]+.com"]){
		return @"2138777091721";
	}else 	{
		return nil;
	}

}

@end
