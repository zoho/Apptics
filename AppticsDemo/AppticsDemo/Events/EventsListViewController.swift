
import UIKit
import AppticsEventTracker

class EventsListViewController: UITableViewController {
}

extension EventsListViewController {
    static let eventsListCellIdentifier = "EventsListCell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventsTableList.eventData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.eventsListCellIdentifier, for: indexPath) as? EventsListCell else {
            fatalError("Unable to dequeue ReminderCell")
        }
        let list = EventsTableList.eventData[indexPath.row]
        
        let eventID = APEvent.eventID(forType: list.type)
        let eventObject = APEventExtension.formatTypeToPrivateObject(fromEventId: eventID!)! as APPrivateObject
        
        cell.eventTitle.text = eventObject.event
//        cell.groupTitle.text = eventObject.group
//        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = EventsTableList.eventData[indexPath.row]
        var eventName = ""
        switch list.type {
        case ._bill_transaction_pdf_click, ._bill_country_code, ._bill_mobile_number_change, ._bill_share_click:
            // Track event with enum
            APEvent.trackEvent(withType: list.type)
            let eventID = APEvent.eventID(forType: list.type)
            let eventObject = APEventExtension.formatTypeToPrivateObject(fromEventId: eventID!)! as APPrivateObject
            eventName = eventObject.event            
            break
        case ._bill_country_code_change:
            // Track event with String
            eventName = "country_code_change"
            APEvent.trackEvent(eventName, andGroupName: "bill", withProperties: [:])
            break
        case ._bill_menu_click:
            // Track event with String
            eventName = "menu_click"
            APEvent.trackEvent(eventName, andGroupName: "bill",withProperties: [:])
            break
        case ._bill_transaction_link_click:
            // Track event with String
            eventName = "transaction_link_click"
            APEvent.trackEvent(eventName, andGroupName: "bill",withProperties: [:])
            break
        case ._Bills_transaction_rejected:
            // Track event with String
            eventName = "transaction_rejected"
            APEvent.trackEvent(eventName, andGroupName: "bills",withProperties: [:])
            break
        default:
            break
        }
        Toast.show(message: "Event '\(eventName)' tracked!", controller: self)
    }
}
