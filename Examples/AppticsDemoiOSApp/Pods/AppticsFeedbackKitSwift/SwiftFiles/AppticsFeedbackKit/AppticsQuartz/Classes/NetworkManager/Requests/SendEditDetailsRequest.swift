//
//  SendEditDetailsRequest.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 14/02/24.
//

import Foundation


struct SendEditDetailsRequest: APIRequestProtocol {
        
    let recDetails: [String: Any]
    let shapeInfo: [(String,Data)]
    let audioInfo: [(String,Data)]
    
    init(recDetails: [String: Any], shapeInfo: [(String,Data)], audioInfo: [(String,Data)]) {
        self.recDetails = recDetails
        self.shapeInfo = shapeInfo
        self.audioInfo = audioInfo
    }
    
    var host : String {
        "\(APIConstants.host).\(QuartzKit.shared.lastUsedSubdomain.isEmpty ? QuartzKit.shared.subDomain: QuartzKit.shared.lastUsedSubdomain)"
    }
    
    var path: String{
        "/api/v2/mobile/feedback/video"
    }
    
    var requestHeader: [String : String]{
        var dict : [String : String] = [:]
        if let recID = APIKeySaver.shared.getKeyFor(type: .recordingID){
            dict[APIConstants.recordingIdentifierKey] = recID
        }
        return dict
    }
    
    var requestType: RequestType{
        .PUT
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
        return dict
    }
    
    func getContentTypeAndBodyData() -> (String, Data?) {
        var multipart = MultipartRequest()
        
        do {
             let jsonData = try JSONSerialization.data(withJSONObject: recDetails, options: [])
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    multipart.add(key: APIConstants.recordingDetailsKey, value: jsonString)
                }
         } catch {
             print("Error converting dictionary to JSON: \(error)")
         }

        
        for (index,info) in shapeInfo.enumerated() {
            multipart.add(
                key: "elem\(index+1)",
                fileName: "elem\(index+1).png",
                fileMimeType: "image/png",
                fileData:(info.1)
            )
        }

        for (index,info) in audioInfo.enumerated(){
            multipart.add(
                key: "audio\(index+1)",
                fileName: "audio\(index+1).m4a",
                fileMimeType: "application/octet-stream",
                fileData:(info.1)
            )
        }
        
        return(multipart.httpContentTypeHeadeValue, multipart.httpBody)
    }
}


public extension Data {
    mutating func append(_ string: String,encoding: String.Encoding = .utf8) {
        guard let data = string.data(using: encoding) else {
            return
        }
        append(data)
    }
}


public struct MultipartRequest {
    
    public let boundary: String
    
    private let separator: String = "\r\n"
    private var data: Data

    public init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
        self.data = .init()
    }
    
    private mutating func appendBoundarySeparator() {
        data.append("--\(boundary)\(separator)")
    }
    
    private mutating func appendSeparator() {
        data.append(separator)
    }

    private func disposition(_ key: String) -> String {
        "Content-Disposition: form-data; name=\"\(key)\""
    }

    public mutating func add(
        key: String,
        fileName: String,
        fileMimeType: String,
        fileData: Data) {
        appendBoundarySeparator()
        data.append(disposition(key) + "; filename=\"\(fileName)\"" + separator)
        data.append("Content-Type: \(fileMimeType)" + separator + separator)
        data.append(fileData)
        appendSeparator()
    }

    public mutating func add(
        key: String,
        value: String) {
        appendBoundarySeparator()
        data.append(disposition(key) + separator)
        appendSeparator()
        data.append(value + separator)
    }

    
    public var httpContentTypeHeadeValue: String {
        "multipart/form-data; boundary=\(boundary)"
    }

    public var httpBody: Data {
        var bodyData = data
        bodyData.append("--\(boundary)--")
        return bodyData
    }
}
