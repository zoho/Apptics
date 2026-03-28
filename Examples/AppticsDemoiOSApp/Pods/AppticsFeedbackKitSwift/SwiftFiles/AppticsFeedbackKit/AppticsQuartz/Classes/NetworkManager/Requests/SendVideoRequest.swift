//
//  SendVideoRequest.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 13/02/24.
//


import Foundation


struct SendVideoRequest: APIRequestProtocol {
    private let url: URL
    
    init(videoUrl: URL) {
        url = videoUrl
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
        .POST
    }
    
    var shouldIncludeAuthenticationToken: Bool{
        false
    }
    
    var urlQuery : [String : String]{
        var dict : [String : String] = [:]
        dict[APIConstants.workSpaceKey] = APIKeySaver.shared.getKeyFor(type: .workSpaceID)
        dict[APIConstants.departmentKey] = APIKeySaver.shared.getKeyFor(type: .deptId)
//        dict[APIConstants.videoFileKey] = APIConstants.videoFileValue
        
        if let recID = APIKeySaver.shared.getKeyFor(type: .recordingID){
            dict[APIConstants.recordingIdentifierKey] = recID
        }
        
        
        return dict
    }
    
    func getContentTypeAndBodyData() -> (String, Data?) {
        guard let data = try? Data(contentsOf: url) else {return ("application/json",nil)}
    
        let boundary = UUID().uuidString
        let clrf = "\r\n"

        var body = Data()
        body.append("--\(boundary)")
        body.append(clrf)
        body.append("Content-Disposition: form-data; name=\"videochunk\"; filename=\"videochunk-1-part.mp4\"")
        body.append(clrf)
        body.append("Content-Type: video/mp4")
        body.append(clrf)
        body.append(clrf)
        body.append(data)
        body.append(clrf)
        body.append("--\(boundary)--")
        body.append(clrf)
        
        return ("multipart/form-data; boundary=\(boundary)", body)
    }
}
