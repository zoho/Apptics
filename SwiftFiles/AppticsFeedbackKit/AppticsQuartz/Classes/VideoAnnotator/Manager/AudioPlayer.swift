//
//  AudioPlayer.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 29/10/23.
//

import AVKit


protocol AudioPlayerProtocol{
    var isAudioPlaying: Bool { get }
    func playAudio(from url: URL, atTime: CMTime)
    func pause()
    func stop()
    func continuePlaying()
    func sound(shouldEnable: Bool)
}

class AudioPlayer: AudioPlayerProtocol{
    
    var isAudioPlaying: Bool{
        audioPlayer?.timeControlStatus == .playing
    }
    
    private var audioPlayer: AVPlayer?
    
    func playAudio(from url: URL, atTime time: CMTime = CMTime.zero) {
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer?.seek(to: time)
        audioPlayer?.play()
        audioPlayer?.volume = 1.0
    }
    
    func pause() {
        audioPlayer?.pause()
    }
    
    func stop(){
        audioPlayer?.replaceCurrentItem(with: nil)
    }
    
    func continuePlaying() {
        audioPlayer?.play()
    }
    
    func sound(shouldEnable: Bool){
        if shouldEnable{
            audioPlayer?.volume = 1.0
        }else{
            audioPlayer?.volume = 0
        }
    }
    
}
