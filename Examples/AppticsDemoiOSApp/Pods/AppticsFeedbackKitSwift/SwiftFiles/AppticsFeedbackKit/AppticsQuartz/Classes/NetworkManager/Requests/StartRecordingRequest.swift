//
//  StartRecordingRequest.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 01/02/24.
//

import Foundation

/*
Response
recordingIdentifier - unique Identifier for the recording
startTime - time when the api hit the server
*/

struct StartRecordingRequest : APIRequestProtocol {
            
    var path: String{
        "/api/v2/mobile/feedback/start"
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
        return dict
    }
}
