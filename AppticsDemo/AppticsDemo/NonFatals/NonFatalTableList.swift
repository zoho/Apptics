
import Foundation
import Apptics_Swift

enum NonFatalListType {
    case ObjcException
    case ObjcError
    case SwiftError
}

struct NonFatalTableList {
    var name: String
    var type: NonFatalListType
}

extension NonFatalTableList {
    static var nonFatalData = [
        NonFatalTableList(name: "Catch Objective-C exception", type: .ObjcException),
        NonFatalTableList(name: "Catch Objective-C error", type: .ObjcError),
        NonFatalTableList(name: "Catch Swift error", type: .SwiftError)
    ]
}

class NonFatalMasterSwift: NSObject {
    
     func throwError() {
        let filename = Bundle.main.path(forResource: "input", ofType: "txt")
        do {
            let str = try String(contentsOfFile: filename ?? "")
            
        } catch let error{
            trackError(error as NSError)
        }
    }
}
