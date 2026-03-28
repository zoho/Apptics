//
//  AudioMergingManager.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 27/10/23.
//

import AVFoundation
import UIKit
import Photos

struct VideoModel{
    let url: URL
    
    private(set) var videoStartTime: CMTime
    private(set) var videoEndTime: CMTime
    
    mutating func changeStartTime(to: CMTime){
        self.videoStartTime = to
    }
    
    mutating func changeEndTime(to: CMTime){
        self.videoEndTime = to
    }
}

protocol AudioMergingManagerProtocol{
    func mergeAudioSegmentsWithVideo(audioModels: [RecordedAudioModel], videoModel: VideoModel, outputURL: URL,   addedShapeDict: [UIView:AddedShapeDetails], completion: @escaping (Bool) -> Void)
}

class AudioMergingManager: AudioMergingManagerProtocol{
    
    func mergeAudioSegmentsWithVideo(audioModels: [RecordedAudioModel],
                                     videoModel: VideoModel,
                                     outputURL: URL,
                                     addedShapeDict: [UIView:AddedShapeDetails],
                                     completion: @escaping (Bool) -> Void) {
        let composition = AVMutableComposition()
        
        var filteredAudioModels = audioModels.filter { audioModel in // Removing audios not in the video range
            
            if audioModel.videoStartTime >= videoModel.videoStartTime,
               audioModel.videoEndTime <= videoModel.videoEndTime { // Audio is completly inside video duration
                return true
            }
            
            if audioModel.videoStartTime >= videoModel.videoStartTime ||
                audioModel.videoEndTime <= videoModel.videoEndTime {
                return true
            }
            
            return false
        }
        
        if videoModel.videoStartTime != CMTime.zero{
            filteredAudioModels = filteredAudioModels.map({ audioModel in
                var model = audioModel
                /*
                 case 1 // Font & back are inside
                 case 2 // Front is outside back is inside
                 case 3 // Front is inside back is outside
                 case 4 // Front & back are outside
                 */
                
                if audioModel.videoStartTime >= videoModel.videoStartTime &&  // case 1 -> Front & back are inside
                    audioModel.videoEndTime <= videoModel.videoEndTime{
                    let newVideoStartTime = CMTimeSubtract(model.videoStartTime, videoModel.videoStartTime)
                    let newVideoEndTime = CMTimeSubtract(model.videoEndTime, videoModel.videoStartTime)
                    model.updateVideo(newStartTime: newVideoStartTime, newEndTime: newVideoEndTime)
                }
                
                if audioModel.videoStartTime <= videoModel.videoStartTime &&  // case 2 -> Front is outside back is inside
                    audioModel.videoEndTime <= videoModel.videoEndTime{
                    
                    let newVideoStartTime = CMTime.zero
                    let newVideoEndTime = CMTimeSubtract(model.videoEndTime, videoModel.videoStartTime)
                    model.updateVideo(newStartTime: newVideoStartTime, newEndTime: newVideoEndTime)
                    
                    let newAudioStartTime = CMTimeSubtract(videoModel.videoStartTime, audioModel.videoStartTime)
                    let newAudioEndTime = audioModel.audioEndTime
                    
                    model.updateAudio(newStartTime: newAudioStartTime, newEndTime: newAudioEndTime)
                }
                
                if audioModel.videoStartTime >= videoModel.videoStartTime &&  // case 3 -> Front is inside back is outside
                    audioModel.videoEndTime >= videoModel.videoEndTime{
                    
                    let newVideoStartTime = CMTimeSubtract(model.videoStartTime, videoModel.videoStartTime)
                    let newVideoEndTime = CMTimeSubtract(videoModel.videoEndTime,model.videoEndTime)
                    model.updateVideo(newStartTime: newVideoStartTime, newEndTime: newVideoEndTime)
                    
                    
                    let newAudioStartTime = audioModel.audioStartTime
                    let newAudioEndTime =  CMTimeAdd(audioModel.audioStartTime, CMTimeSubtract(videoModel.videoEndTime, audioModel.audioStartTime))
                    
                    model.updateAudio(newStartTime: newAudioStartTime, newEndTime: newAudioEndTime)
                }
                
                if audioModel.videoStartTime <= videoModel.videoStartTime &&  // case 4 -> Font & back are outside
                    audioModel.videoEndTime >= videoModel.videoEndTime{
                    
                    let newVideoStartTime = videoModel.videoStartTime
                    let newVideoEndTime = videoModel.videoEndTime
                    model.updateVideo(newStartTime: newVideoStartTime, newEndTime: newVideoEndTime)
                    
                    
                    let newAudioStartTime = CMTimeAdd(audioModel.audioStartTime, CMTimeSubtract(videoModel.videoStartTime, audioModel.audioStartTime))
                    let newAudioEndTime =  CMTimeSubtract(videoModel.videoEndTime,videoModel.videoStartTime)
                    
                    model.updateAudio(newStartTime: newAudioStartTime, newEndTime: newAudioEndTime)
                }
                return model
            })
        }
        
        // Add video track
        let videoAsset = AVURLAsset(url: videoModel.url)
        let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        do {
            let timeRange = CMTimeRange(start: videoModel.videoStartTime, duration: CMTimeSubtract(videoModel.videoEndTime, videoModel.videoStartTime))
            try videoTrack?.insertTimeRange(timeRange, of: videoAsset.tracks(withMediaType: .video)[0], at: CMTime.zero)
        } catch {
            print("Error adding video track: \(error)")
            completion(false)
        }
        
        
        // Merge audio segments
        for audioModel in filteredAudioModels {
            let asset = AVURLAsset(url: audioModel.fileUrl)
            let audioStartTime = audioModel.audioStartTime
            let audioDuration = CMTimeSubtract(audioModel.audioEndTime, audioModel.audioStartTime)
            
            let timeRange = CMTimeRange(start: audioStartTime, duration: audioDuration)
            
            do {
                let track = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
                try track?.insertTimeRange(timeRange, of: asset.tracks(withMediaType: .audio)[0], at: audioModel.videoStartTime)
            } catch {
                print("Error merging audio: \(error)")
                completion(false)
            }
        }
        let videoSize = videoTrack?.naturalSize ?? CGSize.zero
        let videoComposition = getVideoComposition(forVideoSize: videoSize,composition: composition, videoTrack: videoTrack!, shapeDict: addedShapeDict)
        
        // Export merged composition
        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputFileType = .mp4
        exportSession?.outputURL = outputURL
        exportSession?.videoComposition = videoComposition
        
        exportSession?.exportAsynchronously(completionHandler: {
            if exportSession?.status == .completed {
                print("Video merging completed successfully!")
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
                }) { saved, error in
                    if saved {
                        //                        let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                        //                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        //                        alertController.addAction(defaultAction)
                        //                        self.present(alertController, animated: true, completion: nil)
                    }else{
                        print("Saving Error")
                    }
                }
                
                completion(true)
                
            } else if exportSession?.status == .failed {
                if let error = exportSession?.error {
                    print("Error merging video: \(error)")
                    completion(false)
                }
            }
        })
    }
    
    
    private func getVideoComposition(forVideoSize videoSize : CGSize,
                                     composition: AVMutableComposition,
                                     videoTrack: AVMutableCompositionTrack,
                                     shapeDict: [UIView:AddedShapeDetails]) -> AVMutableVideoComposition{
        // Add rectangle shape layer
        let rectangleLayer = CALayer()
        let rectangleSize = CGSize(width: 100, height: 100) // Adjust the size as per your requirements
        rectangleLayer.bounds = CGRect(origin: .zero, size: rectangleSize)
        rectangleLayer.position = CGPoint(x: videoSize.width / 2, y: videoSize.height / 2)
        rectangleLayer.backgroundColor = UIColor.red.cgColor
        
        let parentLayer = CALayer()
        parentLayer.frame = CGRect(origin: .zero, size: videoSize)
        
        let videoLayer = CALayer()
        videoLayer.backgroundColor = UIColor.black.cgColor
        
        videoLayer.frame = CGRect(origin: .zero, size: videoSize)
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(rectangleLayer)
        
//        for (key,value) in shapeDict{
//            let img = key.asImage()
//            print(img)
//            print(value)
//            
//            rectangleLayer.contents = img
////            rectangleLayer.contentsGravity = .resizeAspectFill
//        }
        
        // Apply composition instructions
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30) // Assuming 30 frames per second, adjust as needed
        
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
        
        // Set video composition instructions
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: CMTime.zero, duration: composition.duration)
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        instruction.layerInstructions = [layerInstruction]
        videoComposition.instructions = [instruction]
        
        
        return videoComposition
    }
}


extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
