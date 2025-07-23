//
//  APIConstants.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 31/01/24.
//

import Foundation

struct APIConstants {
    static let host = "quartz"
    static let scheme = "https"
    static let workSpaceKey = "workspaceKey"
    static let departmentKey = "departmentKey"
    
    static let videoFileKey = "videofile"
    static let videoFileValue = "videoChunk-1-part.mp4"
    
    static let recordingIdentifierKey = "recordingIdentifier"
    static let feedBackUrlsKey = "feedbackUrls"
    
    static let randomkeyIdentifierKey = "randomkeyIdentifier"
    static let timeIdentifierKey = "timeIdentifier"
    static let clientMetricsKey = "clientMetrics"
    
    static let recordingDetailsKey = "recordingDetails"
    static let editFilesKey = "editFiles"
    
    static let feedbackDetailsKey = "feedbackDetails"
    static let supportFilesKey = "supportFiles"
    
}



//struct ClientMetricsKeys{
//    requestUrl
//    method
//    statusCode
//    memory
//    usedHeapSize
//    totalHeapSize
//    paintMetrics
//}


enum QuartzResponseKey{
    static let recIDKey = "QuartzRecordingIdenfier"
    static let startTimeKey = "QuartzRecordingStartTime"
    static let deptIdKey = "QuartzRecordingDeptID"
    static let workSpaceIDKey = "QuartzRecordingWorkspaceID"
    
    case recordingID
    case startTime
    case deptId
    case workSpaceID
    
    var key: String{
        switch self {
        case .recordingID:
            return QuartzResponseKey.recIDKey
        case .startTime:
            return QuartzResponseKey.startTimeKey
        case .deptId:
            return QuartzResponseKey.deptIdKey
        case .workSpaceID:
            return QuartzResponseKey.workSpaceIDKey
        }
    }
}

class APIKeySaver{
    static let shared = APIKeySaver.init()
    private let standardUserDefault = UserDefaults.standard
    
    private init(){}
    
    
    func save(_ key: String, type: QuartzResponseKey){
        guard !key.isEmpty else {return}
        standardUserDefault.set(key, forKey: type.key)
    }
    
    func getKeyFor(type: QuartzResponseKey) -> String?{
        if let value = standardUserDefault.object(forKey: type.key) as? String, !value.isEmpty{
            return value
        }
        return nil
    }
    
}
