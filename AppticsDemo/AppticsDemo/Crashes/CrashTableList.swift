
import Foundation

enum CrashListType {
    case NullPointer
    case BadPointer
    case AsyncSafeThread
    case ObjCException
    case ReadOnlyPage
    case CrashAbort
    case CrashSwift
}

struct CrashTableList {
    var name: String
    var type: CrashListType
}

extension CrashTableList {
    static var crashData = [
        CrashTableList(name: "Difference a NULL Pointer", type: .NullPointer),
        CrashTableList(name: "Difference a bad Pointer", type: .BadPointer),
        CrashTableList(name: "Crash with __Pthread_list_lock held", type: .AsyncSafeThread),
        CrashTableList(name: "Throw Objective-C exception", type: .ObjCException),
        CrashTableList(name: "Write to a read-only page", type: .ReadOnlyPage),
        CrashTableList(name: "Call abort()", type: .CrashAbort),
        CrashTableList(name: "Swift crash", type: .CrashSwift)
    ]
}

class CrashSwift: NSObject {
    
     func crash() {
        let buf: UnsafeMutablePointer<UInt>? = nil;
        
        buf![1] = 1;
    }
}
