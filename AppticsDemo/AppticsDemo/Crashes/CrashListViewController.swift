
import UIKit

class CrashListViewController: UITableViewController {
}

extension CrashListViewController {
    static let crashListCellIdentifier = "CrashListCell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CrashTableList.crashData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.crashListCellIdentifier, for: indexPath) as? CrashListCell else {
            fatalError("Unable to dequeue ReminderCell")
        }
        let list = CrashTableList.crashData[indexPath.row]
        cell.title.text = list.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = CrashTableList.crashData[indexPath.row]

        switch list.type {
        
        case .NullPointer:
            CrashNULL().crash()
        case .BadPointer:
            CrashGarbage().crash()
        case .AsyncSafeThread:
            CrashAsyncSafeThread().crash()
        case .ObjCException:
            CrashObjCException().crash()
        case .ReadOnlyPage:
            CrashReadOnlyPage().crash()
        case .CrashAbort:
            CrashAbort().crash()
        case .CrashSwift:
            CrashSwift().crash()
        }
        
    }
}
