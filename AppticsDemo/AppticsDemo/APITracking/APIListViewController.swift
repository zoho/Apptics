
import UIKit

class APIListViewController: UITableViewController {
}

extension APIListViewController {
    static let apiListCellIdentifier = "APIListCell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APITableList.apiData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.apiListCellIdentifier, for: indexPath) as? APIListCell else {
            fatalError("Unable to dequeue ReminderCell")
        }
        let list = APITableList.apiData[indexPath.row]
                        
        cell.title.text = list.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = APITableList.apiData[indexPath.row]

        switch list.type {

        case .SimpleMatch, .SingleWithParam, .RegexMatch:
            self.request(url: list.url, apiId: nil)
            Toast.show(message: "Tracked api by \(list.name)", controller: self)
            break
        case .TrackByApiID:
            self.request(url: list.url, apiId: "2138769408909")
            Toast.show(message: "Tracked api by API ID", controller: self)
            break
        }
        
    }
}

extension APIListViewController {
    func request(url : String, apiId : String?) {

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        if let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest {
            if let apiId = apiId{
                mutableRequest.addValue(apiId, forHTTPHeaderField: "API-ID")
            }
            
            let configuration = URLSessionConfiguration.default
            APAPIManager.enable(for: configuration)
            let session = URLSession(configuration: configuration)

            let task = session.dataTask(with: mutableRequest as URLRequest, completionHandler: { data, response, error -> Void in
                if let data = data{
                    let string = String(decoding: data, as: UTF8.self)
                    print(string)
                }
                else{
                    print("error \(error)")
                }
            })

            task.resume()
        }
    }
}
