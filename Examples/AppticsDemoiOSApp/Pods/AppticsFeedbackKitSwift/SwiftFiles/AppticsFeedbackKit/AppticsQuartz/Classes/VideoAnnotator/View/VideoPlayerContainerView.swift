//
//  VideoPlayerContainerView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 13/09/23.
//
import UIKit
import AVFoundation

protocol VideoPlayerContainerViewProtocol: UIView{
    var viewModel: AnnotatorViewModelProtocol{ get }
    var viewFactory: VideoPlayerViewFactory{ get }
    
    func enteringFullScreen()
    func exitingFullScreen()
    
    func audioRecordingStarted()
    func audioRecordingEnded()
    
    func playPauseTapped(isVideoPlaying: Bool)
    func videoPlayingFinished()
    func shouldEnableDoneAndBackButton(_:Bool)
}

class VideoPlayerContainerView: UIView, VideoPlayerContainerViewProtocol{
    var viewModel: AnnotatorViewModelProtocol
    let viewFactory: VideoPlayerViewFactory
    
    private var controlViewHidingTimer: Timer? = nil
    private var widthConstraintOfVideoPlayerView: NSLayoutConstraint?
    private var leadingConstraintOfVideoPlayerView: NSLayoutConstraint?
    private var leadingConstraintOfVideoPlayerViewInFullScreen: NSLayoutConstraint?
    
    private var bottomConstraintOfVideoPlayerView: NSLayoutConstraint?
    private var bottomConstraintOfVideoPlayerViewInFullScreen: NSLayoutConstraint?
    
    private var topConstraintOfVideoControlView: NSLayoutConstraint?
    
    private var doneButtonHeightAnchor: NSLayoutConstraint?
    private var backButtonHeightAnchor: NSLayoutConstraint?
    
    
    private var videoPlayerView: VideoPlayerViewProtocol?
    private var videoControlView: VideoControlViewProtocol?
    private var playerTimeIndicatorView: PlayerTimeIndicatorView?
    
    private var isInFullScreenPlayMode = false
    
    private let heightOfDoneButton: CGFloat = 30
    private let heightOfBackButton: CGFloat = 30
    
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setImage(UIImage.named("done")?.withRenderingMode(.alwaysTemplate), for: .normal)
        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        doneButton.tintColor = QuartzKit.shared.primaryColor ?? UIColor.systemBlue
        return doneButton
    }()
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage.named("back")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(img, for: .normal)
        backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
//        backButton.tintColor = UIColor(red: 136.0/255.0, green: 136.0/255.0, blue: 136.0/255.0, alpha: 1)
        backButton.tintColor = QuartzKit.shared.primaryColor ?? UIColor.systemBlue
        return backButton
    }()

    private lazy var selectionDisablingView: UIView = {
        let selectionDisablingView = UIView()
        selectionDisablingView.translatesAutoresizingMaskIntoConstraints = false
        return selectionDisablingView
    }()
    
    init(viewModel: AnnotatorViewModelProtocol, containerViewFactory: VideoPlayerViewFactory = ConcreteVideoPlayerViewFactory()){
        self.viewModel = viewModel
        self.viewFactory = containerViewFactory
        super.init(frame: .zero)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews(){
        
        addSubviews(selectionDisablingView, doneButton,backButton)
        
        let topPaddingOfDoneButton: CGFloat = 0
        let leadingPaddingOfBackButton: CGFloat = 16
        let trailingPaddingOfDoneButton: CGFloat = 16
        
        let widthOfDoneButton: CGFloat = 30
        let widthOfBackButton: CGFloat = 30
        
        let doneButtonHeightAnchor =  doneButton.heightAnchor.constraint(equalToConstant: heightOfDoneButton)
        self.doneButtonHeightAnchor = doneButtonHeightAnchor
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: topAnchor,constant: topPaddingOfDoneButton),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -trailingPaddingOfDoneButton),
            doneButton.widthAnchor.constraint(equalToConstant: widthOfDoneButton),
            doneButtonHeightAnchor
        ])
        
        let backButtonHeightAnchor = backButton.heightAnchor.constraint(equalToConstant: heightOfBackButton)
        self.backButtonHeightAnchor = backButtonHeightAnchor
        
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: doneButton.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant: leadingPaddingOfBackButton),
            backButton.widthAnchor.constraint(equalToConstant: widthOfBackButton),
            backButtonHeightAnchor
        ])
        
        
        let leadingPaddingOfControlView: CGFloat = 10
        let trailingPaddingOfControlView: CGFloat = 10
        let topPaddingOfControlView: CGFloat = 10
        let bottomPaddingOfControlView: CGFloat = 5
//        let heightOfControlView: CGFloat = 33
        
        
        let leadingPaddingOfTimeIndicatorView: CGFloat = 10
        let leadingPaddingOfVideoPlayerInFullScreen: CGFloat = 0
        
        let paddingBetweenTimeIndicatorViewAndPlayer: CGFloat = 10
        let bottomPaddingOfTimeIndicatorView: CGFloat = 0
        
        let (videoPlayerView, videoPlayerControlView, timeIndicatorView) = viewFactory.createVideoPlayerAndControlViewAndTimeIndicatorView(viewModel: viewModel)
        //        viewPlayerView.backgroundColor = .red
        //        viewPlayerControlView.backgroundColor = .green
        videoPlayerControlView.sliderChangeMonitoringDelegate = self
        [videoPlayerView, videoPlayerControlView, timeIndicatorView].forEach { aView in
            aView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(aView)
        }
        self.videoPlayerView = videoPlayerView
        self.videoControlView = videoPlayerControlView
        self.playerTimeIndicatorView = timeIndicatorView
        let widthConstraintOfVideoPlayerView = videoPlayerView.widthAnchor.constraint(equalToConstant: 0)
        self.widthConstraintOfVideoPlayerView = widthConstraintOfVideoPlayerView
    
        let leadingConstraintOfVideoPlayerView = videoPlayerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddingBetweenTimeIndicatorViewAndPlayer)
        self.leadingConstraintOfVideoPlayerView = leadingConstraintOfVideoPlayerView
        
        let leadingConstraintOfVideoPlayerViewInFullScreen = videoPlayerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingPaddingOfVideoPlayerInFullScreen)
        self.leadingConstraintOfVideoPlayerViewInFullScreen = leadingConstraintOfVideoPlayerViewInFullScreen
        
        let bottomConstraintOfVideoPlayerView =  videoPlayerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        self.bottomConstraintOfVideoPlayerView = bottomConstraintOfVideoPlayerView
        
        let bottomConstraintOfVideoPlayerViewInFullScreen =  videoPlayerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        self.bottomConstraintOfVideoPlayerViewInFullScreen = bottomConstraintOfVideoPlayerViewInFullScreen
        
        let topConstraintOfVideoControlView = videoPlayerControlView.topAnchor.constraint(equalTo: videoPlayerView.bottomAnchor , constant: topPaddingOfControlView)
        self.topConstraintOfVideoControlView = topConstraintOfVideoControlView
        
        NSLayoutConstraint.activate([
            timeIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingPaddingOfTimeIndicatorView),
            timeIndicatorView.bottomAnchor.constraint(equalTo: videoPlayerView.bottomAnchor, constant: -bottomPaddingOfTimeIndicatorView),
            
            leadingConstraintOfVideoPlayerView,
            widthConstraintOfVideoPlayerView,
            videoPlayerView.topAnchor.constraint(equalTo: doneButton.topAnchor),
            bottomConstraintOfVideoPlayerView,
            
            videoPlayerControlView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingPaddingOfControlView),
            videoPlayerControlView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingPaddingOfControlView),
            topConstraintOfVideoControlView,
            videoPlayerControlView.bottomAnchor.constraint(equalTo: bottomAnchor , constant: -bottomPaddingOfControlView),
//            videoPlayerControlView.heightAnchor.constraint(equalToConstant: heightOfControlView)
        ])
        
        
        NSLayoutConstraint.activate([
            selectionDisablingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectionDisablingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectionDisablingView.topAnchor.constraint(equalTo: videoPlayerView.topAnchor),
            selectionDisablingView.bottomAnchor.constraint(equalTo: videoPlayerView.bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOutsideOfPlayerView))
        selectionDisablingView.addGestureRecognizer(tapGesture)
        
        bringSubviewsToFront(backButton, doneButton, timeIndicatorView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        widthConstraintOfVideoPlayerView?.constant = bounds.width - ( 2 * (self.videoPlayerView?.frame.origin.x ?? 0))
    }
    
    @objc private func doneAction() {
        viewModel.doneButtonTapped()
    }
    
    
    @objc private func backAction(_ sender: UIButton){
        viewModel.backButtonTapped()
    }
    
    func audioRecordingStarted(){
        backButton.isHidden = true
    }
    
    func audioRecordingEnded(){
        backButton.isHidden = false
    }
    
    func enteringFullScreen(){
        isInFullScreenPlayMode = true
        
        doneButtonHeightAnchor?.constant = 0
        backButtonHeightAnchor?.constant = 0
        playerTimeIndicatorView?.isHidden = true
        
        leadingConstraintOfVideoPlayerView?.isActive = false
        leadingConstraintOfVideoPlayerViewInFullScreen?.isActive = true
        
        bottomConstraintOfVideoPlayerView?.isActive = false
        bottomConstraintOfVideoPlayerViewInFullScreen?.isActive = true
        topConstraintOfVideoControlView?.isActive = false
    }
    
    func exitingFullScreen(){
        isInFullScreenPlayMode = false
        
        doneButtonHeightAnchor?.constant = heightOfDoneButton
        backButtonHeightAnchor?.constant = heightOfBackButton
        playerTimeIndicatorView?.isHidden = false

        leadingConstraintOfVideoPlayerViewInFullScreen?.isActive = false
        leadingConstraintOfVideoPlayerView?.isActive = true
        
        bottomConstraintOfVideoPlayerView?.isActive = true
        bottomConstraintOfVideoPlayerViewInFullScreen?.isActive = false
        topConstraintOfVideoControlView?.isActive = true
    }
    
    @objc private func tappedOutsideOfPlayerView(){
        viewModel.tappedOutsideOfPlayer()
    }
    
    func playPauseTapped(isVideoPlaying: Bool){
        if isVideoPlaying, isInFullScreenPlayMode{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                self.hideOrShowControlView()
            }
        }
    }
    
    func videoPlayingFinished(){
        if isInFullScreenPlayMode{
            showControlView()
        }
    }
    
    func shouldEnableDoneAndBackButton(_ shouldEnable:Bool){
        doneButton.isEnabled = shouldEnable
        backButton.isEnabled = shouldEnable
        doneButton.isHidden = !shouldEnable
    }
    
    deinit{
        videoPlayerView = nil
        videoControlView = nil
        playerTimeIndicatorView = nil
        controlViewHidingTimer?.invalidate()
        controlViewHidingTimer = nil
    }
}

extension VideoPlayerContainerView{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isInFullScreenPlayMode{
            hideOrShowControlView()
        }
    }
        
    private func hideOrShowControlView(){
        let isVideoControlViewHidden = videoControlView?.isHidden ?? false
        if isVideoControlViewHidden{
            showControlView()
        }else{
            hideControlView()
        }
    }
    
    private func hideControlView(){
        UIView.animate(withDuration: 0.2) {
            self.videoControlView?.alpha = 0
        } completion: { _ in
            self.videoControlView?.isHidden = true
        }
    }
    
    private func showControlView(){
        self.videoControlView?.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.videoControlView?.alpha = 1
        }
    }
}


extension VideoPlayerContainerView: SliderChangeMonitoring{
    
    func sliderChanging() {
        videoControlView?.alpha = 1
    }
    
    func sliderChangingEnded() {
     
    }
}
