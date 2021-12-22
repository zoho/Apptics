#if canImport(Apptics)
	import Apptics
#endif

#if canImport(AppticsEventTracker)
	import AppticsEventTracker
#endif

@objc public enum APEventType : Int {
    case _vendorcredits_mark_void
    case _vendorcredits_approve
    case _vendorcredits_add_comment
    case _vendorcredits_create
    case _vendorcredits_mark_draft
    case _vendorcredits_print_pdf
    case _vendorcredits_submitForApproval
    case _vendorcredits_update
    case _vendorcredits_download_pdf
    case _vendorcredits_mark_open
    case _vendorcredits_save_payment
    case _test1234_testphase
    case _test_testphase
    case _IN_APP_UPDATE_dismiss_install_alert
    case _IN_APP_UPDATE_update_install_event
    case _ICICI_Vendor_Payments_add_vendor_bank_account
    case _ICICI_Vendor_Payments_show_otp_dialog
    case _ICICI_Vendor_Payments_vendor_payment
    case _ICICI_Vendor_Payments_bill_payment
    case _ICICI_Vendor_Payments_Failure
    case _ICICI_Vendor_Payments_Success
    case _ICICI_Vendor_Payments_otp_validation_failure
    case _pretestgroup_pretestevent
    case _pretestgroup_Pre_Test_Event
    case _complaints_DON
    case _bill_transaction_pdf_click
    case _bill_country_code
    case _bill_mobile_number_change
    case _bill_share_click
    case _bill_country_code_change
    case _bill_menu_click
    case _bill_transaction_link_click
    case _DetailsFragment_notify_via_sms
    case _DetailsFragment_dafdfdsfds
    case _DetailsFragment_test
    case _DetailsFragment_get_contact_details_to_send_sms
    case _DetailsFragment_reject_transaction
    case _TEST_RATE_US_GROUP_tt
    case _TEST_RATE_US_GROUP_testEvent
    case _TEST_RATE_US_GROUP_NEW_TEST_EVENT_FOR_RATE_US
    case _j_applifecycle_ja_application_launched
    case _j_applifecycle_ja_did_become_active
    case _PRE_TEST_EVENT_B
    case _PRE_TEST_EVENT_A
    case _Group_A_Event_A
    case _Group_A_Event_B
    case _Group_A_Event_C
    case _Group_A_Event_ZZ
    case _texst5_Testevent
    case _j_default_apptics_android_demo_event
    case _j_default_TEST
    case _j_default_this_is_an_demo_event
    case _TESTGROUP_NEW_TEST_EVENT_FOR_RATE_US
    case _TESTGROUP_TESTEVENT
    case _PRE_GROUP_PRE_EVENT
    case _Test_Group_Test_Event
    case _test_group_ek_test_event_dho
    case _Bills_mark_void
    case _Bills_transaction_rejected
    case _Bills_view_attachment
    case _Bills_add_comment
    case _Bills_mark_draft
    case _Bills_print_pdf
    case _Bills_update
    case _Bills_create_payment
    case _Bills_submitforapproval
    case _Bills_print_pdf_from_buildin_option
    case _Bills_save_attachment
    case _Bills_SATHISH1234
    case _Bills_TEst
    case _Bills_approve
    case _Bills_dfadsf
    case _Bills_create
    case _Bills_dfsfdsfdsfdsfdfdsfdsfsdfds
    case _Bills_details
    case _Bills_export_pdf
    case _Bills_download_pdf
    case _Bills_mark_open
    case _Bills_save_payment
		case None
}

extension Apptics
{
	@objc class func setCustomEventsProtocol() {
		APBundle.getInstance()?.eventsProtocolClass=APEventExtension.self
	}

	@objc class func setApiTrackingProtocol() {
		APBundle.getInstance()?.apiProtocolClass=APAPAPIExtension.self
	}

}

extension APEvent
{

	@objc class func eventID(forType type : APEventType) -> String?{

		var eventID : String?
		switch (type) {
		case ._vendorcredits_mark_void:
			eventID="2089979387833"
			break
		case ._vendorcredits_approve:
			eventID="2089979387815"
			break
		case ._vendorcredits_add_comment:
			eventID="2089979387811"
			break
		case ._vendorcredits_create:
			eventID="2089979387817"
			break
		case ._vendorcredits_mark_draft:
			eventID="2089979387827"
			break
		case ._vendorcredits_print_pdf:
			eventID="2089979387837"
			break
		case ._vendorcredits_submitForApproval:
			eventID="2089979387845"
			break
		case ._vendorcredits_update:
			eventID="2089979387849"
			break
		case ._vendorcredits_download_pdf:
			eventID="2089979387821"
			break
		case ._vendorcredits_mark_open:
			eventID="2089979387831"
			break
		case ._vendorcredits_save_payment:
			eventID="2089979387841"
			break
		case ._test1234_testphase:
			eventID="2092532233855"
			break
		case ._test_testphase:
			eventID="2085072955573"
			break
		case ._IN_APP_UPDATE_dismiss_install_alert:
			eventID="2089979387867"
			break
		case ._IN_APP_UPDATE_update_install_event:
			eventID="2089979387871"
			break
		case ._ICICI_Vendor_Payments_add_vendor_bank_account:
			eventID="2089979387397"
			break
		case ._ICICI_Vendor_Payments_show_otp_dialog:
			eventID="2089979387399"
			break
		case ._ICICI_Vendor_Payments_vendor_payment:
			eventID="2089979387389"
			break
		case ._ICICI_Vendor_Payments_bill_payment:
			eventID="2089979387393"
			break
		case ._ICICI_Vendor_Payments_Failure:
			eventID="2089979387381"
			break
		case ._ICICI_Vendor_Payments_Success:
			eventID="2089979387385"
			break
		case ._ICICI_Vendor_Payments_otp_validation_failure:
			eventID="2089979387403"
			break
		case ._pretestgroup_pretestevent:
			eventID="2080773705279"
			break
		case ._pretestgroup_Pre_Test_Event:
			eventID="2070425425057"
			break
		case ._complaints_DON:
			eventID="2104093950203"
			break
		case ._bill_transaction_pdf_click:
			eventID="2089979387383"
			break
		case ._bill_country_code:
			eventID="2089979387409"
			break
		case ._bill_mobile_number_change:
			eventID="2089979387401"
			break
		case ._bill_share_click:
			eventID="2089979387405"
			break
		case ._bill_country_code_change:
			eventID="2089979387395"
			break
		case ._bill_menu_click:
			eventID="2089979387391"
			break
		case ._bill_transaction_link_click:
			eventID="2089979387387"
			break
		case ._DetailsFragment_notify_via_sms:
			eventID="2089979387905"
			break
		case ._DetailsFragment_dafdfdsfds:
			eventID="2132945117861"
			break
		case ._DetailsFragment_test:
			eventID="2103432686513"
			break
		case ._DetailsFragment_get_contact_details_to_send_sms:
			eventID="2089979387901"
			break
		case ._DetailsFragment_reject_transaction:
			eventID="2089979387909"
			break
		case ._TEST_RATE_US_GROUP_tt:
			eventID="2092530813791"
			break
		case ._TEST_RATE_US_GROUP_testEvent:
			eventID="2082870435169"
			break
		case ._TEST_RATE_US_GROUP_NEW_TEST_EVENT_FOR_RATE_US:
			eventID="2066883995575"
			break
		case ._j_applifecycle_ja_application_launched:
			eventID="2068511119033"
			break
		case ._j_applifecycle_ja_did_become_active:
			eventID="2070425425003"
			break
		case ._PRE_TEST_EVENT_B:
			eventID="2089778301319"
			break
		case ._PRE_TEST_EVENT_A:
			eventID="2089778301317"
			break
		case ._Group_A_Event_A:
			eventID="2089726594145"
			break
		case ._Group_A_Event_B:
			eventID="2089726594147"
			break
		case ._Group_A_Event_C:
			eventID="2089726594149"
			break
		case ._Group_A_Event_ZZ:
			eventID="2092899795007"
			break
		case ._texst5_Testevent:
			eventID="2102416636963"
			break
		case ._j_default_apptics_android_demo_event:
			eventID="2089621848204"
			break
		case ._j_default_TEST:
			eventID="2068207172008"
			break
		case ._j_default_this_is_an_demo_event:
			eventID="2089621848232"
			break
		case ._TESTGROUP_NEW_TEST_EVENT_FOR_RATE_US:
			eventID="2066883935317"
			break
		case ._TESTGROUP_TESTEVENT:
			eventID="2064750929005"
			break
		case ._PRE_GROUP_PRE_EVENT:
			eventID="2070425425077"
			break
		case ._Test_Group_Test_Event:
			eventID="2080773705283"
			break
		case ._test_group_ek_test_event_dho:
			eventID="2085415402309"
			break
		case ._Bills_mark_void:
			eventID="2089979448411"
			break
		case ._Bills_transaction_rejected:
			eventID="2089979448369"
			break
		case ._Bills_view_attachment:
			eventID="2089979448437"
			break
		case ._Bills_add_comment:
			eventID="2089979448389"
			break
		case ._Bills_mark_draft:
			eventID="2089979448405"
			break
		case ._Bills_print_pdf:
			eventID="2089979448417"
			break
		case ._Bills_update:
			eventID="2089979448433"
			break
		case ._Bills_create_payment:
			eventID="2089979448373"
			break
		case ._Bills_submitforapproval:
			eventID="2089979448429"
			break
		case ._Bills_print_pdf_from_buildin_option:
			eventID="2089979448385"
			break
		case ._Bills_save_attachment:
			eventID="2089979448421"
			break
		case ._Bills_SATHISH1234:
			eventID="2132945117865"
			break
		case ._Bills_TEst:
			eventID="2135925115883"
			break
		case ._Bills_approve:
			eventID="2089979448393"
			break
		case ._Bills_dfadsf:
			eventID="2132945117869"
			break
		case ._Bills_create:
			eventID="2089979448397"
			break
		case ._Bills_dfsfdsfdsfdsfdfdsfdsfsdfds:
			eventID="2132961833717"
			break
		case ._Bills_details:
			eventID="2089979448377"
			break
		case ._Bills_export_pdf:
			eventID="2089979448381"
			break
		case ._Bills_download_pdf:
			eventID="2089979448401"
			break
		case ._Bills_mark_open:
			eventID="2089979448409"
			break
		case ._Bills_save_payment:
			eventID="2089979448425"
			break
		case .None:
			break
			default: break
		}
		return eventID

	}

	@objc class func groupID(forType type : APEventType) -> String?{

		var groupID : String?
		switch (type) {
		case ._vendorcredits_mark_void:
			groupID="2089979387807"
			break
		case ._vendorcredits_approve:
			groupID="2089979387807"
			break
		case ._vendorcredits_add_comment:
			groupID="2089979387807"
			break
		case ._vendorcredits_create:
			groupID="2089979387807"
			break
		case ._vendorcredits_mark_draft:
			groupID="2089979387807"
			break
		case ._vendorcredits_print_pdf:
			groupID="2089979387807"
			break
		case ._vendorcredits_submitForApproval:
			groupID="2089979387807"
			break
		case ._vendorcredits_update:
			groupID="2089979387807"
			break
		case ._vendorcredits_download_pdf:
			groupID="2089979387807"
			break
		case ._vendorcredits_mark_open:
			groupID="2089979387807"
			break
		case ._vendorcredits_save_payment:
			groupID="2089979387807"
			break
		case ._test1234_testphase:
			groupID="2092532233853"
			break
		case ._test_testphase:
			groupID="2085072955483"
			break
		case ._IN_APP_UPDATE_dismiss_install_alert:
			groupID="2089979387863"
			break
		case ._IN_APP_UPDATE_update_install_event:
			groupID="2089979387863"
			break
		case ._ICICI_Vendor_Payments_add_vendor_bank_account:
			groupID="2089979387377"
			break
		case ._ICICI_Vendor_Payments_show_otp_dialog:
			groupID="2089979387377"
			break
		case ._ICICI_Vendor_Payments_vendor_payment:
			groupID="2089979387377"
			break
		case ._ICICI_Vendor_Payments_bill_payment:
			groupID="2089979387377"
			break
		case ._ICICI_Vendor_Payments_Failure:
			groupID="2089979387377"
			break
		case ._ICICI_Vendor_Payments_Success:
			groupID="2089979387377"
			break
		case ._ICICI_Vendor_Payments_otp_validation_failure:
			groupID="2089979387377"
			break
		case ._pretestgroup_pretestevent:
			groupID="2070425425051"
			break
		case ._pretestgroup_Pre_Test_Event:
			groupID="2070425425051"
			break
		case ._complaints_DON:
			groupID="2064727740041"
			break
		case ._bill_transaction_pdf_click:
			groupID="2089979387379"
			break
		case ._bill_country_code:
			groupID="2089979387379"
			break
		case ._bill_mobile_number_change:
			groupID="2089979387379"
			break
		case ._bill_share_click:
			groupID="2089979387379"
			break
		case ._bill_country_code_change:
			groupID="2089979387379"
			break
		case ._bill_menu_click:
			groupID="2089979387379"
			break
		case ._bill_transaction_link_click:
			groupID="2089979387379"
			break
		case ._DetailsFragment_notify_via_sms:
			groupID="2089979387895"
			break
		case ._DetailsFragment_dafdfdsfds:
			groupID="2089979387895"
			break
		case ._DetailsFragment_test:
			groupID="2089979387895"
			break
		case ._DetailsFragment_get_contact_details_to_send_sms:
			groupID="2089979387895"
			break
		case ._DetailsFragment_reject_transaction:
			groupID="2089979387895"
			break
		case ._TEST_RATE_US_GROUP_tt:
			groupID="2066883977631"
			break
		case ._TEST_RATE_US_GROUP_testEvent:
			groupID="2066883977631"
			break
		case ._TEST_RATE_US_GROUP_NEW_TEST_EVENT_FOR_RATE_US:
			groupID="2066883977631"
			break
		case ._j_applifecycle_ja_application_launched:
			groupID="2068511119031"
			break
		case ._j_applifecycle_ja_did_become_active:
			groupID="2068511119031"
			break
		case ._PRE_TEST_EVENT_B:
			groupID="2089778301315"
			break
		case ._PRE_TEST_EVENT_A:
			groupID="2089778301315"
			break
		case ._Group_A_Event_A:
			groupID="2089726594143"
			break
		case ._Group_A_Event_B:
			groupID="2089726594143"
			break
		case ._Group_A_Event_C:
			groupID="2089726594143"
			break
		case ._Group_A_Event_ZZ:
			groupID="2089726594143"
			break
		case ._texst5_Testevent:
			groupID="2102416636961"
			break
		case ._j_default_apptics_android_demo_event:
			groupID="2066470065005"
			break
		case ._j_default_TEST:
			groupID="2066470065005"
			break
		case ._j_default_this_is_an_demo_event:
			groupID="2066470065005"
			break
		case ._TESTGROUP_NEW_TEST_EVENT_FOR_RATE_US:
			groupID="2064750929003"
			break
		case ._TESTGROUP_TESTEVENT:
			groupID="2064750929003"
			break
		case ._PRE_GROUP_PRE_EVENT:
			groupID="2070425425073"
			break
		case ._Test_Group_Test_Event:
			groupID="2080773705281"
			break
		case ._test_group_ek_test_event_dho:
			groupID="2085415402295"
			break
		case ._Bills_mark_void:
			groupID="2089979448363"
			break
		case ._Bills_transaction_rejected:
			groupID="2089979448363"
			break
		case ._Bills_view_attachment:
			groupID="2089979448363"
			break
		case ._Bills_add_comment:
			groupID="2089979448363"
			break
		case ._Bills_mark_draft:
			groupID="2089979448363"
			break
		case ._Bills_print_pdf:
			groupID="2089979448363"
			break
		case ._Bills_update:
			groupID="2089979448363"
			break
		case ._Bills_create_payment:
			groupID="2089979448363"
			break
		case ._Bills_submitforapproval:
			groupID="2089979448363"
			break
		case ._Bills_print_pdf_from_buildin_option:
			groupID="2089979448363"
			break
		case ._Bills_save_attachment:
			groupID="2089979448363"
			break
		case ._Bills_SATHISH1234:
			groupID="2089979448363"
			break
		case ._Bills_TEst:
			groupID="2089979448363"
			break
		case ._Bills_approve:
			groupID="2089979448363"
			break
		case ._Bills_dfadsf:
			groupID="2089979448363"
			break
		case ._Bills_create:
			groupID="2089979448363"
			break
		case ._Bills_dfsfdsfdsfdsfdfdsfdsfsdfds:
			groupID="2089979448363"
			break
		case ._Bills_details:
			groupID="2089979448363"
			break
		case ._Bills_export_pdf:
			groupID="2089979448363"
			break
		case ._Bills_download_pdf:
			groupID="2089979448363"
			break
		case ._Bills_mark_open:
			groupID="2089979448363"
			break
		case ._Bills_save_payment:
			groupID="2089979448363"
			break
		case .None:
			break
			default: break
		}
		return groupID

	}

	@objc class public func trackEvent(withType type : APEventType, andProperties : [String : Any]?) {
		if let eventID = self.eventID(forType: type){
			let groupID = self.groupID(forType: type)
		APEvent.getInstance().trackEvent(eventID, groupId: groupID, andProperties: andProperties, isTimed: false)
		}
	}

	@objc class public func trackEvent(withType type : APEventType) {
		self.trackEvent(withType: type, andProperties: nil)
	}

	@objc class public func startTimedEvent(withType type : APEventType, andProperties : [String : Any]?){
		if let eventID = self.eventID(forType: type){
			let groupID = self.groupID(forType: type)
		APEvent.getInstance().startTimedEvent(eventID, groupId: groupID, andProperties: andProperties)
		}
	}

	@objc class public func endTimedEvent(withType type : APEventType){
		if let eventID = self.eventID(forType: type){
		APEvent.getInstance().endTimedEvent(eventID)
		}
	}

}

class APEventExtension: NSObject, APEventsProtocol {

	class func formatType(toPrivateObject group: String, event: String) -> APPrivateObject? {

		let event_str = "\(group)_\(event)"

		if (event_str == "vendorcredits_mark_void") {
			return APPrivateObject("2089979387833", andGroupId:"2089979387807")
		}else if (event_str == "vendorcredits_approve") {
			return APPrivateObject("2089979387815", andGroupId:"2089979387807")
		}else if (event_str == "vendorcredits_add_comment") {
			return APPrivateObject("2089979387811", andGroupId:"2089979387807")
		}else if (event_str == "vendorcredits_create") {
			return APPrivateObject("2089979387817", andGroupId:"2089979387807")
		}else if (event_str == "vendorcredits_mark_draft") {
			return APPrivateObject("2089979387827", andGroupId:"2089979387807")
		}else if (event_str == "vendorcredits_print_pdf") {
			return APPrivateObject("2089979387837", andGroupId:"2089979387807")
		}else if (event_str == "vendorcredits_submitForApproval") {
			return APPrivateObject("2089979387845", andGroupId:"2089979387807")
		}else if (event_str == "vendorcredits_update") {
			return APPrivateObject("2089979387849", andGroupId:"2089979387807")
		}else if (event_str == "vendorcredits_download_pdf") {
			return APPrivateObject("2089979387821", andGroupId:"2089979387807")
		}else if (event_str == "vendorcredits_mark_open") {
			return APPrivateObject("2089979387831", andGroupId:"2089979387807")
		}else if (event_str == "vendorcredits_save_payment") {
			return APPrivateObject("2089979387841", andGroupId:"2089979387807")
		}else if (event_str == "test1234_testphase") {
			return APPrivateObject("2092532233855", andGroupId:"2092532233853")
		}else if (event_str == "test_testphase") {
			return APPrivateObject("2085072955573", andGroupId:"2085072955483")
		}else if (event_str == "IN_APP_UPDATE_dismiss_install_alert") {
			return APPrivateObject("2089979387867", andGroupId:"2089979387863")
		}else if (event_str == "IN_APP_UPDATE_update_install_event") {
			return APPrivateObject("2089979387871", andGroupId:"2089979387863")
		}else if (event_str == "ICICI_Vendor_Payments_add_vendor_bank_account") {
			return APPrivateObject("2089979387397", andGroupId:"2089979387377")
		}else if (event_str == "ICICI_Vendor_Payments_show_otp_dialog") {
			return APPrivateObject("2089979387399", andGroupId:"2089979387377")
		}else if (event_str == "ICICI_Vendor_Payments_vendor_payment") {
			return APPrivateObject("2089979387389", andGroupId:"2089979387377")
		}else if (event_str == "ICICI_Vendor_Payments_bill_payment") {
			return APPrivateObject("2089979387393", andGroupId:"2089979387377")
		}else if (event_str == "ICICI_Vendor_Payments_Failure") {
			return APPrivateObject("2089979387381", andGroupId:"2089979387377")
		}else if (event_str == "ICICI_Vendor_Payments_Success") {
			return APPrivateObject("2089979387385", andGroupId:"2089979387377")
		}else if (event_str == "ICICI_Vendor_Payments_otp_validation_failure") {
			return APPrivateObject("2089979387403", andGroupId:"2089979387377")
		}else if (event_str == "pretestgroup_pretestevent") {
			return APPrivateObject("2080773705279", andGroupId:"2070425425051")
		}else if (event_str == "pretestgroup_Pre_Test_Event") {
			return APPrivateObject("2070425425057", andGroupId:"2070425425051")
		}else if (event_str == "complaints_DON") {
			return APPrivateObject("2104093950203", andGroupId:"2064727740041")
		}else if (event_str == "bill_transaction_pdf_click") {
			return APPrivateObject("2089979387383", andGroupId:"2089979387379")
		}else if (event_str == "bill_country_code") {
			return APPrivateObject("2089979387409", andGroupId:"2089979387379")
		}else if (event_str == "bill_mobile_number_change") {
			return APPrivateObject("2089979387401", andGroupId:"2089979387379")
		}else if (event_str == "bill_share_click") {
			return APPrivateObject("2089979387405", andGroupId:"2089979387379")
		}else if (event_str == "bill_country_code_change") {
			return APPrivateObject("2089979387395", andGroupId:"2089979387379")
		}else if (event_str == "bill_menu_click") {
			return APPrivateObject("2089979387391", andGroupId:"2089979387379")
		}else if (event_str == "bill_transaction_link_click") {
			return APPrivateObject("2089979387387", andGroupId:"2089979387379")
		}else if (event_str == "DetailsFragment_notify_via_sms") {
			return APPrivateObject("2089979387905", andGroupId:"2089979387895")
		}else if (event_str == "DetailsFragment_dafdfdsfds") {
			return APPrivateObject("2132945117861", andGroupId:"2089979387895")
		}else if (event_str == "DetailsFragment_test") {
			return APPrivateObject("2103432686513", andGroupId:"2089979387895")
		}else if (event_str == "DetailsFragment_get_contact_details_to_send_sms") {
			return APPrivateObject("2089979387901", andGroupId:"2089979387895")
		}else if (event_str == "DetailsFragment_reject_transaction") {
			return APPrivateObject("2089979387909", andGroupId:"2089979387895")
		}else if (event_str == "TEST_RATE_US_GROUP_tt") {
			return APPrivateObject("2092530813791", andGroupId:"2066883977631")
		}else if (event_str == "TEST_RATE_US_GROUP_testEvent") {
			return APPrivateObject("2082870435169", andGroupId:"2066883977631")
		}else if (event_str == "TEST_RATE_US_GROUP_NEW_TEST_EVENT_FOR_RATE_US") {
			return APPrivateObject("2066883995575", andGroupId:"2066883977631")
		}else if (event_str == "j_applifecycle_ja_application_launched") {
			return APPrivateObject("2068511119033", andGroupId:"2068511119031")
		}else if (event_str == "j_applifecycle_ja_did_become_active") {
			return APPrivateObject("2070425425003", andGroupId:"2068511119031")
		}else if (event_str == "PRE_TEST_EVENT_B") {
			return APPrivateObject("2089778301319", andGroupId:"2089778301315")
		}else if (event_str == "PRE_TEST_EVENT_A") {
			return APPrivateObject("2089778301317", andGroupId:"2089778301315")
		}else if (event_str == "Group_A_Event_A") {
			return APPrivateObject("2089726594145", andGroupId:"2089726594143")
		}else if (event_str == "Group_A_Event_B") {
			return APPrivateObject("2089726594147", andGroupId:"2089726594143")
		}else if (event_str == "Group_A_Event_C") {
			return APPrivateObject("2089726594149", andGroupId:"2089726594143")
		}else if (event_str == "Group_A_Event_ZZ") {
			return APPrivateObject("2092899795007", andGroupId:"2089726594143")
		}else if (event_str == "texst5_Testevent") {
			return APPrivateObject("2102416636963", andGroupId:"2102416636961")
		}else if (event_str == "j_default_apptics_android_demo_event") {
			return APPrivateObject("2089621848204", andGroupId:"2066470065005")
		}else if (event_str == "j_default_TEST") {
			return APPrivateObject("2068207172008", andGroupId:"2066470065005")
		}else if (event_str == "j_default_this_is_an_demo_event") {
			return APPrivateObject("2089621848232", andGroupId:"2066470065005")
		}else if (event_str == "TESTGROUP_NEW_TEST_EVENT_FOR_RATE_US") {
			return APPrivateObject("2066883935317", andGroupId:"2064750929003")
		}else if (event_str == "TESTGROUP_TESTEVENT") {
			return APPrivateObject("2064750929005", andGroupId:"2064750929003")
		}else if (event_str == "PRE_GROUP_PRE_EVENT") {
			return APPrivateObject("2070425425077", andGroupId:"2070425425073")
		}else if (event_str == "Test_Group_Test_Event") {
			return APPrivateObject("2080773705283", andGroupId:"2080773705281")
		}else if (event_str == "test_group_ek_test_event_dho") {
			return APPrivateObject("2085415402309", andGroupId:"2085415402295")
		}else if (event_str == "Bills_mark_void") {
			return APPrivateObject("2089979448411", andGroupId:"2089979448363")
		}else if (event_str == "Bills_transaction_rejected") {
			return APPrivateObject("2089979448369", andGroupId:"2089979448363")
		}else if (event_str == "Bills_view_attachment") {
			return APPrivateObject("2089979448437", andGroupId:"2089979448363")
		}else if (event_str == "Bills_add_comment") {
			return APPrivateObject("2089979448389", andGroupId:"2089979448363")
		}else if (event_str == "Bills_mark_draft") {
			return APPrivateObject("2089979448405", andGroupId:"2089979448363")
		}else if (event_str == "Bills_print_pdf") {
			return APPrivateObject("2089979448417", andGroupId:"2089979448363")
		}else if (event_str == "Bills_update") {
			return APPrivateObject("2089979448433", andGroupId:"2089979448363")
		}else if (event_str == "Bills_create_payment") {
			return APPrivateObject("2089979448373", andGroupId:"2089979448363")
		}else if (event_str == "Bills_submitforapproval") {
			return APPrivateObject("2089979448429", andGroupId:"2089979448363")
		}else if (event_str == "Bills_print_pdf_from_buildin_option") {
			return APPrivateObject("2089979448385", andGroupId:"2089979448363")
		}else if (event_str == "Bills_save_attachment") {
			return APPrivateObject("2089979448421", andGroupId:"2089979448363")
		}else if (event_str == "Bills_SATHISH1234") {
			return APPrivateObject("2132945117865", andGroupId:"2089979448363")
		}else if (event_str == "Bills_TEst") {
			return APPrivateObject("2135925115883", andGroupId:"2089979448363")
		}else if (event_str == "Bills_approve") {
			return APPrivateObject("2089979448393", andGroupId:"2089979448363")
		}else if (event_str == "Bills_dfadsf") {
			return APPrivateObject("2132945117869", andGroupId:"2089979448363")
		}else if (event_str == "Bills_create") {
			return APPrivateObject("2089979448397", andGroupId:"2089979448363")
		}else if (event_str == "Bills_dfsfdsfdsfdsfdfdsfdsfsdfds") {
			return APPrivateObject("2132961833717", andGroupId:"2089979448363")
		}else if (event_str == "Bills_details") {
			return APPrivateObject("2089979448377", andGroupId:"2089979448363")
		}else if (event_str == "Bills_export_pdf") {
			return APPrivateObject("2089979448381", andGroupId:"2089979448363")
		}else if (event_str == "Bills_download_pdf") {
			return APPrivateObject("2089979448401", andGroupId:"2089979448363")
		}else if (event_str == "Bills_mark_open") {
			return APPrivateObject("2089979448409", andGroupId:"2089979448363")
		}else if (event_str == "Bills_save_payment") {
			return APPrivateObject("2089979448425", andGroupId:"2089979448363")
		}else {
			return nil;
		}
	}

	class func formatTypeToPrivateObject(fromEventId eventId: String) -> APPrivateObject?{

		if (eventId == "2089979387833") {
			return APPrivateObject("vendorcredits", event: "mark_void")
		}else if (eventId == "2089979387815") {
			return APPrivateObject("vendorcredits", event: "approve")
		}else if (eventId == "2089979387811") {
			return APPrivateObject("vendorcredits", event: "add_comment")
		}else if (eventId == "2089979387817") {
			return APPrivateObject("vendorcredits", event: "create")
		}else if (eventId == "2089979387827") {
			return APPrivateObject("vendorcredits", event: "mark_draft")
		}else if (eventId == "2089979387837") {
			return APPrivateObject("vendorcredits", event: "print_pdf")
		}else if (eventId == "2089979387845") {
			return APPrivateObject("vendorcredits", event: "submitForApproval")
		}else if (eventId == "2089979387849") {
			return APPrivateObject("vendorcredits", event: "update")
		}else if (eventId == "2089979387821") {
			return APPrivateObject("vendorcredits", event: "download_pdf")
		}else if (eventId == "2089979387831") {
			return APPrivateObject("vendorcredits", event: "mark_open")
		}else if (eventId == "2089979387841") {
			return APPrivateObject("vendorcredits", event: "save_payment")
		}else if (eventId == "2092532233855") {
			return APPrivateObject("test1234", event: "testphase")
		}else if (eventId == "2085072955573") {
			return APPrivateObject("test", event: "testphase")
		}else if (eventId == "2089979387867") {
			return APPrivateObject("IN_APP_UPDATE", event: "dismiss_install_alert")
		}else if (eventId == "2089979387871") {
			return APPrivateObject("IN_APP_UPDATE", event: "update_install_event")
		}else if (eventId == "2089979387397") {
			return APPrivateObject("ICICI_Vendor_Payments", event: "add_vendor_bank_account")
		}else if (eventId == "2089979387399") {
			return APPrivateObject("ICICI_Vendor_Payments", event: "show_otp_dialog")
		}else if (eventId == "2089979387389") {
			return APPrivateObject("ICICI_Vendor_Payments", event: "vendor_payment")
		}else if (eventId == "2089979387393") {
			return APPrivateObject("ICICI_Vendor_Payments", event: "bill_payment")
		}else if (eventId == "2089979387381") {
			return APPrivateObject("ICICI_Vendor_Payments", event: "Failure")
		}else if (eventId == "2089979387385") {
			return APPrivateObject("ICICI_Vendor_Payments", event: "Success")
		}else if (eventId == "2089979387403") {
			return APPrivateObject("ICICI_Vendor_Payments", event: "otp_validation_failure")
		}else if (eventId == "2080773705279") {
			return APPrivateObject("pretestgroup", event: "pretestevent")
		}else if (eventId == "2070425425057") {
			return APPrivateObject("pretestgroup", event: "Pre_Test_Event")
		}else if (eventId == "2104093950203") {
			return APPrivateObject("complaints", event: "DON")
		}else if (eventId == "2089979387383") {
			return APPrivateObject("bill", event: "transaction_pdf_click")
		}else if (eventId == "2089979387409") {
			return APPrivateObject("bill", event: "country_code")
		}else if (eventId == "2089979387401") {
			return APPrivateObject("bill", event: "mobile_number_change")
		}else if (eventId == "2089979387405") {
			return APPrivateObject("bill", event: "share_click")
		}else if (eventId == "2089979387395") {
			return APPrivateObject("bill", event: "country_code_change")
		}else if (eventId == "2089979387391") {
			return APPrivateObject("bill", event: "menu_click")
		}else if (eventId == "2089979387387") {
			return APPrivateObject("bill", event: "transaction_link_click")
		}else if (eventId == "2089979387905") {
			return APPrivateObject("DetailsFragment", event: "notify_via_sms")
		}else if (eventId == "2132945117861") {
			return APPrivateObject("DetailsFragment", event: "dafdfdsfds")
		}else if (eventId == "2103432686513") {
			return APPrivateObject("DetailsFragment", event: "test")
		}else if (eventId == "2089979387901") {
			return APPrivateObject("DetailsFragment", event: "get_contact_details_to_send_sms")
		}else if (eventId == "2089979387909") {
			return APPrivateObject("DetailsFragment", event: "reject_transaction")
		}else if (eventId == "2092530813791") {
			return APPrivateObject("TEST_RATE_US_GROUP", event: "tt")
		}else if (eventId == "2082870435169") {
			return APPrivateObject("TEST_RATE_US_GROUP", event: "testEvent")
		}else if (eventId == "2066883995575") {
			return APPrivateObject("TEST_RATE_US_GROUP", event: "NEW_TEST_EVENT_FOR_RATE_US")
		}else if (eventId == "2068511119033") {
			return APPrivateObject("j_applifecycle", event: "ja_application_launched")
		}else if (eventId == "2070425425003") {
			return APPrivateObject("j_applifecycle", event: "ja_did_become_active")
		}else if (eventId == "2089778301319") {
			return APPrivateObject("PRE_TEST", event: "EVENT_B")
		}else if (eventId == "2089778301317") {
			return APPrivateObject("PRE_TEST", event: "EVENT_A")
		}else if (eventId == "2089726594145") {
			return APPrivateObject("Group_A", event: "Event_A")
		}else if (eventId == "2089726594147") {
			return APPrivateObject("Group_A", event: "Event_B")
		}else if (eventId == "2089726594149") {
			return APPrivateObject("Group_A", event: "Event_C")
		}else if (eventId == "2092899795007") {
			return APPrivateObject("Group_A", event: "Event_ZZ")
		}else if (eventId == "2102416636963") {
			return APPrivateObject("texst5", event: "Testevent")
		}else if (eventId == "2089621848204") {
			return APPrivateObject("j_default", event: "apptics_android_demo_event")
		}else if (eventId == "2068207172008") {
			return APPrivateObject("j_default", event: "TEST")
		}else if (eventId == "2089621848232") {
			return APPrivateObject("j_default", event: "this_is_an_demo_event")
		}else if (eventId == "2066883935317") {
			return APPrivateObject("TESTGROUP", event: "NEW_TEST_EVENT_FOR_RATE_US")
		}else if (eventId == "2064750929005") {
			return APPrivateObject("TESTGROUP", event: "TESTEVENT")
		}else if (eventId == "2070425425077") {
			return APPrivateObject("PRE_GROUP", event: "PRE_EVENT")
		}else if (eventId == "2080773705283") {
			return APPrivateObject("Test_Group", event: "Test_Event")
		}else if (eventId == "2085415402309") {
			return APPrivateObject("test_group_ek", event: "test_event_dho")
		}else if (eventId == "2089979448411") {
			return APPrivateObject("Bills", event: "mark_void")
		}else if (eventId == "2089979448369") {
			return APPrivateObject("Bills", event: "transaction_rejected")
		}else if (eventId == "2089979448437") {
			return APPrivateObject("Bills", event: "view_attachment")
		}else if (eventId == "2089979448389") {
			return APPrivateObject("Bills", event: "add_comment")
		}else if (eventId == "2089979448405") {
			return APPrivateObject("Bills", event: "mark_draft")
		}else if (eventId == "2089979448417") {
			return APPrivateObject("Bills", event: "print_pdf")
		}else if (eventId == "2089979448433") {
			return APPrivateObject("Bills", event: "update")
		}else if (eventId == "2089979448373") {
			return APPrivateObject("Bills", event: "create_payment")
		}else if (eventId == "2089979448429") {
			return APPrivateObject("Bills", event: "submitforapproval")
		}else if (eventId == "2089979448385") {
			return APPrivateObject("Bills", event: "print_pdf_from_buildin_option")
		}else if (eventId == "2089979448421") {
			return APPrivateObject("Bills", event: "save_attachment")
		}else if (eventId == "2132945117865") {
			return APPrivateObject("Bills", event: "SATHISH1234")
		}else if (eventId == "2135925115883") {
			return APPrivateObject("Bills", event: "TEst")
		}else if (eventId == "2089979448393") {
			return APPrivateObject("Bills", event: "approve")
		}else if (eventId == "2132945117869") {
			return APPrivateObject("Bills", event: "dfadsf")
		}else if (eventId == "2089979448397") {
			return APPrivateObject("Bills", event: "create")
		}else if (eventId == "2132961833717") {
			return APPrivateObject("Bills", event: "dfsfdsfdsfdsfdfdsfdsfsdfds")
		}else if (eventId == "2089979448377") {
			return APPrivateObject("Bills", event: "details")
		}else if (eventId == "2089979448381") {
			return APPrivateObject("Bills", event: "export_pdf")
		}else if (eventId == "2089979448401") {
			return APPrivateObject("Bills", event: "download_pdf")
		}else if (eventId == "2089979448409") {
			return APPrivateObject("Bills", event: "mark_open")
		}else if (eventId == "2089979448425") {
			return APPrivateObject("Bills", event: "save_payment")
		}else {
			return nil;
		}
	}

}

class APAPAPIExtension: NSObject, APAPIProtocol {

	class func isMatch(_ source: String?, with pattern: String?) -> Bool {
		var regex: NSRegularExpression? = nil
		do {
			regex = try NSRegularExpression(pattern: pattern ?? "", options: [])
		} catch {
		}
		let n = regex?.numberOfMatches(in: source ?? "", options: [], range: NSRange(location: 0, length: source?.count ?? 0)) ?? 0
		return n > 0
	}

	class func directMatch(_ url: String) -> String? {
		if url == "http://notebook.zoho.com/ui/search?param1=windows" {
			return "2077491134897"
		}else if url == "https://www.google.com/maps/" {
			return "2079961640855"
		}else if url == "https://notebook.zoho.com/search?param1=testParam" {
			return "2079961640905"
		}else if url == "http://fdj.com" {
			return "2085330724487"
		}else if url == "https://jsonplaceholder.typicode.com/todos/1" {
			return "2087903231799"
		}else if url == "https://jproxy.zoho.com/api/janalytic/v3/addevents" {
			return "2087903231825"
		}else if url == "https://jproxy.zoho.com/api/janalytic/v3/addscreens?identifier=com.zoho.zanalyticsapp" {
			return "2088206072929"
		}else if url == "https://jproxy.zoho.com/api/janalytic/v3/addscreens" {
			return "2088214272449"
		}else if url == "https://apptics.zoho.com/ac/660807468/2000017429321/api/1/2" {
			return "2102060815571"
		}else if url == "https://preapptics.zoho.com/ac/660807468/2000017429321/1/api/9" {
			return "2102416239581"
		}else if url == "https://preapptics.zoho.com/ac/660807468/2000017429321/1/api/10" {
			return "2102416239585"
		}else if url == "https://preapptics.zoho.com/ac/660807468/2000017429321/1/api/9?param=value" {
			return "2102416239589"
		}else if url == "https://preapptics.zoho.com/ac/660807468/2000017429321/1/api/9?Param=value" {
			return "2102416341527"
		}else if url == "https://apptics.zoho.com/ac?param=value1" {
			return "2125132031739"
		}else if url == "https://apptics.zoho.com/ac?param=value2" {
			return "2125132101077"
		}else if url == "https://test.com/testapi" {
			return "2128537170283"
		}else if url == "https://apptics.zoho.com/ac/660807468/2000017429321/1/api/2" {
			return "2128551619179"
		}else if url == "https://template.com/test31" {
			return "2128921646819"
		}else if url == "https://template.com/test33" {
			return "2128921831835"
		}else if url == "https://template.com/test34" {
			return "2128922358970"
		}else if url == "https://template.com/test35" {
			return "2128922696996"
		}else if url == "https://template.com/test36" {
			return "2128922977558"
		}else if url == "https://apptics.localzoho.com/ac/56513647/51000000002015/1/api/2" {
			return "2128949315251"
		}else if url == "https://apptics.localzoho.com/ac/56513647/51000000002015/1/api/1" {
			return "2129518180443"
		}else 		{
			return nil
		}
	}

	class func patternMatch(_ url: String) -> String? {
		if self.isMatch(url, with:"https://notebook.zoho.com/ui/[a-z]+/[0-9]+/search") == true{
			return "2077262005812"
		}else if self.isMatch(url, with:"https://jproxy.zoho.com/api/janalytic/v3/[a-z]+") == true{
			return "2088206072777"
		}else if self.isMatch(url, with:"https://apptics.zoho.com/api/janalytic/v3/[a-z]+") == true{
			return "2089597534687"
		}else if self.isMatch(url, with:"https://www.google.com/[a-z]+") == true{
			return "2102273666655"
		}else if self.isMatch(url, with:"https://preapptics.zoho.com/ac/660807468/2000017429321/1/[a-z]+/9") == true{
			return "2102416341523"
		}else if self.isMatch(url, with:"https://lens.zoho.com/api/v2/session/schedule/[0-9]+") == true{
			return "2119368842917"
		}else if self.isMatch(url, with:"http(s)?://.*[/]api[/]json[/]alarm[/]listAlarms") == true{
			return "2133883604831"
		}else if self.isMatch(url, with:"http(s)?://.*[/]api[/]json[/]alarm[/]listAlarms") == true{
			return "2133883690441"
		}else 		{
			return nil
		}
	}

}

