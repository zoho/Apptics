//
//  RecordingKeysDetailsRequest.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 25/03/24.
//

import Foundation

struct RecordingKeysDetailsRequest : APIRequestProtocol {

    var path: String{
        "/api/v2/\(QuartzKit.shared.workspace)/\(QuartzKit.shared.department)/keys"
    }
    
    var requestType: RequestType{
        .GET
    }
    
    var shouldIncludeAuthenticationToken: Bool{
        false
    }
    
}
