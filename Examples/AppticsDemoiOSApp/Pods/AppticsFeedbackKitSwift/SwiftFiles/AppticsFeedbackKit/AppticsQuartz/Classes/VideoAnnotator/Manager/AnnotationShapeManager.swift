//
//  AnnotationShapeManager.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 20/09/23.
//

import UIKit
import CoreMedia


protocol RefresherProtocol: AnyObject{
    func refreshSelectedColorInPalatte()
    func shapeRemoved()
    func tappedNewShape()
    func tappedOutside()
    func shapeChangeActionExecuted()
    func getViewForShapeAddition() -> UIView?
    func getViewForRowAddition() -> UIStackView?
    
    func alertUserToRemoveExistingRecordings()
    func alertUserAbtTextLimitReached()
    func getParentViewHeight() -> CGFloat
    
    func audioRecordingWillStart()
    func audioRecordingStarted(at: CMTime)
    func audioRecordingCancelled()
    func audioRecordingEnded(audioModel: RecordedAudioModel)
    func removeAudioViewStartingAt(time: CMTime)
    func removeAudioViewOfRecordedVideo()
    func addAudioViewOfRecordedVideo()
    
    func deSelectSelectedAudioTrackView(startingAt: CMTime)
    func deSelectSelectedAudioTrackOfVideo()
    
    func endAudioRecordingAndShowAlertToRemoveExistingRecordingToContinueRecording()
    
    func updateTheVideoTrimmingTo(startTime: CMTime, endTime: CMTime)
    func updateTheVideoTrimmingToInitialState()

    func removeAudioModel(_: AudioModel)
    func addAudioModel(_: AudioModel)
    
    func textEditTapped()
    func textBecameFirstResponder()
    
    func isVideoPlaying() -> Bool
    func showPauseVideoPlayingBeforeRecordingAlert()
    
    func scrollAfterUndoRedo(start : CMTime, end: CMTime)
    func getContainerSize() -> CGSize
    
    func setNewScreenRatio(newFactor: CGFloat, normalFactor: CGFloat)
}

protocol AnnotationShapeManagerProtocol: AudioRecordingManagingProtocol{
    var refresherDelegate: RefresherProtocol? { get set}
    var selectedShapeView: AnnotationShapeViewProtocol? { get }
    var colors: [UIColor] { get }
    var currentlySelectedColorIndex: Int { get }
    var colorIndexForNewShape: Int { get }
    
    var areUndoActionsAvailable: Bool { get }
    var areRedoActionsAvailable: Bool { get }
    
    var addedShapesDictionary: [UIView:AddedShapeDetails] { get }
    
    var areChangesDoneToAnnotation: Bool { get }
    var numberOfChangesDone: Int { get set }
    
    func getShapeAndRowShapeView(forShape shape: AddedShape, videoContainerSize: CGSize, curTime: CMTime, totalDuration: CMTime) -> (view: AnnotationShapeViewProtocol, frame: CGRect, detail : AddedShapeDetails)
    func saveShapeDetailsAndRowView(_ view: ShapeRowViewProtocol,details: AddedShapeDetails, forShapeView shapeView: UIView)
    
    func hideOrShowAddedShapesAt(time: CMTime)
    
    func updateBlockView(withFrame blockViewFrame: CGRect, totalWidth: CGFloat, videoDuration: CMTime, view: UIView)
    func pickedColorAt(index: Int)
    
    func textEntered(_ : String)
    func borderStyleSelected(_: BorderStyleType)
    func borderWidthSelectionChangeTo(_: Int)
    func borderWidthSelectionChangesEnded(_ newValue: Int)
    func textSizeChangeTo(_: Int)
    func textSizeChangesEnded(_: Int)
    
    func textOpacityChangeTo(_: CGFloat)
    func textOpacityChangesEnded(_: CGFloat)
    
    func txtStyleSelected(_: TextStyle)
    func txtEditTapped()
    
    func videoTapped()
    func tappedBlock(view: ShapeRowViewProtocol)
    
    func executeUndoAction()
    func executeRedoAction()
    
    func removeSelectedShape()
    func audioTrackTapped(startingAt: CMTime)
    func audioTrackOfVideoTapped()
    
    func getAudioModel() -> [RecordedAudioModel]
    
    func updateModel(newModel : RecordedAudioModel, startingAt: CMTime)
    func checkAndPlayRecordedAudiosIfAvailable(at time: CMTime) -> Bool
    func videoScrollingStarted()
    func audioPlayerSound(shouldEnable: Bool)
    func playPauseButtonAction()
    
    func addVideoTrimmingInUndoableAction(oldStartTime: CMTime, oldEndTime: CMTime, newStartTime: CMTime, newEndTime: CMTime)
    func addVideoTrimmingDeletionInUndoableAction(startTime: CMTime, endTime: CMTime)

    func addAudioAdditionInUndoableAction(model: AudioModel)
    func addAudioDeletionInUndoableAction(model: AudioModel)
    
    func updateShapesWithNewParentSize(_ parentSize: CGSize, isInFullScreenPreview: Bool)
    func isRecordedAudioPlaying() -> Bool
    
    func cancelLastAppliedShapeChanges()
}



class AnnotationShapeManager{
    weak var refresherDelegate: RefresherProtocol?
    
    var selectedShapeView: AnnotationShapeViewProtocol? = nil
    private var selectedShapeColorIndex: Int = 0
    
    let defaultShapeAttributesProvider: DefaultShapeAttributesProviderProtocol
    let timeHandler: TimeHandlerProtocol
    
    var addedShapesDictionary: [UIView:AddedShapeDetails] = [:]
    
    typealias RedoActionManager = UndoActionManager
    
    let undoManager = UndoActionManager()
    let redoManager = RedoActionManager()
    
    var audioRecorder: AudioRecorderProtocol = AudioRecorder()
    var audioRecorderStartTime: CMTime? = nil
    var audioModels: [RecordedAudioModel] = []
    var selectedAudioTrackStartTime: CMTime? = nil
    var isAudioTrackOfVideoSelected = false
    
    private var audioPlayer: AudioPlayerProtocol = AudioPlayer()

    var numberOfChangesDone = 0
    
    init(defaultShapeSizeProvider: DefaultShapeAttributesProviderProtocol = DefaultShapeAttributesProvider(),
         timeHandler: TimeHandlerProtocol = TimeHandler()) {
        self.defaultShapeAttributesProvider = defaultShapeSizeProvider
        self.timeHandler = timeHandler
    }
    
    private func getShapeDetails(_ shape: AddedShape,
                                 view: AnnotationShapeViewProtocol,
                                 viewRect: CGRect,
                                 curTime: CMTime,
                                 totalDuration: CMTime,
                                 videoContainerSize: CGSize) -> AddedShapeDetails {
        let (startTime, endTime) = timeHandler.getShapeStartAndEndTimeWithInLimit(withCurTime: curTime, totalDuration: totalDuration)
        let shapeRect = viewRect
        let shapeDetail = AddedShapeDetails(shape: shape, rect: shapeRect, refSize: videoContainerSize, startTime: startTime, endTime: endTime)
        return shapeDetail
    }
    
    private func getAnnotationShapeView(forShape shape: AddedShape, containerSize: CGSize) -> (view: AnnotationShapeViewProtocol, frame: CGRect){
        var shapeRect: CGRect = .zero
        let shapeSize = defaultShapeAttributesProvider.getSizeFor(shape: shape)
        shapeRect = CGRect(x: (containerSize.width / 2.0) - (shapeSize.width / 2.0) ,
                           y: (containerSize.height / 2.0) - (shapeSize.height / 2.0),
                           width: shapeSize.width,
                           height: shapeSize.height)
        
        let mainScreenWidth = UIScreen.main.bounds.width
        let aspectRatio = containerSize.width / mainScreenWidth
        let viewModel =  AnnotationRectangleCircleShapeModel(shape: shape, defaultProvider: defaultShapeAttributesProvider, aspectRatio: aspectRatio)
        let view = AnnotationRectangleCircleView(model:viewModel, delegate: self)
        return (view,shapeRect)
    }
    
    private func getColorChangeAction(fromColor: UIColor,
                                      toColor: UIColor,
                                      sourceView: AnnotationShapeViewProtocol,
                                      rowView: ShapeRowViewProtocol) -> Action? {
        guard let fromIndex = getIndexOf(color: fromColor),
              let toIndex = getIndexOf(color: toColor) else {return nil}
        let action = Action(type: .colorChange(from: fromIndex, to: toIndex),
                            sourceView: sourceView,
                            rowView: rowView)
        return action
    }
    
    private func getIndexOf(color: UIColor) -> Int?{
        colors.firstIndex(of: color)
    }
}


extension AnnotationShapeManager: AnnotationShapeManagerProtocol{
    
    var areChangesDoneToAnnotation: Bool{
        numberOfChangesDone != 0
    }
    
    func executeUndoAction() {
        executeUndoAction(withAnimation: true)
    }
    
    
    var areUndoActionsAvailable: Bool {
        undoManager.areActionsAvailable
    }
    
    var areRedoActionsAvailable: Bool {
        redoManager.areActionsAvailable
    }
    
    var colors: [UIColor] {
        defaultShapeAttributesProvider.colors
    }
    
    var currentlySelectedColorIndex: Int{
        selectedShapeColorIndex
    }
    
    var colorIndexForNewShape: Int{
        0
    }
    
    func pickedColorAt(index: Int){
        let newColor = colors[index]
        selectedShapeView?.model.setColor(to:newColor)
        selectedShapeColorIndex = index
        refresherDelegate?.refreshSelectedColorInPalatte()
        if let selectedShapeView = selectedShapeView , var addedDetail = addedShapesDictionary[selectedShapeView]{
            let existingDetails = addedDetail
            addedDetail.update(color: newColor)
            addedShapesDictionary[selectedShapeView] = addedDetail
            
            guard let rowView = addedDetail.rowView,
                  let fromColor = existingDetails.shape.getShapeColor(),
                  let toColor = addedDetail.shape.getShapeColor() else {return}
            
            let actionType = UndoableActionType.colorChange(fromColor, toColor, selectedShapeView, rowView)
            addActionInUndoableStack(actionType: actionType)
        }
    }
    
    func textEntered(_ text: String) {
        selectedShapeView?.model.setText(text)
//        selectedShapeView?.refreshTextElementToAdjustFrameBasedOnContent()
        if let selectedShapeView = selectedShapeView , var addedDetail = addedShapesDictionary[selectedShapeView]{
            addedDetail.update(txt: text)
            addedShapesDictionary[selectedShapeView] = addedDetail            
        }
    }
    
    func borderStyleSelected(_ newBorderStyleType: BorderStyleType) {
        selectedShapeView?.model.setBorderStyle(to: newBorderStyleType)
        if let selectedShapeView = selectedShapeView , var addedDetail = addedShapesDictionary[selectedShapeView]{
            let existingDetails = addedDetail
            addedDetail.update(borderStyle: newBorderStyleType)
            addedShapesDictionary[selectedShapeView] = addedDetail
            
            guard let rowView = addedDetail.rowView,
                  let from = existingDetails.shape.getBorderStyle(),
                  let to = addedDetail.shape.getBorderStyle() else {return}
            
            let actionType = UndoableActionType.borderStyleChange(from, to, selectedShapeView, rowView)
            addActionInUndoableStack(actionType: actionType)
        }
    }
    
    func addVideoTrimmingInUndoableAction(oldStartTime: CMTime, oldEndTime: CMTime, newStartTime: CMTime, newEndTime: CMTime){
        let actionType = UndoableActionType.videoTrimming(oldStartTime, oldEndTime, newStartTime, newEndTime)
        addActionInUndoableStack(actionType: actionType)
    }
    
    func addVideoTrimmingDeletionInUndoableAction(startTime: CMTime, endTime: CMTime){
        let actionType = UndoableActionType.videoTrimmingDeletion(startTime, endTime)
        addActionInUndoableStack(actionType: actionType)
    }
    
    func addAudioAdditionInUndoableAction(model: AudioModel){
        let actionType = UndoableActionType.audioAddition(model)
        addActionInUndoableStack(actionType: actionType)
    }
    
    func addAudioDeletionInUndoableAction(model: AudioModel) {
        let actionType = UndoableActionType.audioDeletion(model)
        addActionInUndoableStack(actionType: actionType)
    }
    
    
    func txtStyleSelected(_ txtStyle: TextStyle) {
        selectedShapeView?.model.setTextStyle(to: txtStyle)
        
        if let selectedShapeView = selectedShapeView , var addedDetail = addedShapesDictionary[selectedShapeView]{
            let existingDetails = addedDetail
            
            addedDetail.update(txtStyle: txtStyle)
            addedShapesDictionary[selectedShapeView] = addedDetail
            
            guard let rowView = addedDetail.rowView,
                  let from = existingDetails.shape.getTextModel()?.textStyle,
                  let to = addedDetail.shape.getTextModel()?.textStyle else {return}
            
            let actionType = UndoableActionType.txtStyleChange(from, to, selectedShapeView, rowView)
            addActionInUndoableStack(actionType: actionType)
        }
    }

    func txtEditTapped() {
        if let selectedShapeView = selectedShapeView as? AnnotationRectangleCircleView{
            selectedShapeView.editTextTapped()
        }
    }
    
    func borderWidthSelectionChangeTo(_ newValue: Int) {
        selectedShapeView?.model.setBorderWidth(to: newValue)
        //        if let selectedShapeView = selectedShapeView , var addedDetail = addedShapesDictionary[selectedShapeView]{
        //            let existingDetails = addedDetail
        //            addedDetail.update(borderWidth: newValue)
        //            addedShapesDictionary[selectedShapeView] = addedDetail
        //
        //            guard let rowView = addedDetail.rowView else {return}
        //            addActionInUndoableStack(actionType: .borderWidthChange,
        //                                     newDetails: addedDetail,
        //                                     existingDetails: existingDetails,
        //                                     shapeView: selectedShapeView,
        //                                     shapeRowView: rowView)
        //        }
    }
    
    func borderWidthSelectionChangesEnded(_ newValue: Int) {
        //        selectedShapeView?.model.setBorderWidth(to: newValue)
        if let selectedShapeView = selectedShapeView , var addedDetail = addedShapesDictionary[selectedShapeView]{
            let existingDetails = addedDetail
            addedDetail.update(borderWidth: newValue)
            addedShapesDictionary[selectedShapeView] = addedDetail
            
            guard let rowView = addedDetail.rowView,
                  let from = existingDetails.shape.getBorderWidthModel(),
                  let to = addedDetail.shape.getBorderWidthModel() else {return}
            let actionType = UndoableActionType.borderWidthChange(from, to, selectedShapeView, rowView)
            addActionInUndoableStack(actionType: actionType)
        }
    }
    
    func textOpacityChangeTo(_ newOpacity: CGFloat) {
        selectedShapeView?.model.setTextOpacity(to: newOpacity)
    }
    
    func textOpacityChangesEnded(_ newOpacity: CGFloat) {
        if let selectedShapeView = selectedShapeView , var addedDetail = addedShapesDictionary[selectedShapeView]{
            let existingDetails = addedDetail
            addedDetail.update(opacity: newOpacity)
            addedShapesDictionary[selectedShapeView] = addedDetail
            
            guard let rowView = addedDetail.rowView,
                  let from = existingDetails.shape.getTextModel()?.textBG,
                  let to = addedDetail.shape.getTextModel()?.textBG else {return}
            let actionType = UndoableActionType.txtOpacityChange(from, to, selectedShapeView, rowView)
            addActionInUndoableStack(actionType: actionType)
        }
    }
    
    func textSizeChangeTo(_ newSize: Int) {
        selectedShapeView?.model.setTextSize(to: newSize)
    }
    
    func textSizeChangesEnded(_ newSize: Int){
        //        selectedShapeView?.model.setTextSize(to: newSize)
        if let selectedShapeView = selectedShapeView , var addedDetail = addedShapesDictionary[selectedShapeView]{
            let existingDetails = addedDetail
            addedDetail.update(fontSize: newSize)
            addedShapesDictionary[selectedShapeView] = addedDetail
            
            guard let rowView = addedDetail.rowView,
                  let from = existingDetails.shape.getTextModel()?.fontSize,
                  let to = addedDetail.shape.getTextModel()?.fontSize else {return}
            let actionType = UndoableActionType.txtSizeChange(from, to, selectedShapeView, rowView)
            addActionInUndoableStack(actionType: actionType)
        }
    }
    
    func videoTapped() {
        if let selectedShapeView = selectedShapeView {
            switch selectedShapeView.model.shape.type {
            case .text:
                selectedShapeView.superview?.endEditing(true)
            default:()
            }
        }
        if let selectedAudioTrackStartTime = selectedAudioTrackStartTime {
            self.selectedAudioTrackStartTime = nil
            refresherDelegate?.deSelectSelectedAudioTrackView(startingAt: selectedAudioTrackStartTime)
        }
        if isAudioTrackOfVideoSelected{
            isAudioTrackOfVideoSelected = false
            refresherDelegate?.deSelectSelectedAudioTrackOfVideo()
        }
        refreshViewsForSelectionChanges(withNewSelectedView: nil)
    }
    
    func tappedBlock(view: ShapeRowViewProtocol) {
        videoTapped()
        if isAudioTrackOfVideoSelected{
            isAudioTrackOfVideoSelected = false
            refresherDelegate?.deSelectSelectedAudioTrackOfVideo()
        }
        let returnedView = addedShapesDictionary.first { (addedView,addedViewDetails) in
            guard let rowView = addedViewDetails.rowView else { return false}
            return rowView == view
        }?.key
        
        guard let newSelectedView = returnedView as? AnnotationShapeViewProtocol else {return}
        tapped(view: newSelectedView)
    }
    
    func executeUndoAction(withAnimation allowAnimation: Bool){
        numberOfChangesDone -= 1
        guard let action = undoManager.remove() else {return}
        redoManager.add(action)
        
        var changes: (()->Void)? = nil
        var completion: (()->Void)? = nil
        
        switch action.type{
        case .addition:
            guard let sourceView = action.sourceView, let rowView = action.rowView else {return}
            changes = {
                sourceView.alpha = 0
                rowView.alpha = 0
            }
            completion = {
                sourceView.removeFromSuperview()
                rowView.removeFromSuperview()
            }
            addedShapesDictionary[sourceView] = nil
//            tapped(view: sourceView)
        case .deletion(let details):
            guard let superViewOfShapeView = refresherDelegate?.getViewForShapeAddition(),
                  let superViewOfRowView = refresherDelegate?.getViewForRowAddition(),
                  let sourceView = action.sourceView,
                  let rowView = action.rowView else {return}
            sourceView.alpha = 0
            rowView.alpha = 0
            superViewOfShapeView.addSubview(sourceView)
            superViewOfRowView.addArrangedSubview(rowView)
            
            changes = {
                sourceView.alpha = 1
                rowView.alpha = 1
            }
            addedShapesDictionary[sourceView] = details
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: details.startTime, end: details.endTime)
        case .frameChange(let from, _ ):
            guard let sourceView = action.sourceView else {return}
            guard let containerSize = refresherDelegate?.getContainerSize(), containerSize != .zero else {break}
            let x = from.0 * containerSize.width
            let y = from.1 * containerSize.height
            let width = from.2 * containerSize.width
            let height = from.3 * containerSize.height
            let fromFrame = CGRect(x: x, y: y, width: width, height: height)
            if let arrowPtChanges = action.arrowPointsChange{ // Frame change action Of arrow view
                completion = {
                    sourceView.frame = fromFrame
                    sourceView.refreshArrowView(startFrom: arrowPtChanges.0.start, endAt: arrowPtChanges.0.end)
                }
            }else{
                changes = {
                    sourceView.frame = fromFrame
                }
            }
            
            guard var details = addedShapesDictionary[sourceView] else {return}
            if let superView = sourceView.superview{
                details.update(frame: fromFrame, parentViewSize: superView.frame.size, arrowPoints: action.arrowPointsChange?.0)
            }
            addedShapesDictionary[sourceView] = details
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: details.startTime, end: details.endTime)
        case .colorChange(let from, _ ):
            guard let sourceView = action.sourceView else {return}
            let newColor = self.colors[from]
            changes = {
                sourceView.model.setColor(to:newColor)
            }
            guard var addedDetail = self.addedShapesDictionary[sourceView] else { return }
            addedDetail.update(color: newColor)
            self.addedShapesDictionary[sourceView] = addedDetail
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: addedDetail.startTime, end: addedDetail.endTime)
        case .borerStyleChange(let from, _):
            guard let sourceView = action.sourceView else {return}
            changes = {
                sourceView.model.setBorderStyle(to: from)
            }
            guard var addedDetail = self.addedShapesDictionary[sourceView] else { return }
            addedDetail.update(borderStyle: from)
            self.addedShapesDictionary[sourceView] = addedDetail
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: addedDetail.startTime, end: addedDetail.endTime)
        case .borderWidthChange(let from, _):
            guard let sourceView = action.sourceView else {return}
            changes = {
                sourceView.model.setBorderWidth(to: from.selectedWidth)
            }
            guard var addedDetail = self.addedShapesDictionary[sourceView] else { return }
            addedDetail.update(borderWidth: from.selectedWidth)
            self.addedShapesDictionary[sourceView] = addedDetail
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: addedDetail.startTime, end: addedDetail.endTime)
        case .txtSizeChange(let from, _):
            guard let sourceView = action.sourceView else {return}
            changes = {
                sourceView.model.setTextSize(to: from.selectedFontSize)
            }
            guard var addedDetail = self.addedShapesDictionary[sourceView] else { return }
            addedDetail.update(fontSize: from.selectedFontSize)
            self.addedShapesDictionary[sourceView] = addedDetail
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: addedDetail.startTime, end: addedDetail.endTime)
            
        case .txtOpacityChange(let from, _):
            guard let sourceView = action.sourceView else {return}
            changes = {
                sourceView.model.setTextOpacity(to: from.opacity)
            }
            guard var addedDetail = self.addedShapesDictionary[sourceView] else { return }
            addedDetail.update(opacity: from.opacity)
        
            self.addedShapesDictionary[sourceView] = addedDetail
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: addedDetail.startTime, end: addedDetail.endTime)
            
        case .txtStyleChange(let from, _):
            guard let sourceView = action.sourceView else {return}
            changes = {
                sourceView.model.setTextStyle(to: from)
            }
            guard var addedDetail = self.addedShapesDictionary[sourceView] else { return }
            addedDetail.update(txtStyle: from)
            self.addedShapesDictionary[sourceView] = addedDetail
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: addedDetail.startTime, end: addedDetail.endTime)
        case .videoTrimming(let oldStartTime, let oldEndTime, _, _):
            refresherDelegate?.updateTheVideoTrimmingTo(startTime: oldStartTime, endTime: oldEndTime)
        case .videoTrimmingDeletion(startTime: let startTime, endTime: let endTime):
            refresherDelegate?.updateTheVideoTrimmingTo(startTime: startTime, endTime: endTime)
            
        case .shapeDisplayingTimeChange(let xOffset, let width, _, _ , let startTime, let endTime, _, _):
            guard let sourceView = action.sourceView,
                  let rowView = action.rowView,
                  var details = addedShapesDictionary[sourceView] else {return}
            
            rowView.model.update(x: xOffset, width: width)
            details.update(startTime: startTime, endTime: endTime)
            addedShapesDictionary[sourceView] = details
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: details.startTime, end: details.endTime)
        case .audioAddition(let model):
            refresherDelegate?.removeAudioModel(model)
            audioModels = audioModels.filter({
                !($0.videoStartTime == model.startTime)
            })
        case .audioDeletion(let model):
            refresherDelegate?.addAudioModel(model)
            guard let recordedAudioModel = model.model else {return}
            audioModels.append(recordedAudioModel)
        case .audioOfRecordedVideoDeletion:
            refresherDelegate?.addAudioViewOfRecordedVideo()
        }
        
        if allowAnimation == false{
            changes?()
            completion?()
        }else{
            let animationDuration = 0.2
            UIView.animate(withDuration: animationDuration, delay: 0, options:.curveEaseIn) {
                changes?()
            }completion: { _ in
                completion?()
            }
        }
        
        refresherDelegate?.shapeChangeActionExecuted()
    }
    
    func executeRedoAction(){
        guard let action = redoManager.remove() else {return}
        undoManager.add(action)
        let animationDuration = 0.2
        
        var changes: (()->Void)? = nil
        var completion: (()->Void)? = nil
        
        switch action.type{
        case .addition(let details):
            guard let superViewOfShapeView = refresherDelegate?.getViewForShapeAddition(),
                  let superViewOfRowView = refresherDelegate?.getViewForRowAddition(),
                  let sourceView = action.sourceView,
                  let rowView = action.rowView else {return}
            sourceView.alpha = 0
            rowView.alpha = 0
            superViewOfShapeView.addSubview(sourceView)
            superViewOfRowView.addArrangedSubview(rowView)
            
            changes = {
                sourceView.alpha = 1
                rowView.alpha = 1
            }
            addedShapesDictionary[sourceView] = details
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: details.startTime, end: details.endTime)
        case .deletion:
            guard let sourceView = action.sourceView, let rowView = action.rowView else {return}
            changes = {
                sourceView.alpha = 0
                rowView.alpha = 0
            }
            completion = {
                sourceView.removeFromSuperview()
                rowView.removeFromSuperview()
            }
            addedShapesDictionary[sourceView] = nil
//            tapped(view: sourceView)
        case .frameChange( _ , let to):
            guard let sourceView = action.sourceView else {return}
            guard let containerSize = refresherDelegate?.getContainerSize(), containerSize != .zero else {break}
            
            let x = to.0 * containerSize.width
            let y = to.1 * containerSize.height
            let width = to.2 * containerSize.width
            let height = to.3 * containerSize.height
            let toFrame = CGRect(x: x, y: y, width: width, height: height)
            if let arrowPtChanges = action.arrowPointsChange{ // Frame change action Of arrow view
                completion = {
                    sourceView.frame = toFrame
                    sourceView.refreshArrowView(startFrom: arrowPtChanges.1.start, endAt: arrowPtChanges.1.end)
                }
            }else{
                changes = {
                    sourceView.frame = toFrame
                }
            }
            guard var details = addedShapesDictionary[sourceView] else {return}
            if let superView = sourceView.superview{
                details.update(frame: toFrame, parentViewSize: superView.frame.size, arrowPoints: action.arrowPointsChange?.1)
            }
            addedShapesDictionary[sourceView] = details
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: details.startTime, end: details.endTime)
        case .colorChange( _ , let to ):
            guard let sourceView = action.sourceView else {return}
            let newColor = self.colors[to]
            changes = {
                sourceView.model.setColor(to:newColor)
            }
            guard var addedDetail = self.addedShapesDictionary[sourceView] else { return }
            addedDetail.update(color: newColor)
            self.addedShapesDictionary[sourceView] = addedDetail
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: addedDetail.startTime, end: addedDetail.endTime)
        case .borerStyleChange(_, let to):
            guard let sourceView = action.sourceView else {return}
            changes = {
                sourceView.model.setBorderStyle(to: to)
            }
            guard var addedDetail = self.addedShapesDictionary[sourceView] else { return }
            addedDetail.update(borderStyle: to)
            self.addedShapesDictionary[sourceView] = addedDetail
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: addedDetail.startTime, end: addedDetail.endTime)
        case .borderWidthChange(_, let to):
            guard let sourceView = action.sourceView else {return}
            changes = {
                sourceView.model.setBorderWidth(to: to.selectedWidth)
            }
            guard var addedDetail = self.addedShapesDictionary[sourceView] else { return }
            addedDetail.update(borderWidth: to.selectedWidth)
            self.addedShapesDictionary[sourceView] = addedDetail
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: addedDetail.startTime, end: addedDetail.endTime)
        case .txtSizeChange(_, let to):
            guard let sourceView = action.sourceView else {return}
            changes = {
                sourceView.model.setTextSize(to: to.selectedFontSize)
            }
            guard var addedDetail = self.addedShapesDictionary[sourceView] else { return }
            addedDetail.update(fontSize: to.selectedFontSize)
            self.addedShapesDictionary[sourceView] = addedDetail
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: addedDetail.startTime, end: addedDetail.endTime)
            
        case .txtOpacityChange(_, let to):
            guard let sourceView = action.sourceView else {return}
            changes = {
                sourceView.model.setTextOpacity(to: to.opacity)
            }
            guard var addedDetail = self.addedShapesDictionary[sourceView] else { return }
            addedDetail.update(opacity: to.opacity)
            self.addedShapesDictionary[sourceView] = addedDetail
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: addedDetail.startTime, end: addedDetail.endTime)
            
        case .txtStyleChange(_, let to):
            guard let sourceView = action.sourceView else {return}
            changes = {
                sourceView.model.setTextStyle(to: to)
            }
            guard var addedDetail = self.addedShapesDictionary[sourceView] else { return }
            addedDetail.update(txtStyle: to)
            self.addedShapesDictionary[sourceView] = addedDetail
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: addedDetail.startTime, end: addedDetail.endTime)
        case .videoTrimming(_, _, let newStartTime, let newEndTime):
            refresherDelegate?.updateTheVideoTrimmingTo(startTime: newStartTime, endTime: newEndTime)
        case .videoTrimmingDeletion(_,_):
            refresherDelegate?.updateTheVideoTrimmingToInitialState()
        case .shapeDisplayingTimeChange(_, _, let xOffset, let width, _, _, let startTime, let endTime):
            guard let sourceView = action.sourceView,
                  let rowView = action.rowView,
                  var details = addedShapesDictionary[sourceView] else {return}
            rowView.model.update(x: xOffset, width: width)
            details.update(startTime: startTime, endTime: endTime)
            addedShapesDictionary[sourceView] = details
            tapped(view: sourceView)
            refresherDelegate?.scrollAfterUndoRedo(start: details.startTime, end: details.endTime)
        case .audioAddition(let model):
            refresherDelegate?.addAudioModel(model)
            guard let recordedAudioModel = model.model else {return}
            audioModels.append(recordedAudioModel)
        case .audioDeletion(let model):
            refresherDelegate?.removeAudioModel(model)
            audioModels = audioModels.filter({
                !($0.videoStartTime == model.startTime)
            })
        case .audioOfRecordedVideoDeletion:
            refresherDelegate?.removeAudioViewOfRecordedVideo()
        }
        
        UIView.animate(withDuration: animationDuration, delay: 0, options:.curveEaseIn) {
            changes?()
        }completion: { _ in
            completion?()
        }
        
        refresherDelegate?.shapeChangeActionExecuted()
    }
    
    func removeSelectedShape() {
        guard let selectedShapeView = selectedShapeView else {
            if isAudioTrackOfVideoSelected{
                isAudioTrackOfVideoSelected = false
                let actionType: UndoableActionType = UndoableActionType.audioOfRecordedVideoDeletion
                addActionInUndoableStack(actionType: actionType)

                refresherDelegate?.removeAudioViewOfRecordedVideo()
                return
            }
            
            guard let selectedAudioTrackStartTime = selectedAudioTrackStartTime else { return }
            self.selectedAudioTrackStartTime = nil
            audioModels = audioModels.filter({ model in
                !(model.videoStartTime == selectedAudioTrackStartTime)
            })
            refresherDelegate?.removeAudioViewStartingAt(time: selectedAudioTrackStartTime)
            return
        }
        
        
        if let shapeDetails = addedShapesDictionary[selectedShapeView], let rowView = shapeDetails.rowView {
            let actionType: UndoableActionType = UndoableActionType.deletion(shapeDetails, selectedShapeView, rowView)
            addActionInUndoableStack(actionType: actionType)
        }
        remove(view: selectedShapeView)
    }
    
    func audioTrackTapped(startingAt: CMTime) {
        videoTapped()
        selectedAudioTrackStartTime = startingAt
    }
    
    func audioTrackOfVideoTapped() {
        videoTapped()
        isAudioTrackOfVideoSelected = true
    }
    
    func checkAndPlayRecordedAudiosIfAvailable(at time: CMTime) -> Bool {
        if audioPlayer.isAudioPlaying {return false}
        for model in audioModels{
            if time >= model.videoStartTime && model.videoEndTime >= time{
                let startTime = CMTimeSubtract(time, model.videoStartTime)
                audioPlayer.playAudio(from: model.fileUrl, atTime: startTime)
                return true
            }
        }
        return false
    }
    
    func audioPlayerSound(shouldEnable: Bool) {
        audioPlayer.sound(shouldEnable: shouldEnable)
    }
    
    func playPauseButtonAction() {
        if audioPlayer.isAudioPlaying{
            audioPlayer.stop()
        }else{
            audioPlayer.continuePlaying()
        }
    }
    
    func isRecordedAudioPlaying() -> Bool{
        audioPlayer.isAudioPlaying
    }
    
    func cancelLastAppliedShapeChanges() {
        videoTapped()
        while numberOfChangesDone > 0 {
            executeUndoAction(withAnimation: false)
        }
        redoManager.removeAll()
        refresherDelegate?.shapeChangeActionExecuted()
    }
    
}

extension AnnotationShapeManager{
    
    private func refreshViewsForSelectionChanges(withNewSelectedView newSelectedView: AnnotationShapeViewProtocol?){
        guard let newSelectedView = newSelectedView else {
            if let currentlySelectedView = selectedShapeView{
                currentlySelectedView.model.setSelected(to: false) // Hides delete, resize & copy buttons
                if let currentlySelectedViewDetails = addedShapesDictionary[currentlySelectedView],
                   let rowView = currentlySelectedViewDetails.rowView {
                    rowView.model.setSelected(to: false)
                }
            }
            selectedShapeView = nil
            return
        }
        if let currentlySelectedView = selectedShapeView{
            currentlySelectedView.model.setSelected(to: false) // Hides delete, resize & copy buttons
            if let currentlySelectedViewDetails = addedShapesDictionary[currentlySelectedView],
               let rowView = currentlySelectedViewDetails.rowView {
                rowView.model.setSelected(to: false)
            }
        }
        newSelectedView.model.setSelected(to: true) // Shows delete, resize & copy buttons
        if let newlySelectedViewDetails = addedShapesDictionary[newSelectedView],
           let rowView = newlySelectedViewDetails.rowView {
            rowView.model.setSelected(to: true)
        }
        selectedShapeView = newSelectedView
    }
    
    func getShapeAndRowShapeView(forShape shape: AddedShape, videoContainerSize: CGSize, curTime: CMTime, totalDuration: CMTime) -> (view: AnnotationShapeViewProtocol, frame: CGRect, detail : AddedShapeDetails){
        let returningVal = getAnnotationShapeView(forShape: shape, containerSize: videoContainerSize)
        let viewToReturn = returningVal.view
        let frameOfViewToReturn = returningVal.frame
        refreshViewsForSelectionChanges(withNewSelectedView: viewToReturn)
        let shapeDetail = getShapeDetails(shape, view: viewToReturn, viewRect: frameOfViewToReturn, curTime: curTime, totalDuration: totalDuration, videoContainerSize: videoContainerSize)
        return (returningVal.view, frameOfViewToReturn ,shapeDetail)
    }
    
    
    func hideOrShowAddedShapesAt(time: CMTime) {
        addedShapesDictionary.forEach {$0.isHidden = !(time >= $1.startTime && time <= $1.endTime) }
    }
    
    
    func saveShapeDetailsAndRowView(_ view: ShapeRowViewProtocol, details: AddedShapeDetails, forShapeView shapeView: UIView){
        var details = details
        details.rowView = view
        addedShapesDictionary[shapeView] = details
        
        // New Shape Addition
        guard let shapeView = shapeView as? AnnotationShapeViewProtocol else {return}
        let actionType: UndoableActionType = UndoableActionType.addition(details, shapeView, view)
        addActionInUndoableStack(actionType: actionType)
        
    }
    
    private func addActionInUndoableStack(actionType: UndoableActionType){
        numberOfChangesDone += 1
        redoManager.removeAll() 
        switch actionType {
        case .addition(let details, let shapeView, let rowView) :
            let action = Action(type: .addition(details: details),
                                sourceView: shapeView,
                                rowView: rowView)
            undoManager.add(action)
        case .deletion(let details, let shapeView, let rowView):
            let action = Action(type: .deletion(details: details),
                                sourceView: shapeView,
                                rowView: rowView)
            undoManager.add(action)
        case .colorChange(let fromColor, let toColor, let shapeView, let shapeRowView) :
            guard let action = getColorChangeAction(fromColor: fromColor,
                                                    toColor: toColor,
                                                    sourceView: shapeView,
                                                    rowView: shapeRowView) else {return}
            undoManager.add(action)
        case .frameChange(let from, let to, let shapeView, let shapeRowView, let fromArrowPoints, let toArrowPoints):
            var arrowPtChange: (ArrowPoints, ArrowPoints)? = nil
            if let fromArrowPoints = fromArrowPoints, let toArrowPoints = toArrowPoints{
                arrowPtChange = (fromArrowPoints, toArrowPoints)
            }
            let action = Action(type: .frameChange(from: from, to: to),
                                sourceView: shapeView,
                                rowView: shapeRowView,
                                arrowPointsChange: arrowPtChange)
            undoManager.add(action)
        case .borderStyleChange(let from, let to, let shapeView, let shapeRowView):
            let action = Action(type: .borerStyleChange(from: from, to: to),
                                sourceView: shapeView,
                                rowView: shapeRowView)
            undoManager.add(action)
        case .borderWidthChange(let from, let to, let shapeView, let shapeRowView):
            let action = Action(type: .borderWidthChange(from: from, to: to),
                                sourceView: shapeView,
                                rowView: shapeRowView)
            undoManager.add(action)
        case .txtSizeChange(let from, let to, let shapeView, let shapeRowView):
            
            let action = Action(type: .txtSizeChange(from: from, to: to),
                                sourceView: shapeView,
                                rowView: shapeRowView)
            undoManager.add(action)
        case .txtOpacityChange(let from, let to, let shapeView, let shapeRowView):
            let action = Action(type: .txtOpacityChange(from: from, to: to),
                                sourceView: shapeView,
                                rowView: shapeRowView)
            undoManager.add(action)
            
        case .txtStyleChange(let from, let to, let shapeView, let shapeRowView):
            let action = Action(type: .txtStyleChange(from: from, to: to),
                                sourceView: shapeView,
                                rowView: shapeRowView)
            undoManager.add(action)
        case .videoTrimming(let oldStartTime, let oldEndTime, let newStartTime, let newEndTime):
            let action = Action(type: .videoTrimming(oldStartTime: oldStartTime, oldEndTime: oldEndTime, newStartTime: newStartTime, newEndTime: newEndTime))
            undoManager.add(action)
        case .videoTrimmingDeletion(let startTime, let endTime):
            let action = Action(type: .videoTrimmingDeletion(startTime: startTime, endTime: endTime))
            undoManager.add(action)
        case .shapeRowViewTimeChanges(let oldXOffset, let oldWidth, let newXOffset, let newWidth, let oldStartTime, let oldEndTime, let newStartTime, let newEndTime, let sourceView, let rowView):
            let action = Action(type: .shapeDisplayingTimeChange(oldXOffset: oldXOffset, oldWidth: oldWidth, newXOffset: newXOffset, newWidth: newWidth, oldStartTime: oldStartTime, oldEndTime: oldEndTime, newStartTime: newStartTime, newEndTime: newEndTime), sourceView: sourceView, rowView: rowView)
            undoManager.add(action)
        case .audioAddition(let model):
            let action = Action(type: .audioAddition(model: model))
            undoManager.add(action)
        case .audioDeletion(let model): ()
            let action = Action(type: .audioDeletion(model: model))
            undoManager.add(action)
        case .audioOfRecordedVideoDeletion:
            let action = Action(type: .audioOfRecordedVideoDeletion)
            undoManager.add(action)
        }
        refresherDelegate?.shapeChangeActionExecuted()
    }
    
    
    
    func updateBlockView(withFrame blockViewFrame: CGRect, totalWidth: CGFloat, videoDuration: CMTime, view: UIView){
        let totalWidthOfView: Double = Double(totalWidth)
        let availableWidth = blockViewFrame.size.width
        let startX = blockViewFrame.origin.x
        let timeDurationToShowTheShape = (CMTimeGetSeconds(videoDuration) * availableWidth) / totalWidthOfView
        let startTimeToShowShape = (CMTimeGetSeconds(videoDuration) * startX) / totalWidthOfView
        
        for (addedView,viewDetails) in addedShapesDictionary{
            if let addedBlockView = viewDetails.rowView, addedBlockView == view{
                let startTimeInCMTime = CMTime(seconds: startTimeToShowShape, preferredTimescale: videoDuration.timescale)
                let totalDurationInCMTime = CMTime(seconds: timeDurationToShowTheShape, preferredTimescale: videoDuration.timescale)
                let endTimeInCMTime = CMTimeAdd(startTimeInCMTime, totalDurationInCMTime)
                var updatedViewDetails = viewDetails
                
                updatedViewDetails.update(startTime: startTimeInCMTime, endTime: endTimeInCMTime)
                addedShapesDictionary[addedView] = updatedViewDetails
                
                let oldXOffset = addedBlockView.model.xOffset
                let oldWidth = addedBlockView.model.width
                
                let oldStartTime = viewDetails.startTime
                let oldEndTime = viewDetails.endTime
                
                addedBlockView.model.update(x: blockViewFrame.origin.x, width: blockViewFrame.size.width)
                // Add Pan Action for view
                guard let addedView = addedView as? AnnotationShapeViewProtocol else {break}
                
                let actionType = UndoableActionType.shapeRowViewTimeChanges(oldXOffset, oldWidth, blockViewFrame.origin.x, blockViewFrame.size.width, oldStartTime, oldEndTime, startTimeInCMTime, endTimeInCMTime, addedView, addedBlockView)
                
                addActionInUndoableStack(actionType: actionType)
                
                break
            }
        }
    }    
}

extension AnnotationShapeManager: AnnotationShapeDelegateProtocol {
    
    func remove(view: AnnotationShapeViewProtocol) {
        view.removeFromSuperview()
        if let addedShapeViewDetails = addedShapesDictionary[view]{
            let animation = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut){
                addedShapeViewDetails.rowView?.alpha = 0
            }
            animation.addCompletion { _ in
                addedShapeViewDetails.rowView?.alpha = 1
                addedShapeViewDetails.rowView?.removeFromSuperview()
            }
            animation.startAnimation()
        }
        addedShapesDictionary.removeValue(forKey: view)
        selectedShapeView = nil
        refresherDelegate?.shapeRemoved()
    }
    
    func tapped(view: AnnotationShapeViewProtocol) {
        view.superview?.bringSubviewsToFront(view)
        if let selectedShapeView = selectedShapeView {
            
            switch selectedShapeView.model.shape.type{
                case .text:
                if selectedShapeView == view{
                    refresherDelegate?.textEditTapped()
                }else{
                    selectedShapeView.superview?.endEditing(true)
                }
                default:break
            }
        }
        refreshViewsForSelectionChanges(withNewSelectedView: view)
        refresherDelegate?.tappedNewShape()
    }
    
    func tappedOutside() {
        refresherDelegate?.tappedOutside()
    }
    
    func textBecameFirstResponder(view: AnnotationShapeViewProtocol){
        refresherDelegate?.textBecameFirstResponder()
    }
    
    func updateArrowPoints(view: AnnotationShapeViewProtocol, arrowPoints: ArrowPoints? = nil){
        if var addedDetail = addedShapesDictionary[view]{
            addedDetail.update(arrowPoints: arrowPoints)
            addedShapesDictionary[view] = addedDetail            
        }
    }
    
    func frameChangeEnded(view: AnnotationShapeViewProtocol, arrowPoints: ArrowPoints? = nil){
        if var addedDetail = addedShapesDictionary[view]{
            let oldDetails = addedDetail
            if let superView = view.superview{
                addedDetail.update(frame: view.frame, parentViewSize: superView.frame.size, arrowPoints: arrowPoints)
            }
            addedShapesDictionary[view] = addedDetail
            
            guard let rowView = addedDetail.rowView else {return}
            let actionType = UndoableActionType.frameChange(oldDetails.shapeRect, addedDetail.shapeRect, view, rowView, oldDetails.arrowPoints, arrowPoints)
            addActionInUndoableStack(actionType: actionType)
        }
    }
    
    func textViewEditingEnded(view: AnnotationShapeViewProtocol){
        if var addedDetail = addedShapesDictionary[view]{
            if let superView = view.superview{
                addedDetail.update(frame: view.frame, parentViewSize: superView.frame.size)
            }
            addedShapesDictionary[view] = addedDetail
        }
    }
    
    func showTextExceededAlert() {
        refresherDelegate?.alertUserAbtTextLimitReached()
    }
    
    func getParentViewHeight() -> CGFloat {
        return refresherDelegate?.getParentViewHeight() ?? 0
    }
    
}


protocol AudioRecordingManagingProtocol{
    var isRecordingInProgress: Bool { get }
    func startRecording(at time: CMTime)
    func stopRecording(at time: CMTime)
    func audioRecordingInProgress(time: CMTime)
}

extension AnnotationShapeManager: AudioRecordingManagingProtocol {
    
    var isRecordingInProgress: Bool{
        isAudioRecordingInProgress()
    }
    
    private func canRecordAudioAt(time: CMTime) -> Bool{
        let isVideoPlaying = refresherDelegate?.isVideoPlaying() ?? false
        if isVideoPlaying{
            // Alert user to stop playing video
            refresherDelegate?.showPauseVideoPlayingBeforeRecordingAlert()
            return false
        }
        
        guard !audioModels.isEmpty else {return true}
        for audioModel in audioModels{
            if time >= audioModel.videoStartTime, time <= audioModel.videoEndTime {
                refresherDelegate?.alertUserToRemoveExistingRecordings()
                return false
            }
        }
        return true
    }
    
    func startRecording(at time: CMTime) {
        guard canRecordAudioAt(time: time) else {
            return
        }
//        if audioModels.isEmpty{
//            audioRecorder.deleteAllRecordings()
//        }
        refresherDelegate?.audioRecordingWillStart()
        audioRecorder.startRecording()
        refresherDelegate?.audioRecordingStarted(at: time)
        audioRecorderStartTime = time
        //        audioRecorderStartTime = refresherDelegate?.audioRecordingStartedAndGetStartTime()
    }
    
    func stopRecording(at endTime: CMTime) {
        guard let audioFileUrl = audioRecorder.stopRecording(),
              let startTime = audioRecorderStartTime else {return}
        let audioDuration = CMTimeGetSeconds(CMTimeSubtract(endTime, startTime))
        if audioDuration < 1.0 { // Discard the audio as its duration is less than 1 second
            refresherDelegate?.audioRecordingCancelled()
            return
        }
        let audioModel = RecordedAudioModel(fileUrl: audioFileUrl,
                                            videoStartTime: startTime,
                                            videoEndTime: endTime)
        audioModels.append(audioModel)
        refresherDelegate?.audioRecordingEnded(audioModel: audioModel)
    }
    
    func isAudioRecordingInProgress() -> Bool{
        audioRecorder.isRecordingInProgress
    }
    
    func videoScrollingStarted(){
        if audioPlayer.isAudioPlaying{
            audioPlayer.stop()
        }
    }
    
    func getAudioModel() -> [RecordedAudioModel]{
        audioModels
    }
    
    
    func updateModel(newModel: RecordedAudioModel, startingAt: CMTime) {
        for index in 0..<audioModels.count{
            let model = audioModels[index]
            if model.videoStartTime == startingAt {
                audioModels[index] = newModel
                selectedAudioTrackStartTime = newModel.videoStartTime
                return
            }
        }
    }
    
    func audioRecordingInProgress(time: CMTime){
        if audioModels.isEmpty{return}
        for model in audioModels{
            let timeToCompare = CMTimeAdd(time, CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
            if timeToCompare >= model.videoStartTime && model.videoEndTime > time{
                refresherDelegate?.endAudioRecordingAndShowAlertToRemoveExistingRecordingToContinueRecording()
            }
        }
    }
}


struct RecordedAudioModel: Equatable{
    let fileUrl: URL
    let originalRecordedAudioTotalDuration: CMTime
    
    private(set) var videoStartTime: CMTime
    private(set) var videoEndTime: CMTime
    
    private(set) var audioStartTime: CMTime
    private(set) var audioEndTime: CMTime
    
    init(fileUrl: URL, videoStartTime: CMTime, videoEndTime: CMTime) {
        self.fileUrl = fileUrl
        self.videoStartTime = videoStartTime
        self.videoEndTime = videoEndTime
        
        let totalAudioDuration = CMTimeSubtract(videoEndTime, videoStartTime)
        self.audioStartTime = CMTime.zero
        self.audioEndTime = totalAudioDuration
        self.originalRecordedAudioTotalDuration = totalAudioDuration
    }
    
    mutating func updateVideoStartTimeEndTime(to newStartTime:CMTime){
        self.videoStartTime = newStartTime
        self.videoEndTime = CMTimeAdd(newStartTime, originalRecordedAudioTotalDuration)
    }
    
    mutating func updateVideo(newStartTime: CMTime, newEndTime: CMTime){
        self.videoStartTime = newStartTime
        self.videoEndTime = newEndTime
    }
    
    mutating func updateAudio(newStartTime: CMTime, newEndTime: CMTime){
        self.audioStartTime = newStartTime
        self.audioEndTime = newEndTime
    }
}


extension AnnotationShapeManager{
    
    func updateShapesWithNewParentSize(_ parentSize: CGSize, isInFullScreenPreview: Bool){
        addedShapesDictionary.forEach { (view, shapeDetails) in
            let newFrame = shapeDetails.rect.getFrame(in: parentSize)
            view.frame = newFrame
            if let view = view as? AnnotationRectangleCircleView{
                let ratio = parentSize.width/UIScreen.main.bounds.width
                view.model.setScreenSize(to: ratio)
                let normalFactor = view.refreshCornerPanViews(isInFullScreen: isInFullScreenPreview)
                refresherDelegate?.setNewScreenRatio(newFactor: ratio, normalFactor: normalFactor)
            }
        }
    }
}
