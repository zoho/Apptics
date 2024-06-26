
import Foundation

enum TableListType {
    case Event
    case Crash
    case Nonfatal
    case Feedback
    case securecontainer
    case Appupdate
    case Apitracking
    case Login
    case Logout
    case Opensettings
    case Crosspromotion
}

struct TableList {
    var title: String
    var type: TableListType
}

extension TableList {
    static var testData = [
        TableList(title: "Events", type: .Event),
        TableList(title: "Crash", type: .Crash),
        TableList(title: "Add Non-fatal", type: .Nonfatal),
        TableList(title: "Feedback", type: .Feedback),
        TableList(title: "Secure Container", type: .securecontainer),
        TableList(title: "Check for update", type: .Appupdate),
        TableList(title: "APIs tracking", type: .Apitracking),
        TableList(title: "Login", type: .Login),
        TableList(title: "Logout", type: .Logout),
        TableList(title: "Open analytics preference", type: .Opensettings),
        TableList(title: "More apps by us", type: .Crosspromotion)
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
