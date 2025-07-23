//
//  QuartzDataManager.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 12/02/24.
//

import Foundation
import OSLog
import os
import AVFoundation

class QuartzDataManager{
    static let shared = QuartzDataManager()
    private let reqManager = RequestManager()
    
    private init(){}
    
    func fetchDepartmentAndWorkspaceKey() async -> Bool {
        let recordingKeysDetailsRequest = RecordingKeysDetailsRequest()
        do{
            let recordingDetails: RecordingDetailsResponse = try await reqManager.perform(recordingKeysDetailsRequest)
            APIKeySaver.shared.save(recordingDetails.departmentRefId, type: .deptId)
            APIKeySaver.shared.save(recordingDetails.workspaceRefId, type: .workSpaceID)
            
            return true
        }catch{
            print("Error:\(error.localizedDescription)")
            stopNetworkInceptionIfStarted()
            return false
        }
    }
    
    func recordingStarted() async -> Bool {
        startNetworkInceptionIfAllowed()
        let startRecordingRequest = StartRecordingRequest()
        do{
            let recordingInfo: StartRecordingResponse = try await reqManager.perform(startRecordingRequest)
            save(recordingInfo: recordingInfo)
            return true
        }catch{
            print("Error:\(error.localizedDescription)")
            stopNetworkInceptionIfStarted()
            return false
        }
    }
    
    func recordingEnded(){
        stopNetworkInceptionIfStarted()
    }
    
    private func save(recordingInfo: StartRecordingResponse){
        APIKeySaver.shared.save(String(QuartzDataManager.currentTimeInMilliSeconds()), type: .startTime)
        APIKeySaver.shared.save(recordingInfo.recordingIdentifier, type: .recordingID)
    }
    
    static func currentTimeInMilliSeconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    
    public func sendVideo(url: URL) async -> Bool {
        let sendVideoRequest = SendVideoRequest.init(videoUrl: url)
        do{
            let _: [String:String]  = try await reqManager.perform(sendVideoRequest)
            return true
        }catch{
            return false
        }
    }
    
    public func sendEditInfo(videoInfo: VideoSendEditDetailsInfo) async -> Bool {
        let (recDetails, shapeInfo, audioInfo) = await getRecordingAnnotationDetails(for: videoInfo)
        let sendVideoRequest = SendEditDetailsRequest(recDetails: recDetails, shapeInfo: shapeInfo, audioInfo: audioInfo)
        do{
            let _: [String:String]  = try await reqManager.perform(sendVideoRequest)
            return true
        }catch{
            return false
        }
    }
    
    public func submitRecording(recordingInfo: SubmitRecordingDetail) async -> FeedbackResponse? {
        let videoInfo = getSubmitRecordingDetails(for: recordingInfo)
        let submitRecordingRequest = SubmitRecordingRequest(feedbackDetails: videoInfo, attachments: recordingInfo.files)
        do{
            let response: FeedbackResponse  = try await reqManager.perform(submitRecordingRequest)
            return response
        }catch{
            return nil
        }
    }
    
    private func startNetworkInceptionIfAllowed(){
        if QuartzKit.shared.shouldRecordNetworkLogs{
            URLSession.sessionInterception(true)
        }
    }
    
    private func stopNetworkInceptionIfStarted(){
        if QuartzKit.shared.shouldRecordNetworkLogs{
            URLSession.sessionInterception(false)
        }
    }
    
    @MainActor
    private func getRecordingAnnotationDetails(for videoDetails: VideoSendEditDetailsInfo) -> ([String: Any], [(String, Data)], [(String, Data)])  {
        var dictToReturn: [String: Any] = [:]
        var shapeInfo: [(String, Data)] = []
        var audioInfo: [(String, Data)] = []
        
        var videoInfoDict: [String: Any] = [:]
        videoInfoDict[RecordingDetailsInfoKeys.isVideoTrimmed] = videoDetails.isVideoTrimmed
        videoInfoDict[RecordingDetailsInfoKeys.startTime] = round(num: CMTimeGetSeconds(videoDetails.startTime))
        videoInfoDict[RecordingDetailsInfoKeys.endTime] = round(num: CMTimeGetSeconds(videoDetails.endTime))
        
        dictToReturn[RecordingDetailsInfoKeys.videoInfo] = videoInfoDict
        
        
        var imageInfoDict: [String: Any] = [:]
        
        for (index,dict) in videoDetails.addedShape.enumerated(){
            let name = "elem\(index+1).png"
            var individualShapeDict: [String: Any] = [:]
            switch dict.value.shape.type{
            case .rectangle:
                individualShapeDict[RecordingDetailsInfoKeys.type] = "rectangle"
                
            case .circle:
                individualShapeDict[RecordingDetailsInfoKeys.type] = "ellipse"
                
            case .arrow:
                individualShapeDict[RecordingDetailsInfoKeys.type] = "arrow"
                
            case .blur:
                individualShapeDict[RecordingDetailsInfoKeys.type] = "blur"
                
            case .text:
                individualShapeDict[RecordingDetailsInfoKeys.type] = "text"
                
            case .block:
                individualShapeDict[RecordingDetailsInfoKeys.type] = "block"
            }
            
            
            individualShapeDict[RecordingDetailsInfoKeys.startTime] = round(num: CMTimeGetSeconds(dict.value.startTime))
            individualShapeDict[RecordingDetailsInfoKeys.endTime] = round(num: CMTimeGetSeconds(dict.value.endTime))
            
            let frame = dict.value.rect.getDimentionFactors()
            individualShapeDict[RecordingDetailsInfoKeys.leftPos] = round(num: frame.0*100)
            individualShapeDict[RecordingDetailsInfoKeys.topPos] = round(num: frame.1*100)
            individualShapeDict[RecordingDetailsInfoKeys.width] = round(num: frame.2*100)
            individualShapeDict[RecordingDetailsInfoKeys.height] = round(num: frame.3*100)
            let isHidden = dict.key.isHidden
            dict.key.isHidden = false
            let img = dict.key.asImage()
            dict.key.isHidden = isHidden
            if let imgData = img.pngData(){
                shapeInfo.append((name, imgData))
            }
            imageInfoDict[name] = individualShapeDict
            
        }
        dictToReturn[RecordingDetailsInfoKeys.imageinfo] = imageInfoDict
        
        var audioInfoDict: [String: Any] = [:]
        audioInfoDict[RecordingDetailsInfoKeys.isOriginalTrackDeleted] = videoDetails.isOriginalAudioTrackInVideoRecordingDeleted
        audioInfoDict[RecordingDetailsInfoKeys.isAudioRecorded] = videoDetails.isAudioRecorded
        
        for (index,audio) in videoDetails.audios.enumerated(){
            let name = "audio\(index+1).m4a"
            var individualAudioDict: [String: Any] = [:]
            individualAudioDict[RecordingDetailsInfoKeys.startTime] = round(num: CMTimeGetSeconds(audio.videoStartTime))
            individualAudioDict[RecordingDetailsInfoKeys.endTime] = round(num: CMTimeGetSeconds(audio.videoEndTime))
            
            audioInfoDict[name] = individualAudioDict
            if let audioData = try? Data(contentsOf:audio.fileUrl){
                audioInfo.append((name, audioData))
            }
        }
        
        dictToReturn[RecordingDetailsInfoKeys.audioInfo] = audioInfoDict
        return (dictToReturn, shapeInfo, audioInfo)
    }
    
    private func getSubmitRecordingDetails(for submitRecordingDetails: SubmitRecordingDetail) -> [String: Any]{
        var retDict: [String: Any] = [:]
        var environmentDetailsDict: [String: Any] = [:]
        environmentDetailsDict[SubmitRecordingInfoKeys.deviceName] = submitRecordingDetails.deviceName
        environmentDetailsDict[SubmitRecordingInfoKeys.os] = submitRecordingDetails.os
        environmentDetailsDict[SubmitRecordingInfoKeys.osVersion] = submitRecordingDetails.osVersion
        environmentDetailsDict[SubmitRecordingInfoKeys.appVersion] = submitRecordingDetails.appVersion
        var screenDict: [String: Any] = [:]
        screenDict[SubmitRecordingInfoKeys.width] = submitRecordingDetails.deviceWidth
        screenDict[SubmitRecordingInfoKeys.height] = submitRecordingDetails.deviceHeight
        environmentDetailsDict[SubmitRecordingInfoKeys.screen] = screenDict
        
        retDict[SubmitRecordingInfoKeys.environmentDetails] = environmentDetailsDict
        
        var userDetailsDict: [String: Any] = [:]
        let isTicketNumberPresent = !submitRecordingDetails.ticketNumber.isEmpty
        
        if !isTicketNumberPresent, !submitRecordingDetails.subject.isEmpty{
            userDetailsDict[SubmitRecordingInfoKeys.subject] = submitRecordingDetails.subject
        }
        if !submitRecordingDetails.description.isEmpty{
            userDetailsDict[SubmitRecordingInfoKeys.problemDescription] = submitRecordingDetails.description
        }
        
        if !submitRecordingDetails.email.isEmpty{
            userDetailsDict[SubmitRecordingInfoKeys.email] = submitRecordingDetails.email
        }
        
        retDict[SubmitRecordingInfoKeys.userDetails] = userDetailsDict
        
        retDict[SubmitRecordingInfoKeys.networkSpeed] = "20.00 Mbps"
        retDict[SubmitRecordingInfoKeys.departmentName] = submitRecordingDetails.departmentName
        if isTicketNumberPresent, !submitRecordingDetails.ticketNumber.isEmpty{
            retDict[SubmitRecordingInfoKeys.ticketNumber] = submitRecordingDetails.ticketNumber
        }
        
        return retDict
    }
    
    private func round(num: Double) -> Double{
        let roundedNumber = (num * 100).rounded() / 100
        return roundedNumber
    }
    
}

struct StartRecordingResponse: Codable{
    let startTime: Int
    let recordingIdentifier: String
}

struct RecordingDetailsResponse: Codable{
    let workspaceRefId: String
    let departmentRefId: String
}

struct SubmitRecordingInfoKeys{
    static let environmentDetails = "environmentDetails"
    static let deviceName = "deviceName"
    static let os = "os"
    static let osVersion = "osVersion"
    static let appVersion = "appVersion"
    static let screen = "screen"
    static let width = "width"
    static let height = "height"
    static let userDetails = "userDetails"
    static let subject = "subject"
    static let problemDescription = "problemDescription"
    static let email = "email"
    static let networkSpeed = "networkSpeed"
    
    static let departmentName = "departmentName"
    static let ticketNumber = "ticketNumber"
}


struct RecordingDetailsInfoKeys{
    static let videoInfo = "videoInfo"
    static let isVideoTrimmed = "isVideoTrimmed"
    static let startTime = "startTime"
    static let endTime = "endTime"
    
    static let imageinfo = "imageInfo"
    
    static let type = "type"
    
    static let height = "height"
    static let width = "width"
    static let leftPos = "leftPos"
    static let topPos = "topPos"
    
    static let audioInfo = "audioInfo"
    
    static let isOriginalTrackDeleted = "isOriginalTrackDeleted"
    static let isAudioRecorded = "isAudioRecorded"
}

extension Double {
    func roundToTwoPlaces() -> Double {
        return self*1000.rounded() / 1000
    }
}

struct SubmitRecordingDetail{
    let deviceName: String
    let os: String
    let osVersion: String
    let appVersion: String
    let deviceWidth: Int
    let deviceHeight: Int
    
    let subject: String //only if ticketNumber is not present
    let description: String
    let email: String
    
    let networkSpeed: String
    let departmentName: String = "Creator"
    let ticketNumber: String
    
    let files: [(String, Data)]
}

struct FeedbackResponse: Codable{
    let feedbackLink: String
    let feedbackRefId: String
    let domain: String
    let messageId: Int
    let departmentType: Int
}
