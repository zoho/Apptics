
import UIKit
//import Apptics_Swift
class ListViewController: UITableViewController {
    override func viewDidLoad() {
        self.navigationItem.title = "Apptics Demo"
    }
}

extension ListViewController {
    static let listCellIdentifier = "ListCell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableList.testData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.listCellIdentifier, for: indexPath) as? ListCell else {
            fatalError("Unable to dequeue ReminderCell")
        }
        let list = TableList.testData[indexPath.row]
        
        cell.titleLabel.text = list.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = TableList.testData[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch list.type {
        case .Event:
            let eventsListController = storyboard.instantiateViewController(withIdentifier: "EventsListViewController") 
            self.navigationController?.pushViewController(eventsListController, animated: true)
            break
        case .Crash:
            let crashListController = storyboard.instantiateViewController(withIdentifier: "CrashListViewController")
            self.navigationController?.pushViewController(crashListController, animated: true)
            break
        case .Nonfatal:
            let nonFatalListController = storyboard.instantiateViewController(withIdentifier: "NonFatalListViewController")
            self.navigationController?.pushViewController(nonFatalListController, animated: true)
            break
        case .Feedback:
//            FeedbackKit.setFromEmailAddress("ssaravanan@zohocorp.com")
//            FeedbackKit.showFeedback()
            break
        case .Appupdate:
//            APAppUpdateManager.check { info in
//                 print("update info \(info)")
//            }
            break
        case .Apitracking:
            let apiListController = storyboard.instantiateViewController(withIdentifier: "APIListViewController")
            self.navigationController?.pushViewController(apiListController, animated: true)
            break
        case .Login:
            break
        case .Logout:
            break
        case .Opensettings:
//            Apptics.openAnalyticSettingsController()
            break
        case .Crosspromotion:
//            PromotedAppsKit.presentPromotedAppsController(sectionHeader1: "Related apps", sectionHeader2: "More apps")
            break
        }
        
    }
}

class Toast {
    static func show(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25;
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])

        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .centerX, relatedBy: .equal, toItem: controller.view, attribute: .centerX, multiplier: 1, constant: 0)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .centerY, relatedBy: .equal, toItem: controller.view, attribute: .centerY, multiplier: 1, constant: -100)
//        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: 100)
        controller.view.addConstraints([c1, c2])

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
