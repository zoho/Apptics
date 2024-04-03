
import Foundation
import AppticsEventTracker


struct EventsTableList {
    var group: String, name: String
    
}

extension EventsTableList {
    static var eventData = [
        EventsTableList(group: AP_GROUP_APP_LIFE_CYCLE, name: AP_EVENT_APP_FIRST_OPEN),
        EventsTableList(group: AP_GROUP_APP_LIFE_CYCLE, name: AP_EVENT_APP_LAUNCHING),
        EventsTableList(group: AP_GROUP_APP_LIFE_CYCLE, name: AP_EVENT_APP_UPDATE),
        EventsTableList(group: AP_GROUP_APP_LIFE_CYCLE, name: AP_EVENT_APP_RESIGN_ACTIVE)
    ]
}

