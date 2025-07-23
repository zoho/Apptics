//
//  AudioTrackRowView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 25/10/23.
//

import UIKit
import CoreMedia

struct AudioModel{
    var model: RecordedAudioModel?
    var startTime: CMTime
    
    var xStart: CGFloat
    var xEnd: CGFloat?
    
    init(model:RecordedAudioModel? = nil, startTime: CMTime, xStart: CGFloat, xEnd: CGFloat? = nil) {
        self.model = model
        self.startTime = startTime
        self.xStart = xStart
        self.xEnd = xEnd
    }
    
    mutating func updateEndOffset(_ end: CGFloat){
        xEnd = end
    }
}

protocol AudioViewProtocol: AnyObject {
    func newAudioAdded(withModel: AudioModel) -> UIView
    func updateCurrentlyRecordingAudioView(width: CGFloat, audioBlockView: AudioBlockView)
    
    func refreshNoContentLabel()
    func deSelectAudioViewOfRecordedVideo()
    func removeAudioViewOfRecordedVideo()
    func addAudioViewOfRecordedVideo()
    
    func isAudioRecordedWithVideoAvailble() -> Bool
}

protocol AudioViewModelProtocol{
    var totalWidthOfScrollView: CGFloat { get }
    var totalDurationOfVideo: CMTime { get }
    
    func recordingStarted(at: CMTime, xOffset: CGFloat)
    func updateView(xOffset: CGFloat)
}

protocol AudioTrackRowViewModelProtocol{
    var viewDelegate: AudioViewProtocol? { get set }
    var list: [AudioModel] { get }
    var timeToViewDictionary: [String: (UIView,CMTime)] { get }
    var annotationVMDelegate: AnnotationAudioVMProtocol? { get set }
    
    func audioOfRecordedVideoSelected()
    func selectedAudioTrack(_ view: UIView)
    func allowPan(forNewCenter: CGPoint, oldCenter: CGPoint) -> Bool
    func panAction(forNewCenter: CGPoint)
    
    
    func allowPanOnLeftHandlerView(_: CGPoint) -> Bool
    func allowPanOnRightHandlerView(_: CGPoint) -> Bool
    func panActionOnLeftHandlerView(_: CGPoint)
    func panActionOnRightHandlerView(_: CGPoint)
    
    func isAudioRecordedWithVideo() -> Bool
    func screenRecordedAudioStateChanged()
}

protocol AnnotationAudioVMProtocol: AnyObject{
    var audioVMDelegate: AudioViewModelActionExecutingProtocol? {get set}
    func selectedAudioTrack(startingAt: CMTime)
   
    func selectedAudioTrackOfRecordedVideo()
    func updateModel(_: RecordedAudioModel, startingAt: CMTime)
    func refreshSoundButtonState()
}

protocol AudioViewModelActionExecutingProtocol: AnyObject{
    func currentRecordingCancelled()
    func recordingEnded(audioModel: RecordedAudioModel) -> AudioModel
    func removeAudioViewStartingAt(time: CMTime) -> AudioModel?
    func deSelectAudioViewStartingAt(time: CMTime)
    func deSelectAudioViewOfRecordedVideo()
    
    func deSelectAndRemoveAudioViewOfRecordedVideo()
    func addAudioViewOfRecordedVideo()
    
    func removeAudio(model: AudioModel)
    func addAudio(model: AudioModel)
    func isAudioTrackRecordedWithVideoAvailable() -> Bool
}

class AudioTrackRowView: UIView {
    var viewModel: AudioTrackRowViewModelProtocol
    
//    private var leadingConstraint: NSLayoutConstraint? = nil
//    private var widthConstraint: NSLayoutConstraint? = nil
    
    private lazy var noAudioAvailableLabel: UILabel = {
        let noAudioAvailableLabel = UILabel()
        noAudioAvailableLabel.translatesAutoresizingMaskIntoConstraints = false
        noAudioAvailableLabel.text = QuartzKitStrings.localized("videoannotationscreen.label.noaudiotrack")
        noAudioAvailableLabel.font = UIFont.systemFont(ofSize: 8)
        return noAudioAvailableLabel
    }()
    
    private lazy var audioTrackOfRecordedVideoView: UIView = {
        let audioTrackOfRecordedVideoView = UIView()
        audioTrackOfRecordedVideoView.translatesAutoresizingMaskIntoConstraints = false
        let audioTrackBGColor = AnnotationEditorViewColors.recordedVideoAudioTrackBGColor
        audioTrackOfRecordedVideoView.backgroundColor = QuartzKit.shared.primaryLightColor ?? audioTrackBGColor
        audioTrackOfRecordedVideoView.layer.borderColor = AnnotationEditorViewColors.selectionBorderColor.cgColor
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.named("audio")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AnnotationEditorViewColors.shapeIndicatorViewBGColor
        audioTrackOfRecordedVideoView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: audioTrackOfRecordedVideoView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: audioTrackOfRecordedVideoView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 15),
            imageView.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        return audioTrackOfRecordedVideoView
    }()
    
    init(viewModel: AudioTrackRowViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.viewModel.viewDelegate = self
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubviews(noAudioAvailableLabel)
        let leadingPadding: CGFloat = 6
        NSLayoutConstraint.activate([
            noAudioAvailableLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingPadding),
            noAudioAvailableLabel.topAnchor.constraint(equalTo: topAnchor),
            noAudioAvailableLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            noAudioAvailableLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        if viewModel.isAudioRecordedWithVideo(){
            noAudioAvailableLabel.isHidden = true
            addSubviews(audioTrackOfRecordedVideoView)
            NSLayoutConstraint.activate([
                audioTrackOfRecordedVideoView.leadingAnchor.constraint(equalTo: leadingAnchor),
                audioTrackOfRecordedVideoView.topAnchor.constraint(equalTo: topAnchor),
                audioTrackOfRecordedVideoView.bottomAnchor.constraint(equalTo: bottomAnchor),
                audioTrackOfRecordedVideoView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(audioOfRecordedVideoTapped))
            audioTrackOfRecordedVideoView.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func audioOfRecordedVideoTapped(){
        viewModel.audioOfRecordedVideoSelected()
        shouldShowSelectedStateForAudioOfRecordedVideo(true)
    }
    
    private func shouldShowSelectedStateForAudioOfRecordedVideo(_ shouldShowSelectedState: Bool){
        audioTrackOfRecordedVideoView.layer.borderWidth = shouldShowSelectedState ? 1 : 0
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        audioTrackOfRecordedVideoView.layer.borderColor = AnnotationEditorViewColors.selectionBorderColor.cgColor
    }
    
}


extension AudioTrackRowView: AudioViewProtocol {
    
    func newAudioAdded(withModel model: AudioModel) -> UIView {
        showOrHideNoContentLabel()
        
        let xOffset = model.xStart
        let width = ((model.xEnd ?? model.xStart) - model.xStart)
        let view = AudioBlockView(frame: CGRect(x: xOffset, y: 0, width: width, height: bounds.size.height))
        view.delegate = self
//        view.translatesAutoresizingMaskIntoConstraints = false
        view.configureTapGestureWith(target: self, action: #selector(blockViewTapped(sender:)))
        addSubview(view)
        
//        let lConstraint = view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: xOffset)
//        leadingConstraint = lConstraint
//
//        let wConstraint = view.widthAnchor.constraint(equalToConstant: 0)
//        widthConstraint = wConstraint
//
//        NSLayoutConstraint.activate([
//            lConstraint,
//            view.topAnchor.constraint(equalTo: topAnchor),
//            view.bottomAnchor.constraint(equalTo: bottomAnchor),
//            wConstraint
//
//        ])
        
        return view
    }
    
    
    private func showOrHideNoContentLabel(){
        noAudioAvailableLabel.isHidden = !viewModel.list.isEmpty
    }
    
    
    func updateCurrentlyRecordingAudioView(width: CGFloat, audioBlockView: AudioBlockView) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .layoutSubviews) {
            audioBlockView.frame.size.width = width
        }
//        let widthConstant = xOffset - leadingConstraint.constant
//        widthConstraint.constant = widthConstant
    }
    
    @objc private func blockViewTapped(sender: UITapGestureRecognizer){
        guard let tappedView = sender.view as? AudioBlockView else {return}
        
        viewModel.selectedAudioTrack(tappedView)
    }
    
    func refreshNoContentLabel() {
        showOrHideNoContentLabel()
    }
    
    func deSelectAudioViewOfRecordedVideo(){
        shouldShowSelectedStateForAudioOfRecordedVideo(false)
    }
    
    func removeAudioViewOfRecordedVideo(){
        audioTrackOfRecordedVideoView.isHidden = true
        noAudioAvailableLabel.isHidden = false
        viewModel.screenRecordedAudioStateChanged()
    }
    
    func addAudioViewOfRecordedVideo(){
        audioTrackOfRecordedVideoView.isHidden = false
        noAudioAvailableLabel.isHidden = true
        viewModel.screenRecordedAudioStateChanged()
    }
    
    func isAudioRecordedWithVideoAvailble() -> Bool{
        !audioTrackOfRecordedVideoView.isHidden
    }
}

extension AudioTrackRowView: AudioBlockViewDelegate{
    
    func allowPan(_ newCenter: CGPoint, withOldCenter oldCenter: CGPoint) -> Bool { // Block View Panning
        return viewModel.allowPan(forNewCenter: newCenter, oldCenter: oldCenter)
    }
    
    func panAction(_ newCenter: CGPoint, withOldCenter oldCenter: CGPoint) { // Block View Panning
        viewModel.panAction(forNewCenter: newCenter)
    }
    
    func allowPanOnLeftHandlerView(_ center: CGPoint) -> Bool {
        viewModel.allowPanOnLeftHandlerView(center)
    }
    
    func allowPanOnRightHandlerView(_ center: CGPoint) -> Bool {
        viewModel.allowPanOnRightHandlerView(center)
    }
    
    func panActionOnLeftHandlerView(_ center: CGPoint) {
        viewModel.panActionOnLeftHandlerView(center)
    }
    
    func panActionOnRightHandlerView(_ center: CGPoint) {
        viewModel.panActionOnRightHandlerView(center)
    }
    
}
