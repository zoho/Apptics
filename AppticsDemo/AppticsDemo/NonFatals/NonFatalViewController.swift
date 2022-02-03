
import UIKit

class NonFatalListViewController: UITableViewController {
}

extension NonFatalListViewController {
    static let nonFatalListCellIdentifier = "NonFatalListCell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NonFatalTableList.nonFatalData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.nonFatalListCellIdentifier, for: indexPath) as? NonFatalListCell else {
            fatalError("Unable to dequeue ReminderCell")
        }
        let list = NonFatalTableList.nonFatalData[indexPath.row]
        cell.title.text = list.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = NonFatalTableList.nonFatalData[indexPath.row]

        switch list.type {
                
        case .ObjcException:
            NonFatalMasterObjc().throwException()
            Toast.show(message: "Tracked Objective-C exception!", controller: self)
            break
        case .ObjcError:
            NonFatalMasterObjc().throwError()
            Toast.show(message: "Tracked Objective-C error!", controller: self)
            break
        case .SwiftError:
            NonFatalMasterSwift().throwError()
            Toast.show(message: "Tracked Swift error!", controller: self)
            break
        }
        
    }
}
