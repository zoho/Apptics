//
//  AudioRecordingManager.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 25/10/23.
//

import Foundation
import AVFoundation

protocol AudioRecorderProtocol{
    var isRecordingInProgress: Bool { get }
    func startRecording()
    func stopRecording() -> URL?
}

class AudioRecorder: AudioRecorderProtocol {
    var isRecordingInProgress: Bool {
        audioRecorder?.isRecording ?? false
    }
    private static let audioRecordingFolderName = "RecordedAudioFiles"
    private var audioRecorder: AVAudioRecorder?
    private var currentRecordingURL: URL?
    
    init() {
        AudioRecorder.deleteAllRecordings()
        createAudioDirectoryIfNeeded()
    }
    
    private func createAudioDirectoryIfNeeded() {
        let audioDirectory = AudioRecorder.getAudioDirectory()
        if !FileManager.default.fileExists(atPath: audioDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: audioDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating audio directory: \(error.localizedDescription)")
            }
        }
    }
    
    private func generateUniqueFileName() -> URL {
        let audioDirectory = AudioRecorder.getAudioDirectory()
        let uniqueFileName = UUID().uuidString + ".m4a"
        return audioDirectory.appendingPathComponent(uniqueFileName)
    }
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers, AVAudioSession.CategoryOptions.defaultToSpeaker , AVAudioSession.CategoryOptions.allowBluetoothA2DP])
            try audioSession.setActive(true)
            
            // Specify the file URL where the audio will be saved (with a unique file name)
            let audioFilename = generateUniqueFileName()
            currentRecordingURL = audioFilename
            
            // Define the settings for the audio recorder
            let settings: [String: Any] = [
                AVFormatIDKey: kAudioFormatMPEG4AAC, // AAC format
                AVSampleRateKey: 44100.0, // Sample rate in Hz
                AVNumberOfChannelsKey: 2, // Number of audio channels: 2 for stereo
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue // Audio quality
            ]
            
            // Initialize the audio recorder with the settings and file URL
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            
            // Start recording
            audioRecorder?.record()
        } catch {
            // Handle any errors that occur during initialization
            print("Error starting recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() -> URL? {
        audioRecorder?.stop()
        return currentRecordingURL
    }
    
    
    private static func getAudioDirectory() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioDirectory = documentsDirectory.appendingPathComponent(AudioRecorder.audioRecordingFolderName)
        return audioDirectory
    }
    
    
    static func deleteAllRecordings(){
        let audioDirectory = getAudioDirectory()
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: audioDirectory, includingPropertiesForKeys: nil, options: [])
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch {
            print("Error deleting recordings: \(error.localizedDescription)")
        }
    }
}

