//
//  AnnotatorViewModel.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 13/09/23.
//

import Foundation
import CoreMedia
import UIKit
import AVFoundation
import MobileCoreServices
import ReplayKit

protocol VideoPlayerViewModelProtocol{
    // Video Player View
    var videoFileUrl: URL { get }
    var timeLabelUpdaterDelegate: PlayerTimeIndicatorViewProtocol? { get set }
    var controlViewDelegate: VideoControlViewProtocol? { get set }
    var isAudioOfRecordedVideoDeleted: Bool { get set }
    
    func readyToPlayVideo(withTotalDuration totalDuration: CMTime)
    func didFinishAndRestart()
    func updateLabelText(time: CMTime, withTotalDuration totalDuration: CMTime)
    func updateScroll(time: CMTime, withTotalDuration totalDuration: CMTime)
    func tapped()
    func updateShapesWithNewParentSize(_ parentSize: CGSize, isInFullScreenPreview: Bool)
    func tappedOutsideOfPlayer()
    
    func backTappedFromVideoPlayer()
    func soundTappedFromVideoPlayer()
    func playTappedFromVideoPlayer()
    func isVideoPlaying() -> Bool
    func isSoundEnabled() -> Bool
    func doneTappedForTxtField()
    func videoPlayerSeeked(to: CMTime)
}

protocol VideoControlViewModelProtocol{
    // Video Player Control
    var playerViewDelegate: VideoPlayerViewProtocol? {get set}
    var shouldEnableUndoAction: Bool { get }
    var shouldEnableRedoAction: Bool { get }
    
    func undoButtonTapped()
    func redoButtonTapped()
    func playPauseButtonAction()
    func forwardButtonTapped()
    func backwardButtonTapped()
    func fullScreenButtonTapped()
    func muteUnmuteButtonTapped()
    func deleteButtonTapped()
    
    func sliderSeekedTo(value: Float)
    
    func shouldShowSoundOnOffButton() -> Bool
    func isVideoPlaying() -> Bool
    func isSoundEnabled() -> Bool
    func backTappedFromVideoPlayer()
    func soundTappedFromVideoPlayer()
    func playTappedFromVideoPlayer()
}


protocol VideoThumbnailViewModelProtocol{
    var videoFileUrl: URL { get }
    var videoThumbnailViewDelegate: VideoThumbnailViewProtocol? {get set}
    var numberOfThumbnails: Int { get }
    var totalDuration: CMTime? { get }
    var asset: AVAsset { get }
    
    func scrollViewBeganScrolling()
    func scrollViewScrolling(withOffSet offset: CGPoint, withReferenceWidth referenceWidth: CGFloat)
    func scrollViewEndScrolling(withOffSet offset: CGPoint, withReferenceWidth referenceWidth: CGFloat)
    func scrollViewTapped()
    func thumbnailTapped()
}

protocol VideoTrimmingViewModelProtocol{
    func trimmingStarted()
    func trimInProgress(atOffset: CGFloat, totalWidth: CGFloat)
    func trimVideo(withTotalContentWidth totalWidth: CGFloat, startPoint: CGFloat, endPoint: CGFloat, isStartTimeChanged: Bool)
}

protocol ToolBarActionExecutingProtocol: AnyObject{
    var bottomToolbarViewDelegate: ToolBarViewModelProtocol? { get set }
    
    func trimmingConfirmationButtonClicked()
    func trimmingCancelButtonClicked()
    
    func cutTapped()
    func maskTapped()
    func shapesTapped()
    func textTapped()
    func textEntered(_: String)
    func audioTapped()
    
    func audioRecordingButtonTapped()
    
    func rectangleTapped()
    func ovalTapped()
    func arrowTapped()
    func shapeColorTapped()
    func textColorTapped()
    func blockColorTapped()
    func arrowColorTapped()
    func arrowWidthTapped()
    func textEditTapped()
    func textSizeTapped()
    func textStyleTapped()
    func textBgTapped()
    
    func borderStyleTapped()
    func borderWidthTapped()
    func blockTapped()
    func blurTapped()
    
    func shapeColorSelected(atIndex: Int)
    func textColorSelected(atIndex: Int)
    func blockColorSelected(atIndex: Int)
    func arrowColorSelected(atIndex: Int)
    func borderStyleSelected(_: BorderStyleType)
    func borderWidthChangedTo(_: Int)
    func borderWidthChangesEnded(_: Int)
    
    func textSizeChanged(_:Int)
    func textOpacityChanged(_:CGFloat)
    func textSizeChangesEnded(_:Int)
    func textOpacityChangesEnded(_:CGFloat)
    func textStyleSelected(_: TextStyle)
    
    func requestAudioPermission(completion: @escaping (Bool) -> Void)
    func showAudioPermissionNotGrantedAlert()
}

protocol BottomToolBarViewModelProtocol{
    func updateVideoTrimmed(text: String)
}

protocol FullScreenExecutingProtocol: AnyObject{
    func launchFullScreen()
    func exitFullScreen()
    func playPauseTapped(isVideoPlaying: Bool)
    func videoPlayingFinished()
    func textViewBecameActive()
    func textViewEndActive()
}

protocol AudioRecordingNotifyingProtocol: AnyObject{
    func started()
    func cancelled()
    func ended()
}


protocol FullScreenProtocol: AnyObject{
    var isVideoPlayBackMode: Bool {get set}
    var fullScreenDelegate: FullScreenExecutingProtocol? {get set}
}

protocol DataLossProtocol: AnyObject{
    func showElementDurationAlert()
    func showRemoveAudioAlert()
    func showTxtLimitReachedAlert()
    func showPauseVideoBeforeRecordingAudioAlert()
    func showDataLossAlert()
    func getParentViewHeight() -> CGFloat
    func showAudioPersmissionNotGrantedAlert()
}

protocol AnnotatorViewProtocol: AnyObject{
    var annotatorViewDelegate: DataLossProtocol? {get set}
}


protocol AnnotatorViewModelProtocol: VideoPlayerViewModelProtocol,
                                     VideoControlViewModelProtocol,
                                     VideoThumbnailViewModelProtocol,
                                     ShapeSizeUpdationDelegateProtocol,
                                     VideoTrimmingViewModelProtocol,
                                     ToolBarActionExecutingProtocol,
                                     AnnotationAudioVMProtocol,
                                     FullScreenProtocol,
                                     AnnotatorViewProtocol{
    var navigationDelegate: NavigationProtocol? { get set }
    var audioRecodingNotifyingDelegate: AudioRecordingNotifyingProtocol? { get set }

    var videoFileUrl: URL{ get }
    func doneButtonTapped()
    func backButtonTapped()
    func dimissAnnotationVC()
    func getAllAnnotationData() -> VideoSendEditDetailsInfo
}

public protocol NavigationProtocol: AnyObject {
    func doneAction()
    func cancelAction()
}


class AnnotatorViewModel: AnnotatorViewModelProtocol{
    var videoFileUrl: URL
    weak var playerViewDelegate: VideoPlayerViewProtocol?
    weak var controlViewDelegate: VideoControlViewProtocol?
    weak var videoThumbnailViewDelegate: VideoThumbnailViewProtocol?
    weak var annotatorViewDelegate: DataLossProtocol?
    weak var navigationDelegate: NavigationProtocol?
    
    weak var fullScreenDelegate: FullScreenExecutingProtocol?
    weak var audioRecodingNotifyingDelegate: AudioRecordingNotifyingProtocol?
    
    weak var timeLabelUpdaterDelegate: PlayerTimeIndicatorViewProtocol?
    weak var bottomToolbarViewDelegate: ToolBarViewModelProtocol?
    weak var audioVMDelegate: AudioViewModelActionExecutingProtocol?
    
    private var playBackTimeProvider: PlayBackTimeProviderProtocol
//    private var isVideoPlayingWhenScrollingStarted: Bool = false
    private var isVideoTrimmingEnabled: Bool = false
    
    private var shapeManger: AnnotationShapeManagerProtocol
    
    private var isVideoTrimmed = false
    private var trimmedVideoStartTimeInCMTime: CMTime = CMTime.zero
    private var trimmedVideoEndTimeInCMTime: CMTime = CMTime.zero
    
    private var currentTrimmingStartTimeInCMTime: CMTime = CMTime.zero
    private var currentTrimmingEndTimeInCMTime: CMTime = CMTime.zero
    private var isInFullScreenPreview: Bool = false
    private var isAudioOfVideoIsMutedDueToAudioRecording = false
    
    private var isAudioOfVideoIsMutedDueToRecordedAudioPlaying = false
    private var isAudioOfVideoIsMutedByUser = false // User muted the audio by clicking mute button
    
    private var currentlyShownShapeViewAsResultOfRowViewTimeChanges: UIView?
    var isAudioOfRecordedVideoDeleted: Bool = false
    private let minTrimPaddingFactor: CGFloat = 0
    
    var isVideoPlayBackMode: Bool = false{
        didSet{
            configureUIBasedOnPlayBackMode()
        }
    }
    
    private var isAudioRecordingInProgress: Bool{
        shapeManger.isRecordingInProgress
    }
    
    init(videoFileUrl: URL,
         playBackTimeProvider: PlayBackTimeProviderProtocol = PlayBackTimeProvider(),
         shapeManger: AnnotationShapeManagerProtocol = AnnotationShapeManager()) {
        self.videoFileUrl = videoFileUrl
        self.playBackTimeProvider = playBackTimeProvider
        self.shapeManger = shapeManger
        self.shapeManger.refresherDelegate = self
    }
    
    private func configureUIBasedOnPlayBackMode(){
        if isVideoPlayBackMode {
            if let status =  playerViewDelegate?.getCurrentItemStatus(){
                switch status {
                case .readyToPlay:
                    didFinishAndRestart() // Video is Paused After restart
                    playPauseButtonAction()
                    fullScreenButtonTapped(isAnimated: false)
                default:
                    break
                }
            }
        }else{
            didFinishAndRestart() // Video is Paused After restart
        }
    }
    
    private func navigationButtonTapped(){
        let isVideoPlaying = playerViewDelegate?.isVideoPlaying() ?? false
        if isVideoPlaying{
            playPauseButtonAction()
        }
        if isAudioRecordingInProgress{
            guard let time = playerViewDelegate?.getCurrentTime() else {return}
            shapeManger.stopRecording(at:time)
        }
    }
    
    func backButtonTapped() {
        navigationButtonTapped()
        if shapeManger.areChangesDoneToAnnotation{
            annotatorViewDelegate?.showDataLossAlert()
        }else{
            scrollViewTapped()
            navigationDelegate?.cancelAction()
        }
    }
    
    func doneButtonTapped() {
        shapeManger.numberOfChangesDone = 0
        scrollViewTapped()
        
        navigationButtonTapped()
        navigationDelegate?.doneAction()
    }
    
    func videoPlayerSeeked(to time: CMTime) {
        guard let totalDuration = playerViewDelegate?.totalVideoDuration() else {return}

        let delta = 0.2
        let isTrimmedVideoReachedEnd = (abs(CMTimeGetSeconds(CMTimeSubtract(time, trimmedVideoEndTimeInCMTime))) < delta)
        let isNonTrimmedVideoReachedEnd = (abs(CMTimeGetSeconds(CMTimeSubtract(time, totalDuration))) < delta)
        
        let shouldDisable = isVideoTrimmed ? isTrimmedVideoReachedEnd : isNonTrimmedVideoReachedEnd // When video playing time is seeked to end, disable the audio recording button. Otherwise enable it.
        audioButtonInBottomToolBar(shouldEnable: !shouldDisable)
    }
    
    func audioButtonInBottomToolBar(shouldEnable: Bool){
        bottomToolbarViewDelegate?.audioRecordingButton(shouldEnable: shouldEnable)
    }
    
    func dimissAnnotationVC() {
        cancelLastAppliedChanges()
        scrollViewTapped()
        
        navigationDelegate?.cancelAction()
    }
    
    func cancelLastAppliedChanges(){
        shapeManger.cancelLastAppliedShapeChanges()
        scrollViewTapped()
    }
    
    func getAllAnnotationData() -> VideoSendEditDetailsInfo {
        var editDetails = VideoSendEditDetailsInfo(isVideoTrimmed: isVideoTrimmed,
                                 startTime: trimmedVideoStartTimeInCMTime,
                                 endTime: trimmedVideoEndTimeInCMTime,
                                 addedShape: shapeManger.addedShapesDictionary,
                                 audios: shapeManger.getAudioModel())
        editDetails.isOriginalAudioTrackInVideoRecordingDeleted = isAudioOfRecordedVideoDeleted
        return editDetails
        
    }
    
    func doneTappedForTxtField(){
        fullScreenDelegate?.textViewEndActive()
        tappedOutsideOfPlayer()
    }
}

extension AnnotatorViewModel: ToolBarActionExecutingProtocol {
    
    private func getTextForTrimmedVideoDuration() -> String{
        let text = playBackTimeProvider.getTimmedDurationString(from: currentTrimmingStartTimeInCMTime,
                                                                to: currentTrimmingEndTimeInCMTime)
        return text
    }
    
    private func updateVideoTrimmedText() {
        bottomToolbarViewDelegate?.updateTrimmedVideoDuration(with: getTextForTrimmedVideoDuration())
    }
    
    func trimmingEnded(isStartTimeChanged: Bool) {
        isVideoTrimmingEnabled = true
        bottomToolbarViewDelegate?.updateViewAfterTrimming()
        
        let oldStartTime = trimmedVideoStartTimeInCMTime
        let oldEndTime = trimmedVideoEndTimeInCMTime
        
        let newStartTime = currentTrimmingStartTimeInCMTime
        let newEndTime = currentTrimmingEndTimeInCMTime
        
        shapeManger.addVideoTrimmingInUndoableAction(oldStartTime: oldStartTime,
                                                     oldEndTime: oldEndTime,
                                                     newStartTime: newStartTime,
                                                     newEndTime: newEndTime)
        
        trimmedVideoStartTimeInCMTime = currentTrimmingStartTimeInCMTime
        trimmedVideoEndTimeInCMTime = currentTrimmingEndTimeInCMTime
        
        isVideoTrimmed = true
        
        if isStartTimeChanged{
            playerViewDelegate?.seek(to: trimmedVideoStartTimeInCMTime)
        }else{
            playerViewDelegate?.seek(to: trimmedVideoEndTimeInCMTime)
        }
        
        guard let totalDuration = playerViewDelegate?.totalVideoDuration() else {return}
        videoThumbnailViewDelegate?.adjustScrollBasedOn(startTime: trimmedVideoStartTimeInCMTime, endTime: trimmedVideoEndTimeInCMTime, totalDuration: totalDuration)
    }
    
    func trimmingConfirmationButtonClicked() {
        isVideoTrimmingEnabled = false
        videoThumbnailViewDelegate?.disableVideoTrimming()
        bottomToolbarViewDelegate?.updateViewAfterTrimming()
        
        let oldStartTime = trimmedVideoStartTimeInCMTime
        let oldEndTime = trimmedVideoEndTimeInCMTime
        
        let newStartTime = currentTrimmingStartTimeInCMTime
        let newEndTime = currentTrimmingEndTimeInCMTime
        
        
        shapeManger.addVideoTrimmingInUndoableAction(oldStartTime: oldStartTime,
                                                     oldEndTime: oldEndTime,
                                                     newStartTime: newStartTime,
                                                     newEndTime: newEndTime)
        
        trimmedVideoStartTimeInCMTime = currentTrimmingStartTimeInCMTime
        trimmedVideoEndTimeInCMTime = currentTrimmingEndTimeInCMTime
        
        isVideoTrimmed = true
    }
    
    func trimmingCancelButtonClicked() {
        isVideoTrimmingEnabled = false
        guard isVideoTrimmed else { // Make changes only if video is trimmed
            currentTrimmingStartTimeInCMTime = trimmedVideoStartTimeInCMTime
            currentTrimmingEndTimeInCMTime = trimmedVideoEndTimeInCMTime
            
            videoThumbnailViewDelegate?.resetVideoTrimmingViews()
            videoThumbnailViewDelegate?.disableVideoTrimming()
            bottomToolbarViewDelegate?.updateViewAfterTrimming()
            return
        }
        isVideoTrimmed = false
        shapeManger.addVideoTrimmingDeletionInUndoableAction(startTime: trimmedVideoStartTimeInCMTime, endTime: trimmedVideoEndTimeInCMTime)
        
        trimmedVideoStartTimeInCMTime = CMTime.zero
        if let totalDuration = playerViewDelegate?.totalVideoDuration(){
            trimmedVideoEndTimeInCMTime = totalDuration
        }
        videoThumbnailViewDelegate?.resetVideoTrimmingViews()
        videoThumbnailViewDelegate?.disableVideoTrimming()
        bottomToolbarViewDelegate?.updateViewAfterTrimming()
    }
    
    func cutTapped() {
        if isVideoTrimmingEnabled{
            videoThumbnailViewDelegate?.disableVideoTrimming()
        }else{
            videoThumbnailViewDelegate?.enableVideoTrimming()
            currentTrimmingStartTimeInCMTime = trimmedVideoStartTimeInCMTime
            currentTrimmingEndTimeInCMTime = trimmedVideoEndTimeInCMTime
        }
        isVideoTrimmingEnabled = !isVideoTrimmingEnabled
    }
    
    func maskTapped() {
        bottomToolbarViewDelegate?.updateViewWithMaskBlurShapeAddition()
    }
    
    func shapesTapped() {
        bottomToolbarViewDelegate?.updateViewWithRectangelOvalShapeAddition()
    }
    
    
    func audioRecordingButtonTapped() {
//        let isVideoPlaying = playerViewDelegate?.isVideoPlaying() ?? false
//        if isVideoPlaying {
//            playerViewDelegate?.pause()
//            controlViewDelegate?.pauseVideo()
//        }
        guard let curTime = playerViewDelegate?.getCurrentTime() else {return}
        if isAudioRecordingInProgress{ // Already Recording In progress
            shapeManger.stopRecording(at:curTime)
        }else{
            if isVideoTrimmed{
                if curTime > trimmedVideoStartTimeInCMTime && curTime < trimmedVideoEndTimeInCMTime{
                    shapeManger.startRecording(at: curTime)
                }else{
                    playerViewDelegate?.seek(to: trimmedVideoStartTimeInCMTime)
                    shapeManger.startRecording(at: trimmedVideoStartTimeInCMTime)
                }
            }else{
                shapeManger.startRecording(at: curTime)
            }
        }
    }
    
    func rectangleTapped() {
        let selectedColor = shapeManger.colors[shapeManger.colorIndexForNewShape]
        let rectShapeType = ShapeType.rectangle(color: selectedColor, borderStyle: .solid, borderWidth: .init())
        let shape = AddedShape(type: rectShapeType)
        add(shape: shape)
        bottomToolbarViewDelegate?.showShapeRelatedAttributeOptions(selectedColor: selectedColor, isOval: false)
    }
    
    func ovalTapped() {
        let selectedColor = shapeManger.colors[shapeManger.colorIndexForNewShape]
        let circleShapeType = ShapeType.circle(color: selectedColor, borderStyle: .solid, borderWidth: .init())
        let shape = AddedShape(type: circleShapeType)
        add(shape: shape)
        bottomToolbarViewDelegate?.showShapeRelatedAttributeOptions(selectedColor: selectedColor, isOval: true)
    }
    
    func arrowTapped(){
        let selectedColor = shapeManger.colors[shapeManger.colorIndexForNewShape]
        let arrowShapeType = ShapeType.arrow(color: selectedColor, borderStyle: .solid, borderWidth: .init())
        let shape = AddedShape(type: arrowShapeType)
        add(shape: shape)
        bottomToolbarViewDelegate?.showArrowRelatedAttributeOptions(selectedColor: selectedColor)
    }
    
    func blockTapped() {
        let selectedColor = shapeManger.colors[shapeManger.colorIndexForNewShape]
        let blockShapeType = ShapeType.block(color: selectedColor)
        let shape = AddedShape(type: blockShapeType)
        add(shape: shape)
        
        bottomToolbarViewDelegate?.showBlockRelatedAttributeOptions(selectedColor: selectedColor)
    }
    
    func blurTapped() {
        let shape = AddedShape(type: .blur)
        add(shape: shape)
    }
    
    func textTapped() {
        let selectedColor = shapeManger.colors[shapeManger.colorIndexForNewShape]
        let textShapeType = ShapeType.text(color: selectedColor, textString: "", fontSize: .init(), textStyle: .regular, textBG: .init(opacity: 1))
        
        let shape = AddedShape(type: textShapeType)
        if let addedTxtView = add(shape: shape){
            playerViewDelegate?.addMaskView(belowTxtView: addedTxtView)
            fullScreenDelegate?.textViewBecameActive()
            addedTxtView.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                addedTxtView.alpha = 1
            }
        }
        
        bottomToolbarViewDelegate?.showTextRelatedAttributeOptions(selectedColor: selectedColor)
    }
    
    @discardableResult func add(shape: AddedShape) -> UIView? {
        if let time = playerViewDelegate?.getCurrentTime(),
           let totalTime = playerViewDelegate?.totalVideoDuration(),
           let refSize = playerViewDelegate?.getVideoPlayerBoundingBoxSize(){
            
            let (view,frame,details) = shapeManger.getShapeAndRowShapeView(forShape: shape, videoContainerSize: refSize, curTime: time, totalDuration: totalTime)
            playerViewDelegate?.addView(view, withFrame: frame)
            if let addedRowView = videoThumbnailViewDelegate?.addShape(withDetails:details, currentTime: time, totalPlaybackDuration: totalTime){
                shapeManger.saveShapeDetailsAndRowView(addedRowView, details: details ,forShapeView: view)
            }
            //            colorPickerViewDelegate?.showOrHideColorPicker()
            controlViewDelegate?.shouldHideMuteAndFullScreenButtonsAndShowDeleteButton(true)
            return view
        }
        return nil
    }
    
    func shapeColorTapped() {
        bottomToolbarViewDelegate?.showShapeColorAttributeOption(withColors: shapeManger.colors,
                                                                 selectedColorIndex: shapeManger.currentlySelectedColorIndex)
    }
    
    func textColorTapped() {
        bottomToolbarViewDelegate?.showTextColorAttributeOption(withColors: shapeManger.colors,
                                                                selectedColorIndex: shapeManger.currentlySelectedColorIndex)
    }
    
    func arrowColorTapped() {
        bottomToolbarViewDelegate?.showArrowColorAttributeOption(withColors: shapeManger.colors,
                                                                 selectedColorIndex: shapeManger.currentlySelectedColorIndex)
    }
    
    func blockColorTapped() {
        bottomToolbarViewDelegate?.showBlockColorAttributeOption(withColors: shapeManger.colors,
                                                                 selectedColorIndex: shapeManger.currentlySelectedColorIndex)
    }
    
    func borderStyleTapped() {
        guard let model = shapeManger.selectedShapeView?.model else {return}
        let selectedColor = shapeManger.colors[shapeManger.currentlySelectedColorIndex]
        
        switch model.shape.type{
        case .circle(_, let borderStyle, _):
            bottomToolbarViewDelegate?.showBorderStyleAttributeOption(selectedBorderStyleType: borderStyle, selectedColor: selectedColor, isOval: true)
        case .rectangle(_, let borderStyle, _):
            bottomToolbarViewDelegate?.showBorderStyleAttributeOption(selectedBorderStyleType: borderStyle, selectedColor: selectedColor, isOval: false)
        default:break
        }
    }
    
    func borderWidthTapped() {
        guard let borderWidthModel = shapeManger.selectedShapeView?.model.shape.getBorderWidthModel() else { return }
        let selectedColor = shapeManger.colors[shapeManger.currentlySelectedColorIndex]
        var isOval = false
        if case .circle = shapeManger.selectedShapeView?.model.shape.type {
            isOval = true
        }
        bottomToolbarViewDelegate?.showBorderWidthAttributeOption(borderWidthModel: borderWidthModel, selectedColor: selectedColor, isOval: isOval)
    }
    
    func arrowWidthTapped() {
        guard let borderWidthModel = shapeManger.selectedShapeView?.model.shape.getBorderWidthModel() else { return }
        let selectedColor = shapeManger.colors[shapeManger.currentlySelectedColorIndex]
        bottomToolbarViewDelegate?.showArrowWidthAttributeOption(borderWidthModel: borderWidthModel, selectedColor: selectedColor)
    }
    
    func shapeColorSelected(atIndex index: Int) {
        shapeManger.pickedColorAt(index: index)
        let color = shapeManger.colors[shapeManger.currentlySelectedColorIndex]
        var isOval = false
        if case .circle = shapeManger.selectedShapeView?.model.shape.type {
            isOval = true
        }
        bottomToolbarViewDelegate?.shapeColorSelected(color, isOval: isOval)
        scrollToNearestEndOfSelectedShape()
    }
    
    private func scrollToNearestEndOfSelectedShape(){
        guard let selectedView = shapeManger.selectedShapeView else {return}
        for (curView,addedViewDetails) in shapeManger.addedShapesDictionary{
            if curView != selectedView {continue}
            if let curTime = playerViewDelegate?.getCurrentTime(){
                let shapeStartTime = addedViewDetails.startTime
                let shapeEndTime = addedViewDetails.endTime
                if curTime < shapeStartTime {
                    self.playerViewDelegate?.seek(to: shapeStartTime)
                }else if curTime > shapeEndTime{
                    self.playerViewDelegate?.seek(to: shapeEndTime)
                }
            }
            break
        }
    }
    
    
    func textEntered(_ text: String) {
        shapeManger.textEntered(text)
    }
    
    func borderStyleSelected(_ newBorderStyleType: BorderStyleType) {
        shapeManger.borderStyleSelected(newBorderStyleType)
        var isOval = false
        if case .circle = shapeManger.selectedShapeView?.model.shape.type {
            isOval = true
        }
        guard let selectedShapeColor = shapeManger.selectedShapeView?.model.shape.getShapeColor() else {return}
        bottomToolbarViewDelegate?.dismissBorderStyleMenu(selectedShapeColor, isOval: isOval)
        scrollToNearestEndOfSelectedShape()
    }
    
    func textStyleSelected(_ txtStyle: TextStyle) {
        shapeManger.txtStyleSelected(txtStyle)
        //         print(txtStyle)
        guard let selectedShapeColor = shapeManger.selectedShapeView?.model.shape.getShapeColor() else {return}
        bottomToolbarViewDelegate?.dismissTxtRelatedMenus(selectedShapeColor)
        scrollToNearestEndOfSelectedShape()
    }
    
    
    
    func borderWidthChangedTo(_ newValue: Int) {
        shapeManger.borderWidthSelectionChangeTo(newValue)
        scrollToNearestEndOfSelectedShape()
    }
    
    func borderWidthChangesEnded(_ newValue: Int){
        shapeManger.borderWidthSelectionChangesEnded(newValue)
        guard let selectedShapeColor = shapeManger.selectedShapeView?.model.shape.getShapeColor() else {return}
        var isOval = false
        if case .circle = shapeManger.selectedShapeView?.model.shape.type { isOval = true }
        bottomToolbarViewDelegate?.dismissBorderStyleMenu(selectedShapeColor, isOval: isOval) // Once width changes dismiss the menu
    }
    
    func textSizeChanged(_ newSize: Int) {
        shapeManger.textSizeChangeTo(newSize)
        scrollToNearestEndOfSelectedShape()
    }
    
    func textOpacityChanged(_ newOpacity: CGFloat) {
        shapeManger.textOpacityChangeTo(newOpacity)
        scrollToNearestEndOfSelectedShape()
    }
    
    func textSizeChangesEnded(_ to: Int) {
        shapeManger.textSizeChangesEnded(to)
        guard let selectedShapeColor = shapeManger.selectedShapeView?.model.shape.getShapeColor() else {return}
        bottomToolbarViewDelegate?.dismissTxtRelatedMenus(selectedShapeColor)
    }
    
    func textOpacityChangesEnded(_ to:CGFloat){
        shapeManger.textOpacityChangesEnded(to)
        guard let selectedShapeColor = shapeManger.selectedShapeView?.model.shape.getShapeColor() else {return}
        bottomToolbarViewDelegate?.dismissTxtRelatedMenus(selectedShapeColor)
    }
    
    func blockColorSelected(atIndex index: Int) {
        shapeManger.pickedColorAt(index: index)
        let color = shapeManger.colors[shapeManger.currentlySelectedColorIndex]
        bottomToolbarViewDelegate?.blockColorSelected(color)
        scrollToNearestEndOfSelectedShape()
    }
    
    func arrowColorSelected(atIndex index: Int) {
        shapeManger.pickedColorAt(index: index)
        let color = shapeManger.colors[shapeManger.currentlySelectedColorIndex]
        bottomToolbarViewDelegate?.arrowColorSelected(color)
        scrollToNearestEndOfSelectedShape()
    }
    
    func textColorSelected(atIndex index: Int) {
        shapeManger.pickedColorAt(index: index)
        let color = shapeManger.colors[shapeManger.currentlySelectedColorIndex]
        bottomToolbarViewDelegate?.textColorSelected(color)
        scrollToNearestEndOfSelectedShape()
    }
    
    func requestAudioPermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission(completion)
    }
    
    func showAudioPermissionNotGrantedAlert() {
        annotatorViewDelegate?.showAudioPersmissionNotGrantedAlert()
    }
    
    func textEditTapped() {
        guard let selectedShape = shapeManger.selectedShapeView else {return}
        shapeManger.txtEditTapped()
        playerViewDelegate?.addMaskView(belowTxtView: selectedShape)
        fullScreenDelegate?.textViewBecameActive()
//        bottomToolbarViewDelegate?.showTextEditWith(text: enteredTxt)
        scrollToNearestEndOfSelectedShape()
    }
    
    func textBecameFirstResponder(){
        if let selectedShape = shapeManger.selectedShapeView{
            playerViewDelegate?.addMaskView(belowTxtView: selectedShape)
            fullScreenDelegate?.textViewBecameActive()
        }
    }
    
    func textSizeTapped() {
        guard let txtModel = shapeManger.selectedShapeView?.model.shape.getTextModel() else {return}
        bottomToolbarViewDelegate?.showTextSizeSelectionWith(model: txtModel)
    }
    
    func textStyleTapped() {
        guard let txtModel = shapeManger.selectedShapeView?.model.shape.getTextModel() else {return}
        bottomToolbarViewDelegate?.showTextStyleSelectionWith(model: txtModel)
    }
    
    func textBgTapped(){
        guard let txtModel = shapeManger.selectedShapeView?.model.shape.getTextModel() else {return}
        bottomToolbarViewDelegate?.showTextBGSelectionWith(model: txtModel)
    }
    
    func audioTapped() {
        bottomToolbarViewDelegate?.showAudioRecorder()
    }
    
    //    func checkAudioPermission() {
    //        let audioSession = AVAudioSession.sharedInstance()
    //        switch audioSession.recordPermission {
    //        case .granted:
    //            // Audio recording permission is granted
    //            print("Audio recording permission is granted")
    //            // You can start recording here
    //        case .denied:
    //            // Audio recording permission is denied
    //            print("Audio recording permission is denied")
    //        case .undetermined:
    //            // The user has not yet been asked for permission
    //            print("Audio recording permission is undetermined")
    //            // You can request permission here using AVAudioSession.sharedInstance().requestRecordPermission()
    //        @unknown default:
    //            fatalError("New AVAudioSession.RecordPermission cases have been added that are not handled in this code.")
    //        }
    //    }
}

extension AnnotatorViewModel: VideoPlayerViewModelProtocol{
    
    func backTappedFromVideoPlayer() {
        if isVideoPlayBackMode{ // Play button tapped. Show video annotation in full screen mode.
            fullScreenButtonTapped(isAnimated: false) // Once back Tapped after video play back, switch to edit mode
            doneButtonTapped()
        }else{
            fullScreenButtonTapped(isAnimated: true)
        }
    }
    
    func soundTappedFromVideoPlayer() {
        muteUnmuteButtonTapped()
    }
    
    func isSoundEnabled() -> Bool{
        playerViewDelegate?.isSoundEnabled() ?? false
    }
    
    func playTappedFromVideoPlayer() {
        playPauseButtonAction()
        fullScreenDelegate?.playPauseTapped(isVideoPlaying: isVideoPlaying())
    }
    
    func tappedOutsideOfPlayer(){
        tapped()
    }
    
    
    func tapped() {
        guard !isAudioRecordingInProgress else { return }
        shapeManger.videoTapped()
        //        colorPickerViewDelegate?.showOrHideColorPicker()
        bottomToolbarViewDelegate?.videoTapped()
        controlViewDelegate?.shouldHideMuteAndFullScreenButtonsAndShowDeleteButton(false)
        playerViewDelegate?.removeMaskViewAddedForTxtView()
        fullScreenDelegate?.textViewEndActive()
    }
    
    func updateShapesWithNewParentSize(_ parentSize: CGSize, isInFullScreenPreview: Bool){
        shapeManger.updateShapesWithNewParentSize(parentSize, isInFullScreenPreview: isInFullScreenPreview)
    }
    
    func readyToPlayVideo(withTotalDuration totalDuration: CMTime) {
        //        if shouldInitiateVideoPlayingOnceLoaded{
        //            controlViewDelegate?.playVideo()
        //            playerViewDelegate?.play()
        //        }
        if isVideoPlayBackMode{
            controlViewDelegate?.playVideo()
            playerViewDelegate?.play()
            fullScreenButtonTapped(isAnimated: false)
            if let totalDuration = playerViewDelegate?.totalVideoDuration(){
                trimmedVideoEndTimeInCMTime = totalDuration
            }
            return
        }
        
        if let totalDuration = playerViewDelegate?.totalVideoDuration(){
            trimmedVideoEndTimeInCMTime = totalDuration
            currentTrimmingEndTimeInCMTime = totalDuration
            updateLabelText(time: CMTime.zero, withTotalDuration: totalDuration)
        }
        enableOrDisableForwardBackwardButtons(at: CMTime.zero)
    }
    
    func didFinishAndRestart(){
        if isAudioRecordingInProgress{
            guard let totalDuration = playerViewDelegate?.totalVideoDuration() else {return}
            shapeManger.stopRecording(at: totalDuration)
        }
        controlViewDelegate?.videoPlayingFinished()
        playerViewDelegate?.videoPlayingFinished()
        fullScreenDelegate?.videoPlayingFinished()
        if isVideoTrimmed {
            playerViewDelegate?.seek(to: trimmedVideoStartTimeInCMTime)
            enableOrDisableForwardBackwardButtons(at: trimmedVideoStartTimeInCMTime)
        }else{
            playerViewDelegate?.seek(to: CMTime.zero)
            enableOrDisableForwardBackwardButtons(at: CMTime.zero)
        }
        videoPlayerSeeked(to: .zero)
    }
    
    func updateLabelText(time: CMTime, withTotalDuration totalDuration: CMTime) {
        let timeLabelStr = playBackTimeProvider.getTimeStrForVideo(curDuration: time, totalDuration: totalDuration)
        timeLabelUpdaterDelegate?.updateTime(to: timeLabelStr)
    }
    
    func updateScroll(time: CMTime, withTotalDuration totalDuration: CMTime) {
        
        let isVideoPlaying = playerViewDelegate?.isVideoPlaying() ?? false
        if isVideoPlaying{
            let isRecordedAudioAvailable = shapeManger.checkAndPlayRecordedAudiosIfAvailable(at: time)
            if isRecordedAudioAvailable{
                playerViewDelegate?.sound(shouldEnable: false) // Recorded audio is playing , so disable audio from video
                isAudioOfVideoIsMutedDueToRecordedAudioPlaying = true
            }else{
                if isAudioOfVideoIsMutedDueToRecordedAudioPlaying, shapeManger.isRecordedAudioPlaying() == false { // Recorded audio playing is complete , so enable audio from video
                    isAudioOfVideoIsMutedDueToRecordedAudioPlaying = false
                    if isAudioOfVideoIsMutedByUser == false{ // No mute done by cx so unmute the audio from video
                        playerViewDelegate?.sound(shouldEnable: true)
                    }
                }
            }
        }
        
        if isVideoTrimmed{
            if isVideoPlaying && time > trimmedVideoEndTimeInCMTime { // Video crossed end time of trimmed video
                if isAudioRecordingInProgress{
                    shapeManger.stopRecording(at: time)
                }
                didFinishAndRestart()
                return
            }
        }
        
        if isInFullScreenPreview{
            if isVideoTrimmed{
                let timeLapsedStr = playBackTimeProvider.getTimeStrForVideo(curDuration: CMTimeSubtract(time,trimmedVideoStartTimeInCMTime))
                controlViewDelegate?.updateFullScreenSlider(to: time, timeLapsed: timeLapsedStr)
            }else{
                let timeLapsedStr = playBackTimeProvider.getTimeStrForVideo(curDuration: time)
                controlViewDelegate?.updateFullScreenSlider(to: time, timeLapsed: timeLapsedStr)
            }
        }
        
        if isAudioRecordingInProgress{
            shapeManger.audioRecordingInProgress(time:time)
        }
        
        videoThumbnailViewDelegate?.autoScrollTo(time: time, totalPlaybackDuration: totalDuration,isRecordingInProgress: isAudioRecordingInProgress)
        
        shapeManger.hideOrShowAddedShapesAt(time: time)
    }
    
}

extension AnnotatorViewModel: VideoControlViewModelProtocol{
    
    func sliderSeekedTo(value: Float) {
        guard let totalDuration = totalDuration else {return}
        let timeToSeek = CMTime(seconds: Double(value), preferredTimescale: totalDuration.timescale)
        playerViewDelegate?.seek(to: timeToSeek)
    }
    
    
    var shouldEnableUndoAction: Bool {
        shapeManger.areUndoActionsAvailable
    }
    
    var shouldEnableRedoAction: Bool {
        shapeManger.areRedoActionsAvailable
    }
    
    
    private func isBetweenAllowedTrimmedTime(_ time: CMTime) -> Bool{
        (time >= trimmedVideoStartTimeInCMTime && time <= trimmedVideoEndTimeInCMTime)
    }
    
    func playPauseButtonAction(){
        guard !isAudioRecordingInProgress else { return }
        guard let isVideoPlaying = playerViewDelegate?.isVideoPlaying() else {return}
        if isVideoTrimmed, // Video Trimmed, Video Not Playing, Current Time is out of limit of allowed range
           !isVideoPlaying,
           let currentTime = playerViewDelegate?.getCurrentTime(),
           !isBetweenAllowedTrimmedTime(currentTime),
           let totalDuration = playerViewDelegate?.totalVideoDuration() {
            playerViewDelegate?.seek(to: trimmedVideoStartTimeInCMTime)
            videoThumbnailViewDelegate?.scrollToTime(trimmedVideoStartTimeInCMTime, totalDuration:totalDuration)
        }
        
        shapeManger.playPauseButtonAction()
        
        tapped()
        
        if isVideoPlaying{
            playerViewDelegate?.pause()
            controlViewDelegate?.pauseVideo()
        }else{
            playerViewDelegate?.play()
            controlViewDelegate?.playVideo()
            if let currentTime = playerViewDelegate?.getCurrentTime(){
                if currentTime == CMTime.zero { // Video just started playing from start
                    enableOrDisableForwardBackwardButtons(at: CMTimeMakeWithSeconds(0.5, preferredTimescale: 100))
                }else{
                    enableOrDisableForwardBackwardButtons(at: currentTime)
                }
            }
        }
    }
    
    func undoButtonTapped() {
        guard !isAudioRecordingInProgress else { return }
        let isVideoPlaying = playerViewDelegate?.isVideoPlaying() ?? false
        if isVideoPlaying {
            playPauseButtonAction()
        }
        tapped()
        shapeManger.executeUndoAction()
    }
    
    func redoButtonTapped() {
        guard !isAudioRecordingInProgress else { return }
        let isVideoPlaying = playerViewDelegate?.isVideoPlaying() ?? false
        if isVideoPlaying {
            playPauseButtonAction()
        }
        tapped()
        shapeManger.executeRedoAction()
    }
    
    func forwardButtonTapped(){
        guard !isAudioRecordingInProgress else { return }
        guard let videoPlayerDelegate = playerViewDelegate else {return}
        
        let currentTime = videoPlayerDelegate.getCurrentTime()
        var newTime = CMTimeAdd(currentTime, playBackTimeProvider.forwardSkipTime)
        if isVideoTrimmed{
            newTime = min(newTime, trimmedVideoEndTimeInCMTime)
        }
        let safeNewTime = min(newTime, videoPlayerDelegate.totalVideoDuration())
        videoPlayerDelegate.seek(to: safeNewTime)
        enableOrDisableForwardBackwardButtons(at: safeNewTime)
    }
    
    func backwardButtonTapped(){
        guard !isAudioRecordingInProgress else { return }
        guard let videoPlayerDelegate = playerViewDelegate else {return}
        
        let currentTime = videoPlayerDelegate.getCurrentTime()
        var newTime = CMTimeSubtract(currentTime, playBackTimeProvider.backwardSkipTime)
        if isVideoTrimmed{
            newTime = max(newTime, trimmedVideoStartTimeInCMTime)
        }
        let zeroSecondCMTime = CMTime(seconds: 0, preferredTimescale: 1)
        let safeNewTime = max(zeroSecondCMTime, newTime)
        videoPlayerDelegate.seek(to: safeNewTime)
        enableOrDisableForwardBackwardButtons(at: safeNewTime)
    }
    
    func fullScreenButtonTapped(){
        fullScreenButtonTapped(isAnimated: true)
    }
    
    private func fullScreenButtonTapped(isAnimated: Bool){
        guard !isAudioRecordingInProgress else { return }
        let isVideoPlaying = playerViewDelegate?.isVideoPlaying() ?? false

        if isInFullScreenPreview{
            if isVideoPlayBackMode{
                if isVideoPlaying{
                    self.controlViewDelegate?.playVideo()
                }else{
                    self.controlViewDelegate?.pauseVideo()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){ [weak self] in
                    guard let self = self else {return}
                    UIView.setAnimationsEnabled(false)
                    self.fullScreenDelegate?.exitFullScreen()
                    self.playerViewDelegate?.exitingFullScreen()
                    self.controlViewDelegate?.exitingFullScreen()
                    UIView.setAnimationsEnabled(true)
                }
            }else{
                fullScreenDelegate?.exitFullScreen()
                playerViewDelegate?.exitingFullScreen()
                controlViewDelegate?.exitingFullScreen()
                
                if isVideoPlaying{
                    controlViewDelegate?.playVideo()
                }else{
                    controlViewDelegate?.pauseVideo()
                }
            }
        }else{
            UIView.setAnimationsEnabled(isAnimated)
            controlViewDelegate?.mode = .fullScreen
            
            guard let totalDuration = totalDuration,
                  let currentTime = playerViewDelegate?.getCurrentTime() else { return }
            playerViewDelegate?.enteringFullScreen()
            fullScreenDelegate?.launchFullScreen()

            if isVideoTrimmed{
                if currentTime <= trimmedVideoStartTimeInCMTime || currentTime >= trimmedVideoEndTimeInCMTime {
                    playerViewDelegate?.seek(to: trimmedVideoStartTimeInCMTime)
                    let timeLapsedStr = playBackTimeProvider.getTimeStrForVideo(curDuration: .zero)
                    let timeRemainingStr = playBackTimeProvider.getTimeStrForVideo(curDuration: CMTimeSubtract(trimmedVideoEndTimeInCMTime, trimmedVideoStartTimeInCMTime))
                    
                    controlViewDelegate?.enteringFullScreen(curTime: trimmedVideoStartTimeInCMTime,
                                                            startTime: trimmedVideoStartTimeInCMTime,
                                                            endTime: trimmedVideoEndTimeInCMTime,
                                                            isVideoPlaying: isVideoPlaying,
                                                            timeLapsed: timeLapsedStr,
                                                            timeRemaining: timeRemainingStr)
                }else{
                    
                    let timeLapsedStr = playBackTimeProvider.getTimeStrForVideo(curDuration: CMTimeSubtract(currentTime, trimmedVideoStartTimeInCMTime))
                    let timeRemainingStr = playBackTimeProvider.getTimeStrForVideo(curDuration: CMTimeSubtract(trimmedVideoEndTimeInCMTime, trimmedVideoStartTimeInCMTime))
                    
                    controlViewDelegate?.enteringFullScreen(curTime: currentTime,
                                                            startTime: trimmedVideoStartTimeInCMTime,
                                                            endTime: trimmedVideoEndTimeInCMTime,
                                                            isVideoPlaying: isVideoPlaying,
                                                            timeLapsed: timeLapsedStr,
                                                            timeRemaining: timeRemainingStr)
                }
            }else{
                let timeLapsedStr = playBackTimeProvider.getTimeStrForVideo(curDuration: currentTime)
                let timeRemainingStr = playBackTimeProvider.getTimeStrForVideo(curDuration: totalDuration)
                
                controlViewDelegate?.enteringFullScreen(curTime: currentTime,
                                                        startTime: CMTime.zero,
                                                        endTime: totalDuration,
                                                        isVideoPlaying: isVideoPlaying,
                                                        timeLapsed: timeLapsedStr,
                                                        timeRemaining: timeRemainingStr)
            }
            UIView.setAnimationsEnabled(true)
        }
        
        isInFullScreenPreview.toggle()
    }
    
    
    private func enableOrDisableForwardBackwardButtons(at time: CMTime){
        guard let totalDuration = totalDuration else {return}
        switch time {
        case CMTime.zero:
            controlViewDelegate?.backwardButton(shouldEnable: false)
            controlViewDelegate?.forwardButton(shouldEnable: true)
        case totalDuration:
            controlViewDelegate?.backwardButton(shouldEnable: true)
            controlViewDelegate?.forwardButton(shouldEnable: false)
        default:
            controlViewDelegate?.backwardButton(shouldEnable: true)
            controlViewDelegate?.forwardButton(shouldEnable: true)
        }
    }
    
    func muteUnmuteButtonTapped() {
        guard let isSoundEnabled = playerViewDelegate?.isSoundEnabled() else {return}
        isAudioOfVideoIsMutedByUser = false
        if isSoundEnabled{
            isAudioOfVideoIsMutedByUser = true
        }
        let newSoundState = !isSoundEnabled
        controlViewDelegate?.sound(shouldEnable: newSoundState)
        playerViewDelegate?.sound(shouldEnable: newSoundState)
        //        shapeManger.audioPlayerSound(shouldEnable: newSoundState)
    }
    
    func deleteButtonTapped() {
        shapeManger.removeSelectedShape()
        bottomToolbarViewDelegate?.selectedShapeDeleted()
    }
    
    func shouldShowSoundOnOffButton() -> Bool {
        if RPScreenRecorder.shared().isAvailable, RPScreenRecorder.shared().isMicrophoneEnabled {
            let isAudioAvailable = audioVMDelegate?.isAudioTrackRecordedWithVideoAvailable() ?? true
            return isAudioAvailable
        }
        return false
    }
    
}


extension AnnotatorViewModel: VideoThumbnailViewModelProtocol{
    
    var asset: AVAsset {
        AVAsset(url: videoFileUrl)
    }
    
    var totalDuration: CMTime? {
        playerViewDelegate?.totalVideoDuration()
    }
    
    var numberOfThumbnails: Int {
        10
    }
    
    func scrollViewBeganScrolling() {
        guard let isVideoPlaying = playerViewDelegate?.isVideoPlaying() else {return}
        shapeManger.videoScrollingStarted()
        if isVideoPlaying{
            playerViewDelegate?.pause()
            controlViewDelegate?.pauseVideo()
        }
//        isVideoPlayingWhenScrollingStarted = isVideoPlaying
        //        isAutoScrollForScrollViewEnabled = false
    }
    
    func scrollViewScrolling(withOffSet offset: CGPoint, withReferenceWidth referenceWidth: CGFloat){
        scrollViewEndScrolling(withOffSet: offset, withReferenceWidth: referenceWidth)
    }
    
    func scrollViewEndScrolling(withOffSet offset: CGPoint, withReferenceWidth referenceWidth: CGFloat) {
        
        guard let totalDuration = totalDuration else {return}
        let totalWidth = referenceWidth
        let totalDurationInSeconds = CMTimeGetSeconds(totalDuration)
        let timeToSeek = totalDurationInSeconds * (offset.x / totalWidth )
        let timeToSeekInCMTime = CMTime(seconds: timeToSeek, preferredTimescale: totalDuration.timescale)
        hideOrShowShapesAndseekTheVideoPlayer(to: timeToSeekInCMTime)
        
        //        if isVideoPlayingWhenScrollingStarted{
        //            playerViewDelegate?.play()
        //            controlViewDelegate?.playVideo()
        //            isVideoPlayingWhenScrollingStarted = false
        //        }
        
        //DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
            //            self.isAutoScrollForScrollViewEnabled = true
        //}
        enableOrDisableForwardBackwardButtons(at: timeToSeekInCMTime)
    }
    
    private func hideOrShowShapesAndseekTheVideoPlayer(to time: CMTime){
        playerViewDelegate?.seek(to: time)
        shapeManger.hideOrShowAddedShapesAt(time: time)
    }
    
    func scrollViewTapped() {
        controlViewDelegate?.shouldHideMuteAndFullScreenButtonsAndShowDeleteButton(false)
        shapeManger.videoTapped()
        bottomToolbarViewDelegate?.refreshUIBasedOnCurrentState()
        if isVideoTrimmingEnabled{
            videoThumbnailViewDelegate?.disableVideoTrimming()
            isVideoTrimmingEnabled = false
        }
    }
    func thumbnailTapped(){
        if !isVideoTrimmingEnabled{ // If video trimming not enabled then enable it
            videoThumbnailViewDelegate?.enableVideoTrimming()
            currentTrimmingStartTimeInCMTime = trimmedVideoStartTimeInCMTime
            currentTrimmingEndTimeInCMTime = trimmedVideoEndTimeInCMTime
            isVideoTrimmingEnabled = !isVideoTrimmingEnabled
        }
    }
}


extension AnnotatorViewModel: ShapeSizeUpdationDelegateProtocol{
    
    func showPanningElementOutOfTrimmedDurationAlert(){
        annotatorViewDelegate?.showElementDurationAlert()
    }
    
    func canPanTo(offset: CGFloat, totalWidth: CGFloat) -> Bool {
        guard let totalVideoDuration = playerViewDelegate?.totalVideoDuration() else {return false}
        
        let totalWidthOfView: Double = Double(totalWidth)
        let panDestinationTime = (CMTimeGetSeconds(totalVideoDuration) * offset) / totalWidthOfView
        let panDestinationTimeInCMTime = CMTime(seconds: panDestinationTime, preferredTimescale: totalVideoDuration.timescale)
        
        if isVideoTrimmed{
            if panDestinationTimeInCMTime < trimmedVideoStartTimeInCMTime || panDestinationTimeInCMTime > trimmedVideoEndTimeInCMTime { // If time of out of range of trimmed video then return false
                return false
            }
        }
        return true
    }
    
    func canLongPressPanTo(start: CGFloat, end: CGFloat, totalWidth: CGFloat) -> Bool{
        guard let totalVideoDuration = playerViewDelegate?.totalVideoDuration() else {return true}
        guard isVideoTrimmed else {return true}
        
        let trimStartTime = (totalWidth * CMTimeGetSeconds(trimmedVideoStartTimeInCMTime)) / CMTimeGetSeconds(totalVideoDuration)
        let trimEndTime = (totalWidth * CMTimeGetSeconds(trimmedVideoEndTimeInCMTime)) / CMTimeGetSeconds(totalVideoDuration)
        if start >= trimStartTime, end <= trimEndTime {
            return true
        }
        return false
    }
    
    func getTimeOffsetFor(totalWidth: CGFloat, offset: CGFloat) -> CGFloat{ // Return trimming video start time x offset based on the passed param 'offset'. If parm 'offset' is less than trim start time then this will return trim start time x offset other wise it will return trim end time offset
        guard let totalVideoDuration = playerViewDelegate?.totalVideoDuration() else {return 0}
        let startTimeOffset = (totalWidth * CMTimeGetSeconds(trimmedVideoStartTimeInCMTime)) / CMTimeGetSeconds(totalVideoDuration)
        let endTimeOffset = (totalWidth * CMTimeGetSeconds(trimmedVideoEndTimeInCMTime)) / CMTimeGetSeconds(totalVideoDuration)
        
        let deltaFactor = totalWidth * minTrimPaddingFactor
        
        if offset < startTimeOffset {
            return startTimeOffset + deltaFactor
        }
        return endTimeOffset - deltaFactor
    }
    
    func getTrimStartTimeOffsetFor(totalWidth: CGFloat) -> CGFloat{
        guard let totalVideoDuration = playerViewDelegate?.totalVideoDuration() else {return 0}
        let returningOffset = (totalWidth * CMTimeGetSeconds(trimmedVideoStartTimeInCMTime)) / CMTimeGetSeconds(totalVideoDuration)
        let deltaFactor = totalWidth * minTrimPaddingFactor
        return returningOffset + deltaFactor
    }
    
    func getTrimEndTimeOffsetFor(totalWidth: CGFloat) -> CGFloat{
        guard let totalVideoDuration = playerViewDelegate?.totalVideoDuration() else {return 0}
        let returningOffset = (totalWidth * CMTimeGetSeconds(trimmedVideoEndTimeInCMTime)) / CMTimeGetSeconds(totalVideoDuration)
        let deltaFactor = totalWidth * minTrimPaddingFactor
        return returningOffset - deltaFactor
    }
    
    func shouldStartLongPress(forStart start: CGFloat, end: CGFloat, totalWidth: CGFloat) -> Bool {
        guard let totalVideoDuration = playerViewDelegate?.totalVideoDuration() else {return true}
        guard isVideoTrimmed else {return true}
        
        let trimStartTime = (totalWidth * CMTimeGetSeconds(trimmedVideoStartTimeInCMTime)) / CMTimeGetSeconds(totalVideoDuration)
        let trimEndTime = (totalWidth * CMTimeGetSeconds(trimmedVideoEndTimeInCMTime)) / CMTimeGetSeconds(totalVideoDuration)
        if start >= trimStartTime, end <= trimEndTime {
            return true
        }
        return false
    }
    
    
    func longPressStarted() {
        guard let isVideoPlaying = playerViewDelegate?.isVideoPlaying() else {return}
        if isVideoPlaying{ // Stop playing video once audio recording is stopped
            playPauseButtonAction()
        }
    }
    
    func shapesLongPressChanging(xOffset offset: Double, totalWidth: CGFloat, view: UIView){
        guard let totalVideoDuration = playerViewDelegate?.totalVideoDuration() else {return}
        
        let totalWidthOfView: Double = Double(totalWidth)
        let offsetX = offset
        let offsetTimeToShowShape = (CMTimeGetSeconds(totalVideoDuration) * offsetX) / totalWidthOfView
        let offsetTimeToShowShapeInCMTime = CMTime(seconds: offsetTimeToShowShape, preferredTimescale: totalVideoDuration.timescale)

        playerViewDelegate?.seekForShapeHandlerChanges(to: offsetTimeToShowShapeInCMTime)
        shapeManger.hideOrShowAddedShapesAt(time: offsetTimeToShowShapeInCMTime)
        
        if currentlyShownShapeViewAsResultOfRowViewTimeChanges == nil{ // To show the selected shape in the player view without updating the model addedShapesDictionary dictionary.
            for (shapeRowView ,addedViewDetails) in shapeManger.addedShapesDictionary{
                guard let rowView = addedViewDetails.rowView else { continue }
                if rowView == view {
                    currentlyShownShapeViewAsResultOfRowViewTimeChanges = shapeRowView
                    break
                }
            }
        }
        currentlyShownShapeViewAsResultOfRowViewTimeChanges?.isHidden = false
    }
    
    func shapesLongPressEnded(forBlockViewFrame blockViewFrame: CGRect, totalWidth: CGFloat, view: UIView, isElementOutsideOfTrimRangeAllowed: Bool){
        guard let totalVideoDuration = playerViewDelegate?.totalVideoDuration() else {return}
        shapeManger.updateBlockView(withFrame: blockViewFrame, totalWidth: totalWidth,videoDuration:totalVideoDuration, view: view)
        playerViewDelegate?.seekHandlerChangesEnded()
        
        let totalWidthOfView: Double = Double(totalWidth)
        let startX = blockViewFrame.origin.x
                
        let startTimeToShowShape = (CMTimeGetSeconds(totalVideoDuration) * startX) / totalWidthOfView
        let startTimeInCMTime = CMTime(seconds: startTimeToShowShape, preferredTimescale: totalVideoDuration.timescale)
        let seekingTime = startTimeInCMTime // Always Scroll to start of the shape time when long press ended

        if isElementOutsideOfTrimRangeAllowed, isVideoTrimmed{
            if seekingTime >= trimmedVideoStartTimeInCMTime, seekingTime <= trimmedVideoEndTimeInCMTime{
                UIView.animate(withDuration: 0.3){
                    self.updateScroll(time: seekingTime, withTotalDuration: totalVideoDuration)
                }completion: { _ in
                    self.playerViewDelegate?.seek(to: seekingTime)
                }
            }else{ // If start time is out of trim range then scroll to shape end point if it is inside trim range
                let endX = blockViewFrame.origin.x + blockViewFrame.size.width
                let endTimeToShowShape = (CMTimeGetSeconds(totalVideoDuration) * endX) / totalWidthOfView
                let endTimeInCMTime = CMTime(seconds: endTimeToShowShape, preferredTimescale: totalVideoDuration.timescale)
                if endTimeInCMTime >= trimmedVideoStartTimeInCMTime, endTimeInCMTime <= trimmedVideoEndTimeInCMTime{
                    UIView.animate(withDuration: 0.3){
                        self.updateScroll(time: endTimeInCMTime, withTotalDuration: totalVideoDuration)
                    }completion: { _ in
                        self.playerViewDelegate?.seek(to: endTimeInCMTime)
                    }
                }
            }
        }else{
            
            UIView.animate(withDuration: 0.3){
                self.updateScroll(time: seekingTime, withTotalDuration: totalVideoDuration)
            }completion: { _ in
                self.playerViewDelegate?.seek(to: seekingTime)
            }
        }
        
        currentlyShownShapeViewAsResultOfRowViewTimeChanges = nil  // Once the model addedShapesDictionary dictionary is updated no need to have reference to it.
    }
    
    func shapeSizeUpdated(withBlockViewFrame blockViewFrame: CGRect, totalWidth: CGFloat, view: UIView, isLeftHandler: Bool, isElementOutsideOfTrimRangeAllowed: Bool){
        guard let totalVideoDuration = playerViewDelegate?.totalVideoDuration() else {return}
        shapeManger.updateBlockView(withFrame: blockViewFrame, totalWidth: totalWidth,videoDuration:totalVideoDuration, view: view)
        
        playerViewDelegate?.seekHandlerChangesEnded()
        
        let totalWidthOfView: Double = Double(totalWidth)
        let startX = blockViewFrame.origin.x
        let endX = blockViewFrame.origin.x + blockViewFrame.size.width
        
        let startTimeToShowShape = (CMTimeGetSeconds(totalVideoDuration) * startX) / totalWidthOfView
        let endTimeToShowShape = (CMTimeGetSeconds(totalVideoDuration) * endX) / totalWidthOfView
        
        let startTimeInCMTime = CMTime(seconds: startTimeToShowShape, preferredTimescale: totalVideoDuration.timescale)
        let endTimeInCMTime = CMTime(seconds: endTimeToShowShape, preferredTimescale: totalVideoDuration.timescale)
        
        let seekingTime = isLeftHandler ? startTimeInCMTime : endTimeInCMTime
        
        if isElementOutsideOfTrimRangeAllowed, isVideoTrimmed{
            if seekingTime >= trimmedVideoStartTimeInCMTime, seekingTime <= trimmedVideoEndTimeInCMTime{
                UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                    self.updateScroll(time: seekingTime, withTotalDuration: totalVideoDuration)
                }
            }
        }else{
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                self.updateScroll(time: seekingTime, withTotalDuration: totalVideoDuration)
            }
        }
        currentlyShownShapeViewAsResultOfRowViewTimeChanges = nil  // Once the model addedShapesDictionary dictionary is updated no need to have reference to it.
    }
    
    func shapeSizeUpdating(offset: CGFloat, blockViewFrame: CGRect, totalWidth: CGFloat, view: UIView){
        guard let totalVideoDuration = playerViewDelegate?.totalVideoDuration() else {return}
        
        let totalWidthOfView: Double = Double(totalWidth)
        let offsetX = offset
        let offsetTimeToShowShape = (CMTimeGetSeconds(totalVideoDuration) * offsetX) / totalWidthOfView
        let offsetTimeToShowShapeInCMTime = CMTime(seconds: offsetTimeToShowShape, preferredTimescale: totalVideoDuration.timescale)

        playerViewDelegate?.seekForShapeHandlerChanges(to: offsetTimeToShowShapeInCMTime)
        shapeManger.hideOrShowAddedShapesAt(time: offsetTimeToShowShapeInCMTime)
        
        if currentlyShownShapeViewAsResultOfRowViewTimeChanges == nil{ // To show the selected shape in the player view without updating the model addedShapesDictionary dictionary.
            for (shapeRowView ,addedViewDetails) in shapeManger.addedShapesDictionary{
                guard let rowView = addedViewDetails.rowView else { continue }
                if rowView == view {
                    currentlyShownShapeViewAsResultOfRowViewTimeChanges = shapeRowView
                    break
                }
            }
        }
        currentlyShownShapeViewAsResultOfRowViewTimeChanges?.isHidden = false
    }
    
    func scrollToSelected(view: ShapeRowViewProtocol) {
        videoThumbnailViewDelegate?.scrollTo(view)
    }
    
    func tappedBlock(view: ShapeRowViewProtocol, isElementOutsideOfTrimRangeAllowed: Bool) {
        shapeManger.tappedBlock(view: view)
        for (_,addedViewDetails) in shapeManger.addedShapesDictionary{
            guard let rowView = addedViewDetails.rowView else { continue }
            if rowView == view {
                if let curTime = playerViewDelegate?.getCurrentTime(){
                    let shapeStartTime = addedViewDetails.startTime
                    let shapeEndTime = addedViewDetails.endTime
                    if isElementOutsideOfTrimRangeAllowed,isVideoTrimmed{ // If element outside of trim range is allowed then seek only if that element is with in the trim range
                        if shapeStartTime >= trimmedVideoStartTimeInCMTime, shapeStartTime <= trimmedVideoEndTimeInCMTime,
                           shapeEndTime >= trimmedVideoStartTimeInCMTime, shapeEndTime <= trimmedVideoEndTimeInCMTime{
                                if curTime < shapeStartTime {
                                    self.playerViewDelegate?.seek(to: shapeStartTime)
                                }else if curTime > shapeEndTime{
                                    self.playerViewDelegate?.seek(to: shapeEndTime)
                                }
                        }
                    }else{
                        if curTime < shapeStartTime {
                            self.playerViewDelegate?.seek(to: shapeStartTime)
                        }else if curTime > shapeEndTime{
                            self.playerViewDelegate?.seek(to: shapeEndTime)
                        }
                    }
                }
                break
            }
        }
    }
    
    func longPressed(view: ShapeRowViewProtocol) {
        shapeManger.tappedBlock(view: view)
    }
}

extension AnnotatorViewModel: RefresherProtocol {
    func setNewScreenRatio(newFactor: CGFloat, normalFactor: CGFloat) {
        playerViewDelegate?.setScreen(newRatio: newFactor, normalRatio: normalFactor)
    }
    
    func getParentViewHeight() -> CGFloat {
        annotatorViewDelegate?.getParentViewHeight() ?? 0
    }
    
    
    func shapeRemoved() {
        //        colorPickerViewDelegate?.showOrHideColorPicker()
        controlViewDelegate?.shouldHideMuteAndFullScreenButtonsAndShowDeleteButton(false)
    }
    
    func refreshSelectedColorInPalatte(){
        //        colorPickerViewDelegate?.refreshSelectedColor()
    }
    
    func tappedNewShape() {
        //        colorPickerViewDelegate?.showOrHideColorPicker()
        controlViewDelegate?.shouldHideMuteAndFullScreenButtonsAndShowDeleteButton(true)
        
        guard let selectedShapeType = shapeManger.selectedShapeView?.model.shape.type else {return}
        bottomToolbarViewDelegate?.updateUIBasedOnSelected(shapeType: selectedShapeType)
    }
    
    func tappedOutside() {
        tapped()
    }
    
    func shapeChangeActionExecuted() {
        controlViewDelegate?.refreshUndoRedoButtons()
    }
    
    func getViewForShapeAddition() -> UIView? {
        playerViewDelegate?.getViewForShapeAddition()
    }
    
    func getViewForRowAddition() -> UIStackView? {
        videoThumbnailViewDelegate?.getViewForRowAddition()
    }
    
    func isVideoPlaying() -> Bool{
        playerViewDelegate?.isVideoPlaying() ?? false
    }
    
    func audioRecordingWillStart() {
        guard let isVideoPlaying = playerViewDelegate?.isVideoPlaying() else {return}
        if !isVideoPlaying{
            playPauseButtonAction()
            if playerViewDelegate?.isSoundEnabled() ?? false {
                playerViewDelegate?.sound(shouldEnable: false)
                isAudioOfVideoIsMutedDueToAudioRecording = true
            }
//            controlViewDelegate?.sound(shouldEnable: false)
        }
    }
    
    func audioRecordingStarted(at startTime: CMTime){
        videoThumbnailViewDelegate?.audioRecordingStarted(at: startTime)
        audioRecodingNotifyingDelegate?.started()
        bottomToolbarViewDelegate?.audioRecordingStarted()
    }
    
    func audioRecordingCancelled(){
        if isAudioOfVideoIsMutedDueToAudioRecording{
            isAudioOfVideoIsMutedDueToAudioRecording = false
            playerViewDelegate?.sound(shouldEnable: true)
        }
        videoThumbnailViewDelegate?.audioRecordingEnded()
        audioRecodingNotifyingDelegate?.cancelled()
        audioVMDelegate?.currentRecordingCancelled()
        
        guard let isVideoPlaying = playerViewDelegate?.isVideoPlaying() else {return}
        if isVideoPlaying{ // Stop playing video once audio recording is stopped
            playPauseButtonAction()
        }
        bottomToolbarViewDelegate?.audioRecordingEnded()
    }
    
    func audioRecordingEnded(audioModel: RecordedAudioModel){
        if isAudioOfVideoIsMutedDueToAudioRecording{
            isAudioOfVideoIsMutedDueToAudioRecording = false
            playerViewDelegate?.sound(shouldEnable: true)
        }
        videoThumbnailViewDelegate?.audioRecordingEnded()
        audioRecodingNotifyingDelegate?.ended()
        if let audioModel = audioVMDelegate?.recordingEnded(audioModel: audioModel){
            shapeManger.addAudioAdditionInUndoableAction(model: audioModel)
        }
        
        guard let isVideoPlaying = playerViewDelegate?.isVideoPlaying() else {return}
        if isVideoPlaying{ // Stop playing video once audio recording is stopped
            playPauseButtonAction()
        }
        bottomToolbarViewDelegate?.audioRecordingEnded()
    }
    
    func removeAudioModel(_ model: AudioModel) {
        audioVMDelegate?.removeAudio(model: model)
    }
    
    func addAudioModel(_ model: AudioModel) {
        audioVMDelegate?.addAudio(model: model)
    }
    
    func alertUserPauseVideoBeforeRecordingAudio() {
        annotatorViewDelegate?.showPauseVideoBeforeRecordingAudioAlert()
    }
    
    func alertUserToRemoveExistingRecordings() {
        annotatorViewDelegate?.showRemoveAudioAlert()
    }
    
    func alertUserAbtTextLimitReached() {
        annotatorViewDelegate?.showTxtLimitReachedAlert()
    }
    
    func removeAudioViewStartingAt(time: CMTime) {
        controlViewDelegate?.shouldHideMuteAndFullScreenButtonsAndShowDeleteButton(false)
        if let audioModel = audioVMDelegate?.removeAudioViewStartingAt(time: time){
            shapeManger.addAudioDeletionInUndoableAction(model: audioModel)
        }
    }
    
    func removeAudioViewOfRecordedVideo(){
        isAudioOfRecordedVideoDeleted = true
        controlViewDelegate?.shouldHideMuteAndFullScreenButtonsAndShowDeleteButton(false)
        audioVMDelegate?.deSelectAndRemoveAudioViewOfRecordedVideo()
        playerViewDelegate?.shouldEnableAudioTrackFromRecordedVideo(false)
    }
    
    func addAudioViewOfRecordedVideo(){
        isAudioOfRecordedVideoDeleted = false
        controlViewDelegate?.shouldHideMuteAndFullScreenButtonsAndShowDeleteButton(false)
        audioVMDelegate?.addAudioViewOfRecordedVideo()
        playerViewDelegate?.shouldEnableAudioTrackFromRecordedVideo(true)
    }
    
    func deSelectSelectedAudioTrackView(startingAt: CMTime) {
        controlViewDelegate?.shouldHideMuteAndFullScreenButtonsAndShowDeleteButton(false)
        audioVMDelegate?.deSelectAudioViewStartingAt(time: startingAt)
    }
    
    func deSelectSelectedAudioTrackOfVideo(){
        controlViewDelegate?.shouldHideMuteAndFullScreenButtonsAndShowDeleteButton(false)
        audioVMDelegate?.deSelectAudioViewOfRecordedVideo()
    }
    
    func endAudioRecordingAndShowAlertToRemoveExistingRecordingToContinueRecording(){
        audioRecordingButtonTapped()
        alertUserToRemoveExistingRecordings()
    }
    
    func showPauseVideoPlayingBeforeRecordingAlert(){
        alertUserPauseVideoBeforeRecordingAudio()
    }
    
    func updateTheVideoTrimmingTo(startTime: CMTime, endTime: CMTime) {
        isVideoTrimmed = true
        trimmedVideoStartTimeInCMTime = startTime
        trimmedVideoEndTimeInCMTime = endTime
        
        currentTrimmingStartTimeInCMTime = startTime
        currentTrimmingEndTimeInCMTime = endTime

        guard let totalDuration = playerViewDelegate?.totalVideoDuration() else {return}
        videoThumbnailViewDelegate?.updateTheVideoTrimmingTo(startTime: startTime, endTime: endTime, totalDuration: totalDuration)
    }
    
    func updateTheVideoTrimmingToInitialState(){
        guard let totalDuration = playerViewDelegate?.totalVideoDuration() else {return}
        isVideoTrimmed = true
        trimmedVideoStartTimeInCMTime = CMTime.zero
        trimmedVideoEndTimeInCMTime = totalDuration
        
        currentTrimmingStartTimeInCMTime = trimmedVideoStartTimeInCMTime
        currentTrimmingEndTimeInCMTime = trimmedVideoEndTimeInCMTime
        
        videoThumbnailViewDelegate?.updateTheVideoTrimmingTo(startTime: trimmedVideoStartTimeInCMTime, endTime: trimmedVideoEndTimeInCMTime, totalDuration: totalDuration)
    }
    
    func scrollAfterUndoRedo(start: CMTime, end: CMTime) {
        guard let time = playerViewDelegate?.getCurrentTime() else {return}
        if time >= start, time <= end {return}
        playerViewDelegate?.seek(to: start)
    }
    
    func getContainerSize() -> CGSize {
        guard let refSize = playerViewDelegate?.getVideoPlayerBoundingBoxSize() else {
            return .zero
        }
        return refSize
    }
}

extension AnnotatorViewModel: VideoTrimmingViewModelProtocol{
    
    func trimmingStarted() {
        guard let isVideoPlaying = playerViewDelegate?.isVideoPlaying() else {return}
        if isVideoPlaying{
            playerViewDelegate?.pause()
            controlViewDelegate?.pauseVideo()
        }
    }
    
    func trimVideo(withTotalContentWidth totalWidth: CGFloat, startPoint: CGFloat, endPoint: CGFloat, isStartTimeChanged: Bool){
        guard let totalDuration = playerViewDelegate?.totalVideoDuration() else {return}
        let startTime = CMTimeGetSeconds(totalDuration) * startPoint/totalWidth
        let endTime = CMTimeGetSeconds(totalDuration) * endPoint/totalWidth
        
        currentTrimmingStartTimeInCMTime = CMTimeMakeWithSeconds(startTime, preferredTimescale: totalDuration.timescale)
        currentTrimmingEndTimeInCMTime = CMTimeMakeWithSeconds(endTime, preferredTimescale: totalDuration.timescale)
        trimmingEnded(isStartTimeChanged: isStartTimeChanged)
        playerViewDelegate?.seekHandlerChangesEnded()
    }
    
    func trimInProgress(atOffset offset: CGFloat, totalWidth: CGFloat){
        guard let totalVideoDuration = playerViewDelegate?.totalVideoDuration() else {return}
        let totalWidthOfView: Double = Double(totalWidth)
        let offsetX = offset
        let offsetTimeToShowShape = (CMTimeGetSeconds(totalVideoDuration) * offsetX) / totalWidthOfView
        let offsetTimeToShowShapeInCMTime = CMTime(seconds: offsetTimeToShowShape, preferredTimescale: totalVideoDuration.timescale)
        playerViewDelegate?.seekForShapeHandlerChanges(to: offsetTimeToShowShapeInCMTime)
        shapeManger.hideOrShowAddedShapesAt(time: offsetTimeToShowShapeInCMTime)
    }
}


extension AnnotatorViewModel: AnnotationAudioVMProtocol{
    func updateModel(_ newModel: RecordedAudioModel, startingAt: CMTime) {
        shapeManger.updateModel(newModel: newModel, startingAt: startingAt)
    }
    
    
    func selectedAudioTrack(startingAt: CMTime) {
        let isVideoPlaying = playerViewDelegate?.isVideoPlaying() ?? false
        if isVideoPlaying{
            playPauseButtonAction()
        }
        shapeManger.audioTrackTapped(startingAt: startingAt)
        controlViewDelegate?.shouldHideMuteAndFullScreenButtonsAndShowDeleteButton(true)
    }
    
    func selectedAudioTrackOfRecordedVideo(){
        let isVideoPlaying = playerViewDelegate?.isVideoPlaying() ?? false
        if isVideoPlaying{
            playPauseButtonAction()
        }
        shapeManger.audioTrackOfVideoTapped()
        controlViewDelegate?.shouldHideMuteAndFullScreenButtonsAndShowDeleteButton(true)
    }
    
    func refreshSoundButtonState(){
        controlViewDelegate?.refreshSoundButtonState()
    }
}

struct VideoSendEditDetailsInfo{
    let isVideoTrimmed: Bool
    let startTime: CMTime
    let endTime: CMTime
    let addedShape: [UIView:AddedShapeDetails]
    let audios: [RecordedAudioModel]
    var isAudioRecorded: Bool = true
    var isOriginalAudioTrackInVideoRecordingDeleted: Bool = false
}
