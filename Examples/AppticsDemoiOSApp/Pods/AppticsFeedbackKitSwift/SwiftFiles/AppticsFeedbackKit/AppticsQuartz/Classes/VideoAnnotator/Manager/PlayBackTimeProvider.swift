//
//  PlayBackTimeProvider.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 14/09/23.
//

import Foundation
import CoreMedia

protocol PlayBackTimeProviderProtocol{
    var forwardSkipTime: CMTime{ get }
    var backwardSkipTime: CMTime{ get }
    func getTimeStrForVideo(curDuration: CMTime, totalDuration: CMTime) -> String
    func getTimeStrForVideo(curDuration: CMTime) -> String
    func getTimmedDurationString(from: CMTime, to: CMTime) -> String
}

struct PlayBackTimeProvider: PlayBackTimeProviderProtocol{
    private let forwardTimeInDouble: Double = 5
    private let backwardTimeInDouble: Double = 5
    
    var forwardSkipTime: CMTime{
        CMTime(seconds: forwardTimeInDouble, preferredTimescale: 1)
    }
    
    var backwardSkipTime: CMTime{
        CMTime(seconds: backwardTimeInDouble, preferredTimescale: 1)
    }
    
    private let durationFormat = "%02d:%02d"
    
    func getTimeStrForVideo(curDuration: CMTime, totalDuration: CMTime) -> String {
        let curText = formatTime(seconds: curDuration)
        let totalText = formatTime(seconds: totalDuration)
        return "\(curText)/\(totalText)"
    }
    
    func getTimeStrForVideo(curDuration: CMTime) -> String {
        let curText = formatTime(seconds: curDuration)
        return "\(curText)"
    }
    
    func getTimmedDurationString(from: CMTime, to: CMTime) -> String {
        let curText = formatTime(seconds: from)
        let totalText = formatTime(seconds: to)
        return "\(curText) - \(totalText)"
    }
    
    private func formatTime(seconds: CMTime) -> String {
        let secondsInDouble = CMTimeGetSeconds(seconds)
        guard !secondsInDouble.isNaN else{return " "}
        let minutes = Int(secondsInDouble) / 60
        let seconds = Int(secondsInDouble) % 60
        return String(format: durationFormat , minutes, seconds)
    }
}
