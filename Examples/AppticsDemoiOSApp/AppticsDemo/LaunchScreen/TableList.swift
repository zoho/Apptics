
import UIKit

enum TableListType {
    case Event
    case Screens
    case Crash
    case Nonfatal
    case Feedback
    case securecontainer
    case Appupdate
    case Apitracking
    case Remoteconfig
    case Remotelogger
    case Privacy
    case Login
    case Logout
    case Opensettings
    case Crosspromotion
}

struct TableList {
    var title: String
    var type: TableListType
    var color: UIColor
}

extension TableList {
    static var testData: [TableList] = [
        TableList(title: "In-App Events",              type: .Event,          color: UIColor(red: 0.29, green: 0.56, blue: 0.89, alpha: 1)),
        TableList(title: "Screen Tracking",            type: .Screens,        color: UIColor(red: 0.48, green: 0.40, blue: 0.93, alpha: 1)),
        TableList(title: "Crash Reporting",            type: .Crash,          color: UIColor(red: 0.88, green: 0.33, blue: 0.33, alpha: 1)),
        TableList(title: "Add Non-fatal",              type: .Nonfatal,       color: UIColor(red: 0.95, green: 0.60, blue: 0.20, alpha: 1)),
        TableList(title: "Feedback",                   type: .Feedback,       color: UIColor(red: 0.96, green: 0.42, blue: 0.61, alpha: 1)),
        TableList(title: "Secure Container",           type: .securecontainer,color: UIColor(red: 0.12, green: 0.70, blue: 0.67, alpha: 1)),
        TableList(title: "In-App Updates",             type: .Appupdate,      color: UIColor(red: 0.30, green: 0.69, blue: 0.31, alpha: 1)),
        TableList(title: "API Tracking",               type: .Apitracking,    color: UIColor(red: 0.36, green: 0.42, blue: 0.75, alpha: 1)),
        TableList(title: "Remote Config",              type: .Remoteconfig,   color: UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1)),
        TableList(title: "Remote Logger",              type: .Remotelogger,   color: UIColor(red: 0.15, green: 0.78, blue: 0.85, alpha: 1)),
        TableList(title: "Privacy Settings",           type: .Privacy,        color: UIColor(red: 0.58, green: 0.46, blue: 0.80, alpha: 1)),
        TableList(title: "Login",                      type: .Login,          color: UIColor(red: 0.47, green: 0.56, blue: 0.61, alpha: 1)),
        TableList(title: "Logout",                     type: .Logout,         color: UIColor(red: 0.47, green: 0.56, blue: 0.61, alpha: 1)),
        TableList(title: "Open Analytics Preference",  type: .Opensettings,   color: UIColor(red: 0.26, green: 0.65, blue: 0.96, alpha: 1)),
        TableList(title: "More Apps by Us",            type: .Crosspromotion, color: UIColor(red: 0.93, green: 0.25, blue: 0.48, alpha: 1)),
    ]
}

enum SecureTableListType {
    case secureElements
    case secureViews
    case secureWindow
}

struct SecureTableList {
    var title: String
    var type: SecureTableListType
}

extension SecureTableList {
    static var data = [
        SecureTableList(title: "Secure UI Elements", type: .secureElements),
        SecureTableList(title: "Secure Views", type: .secureViews),
        SecureTableList(title: "Monitor Screen Recording", type: .secureWindow),
    ]
}
