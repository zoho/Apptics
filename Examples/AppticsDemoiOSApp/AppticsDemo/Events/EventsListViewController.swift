
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
                
        cell.eventTitle.text = list.name
//        cell.groupTitle.text = list.group
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = EventsTableList.eventData[indexPath.row]
        APEvent.trackEvent(list.name, withGroupName: list.group)
        Toast.show(message: "Event '\(list.group) - \(list.name)' tracked!", controller: self)
    }
}
