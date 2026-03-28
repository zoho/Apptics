//
//  AudioRowViewModel.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 23/02/24.
//

import UIKit
import CoreMedia
import ReplayKit

class AudioRowViewModel{
    
    weak var viewDelegate: AudioViewProtocol? = nil
    weak var annotationVMDelegate: AnnotationAudioVMProtocol? = nil
    
    var list:[AudioModel] = []
    var timeToViewDictionary: [String: (UIView, CMTime)] = [:]
    
    var currentlyActiveRecordingModelIndex: Int = 0
    
    var selectedAudioBlockView: AudioBlockView? = nil
    var selectedAudioBlockViewStartTime: CMTime? = nil
    
    var totalWidthOfScrollView: CGFloat
    var totalDurationOfVideo: CMTime
    
    init(viewDelegate: AudioViewProtocol? = nil,
         annotationVMDelegate: AnnotationAudioVMProtocol? = nil,
         list: [AudioModel] = [],
         currentlyActiveRecordingModelIndex: Int = 0,
         totalWidthOfScrollView: CGFloat = 0,
         totalDurationOfVideo: CMTime) {
        self.viewDelegate = viewDelegate
        self.annotationVMDelegate = annotationVMDelegate
        self.totalWidthOfScrollView = totalWidthOfScrollView
        self.totalDurationOfVideo = totalDurationOfVideo
        self.annotationVMDelegate?.audioVMDelegate = self
        self.list = list
        self.currentlyActiveRecordingModelIndex = currentlyActiveRecordingModelIndex
    }
}


extension AudioRowViewModel: AudioViewModelProtocol{
    
    func recordingStarted(at startTime: CMTime, xOffset: CGFloat){
        let model = AudioModel(startTime: startTime, xStart: xOffset)
        list.append(model)
        currentlyActiveRecordingModelIndex = list.count - 1
        
        if let addedBlockView = viewDelegate?.newAudioAdded(withModel: model){
            timeToViewDictionary[startTime.positionalTime] = (addedBlockView, startTime)
        }
    }
    
    func updateView(xOffset: CGFloat){
        guard let audioView = timeToViewDictionary[list[currentlyActiveRecordingModelIndex].startTime.positionalTime]?.0 as? AudioBlockView else {return}
        let width =  xOffset - audioView.frame.origin.x
        viewDelegate?.updateCurrentlyRecordingAudioView(width: width, audioBlockView: audioView)
        list[currentlyActiveRecordingModelIndex].updateEndOffset(xOffset)
    }
}

extension AudioRowViewModel: AudioTrackRowViewModelProtocol{

    func audioOfRecordedVideoSelected() {
        annotationVMDelegate?.selectedAudioTrackOfRecordedVideo()
    }
    
    func selectedAudioTrack(_ view: UIView) {
        for (_, (addedView, time)) in timeToViewDictionary {
            if addedView == view{
                annotationVMDelegate?.selectedAudioTrack(startingAt: time)
                
                guard let audioBlockView = view as? AudioBlockView else {return}
                audioBlockView.isSelected = true
                selectedAudioBlockView = audioBlockView
                selectedAudioBlockViewStartTime = time
                return
            }
        }
    }
    
    func allowPan(forNewCenter newCenter: CGPoint, oldCenter: CGPoint) -> Bool {
        guard let selectedAudioBlockView = selectedAudioBlockView,
              let selectedAudioBlockViewStartTime = selectedAudioBlockViewStartTime else {return false}
        
        let newFrame = CGRectMake(selectedAudioBlockView.frame.origin.x + (newCenter.x - oldCenter.x),
                                  selectedAudioBlockView.frame.origin.y,
                                  selectedAudioBlockView.frame.size.width,
                                  selectedAudioBlockView.frame.size.height)
        
        
        let unSelectedRemainingModels = list.filter { model in
            model.startTime != selectedAudioBlockViewStartTime
        }
        let xStartOfPanningView = newFrame.origin.x
        let xEndOfPanningView = (newFrame.origin.x + newFrame.size.width)
        
        for model in unSelectedRemainingModels{
            guard let curModelXEnd = model.xEnd else {continue}
            let isXEndBetweenCurrentModel = (xEndOfPanningView >= model.xStart) && (xEndOfPanningView <= curModelXEnd)
            let isXStartBetweenCurrentModel = (xStartOfPanningView >= model.xStart) && (xStartOfPanningView <= curModelXEnd)
            
            if isXEndBetweenCurrentModel || isXStartBetweenCurrentModel {
                return false
            }
        }
        return true
    }
    
    func panAction(forNewCenter newCenter: CGPoint) {
        guard let selectedAudioBlockView = selectedAudioBlockView,
              let selectedAudioBlockViewStartTime = selectedAudioBlockViewStartTime else {return}
        selectedAudioBlockView.center = newCenter
        
        for index in 0..<list.count{
            let model = list[index]
            if model.startTime == selectedAudioBlockViewStartTime{
        
                var newModel = model
        
                newModel.xStart = selectedAudioBlockView.frame.origin.x
                newModel.xEnd = selectedAudioBlockView.frame.origin.x + selectedAudioBlockView.frame.size.width
        
                let newStartTimeInSeconds = selectedAudioBlockView.frame.origin.x * CMTimeGetSeconds(totalDurationOfVideo) / totalWidthOfScrollView
                let newStartTimeInCMTime = CMTime(seconds: newStartTimeInSeconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
                newModel.startTime = newStartTimeInCMTime
                newModel.model?.updateVideoStartTimeEndTime(to: newStartTimeInCMTime)
                if let eVal = timeToViewDictionary[selectedAudioBlockViewStartTime.positionalTime]{
                    timeToViewDictionary.removeValue(forKey: selectedAudioBlockViewStartTime.positionalTime)
                    timeToViewDictionary[newStartTimeInCMTime.positionalTime] = eVal
                }
                self.selectedAudioBlockViewStartTime = newStartTimeInCMTime
        
                guard let newRecordedModel = newModel.model else {return}
                annotationVMDelegate?.updateModel(newRecordedModel, startingAt: model.startTime)
        
                list[index] = newModel
            }
        }
    }
    
    func allowPanOnLeftHandlerView(_: CGPoint) -> Bool {
        true
    }
    
    func allowPanOnRightHandlerView(_: CGPoint) -> Bool {
        true
    }
    
    func panActionOnLeftHandlerView(_: CGPoint) {
        
    }
    
    func panActionOnRightHandlerView(_: CGPoint) {
    
    }
    
    func isAudioRecordedWithVideo() -> Bool {
        if RPScreenRecorder.shared().isAvailable {
            if RPScreenRecorder.shared().isMicrophoneEnabled {
                return true
            }
        }
        return false
    }
    
    func screenRecordedAudioStateChanged() {
        annotationVMDelegate?.refreshSoundButtonState()
    }
}

extension AudioRowViewModel: AudioViewModelActionExecutingProtocol{
    
    func recordingEnded(audioModel: RecordedAudioModel) -> AudioModel {
        var modelToUpdate = list[currentlyActiveRecordingModelIndex]
        modelToUpdate.model = audioModel
        list[currentlyActiveRecordingModelIndex] = modelToUpdate
        
        return modelToUpdate
    }
    
    func currentRecordingCancelled() {
        if currentlyActiveRecordingModelIndex < list.count{
            let time = list[currentlyActiveRecordingModelIndex].startTime
            guard let viewToRemove = timeToViewDictionary[time.positionalTime]?.0 else {return }
            viewToRemove.removeFromSuperview()
            timeToViewDictionary.removeValue(forKey: time.positionalTime)
        }
        list.remove(at: currentlyActiveRecordingModelIndex)
        selectedAudioBlockView = nil
        selectedAudioBlockViewStartTime = nil
        viewDelegate?.refreshNoContentLabel()
    }
    
    @discardableResult func removeAudioViewStartingAt(time: CMTime) -> AudioModel?{
        var returningModel: AudioModel? = nil
        let indexOfRemovingModel = list.firstIndex { $0.startTime == time }
        if let indexOfRemovingModel = indexOfRemovingModel {
            returningModel = list.remove(at: indexOfRemovingModel)
        }
        selectedAudioBlockView = nil
        selectedAudioBlockViewStartTime = nil
        guard let viewToRemove = timeToViewDictionary[time.positionalTime]?.0 else {return returningModel}
        viewToRemove.removeFromSuperview()
        viewDelegate?.refreshNoContentLabel()
        timeToViewDictionary.removeValue(forKey: time.positionalTime)
        return returningModel
    }
    
    
    func deSelectAudioViewStartingAt(time: CMTime) {
        selectedAudioBlockView?.isSelected = false
        selectedAudioBlockView = nil
        selectedAudioBlockViewStartTime = nil
    }
    
    func deSelectAudioViewOfRecordedVideo(){
        viewDelegate?.deSelectAudioViewOfRecordedVideo()
    }
    
    func isAudioTrackRecordedWithVideoAvailable() -> Bool {
        viewDelegate?.isAudioRecordedWithVideoAvailble() ?? true
    }
    
    func removeAudio(model: AudioModel) {
        let startTime = model.startTime
        removeAudioViewStartingAt(time: startTime)
    }
    
    func deSelectAndRemoveAudioViewOfRecordedVideo(){
        viewDelegate?.deSelectAudioViewOfRecordedVideo()
        viewDelegate?.removeAudioViewOfRecordedVideo()
    }
    
    func addAudioViewOfRecordedVideo(){
        viewDelegate?.addAudioViewOfRecordedVideo()
    }
    
    func addAudio(model: AudioModel) {
        list.append(model)
        
        if let addedBlockView = viewDelegate?.newAudioAdded(withModel: model){
            timeToViewDictionary[model.startTime.positionalTime] = (addedBlockView, model.startTime)
        }
    }
    
}
