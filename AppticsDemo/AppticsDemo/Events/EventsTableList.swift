
import Foundation



struct EventsTableList {
    var type: APEventType
}

extension EventsTableList {
    static var eventData = [
        EventsTableList(type: ._bill_transaction_pdf_click),
        EventsTableList(type: ._bill_country_code),
        EventsTableList(type: ._bill_mobile_number_change),
        EventsTableList(type: ._bill_share_click),
        EventsTableList(type: ._bill_country_code_change),
        EventsTableList(type: ._bill_menu_click),
        EventsTableList(type: ._bill_transaction_link_click),
        EventsTableList(type: ._Bills_transaction_rejected)
    ]
}

