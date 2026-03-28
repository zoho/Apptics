//
//  ClientLogsRequest.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 13/02/24.
//

import Foundation


struct ClientLogsRequest : APIRequestProtocol {
            
    var path: String{
       "/api/v2/mobile/feedback/clientlogs"
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
        if let recID = APIKeySaver.shared.getKeyFor(type: .recordingID){
            dict[APIConstants.recordingIdentifierKey] = recID
        }
        dict[APIConstants.feedBackUrlsKey] = getFeedbackUrlValue().map{$0.key + "=" + $0.value}.joined(separator: ",")
        
        return dict
    }
    
    
    private func getFeedbackUrlValue() -> [String: String] {
        var dict: [String: String] = [:]
        let randomID = UUID().uuidString
        dict[APIConstants.randomkeyIdentifierKey] = randomID
        
        return [:]
    }
}
