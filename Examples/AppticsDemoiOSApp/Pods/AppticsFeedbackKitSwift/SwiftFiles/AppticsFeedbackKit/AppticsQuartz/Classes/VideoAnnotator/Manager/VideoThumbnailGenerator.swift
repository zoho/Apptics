//
//  VideoThumbnailGenerator.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 28/11/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import Foundation
import AVKit

protocol VideoThumbnailGenerationProtocol {
    func generateThumbnail(for asset: AVAsset, at time: CMTime, completion: @escaping (UIImage?) -> Void)
}

class ThumbnailGenerator: VideoThumbnailGenerationProtocol{
    func generateThumbnail(for asset: AVAsset, at time: CMTime, completion: @escaping (UIImage?) -> Void) {
        generateThumbnail(for: asset, at: time, totalNumberOfMaxCalls: 5, completion: completion)
    }
    
    private func generateThumbnail(for asset: AVAsset, at time: CMTime, callCount: Int = 1, totalNumberOfMaxCalls: Int, completion: @escaping (UIImage?) -> Void){
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.requestedTimeToleranceAfter = CMTime.zero
        imageGenerator.requestedTimeToleranceBefore = CMTime.zero
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let image = UIImage(cgImage: cgImage)
            completion(image)
        } catch {
            if callCount < 5 {
                
                let milliseconds: Int64 = 500
                let timeScale: Int32 = 1000
                let cmTime = CMTimeMake(value: milliseconds, timescale: timeScale)
                let newTime = CMTimeSubtract(time, cmTime)
                generateThumbnail(for: asset, at: newTime, callCount: callCount+1, totalNumberOfMaxCalls: totalNumberOfMaxCalls, completion: completion)
            }else{
                print("Error generating thumbnail: \(error)")
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
