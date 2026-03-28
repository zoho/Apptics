//
//  SubmitRecordingRequest.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 14/02/24.
//

import Foundation

struct SubmitRecordingRequest : APIRequestProtocol {
    let feedbackDetails: [String: Any]
    let attachments: [(String,Data)]
    
    init(feedbackDetails: [String : Any], attachments: [(String, Data)]) {
        self.feedbackDetails = feedbackDetails
        self.attachments = attachments
    }
    
    var host : String {
        "\(APIConstants.host).\(QuartzKit.shared.lastUsedSubdomain.isEmpty ? QuartzKit.shared.subDomain: QuartzKit.shared.lastUsedSubdomain)"
    }
    
    var path: String{
        "/api/v2/mobile/feedback/submit"
    }
    
    var requestHeader: [String : String]{
        var dict : [String : String] = [:]
        if let recID = APIKeySaver.shared.getKeyFor(type: .recordingID){
            dict[APIConstants.recordingIdentifierKey] = recID
        }
        return dict
    }
    
    var requestType: RequestType{
        .POST
    }
    
    var shouldIncludeAuthenticationToken: Bool{
        false
    }
    
    var urlQuery : [String : String]{
        var dict : [String : String] = [:]
        dict[APIConstants.workSpaceKey] = APIKeySaver.shared.getKeyFor(type: .workSpaceID)
        dict[APIConstants.departmentKey] = APIKeySaver.shared.getKeyFor(type: .deptId)
        
        if let recID = APIKeySaver.shared.getKeyFor(type: .recordingID){
            dict[APIConstants.recordingIdentifierKey] = recID
        }
        
        do {
             let jsonData = try JSONSerialization.data(withJSONObject: feedbackDetails, options: [])
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    dict[APIConstants.feedbackDetailsKey] = jsonString
                }
         } catch {
             print("Error converting dictionary to JSON: \(error)")
            
         }
        
        return dict
    }
    
    func getContentTypeAndBodyData() -> (String, Data?) {
        if attachments.isEmpty {return ("application/json",nil)}
        var multipart = MultipartRequest()
        var attachedFiles: Set<String> = []
        var fileNumber = 1
        for (name,data) in attachments{
            let nameDecoded = name.removingPercentEncoding ?? "file"
                
            var fileNameWithExtension = nameDecoded
            var components = nameDecoded.components(separatedBy: ".")
            let fileExtension = components.removeLast()
            var fileNameWithoutExtension = components.joined(separator: ",")
            if fileNameWithoutExtension.isEmpty{
                fileNameWithoutExtension = "file"
            }
            
            if attachedFiles.contains(fileNameWithoutExtension){
                fileNameWithoutExtension = fileNameWithoutExtension + "\(fileNumber)"
                fileNameWithExtension = fileNameWithoutExtension + "." + fileExtension
                fileNumber += 1
            }
            attachedFiles.insert(fileNameWithoutExtension)
        
            multipart.add(
                key: "\(fileNameWithoutExtension)",
                fileName: "\(fileNameWithExtension)",
                fileMimeType: "application/octet-stream",
                fileData: data
            )
        }
        
        return(multipart.httpContentTypeHeadeValue, multipart.httpBody)
    }
}
