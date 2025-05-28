//
//  VideoControlView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 15/09/23.
//

import UIKit
import CoreMedia

protocol VideoControlViewProtocol: UIView{
    var viewModel: VideoControlViewModelProtocol{ get }
    var sliderChangeMonitoringDelegate: SliderChangeMonitoring? {get set}
    var mode: PlayerMode { get set }
    
    func playVideo()
    func pauseVideo()
    func forwardButton(shouldEnable: Bool)
    func backwardButton(shouldEnable: Bool)
    func sound(shouldEnable: Bool)
    func refreshUndoRedoButtons()
    func shouldHideMuteAndFullScreenButtonsAndShowDeleteButton(_ :Bool)
    
    func enteringFullScreen(curTime: CMTime, startTime: CMTime, endTime: CMTime, isVideoPlaying: Bool, timeLapsed: String, timeRemaining: String)
    func exitingFullScreen()
    func updateFullScreenSlider(to: CMTime, timeLapsed: String)
    func videoPlayingFinished()
    func refreshSoundButtonState()
}

protocol SliderChangeMonitoring: AnyObject{
    func sliderChanging()
    func sliderChangingEnded()
}

enum PlayerMode{
    case editScreen // Edit screen mode where shapes can be added & removed
    case fullScreen  // Full screen mode where added shapes can be viewed with full screen switching button
}

class VideoControlView: UIView{
    let viewModel: VideoControlViewModelProtocol
    weak var sliderChangeMonitoringDelegate: SliderChangeMonitoring?
    
    var mode: PlayerMode = .editScreen
    private var heightConstraint: NSLayoutConstraint? = nil
    private var isVideoPausedDueToSliderSeeking: Bool = false
    
    private enum ImageConstants{
        static let playImgName = "play"
        static let pauseSystemImgName = "pause.fill"
        static let forwardImgName = "next"
        static let backwardImgName = "prev"
        static let shrinkFromFullScreenIconName = "arrow.down.right.and.arrow.up.left"
        static let expandToFullScreenIconName = "arrow.up.left.and.arrow.down.right"
        
        static let deleteShapeImgName = "delete"
        
        static let muteSystemImgName = "speaker.slash"
        static let unMuteSystemImgName = "speaker.wave.3"
        
        static let undoImgName = "undo"
        static let redoImgName = "redo"
        
        static let sliderName = "circle.fill"
    }
    
    private enum UIConstants{
        static let controlBarHeight: CGFloat = 44
        
        static let forwardSkipVideoDuration: Double = 5
        static let backWardSkipVideoDuration: Double = 5
    }
    
    init(viewModel: AnnotatorViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupControls()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var fullScreenContainerView: UIView = {
        // Create Full Screen View
        let fullScreenContainerView = UIView()
        fullScreenContainerView.translatesAutoresizingMaskIntoConstraints = false
        fullScreenContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return fullScreenContainerView
    }()

    private lazy var backButtonInFullScreen: UIButton = {
        // Create Undo button
        let backButtonInFullScreen = UIButton()
        backButtonInFullScreen.translatesAutoresizingMaskIntoConstraints = false
        let backButtonImg = UIImage(systemName: ImageConstants.shrinkFromFullScreenIconName)?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        backButtonInFullScreen.setImage(backButtonImg, for: .normal)
        backButtonInFullScreen.addTarget(self, action: #selector(backButtonTappedInFullScreen), for: .touchUpInside)
        return backButtonInFullScreen
    }()
    
    private lazy var playPauseButtonInFullScreen: UIButton = {
        // Create Undo button
        let playPauseButtonInFullScreen = UIButton()
        playPauseButtonInFullScreen.translatesAutoresizingMaskIntoConstraints = false
        let playButtonImg = UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        let pauseButtonImg = UIImage(systemName: "pause.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)

        playPauseButtonInFullScreen.setImage(playButtonImg, for: .selected)
        playPauseButtonInFullScreen.setImage(pauseButtonImg, for: .normal)
        playPauseButtonInFullScreen.addTarget(self, action: #selector(playPauseTappedInFullScreen), for: .touchUpInside)
        return playPauseButtonInFullScreen
    }()

    private lazy var soundButtonInFullScreen: UIButton = {
        // Create Undo button
        let soundButtonInFullScreen = UIButton()
        soundButtonInFullScreen.translatesAutoresizingMaskIntoConstraints = false
        let sepakerOffImg = UIImage(systemName: "speaker.slash")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        let sepakerOnImg = UIImage(systemName: "speaker.wave.3")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        soundButtonInFullScreen.setImage(sepakerOffImg, for: .selected)
        soundButtonInFullScreen.setImage(sepakerOnImg, for: .normal)
        soundButtonInFullScreen.addTarget(self, action: #selector(soundButtonTappedInFullScreen), for: .touchUpInside)
        return soundButtonInFullScreen
    }()

    
    private lazy var timeLapsedLabelInFullScreen: UILabel = {
        let timeLapsedLabel = UILabel()
        timeLapsedLabel.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            timeLapsedLabel.textColor = UIColor.white
        }
        timeLapsedLabel.text = "00:00"
        timeLapsedLabel.font = UIFont.systemFont(ofSize: 12)
        return timeLapsedLabel
    }()
    
    private lazy var timeRemainingLabelInFullScreen: UILabel = {
        let timeRemainingLabel = UILabel()
        timeRemainingLabel.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            timeRemainingLabel.textColor = UIColor.white
        }
        timeRemainingLabel.text = "00:00"
        timeRemainingLabel.font = UIFont.systemFont(ofSize: 12)
        return timeRemainingLabel
    }()
    
    private lazy var sliderInFullScreen: UISlider = {
        let sliderInFullScreen = UISlider()
        sliderInFullScreen.translatesAutoresizingMaskIntoConstraints = false
        sliderInFullScreen.addTarget(self, action: #selector(sliderValChanged(slider:event:)), for: .valueChanged)
        
        if #available(iOS 13.0, *) {
            let configuration = UIImage.SymbolConfiguration(pointSize: 18)
            if let image = UIImage(systemName: ImageConstants.sliderName, withConfiguration: configuration) {
                let tintedImage = image.withRenderingMode(.alwaysOriginal).withTintColor(.white)
                sliderInFullScreen.setThumbImage(tintedImage, for: .normal)
            }
        }
        sliderInFullScreen.minimumTrackTintColor = UIColor.white
        sliderInFullScreen.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.7)
        return sliderInFullScreen
    }()
    
    private lazy var controlContainerView: UIView = {
        // Create Container View
        let controlContainerView = UIView()
        controlContainerView.translatesAutoresizingMaskIntoConstraints = false
        return controlContainerView
    }()
    
    private lazy var undoButton: UIButton = {
        // Create Undo button
        let undoButton = UIButton()
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        let undoImage = UIImage.named(ImageConstants.undoImgName)?.withRenderingMode(.alwaysTemplate)
        undoButton.setImage(undoImage, for: .normal)
        undoButton.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        undoButton.tintColor = AnnotationEditorViewColors.controlViewButtonColor
        //        undoButton.backgroundColor = .red
        return undoButton
    }()
    
    private lazy var redoButton: UIButton = {
        // Create Redo button
        let redoButton = UIButton()
        redoButton.translatesAutoresizingMaskIntoConstraints = false
        let redoImage = UIImage.named(ImageConstants.redoImgName)?.withRenderingMode(.alwaysTemplate)
        redoButton.setImage(redoImage, for: .normal)
        redoButton.addTarget(self, action: #selector(redoButtonTapped), for: .touchUpInside)
        redoButton.tintColor = AnnotationEditorViewColors.controlViewButtonColor
        //        redoButton.backgroundColor = .red
        return redoButton
    }()
    
    
    private lazy var playPauseButton: UIButton = {
        // Create play/pause button
        let playPauseButton = UIButton()
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.setImage(UIImage.named(ImageConstants.playImgName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        if #available(iOS 13.0, *) {
            playPauseButton.setImage(UIImage(systemName: ImageConstants.pauseSystemImgName)?.withRenderingMode(.alwaysTemplate), for: .selected)
        } else {
            // Fallback on earlier versions
        }
        playPauseButton.tintColor = AnnotationEditorViewColors.controlViewButtonColor
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        return playPauseButton
    }()
    
    private lazy var forwardButton: UIButton = {
        // Create forward button
        let forwardButton = UIButton()
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.setImage(UIImage.named(ImageConstants.forwardImgName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        forwardButton.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        forwardButton.tintColor = AnnotationEditorViewColors.controlViewButtonColor
        return forwardButton
    }()
    
    private lazy var backwardButton: UIButton = {
        // Create backward button
        let backwardButton = UIButton()
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        backwardButton.setImage(UIImage.named(ImageConstants.backwardImgName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        backwardButton.addTarget(self, action: #selector(backwardButtonTapped), for: .touchUpInside)
        backwardButton.tintColor = AnnotationEditorViewColors.controlViewButtonColor
        return backwardButton
    }()
    
    private lazy var fullScreenButton: UIButton = {
        // Create Full Screen button
        let fullScreenButton = UIButton()
        fullScreenButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            let configuration = UIImage.SymbolConfiguration(pointSize: 18)
            let image = UIImage(systemName: ImageConstants.expandToFullScreenIconName, withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
            fullScreenButton.setImage(image, for: .normal)
        }
        fullScreenButton.tintColor = AnnotationEditorViewColors.controlViewButtonColor
        fullScreenButton.addTarget(self, action: #selector(fullScreenButtonTapped), for: .touchUpInside)
        return fullScreenButton
    }()
    
    private lazy var muteButton: UIButton = {
        // Create mute/unmute button
        let muteButton = UIButton()
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            muteButton.setImage(UIImage(systemName: ImageConstants.unMuteSystemImgName)?.withRenderingMode(.alwaysTemplate), for: .normal)
            muteButton.setImage(UIImage(systemName: ImageConstants.muteSystemImgName), for: .selected)
        } else {
            // Fallback on earlier versions
        }
        muteButton.tintColor = AnnotationEditorViewColors.controlViewButtonColor
        muteButton.addTarget(self, action: #selector(muteButtonTapped), for: .touchUpInside)
        //        muteButton.backgroundColor = .purple
        return muteButton
    }()
    
    private lazy var deleteButton: UIButton = {
        // Create Full Screen button
        let deleteButton = UIButton()
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setImage(UIImage.named(ImageConstants.deleteShapeImgName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        deleteButton.tintColor = .red
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return deleteButton
    }()
    
    private func addFullscreenViews() {
        if fullScreenContainerView.superview == nil{
            addSubviews(fullScreenContainerView)
            
            let leadPaddingOfFullScreenContainerView: CGFloat = 20
            let trailPaddingOfFullScreenContainerView: CGFloat = 20
            let bottomPaddingOfFullScreenContainerView: CGFloat = 20
            let topPaddingOfFullScreenContainerView: CGFloat = 20
            fullScreenContainerView.layer.cornerRadius = 15
            
            NSLayoutConstraint.activate([
                fullScreenContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadPaddingOfFullScreenContainerView),
                fullScreenContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailPaddingOfFullScreenContainerView),
                fullScreenContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
                fullScreenContainerView.topAnchor.constraint(equalTo: topAnchor, constant: topPaddingOfFullScreenContainerView),
                fullScreenContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPaddingOfFullScreenContainerView)
            ])
            
            fullScreenContainerView.addSubviews(sliderInFullScreen, timeLapsedLabelInFullScreen, timeRemainingLabelInFullScreen, backButtonInFullScreen, playPauseButtonInFullScreen, soundButtonInFullScreen)
            
            let leadingPaddingOfTimeLapsedLabelInFullScreenMode: CGFloat = 15
            let timeLapsedLabelAndSliderPadding: CGFloat = 15
            let timeLapsedLabelAndSliderTopPadding: CGFloat = 15
            let timeLapsedLabelAndSliderBottomPadding: CGFloat = 15
            
            let widthOfButton: CGFloat = 30
            let heightOfButton: CGFloat = 30
            
            NSLayoutConstraint.activate([
                timeLapsedLabelInFullScreen.leadingAnchor.constraint(equalTo: fullScreenContainerView.leadingAnchor , constant: leadingPaddingOfTimeLapsedLabelInFullScreenMode),
                timeLapsedLabelInFullScreen.trailingAnchor.constraint(lessThanOrEqualTo: fullScreenContainerView.trailingAnchor),
                timeLapsedLabelInFullScreen.topAnchor.constraint(equalTo: fullScreenContainerView.topAnchor, constant: timeLapsedLabelAndSliderTopPadding),
                timeLapsedLabelInFullScreen.bottomAnchor.constraint(lessThanOrEqualTo: fullScreenContainerView.bottomAnchor, constant: -timeLapsedLabelAndSliderBottomPadding),
                
                
                sliderInFullScreen.leadingAnchor.constraint(equalTo: timeLapsedLabelInFullScreen.trailingAnchor, constant: timeLapsedLabelAndSliderPadding),
                sliderInFullScreen.centerYAnchor.constraint(equalTo: timeLapsedLabelInFullScreen.centerYAnchor),
                sliderInFullScreen.widthAnchor.constraint(lessThanOrEqualTo: fullScreenContainerView.widthAnchor),
                sliderInFullScreen.trailingAnchor.constraint(lessThanOrEqualTo: fullScreenContainerView.trailingAnchor),
                
                timeRemainingLabelInFullScreen.leadingAnchor.constraint(equalTo: sliderInFullScreen.trailingAnchor, constant: timeLapsedLabelAndSliderPadding),
                timeRemainingLabelInFullScreen.trailingAnchor.constraint(equalTo: fullScreenContainerView.trailingAnchor, constant: -leadingPaddingOfTimeLapsedLabelInFullScreenMode),
                timeRemainingLabelInFullScreen.centerYAnchor.constraint(equalTo: timeLapsedLabelInFullScreen.centerYAnchor),
                timeRemainingLabelInFullScreen.topAnchor.constraint(equalTo: fullScreenContainerView.topAnchor, constant: timeLapsedLabelAndSliderTopPadding),
                timeRemainingLabelInFullScreen.bottomAnchor.constraint(lessThanOrEqualTo: fullScreenContainerView.bottomAnchor, constant: -timeLapsedLabelAndSliderBottomPadding),
                
                soundButtonInFullScreen.centerXAnchor.constraint(equalTo: timeLapsedLabelInFullScreen.centerXAnchor),
                soundButtonInFullScreen.topAnchor.constraint(equalTo: timeLapsedLabelInFullScreen.bottomAnchor, constant: 15),
                soundButtonInFullScreen.bottomAnchor.constraint(equalTo: fullScreenContainerView.bottomAnchor, constant: -15),
                soundButtonInFullScreen.trailingAnchor.constraint(lessThanOrEqualTo: fullScreenContainerView.trailingAnchor),
                soundButtonInFullScreen.widthAnchor.constraint(equalToConstant: widthOfButton),
                soundButtonInFullScreen.heightAnchor.constraint(equalToConstant: heightOfButton),
                
                playPauseButtonInFullScreen.centerXAnchor.constraint(equalTo: fullScreenContainerView.centerXAnchor),
                playPauseButtonInFullScreen.topAnchor.constraint(equalTo: soundButtonInFullScreen.topAnchor),
                playPauseButtonInFullScreen.bottomAnchor.constraint(equalTo: soundButtonInFullScreen.bottomAnchor),
                playPauseButtonInFullScreen.trailingAnchor.constraint(lessThanOrEqualTo: fullScreenContainerView.trailingAnchor),
                playPauseButtonInFullScreen.widthAnchor.constraint(equalToConstant: widthOfButton),
                playPauseButtonInFullScreen.heightAnchor.constraint(equalToConstant: heightOfButton),

                backButtonInFullScreen.centerXAnchor.constraint(equalTo: timeRemainingLabelInFullScreen.centerXAnchor),
                backButtonInFullScreen.topAnchor.constraint(equalTo: soundButtonInFullScreen.topAnchor),
                backButtonInFullScreen.bottomAnchor.constraint(equalTo: soundButtonInFullScreen.bottomAnchor),
                backButtonInFullScreen.trailingAnchor.constraint(lessThanOrEqualTo: fullScreenContainerView.trailingAnchor),
                backButtonInFullScreen.widthAnchor.constraint(equalToConstant: widthOfButton),
                backButtonInFullScreen.heightAnchor.constraint(equalToConstant: heightOfButton)
            ])
        }
        heightConstraint?.isActive = false
    }
    private func removeFullscreenViews() {
        fullScreenContainerView.removeFromSuperview()
        heightConstraint?.isActive = true
    }
    
    private func setupControls() {
        
        addSubviews(controlContainerView)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        controlContainerView.addSubviews(playPauseButton, forwardButton, backwardButton, fullScreenButton, muteButton, undoButton, redoButton, deleteButton)
        
        deleteButton.isHidden = true

        let leadingPaddingOfUndo: CGFloat = 0
        let undoAndRedoButtonPadding: CGFloat = 5
        
        let backwardAndPlayButtonPadding: CGFloat = 5
        let forwardAndPlayButtonPadding: CGFloat = 5
        let muteAndFullscreenButtonPadding: CGFloat = 5
        
        let buttonWidth: CGFloat = 28
        
        let selfHeightConstraint = self.heightAnchor.constraint(equalToConstant: 33)
        heightConstraint = selfHeightConstraint
        
        NSLayoutConstraint.activate([
            controlContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            controlContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            controlContainerView.topAnchor.constraint(equalTo: topAnchor),
            controlContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            playPauseButton.centerXAnchor.constraint(equalTo: controlContainerView.centerXAnchor),
            playPauseButton.centerYAnchor.constraint(equalTo: controlContainerView.centerYAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            playPauseButton.heightAnchor.constraint(equalTo: controlContainerView.heightAnchor),
            
            backwardButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -backwardAndPlayButtonPadding),
            backwardButton.centerYAnchor.constraint(equalTo: controlContainerView.centerYAnchor),
            backwardButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            backwardButton.heightAnchor.constraint(equalTo: controlContainerView.heightAnchor),
            
            forwardButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: forwardAndPlayButtonPadding),
            forwardButton.centerYAnchor.constraint(equalTo: controlContainerView.centerYAnchor),
            forwardButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            forwardButton.heightAnchor.constraint(equalTo: controlContainerView.heightAnchor),
            
            undoButton.leadingAnchor.constraint(equalTo: controlContainerView.leadingAnchor, constant: leadingPaddingOfUndo),
            undoButton.centerYAnchor.constraint(equalTo: controlContainerView.centerYAnchor),
            undoButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            undoButton.heightAnchor.constraint(equalTo: controlContainerView.heightAnchor),
            
            redoButton.leadingAnchor.constraint(equalTo: undoButton.trailingAnchor, constant: undoAndRedoButtonPadding),
            redoButton.centerYAnchor.constraint(equalTo: controlContainerView.centerYAnchor),
            redoButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            redoButton.heightAnchor.constraint(equalTo: controlContainerView.heightAnchor),
            
            fullScreenButton.trailingAnchor.constraint(equalTo: controlContainerView.trailingAnchor),
            fullScreenButton.centerYAnchor.constraint(equalTo: controlContainerView.centerYAnchor),
            fullScreenButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            fullScreenButton.heightAnchor.constraint(equalTo: controlContainerView.heightAnchor),
            
            muteButton.centerYAnchor.constraint(equalTo: controlContainerView.centerYAnchor),
            muteButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            muteButton.trailingAnchor.constraint(equalTo: fullScreenButton.leadingAnchor, constant: -muteAndFullscreenButtonPadding),
            muteButton.heightAnchor.constraint(equalTo: controlContainerView.heightAnchor),
            
            deleteButton.trailingAnchor.constraint(equalTo: controlContainerView.trailingAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: controlContainerView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            deleteButton.heightAnchor.constraint(equalTo: controlContainerView.heightAnchor),
            selfHeightConstraint
        ])
        refreshUndoRedoButtons()
        refreshSoundButtonState()
    }
    
    func refreshSoundButton(){
        soundButtonInFullScreen.isSelected = !viewModel.isSoundEnabled()
    }
    
    func refreshPlayButton(){
        playPauseButtonInFullScreen.isSelected = !viewModel.isVideoPlaying()
    }

    @objc private func playPauseTappedInFullScreen() {
        viewModel.playTappedFromVideoPlayer()
        refreshPlayButton()
    }
    
    @objc private func backButtonTappedInFullScreen(){
        viewModel.backTappedFromVideoPlayer()
    }
    
    @objc private func soundButtonTappedInFullScreen(){
        viewModel.soundTappedFromVideoPlayer()
        refreshSoundButton()
    }
    
    @objc private func undoButtonTapped() {
        viewModel.undoButtonTapped()
    }
    
    @objc private func redoButtonTapped() {
        viewModel.redoButtonTapped()
    }
    
    @objc private func playPauseButtonTapped() {
        viewModel.playPauseButtonAction()
    }
    
    @objc private func forwardButtonTapped() {
        viewModel.forwardButtonTapped()
    }
    
    @objc private func backwardButtonTapped() {
        viewModel.backwardButtonTapped()
    }
    
    @objc private func fullScreenButtonTapped() {
        viewModel.fullScreenButtonTapped()
    }
    
    @objc private func muteButtonTapped() {
        viewModel.muteUnmuteButtonTapped()
    }
    
    @objc private func deleteButtonTapped() {
        viewModel.deleteButtonTapped()
    }
}

extension VideoControlView{
    @objc func sliderValChanged(slider: UISlider, event: UIEvent) {
        viewModel.sliderSeekedTo(value: slider.value)
        
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                isVideoPausedDueToSliderSeeking = viewModel.isVideoPlaying()
                if isVideoPausedDueToSliderSeeking{
                    playPauseButtonTapped()
                    refreshPlayButton()
                }
                sliderChangeMonitoringDelegate?.sliderChanging()
            case .moved:
                sliderChangeMonitoringDelegate?.sliderChanging()
            case .ended:
                sliderChangeMonitoringDelegate?.sliderChangingEnded()
                if isVideoPausedDueToSliderSeeking{
                    playPauseButtonTapped()
                    refreshPlayButton()
                    isVideoPausedDueToSliderSeeking = false
                }
            default:
                break
            }
        }
    }
}


extension VideoControlView: VideoControlViewProtocol{
    
    func playVideo() {
        switch mode{
        case .editScreen:
            playPauseButton.isSelected = true
        default: break
        }
    }
    
    func pauseVideo() {
        switch mode{
        case .editScreen:
            playPauseButton.isSelected = false
        default: break
        }
    }
    
    func forwardButton(shouldEnable: Bool) {
        forwardButton.isEnabled = shouldEnable
    }
    
    func backwardButton(shouldEnable: Bool) {
        backwardButton.isEnabled = shouldEnable
    }
    
    func sound(shouldEnable: Bool) {
        muteButton.isSelected = !shouldEnable
    }
    
    func refreshUndoRedoButtons(){
        undoButton.isEnabled = viewModel.shouldEnableUndoAction
        redoButton.isEnabled = viewModel.shouldEnableRedoAction
    }
    
    func shouldHideMuteAndFullScreenButtonsAndShowDeleteButton(_ shouldHide: Bool) {
        if viewModel.shouldShowSoundOnOffButton(){
            muteButton.isHidden = shouldHide
        }
        fullScreenButton.isHidden = shouldHide
        deleteButton.isHidden = !shouldHide
    }
    
    func enteringFullScreen(curTime: CMTime, startTime: CMTime, endTime: CMTime, isVideoPlaying: Bool, timeLapsed: String, timeRemaining: String) {
        if isVideoPlaying{
            playVideo()
        }else{
            pauseVideo()
        }
                
        controlContainerView.isHidden = true
        addFullscreenViews()
        
        refreshSoundButton()
        refreshPlayButton()
        
        sliderInFullScreen.minimumValue = Float(CMTimeGetSeconds(startTime))
        sliderInFullScreen.maximumValue = Float(CMTimeGetSeconds(endTime))
        sliderInFullScreen.value = Float(CMTimeGetSeconds(curTime))
        
        timeLapsedLabelInFullScreen.text = timeLapsed
        timeRemainingLabelInFullScreen.text = timeRemaining
    
    }
    
    func exitingFullScreen() {
        removeFullscreenViews()
        controlContainerView.isHidden = false
        mode = .editScreen
    }
    
    func updateFullScreenSlider(to: CMTime, timeLapsed: String){
        sliderInFullScreen.setValue(Float(CMTimeGetSeconds(to)), animated: true)
        timeLapsedLabelInFullScreen.text = timeLapsed
    }
    
    func videoPlayingFinished(){
        pauseVideo()
        refreshPlayButton()
    }
    
    func refreshSoundButtonState() {
        muteButton.isHidden = !viewModel.shouldShowSoundOnOffButton()
        soundButtonInFullScreen.isHidden = !viewModel.shouldShowSoundOnOffButton()
    }
}

struct AnnotationEditorViewColors{
    static let controlViewButtonColor = QuartzColor.annotationControlViewButtionColor.color
    static let thumbnailContainerViewBGColor = QuartzColor.thumbanilContainerBGColor.color
    static let shapeBlockViewBGColor = QuartzColor.shapeBlockViewBGColor.color
    static let shapeIndicatorViewBGColor = QuartzColor.shapeIndicatorViewBGColor.color
    static let audioRowViewBGColor = QuartzColor.audioRowViewBGColor.color
    static let recordedVideoAudioTrackBGColor = QuartzColor.recordedVideoAudioTrackBGColor.color
    static let recordedAudioBlockViewBG = QuartzColor.recordedAudioBlockViewBG.color
    static let handlerViewCenterLineColor = QuartzColor.handlerViewCenterLineColor.color
    static let selectionBorderColor = QuartzColor.selectionBorderColor.color
    static let toolBarIconsColor = QuartzColor.toolBarIconsColor.color
    static let toolBarTextColor = QuartzColor.toolBarTextColor.color
    static let bottomToolBarColor = QuartzColor.bottomToolBarColor.color
    static let shapeColorPickerBGColor = QuartzColor.shapeColorPickerBGColor.color
    static let borderStyleCellContentViewBGColor = QuartzColor.borderStyleCellContentViewBGColor.color
    static let borderStyleCellContentSelectionBGColor = QuartzColor.borderStyleCellContentSelectionBGColor.color
    static let strokeWidthLabelTxtColor = QuartzColor.strokeWidthLabelTxtColor.color
    static let recordAudioIconColor = QuartzColor.recordAudioIconColor.color
    static let textMaskingViewBGColor = QuartzColor.textMaskingViewBGColor.color
}

struct RecordingStoppinViewColors{
    static let screenRecordingStoppingViewBGColor = QuartzColor.screenRecordingStoppingViewBGColor.color
    static let screenRecordingStoppingViewBorderColor = QuartzColor.screenRecordingStoppingViewBorderColor.color
    static let screenRecordingStoppingViewTextColor = QuartzColor.screenRecordingStoppingViewTextColor.color
}

struct LoadingViewColors{
    static let loadingViewBg = QuartzColor.loaderBoxColor.color
    static let circularLoaderUnfilledColor = QuartzColor.loadingCircleUnfilledColor.color
    static let submittingTextColor = QuartzColor.submittingTextColor.color    
}
