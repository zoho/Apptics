//
//  ScreenRecorder.swift
//  Creator
//
//  Created by Ganesh Arora on 23/08/23.
//  Copyright © 2023 Zoho. All rights reserved.
//
import UIKit
import ReplayKit
import Foundation

public class ScreenRecorder: NSObject, RPPreviewViewControllerDelegate{
    
    static private let screenRecInitiationFailureMessage = QuartzKitStrings.localized("general.label.recordingintiationfailed")
    static private let okMessage = QuartzKitStrings.localized("general.label.ok")
    
    private static var sharedInstance: ScreenRecorder = {
        return ScreenRecorder()
    }()
    
    private let recorder = RPScreenRecorder.shared()
    private var savedVideoData: Data?
    public static let recordedVideoURLKey = "ScreenRecordedVideoURL"
    static let isScreenRecordingStartedByQuartz = "isScreenRecordingStartedByQuartz"
    
    internal static let directoryName = "QuartzVideos"
    internal static let annotatedVideoName = "AnnotatedVideo.mov"
    
    func startScreenRecording(completion: @escaping (Result<Bool, Error>) -> Void) {
        if recorder.isRecording{
            stopBuffering()
            return
        }
        //    https://forums.developer.apple.com/forums/thread/88189 (Alert message cannot be changed)
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case .denied:
            RPScreenRecorder.shared().isMicrophoneEnabled = false
            
        default:
            RPScreenRecorder.shared().isMicrophoneEnabled = true
        }
        
        QuartzKit.shared.cleanUpVideoAndAudioSavedFiles()
        UserDefaults.standard.setValue(true, forKey: ScreenRecorder.isScreenRecordingStartedByQuartz)
        RPScreenRecorder.shared().startRecording{ err in
            DispatchQueue.main.async {
                if let err = err {
                    UserDefaults.standard.setValue(false, forKey: ScreenRecorder.isScreenRecordingStartedByQuartz)
                    completion(.failure(err))
                }else{
                    UserDefaults.standard.setValue(true, forKey: ScreenRecorder.isScreenRecordingStartedByQuartz)
                    self.initiateNetworkInterceptionAndFetchRecordingID()
                    completion(.success(true))
                }
            }
        }
    }
    
    private func initiateNetworkInterceptionAndFetchRecordingID(){
        Task{
            let isDeptAndWorkspaceIdFetched = await QuartzDataManager.shared.fetchDepartmentAndWorkspaceKey()
            if !isDeptAndWorkspaceIdFetched {
                presentScreenRecordingFailureAlert()
                return
            }
            let isRecordingIdFetchedSuccessfully = await QuartzDataManager.shared.recordingStarted()
            if !isRecordingIdFetchedSuccessfully{
                presentScreenRecordingFailureAlert()
            }
        }
    }

    
    private func presentScreenRecordingFailureAlert(){
        DispatchQueue.main.async {
            QuartzRecordingTimeNotifier.shared.stopClicked(isRecordingFailed: true)
            self.presentScreenRecordingFailedAlert()
        }
    }
    
    func presentScreenRecordingFailedAlert(){
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let alert = UIAlertController(title: nil, message: ScreenRecorder.screenRecInitiationFailureMessage , preferredStyle: .alert)
            let action = UIAlertAction(title: ScreenRecorder.okMessage , style: .default)
            alert.addAction(action)
            
            topController.present(alert, animated: true)
        }
    }
    
    
    public func stopScreenRecording(isSuccess: ((Bool) -> Void)?) {
        UserDefaults.standard.setValue(false, forKey: ScreenRecorder.isScreenRecordingStartedByQuartz) // Indicated no active screen recording
        if recorder.isRecording{
            QuartzDataManager.shared.recordingEnded()
            stopBuffering(completion: isSuccess)
        }else{
            DispatchQueue.main.async {
                isSuccess?(false)
            }
        }
    }
    
    func stopBuffering(completion: ((Bool) -> Void)? = nil){
        let tempDirectory = NSTemporaryDirectory()
        let quartzDirectoryURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent(ScreenRecorder.directoryName, isDirectory: true)

        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(at: quartzDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            let clipURL: URL = quartzDirectoryURL.appendingPathComponent("\(ScreenRecorder.annotatedVideoName)")
            if #available(iOS 14.0, *) {
                RPScreenRecorder.shared().stopRecording(withOutput: clipURL){handler in
                    UserDefaults.standard.set(clipURL, forKey: ScreenRecorder.recordedVideoURLKey)
                    DispatchQueue.main.async {
                        completion?(handler==nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion?(false)
                }
            }
        } catch {
            print("Failed to create directory: \(error.localizedDescription)")
            DispatchQueue.main.async {
                completion?(false)
            }
        }
    }
    
    public static func shared() -> ScreenRecorder {
        return sharedInstance
    }
    
    
    public static func isScreenRecording() -> Bool{
        RPScreenRecorder.shared().isRecording
    }
}

class QuartzFileManager{
    static func getDataFromVideoFileURL(videoUrl: URL) -> Data? {
        do {
            let data = try Data(contentsOf: videoUrl)
            return data
        } catch {
            print("Error reading video data: \(error.localizedDescription)")
            return nil
        }
    }
}
