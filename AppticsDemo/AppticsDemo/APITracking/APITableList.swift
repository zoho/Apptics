
import Foundation

enum ApiListType {
    case SimpleMatch
    case SingleWithParam
    case RegexMatch
    case TrackByApiID
}

struct APITableList {
    var name: String
    var url: String
    var type: ApiListType
}

extension APITableList {
    static var apiData = [
        APITableList(name: "Simple match", url: "http://numbersapi.com/random/math", type: .SimpleMatch),
//        APITableList(name: "Single with param", url: "https://list.ly/api/v4/meta?url=http://www.zoho.com", type: .SingleWithParam),
        APITableList(name: "Regex match", url: "https://www.7timer.info/bin/astro.php", type: .RegexMatch),
        APITableList(name: "Track by API ID", url: "https://ip-fast.com/api/ip/", type: .TrackByApiID)
        ]
}

