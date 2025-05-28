//
//  AnnotatorViewController.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 13/09/23.
//

import UIKit

class AnnotatorViewController: UIViewController{
    var viewModel: AnnotatorViewModelProtocol
    let containerViewFactory: VideoPlayerViewFactory
    
    private var showingBottomAnchorConstraintOfVideoPlayerView: NSLayoutConstraint? = nil
    private var hidingBottomAnchorConstraintOfVideoPlayerView: NSLayoutConstraint? = nil
    
    
    private var showingTopAnchorConstraintOfThumbnailView: NSLayoutConstraint? = nil
    private var hidingTopAnchorConstraintOfThumbnailView: NSLayoutConstraint? = nil
    
    private var showingTopAnchorConstraintOfBottomToolBarView: NSLayoutConstraint? = nil
    private var hidingTopAnchorConstraintOfBottomToolBarView: NSLayoutConstraint? = nil
    
    
    private let heightOfBottomView: CGFloat = 68
    private let heightOfAnnotationConfigurationView: CGFloat = 189
    
    private var videoPlayerContainerView: VideoPlayerContainerViewProtocol?
    private var videoConfigurationContainerView: AnnotationConfigurationViewProcotol?
    private var bottomToolBarView: ToolBarView?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if iPad {
            return .all
        } else {
            return .portrait
        }
    }
    
    init(viewModel: AnnotatorViewModelProtocol, containerViewFactory: VideoPlayerViewFactory = ConcreteVideoPlayerViewFactory()) {
        self.viewModel = viewModel
        self.containerViewFactory = containerViewFactory
        super.init(nibName: nil, bundle: nil)
        self.viewModel.annotatorViewDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        configureVideoPlayerView()
        self.navigationController?.delegate = self
        
        navigationController?.overrideUserInterfaceStyle = QuartzKit.shared.uiMode
        overrideUserInterfaceStyle = QuartzKit.shared.uiMode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Video Player View Configuration
    
    private func configureVideoPlayerView(){
        viewModel.fullScreenDelegate = self
        viewModel.audioRecodingNotifyingDelegate = self
        
        let videoPlayerContainerView = containerViewFactory.createVideoPlayerContainerView(viewModel: viewModel)
        videoPlayerContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoPlayerContainerView)
        self.videoPlayerContainerView = videoPlayerContainerView
        
        let leadingPaddingOfVideoPlayerContainerView: CGFloat = 0
        let trailingPaddingOfVideoPlayerContainerView: CGFloat = 0
        let topPaddingOfVideoPlayerContainerView: CGFloat = 0
        
        let showingBottomAnchorConstraintOfVideoPlayerView =  videoPlayerContainerView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        self.showingBottomAnchorConstraintOfVideoPlayerView = showingBottomAnchorConstraintOfVideoPlayerView
        
        let hidingBottomAnchorConstraintOfVideoPlayerView = videoPlayerContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        self.hidingBottomAnchorConstraintOfVideoPlayerView = hidingBottomAnchorConstraintOfVideoPlayerView
        
        NSLayoutConstraint.activate([
            videoPlayerContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingPaddingOfVideoPlayerContainerView),
            videoPlayerContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -trailingPaddingOfVideoPlayerContainerView),
            videoPlayerContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPaddingOfVideoPlayerContainerView),
            showingBottomAnchorConstraintOfVideoPlayerView
        ])
        
        let annotationConfigurationContainerView = containerViewFactory.createAnnotationConfigurationContainerView(viewModel: viewModel)
        annotationConfigurationContainerView.translatesAutoresizingMaskIntoConstraints = false
        annotationConfigurationContainerView.clipsToBounds = true
        view.addSubview(annotationConfigurationContainerView)
        
        self.videoConfigurationContainerView = annotationConfigurationContainerView
        let toolBarVM = ToolBarViewModel(annotatorViewModel: viewModel)
        viewModel.bottomToolbarViewDelegate = toolBarVM
        
        let bottomToolBarView = ToolBarView(viewModel: toolBarVM)
        bottomToolBarView.translatesAutoresizingMaskIntoConstraints = false
        bottomToolBarView.clipsToBounds = true
        view.addSubview(bottomToolBarView)
        self.bottomToolBarView = bottomToolBarView
        
        let leadingPaddingOfAnnotationConfigurationView: CGFloat = 0
        let trailingPaddingOfAnnotationConfigurationView: CGFloat = 0
        let topPaddingOfAnnotationConfigurationView: CGFloat = 0
        let paddingBetweeenAnnotationConfigurationViewAndBottomToolBar: CGFloat = 5
        let bottomPaddingOfToolBarView: CGFloat = 5
        
        let showingTopAnchorConstraintOfThumbnailView = annotationConfigurationContainerView.topAnchor.constraint(equalTo: videoPlayerContainerView.bottomAnchor, constant: topPaddingOfAnnotationConfigurationView)
        self.showingTopAnchorConstraintOfThumbnailView = showingTopAnchorConstraintOfThumbnailView
        
        let hidingTopAnchorConstraintOfThumbnailView = annotationConfigurationContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: topPaddingOfAnnotationConfigurationView)
        self.hidingTopAnchorConstraintOfThumbnailView = hidingTopAnchorConstraintOfThumbnailView
        
        
        let showingTopAnchorConstraintOfBottomToolBarView = bottomToolBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomPaddingOfToolBarView)
        self.showingTopAnchorConstraintOfBottomToolBarView = showingTopAnchorConstraintOfBottomToolBarView
        
        let hidingTopAnchorConstraintOfBottomToolBarView = bottomToolBarView.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomPaddingOfToolBarView)
        self.hidingTopAnchorConstraintOfBottomToolBarView = hidingTopAnchorConstraintOfBottomToolBarView
        
        let bgViewForSafeArea = UIView()
        bgViewForSafeArea.translatesAutoresizingMaskIntoConstraints = false
        bgViewForSafeArea.backgroundColor = AnnotationEditorViewColors.bottomToolBarColor
        view.addSubview(bgViewForSafeArea)
        
        NSLayoutConstraint.activate([
            annotationConfigurationContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingPaddingOfAnnotationConfigurationView),
            annotationConfigurationContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -trailingPaddingOfAnnotationConfigurationView),
            showingTopAnchorConstraintOfThumbnailView,
            annotationConfigurationContainerView.bottomAnchor.constraint(equalTo: bottomToolBarView.topAnchor, constant: -paddingBetweeenAnnotationConfigurationViewAndBottomToolBar),
            annotationConfigurationContainerView.heightAnchor.constraint(equalToConstant: heightOfAnnotationConfigurationView),
            
            bottomToolBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomToolBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            showingTopAnchorConstraintOfBottomToolBarView,
            bottomToolBarView.heightAnchor.constraint(equalToConstant: heightOfBottomView),
            
            bgViewForSafeArea.leadingAnchor.constraint(equalTo: bottomToolBarView.leadingAnchor),
            bgViewForSafeArea.trailingAnchor.constraint(equalTo: bottomToolBarView.trailingAnchor),
            bgViewForSafeArea.topAnchor.constraint(equalTo: bottomToolBarView.bottomAnchor),
            bgViewForSafeArea.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
}


extension AnnotatorViewController: FullScreenExecutingProtocol{
    func launchFullScreen() {

        guard let videoPlayerContainerView = videoPlayerContainerView else {return}
        
        videoPlayerContainerView.enteringFullScreen()
        
        showingBottomAnchorConstraintOfVideoPlayerView?.isActive = false
        showingTopAnchorConstraintOfThumbnailView?.isActive = false
        showingTopAnchorConstraintOfBottomToolBarView?.isActive = false
        
        hidingTopAnchorConstraintOfThumbnailView?.isActive = true
        hidingTopAnchorConstraintOfBottomToolBarView?.isActive = true
        hidingBottomAnchorConstraintOfVideoPlayerView?.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.videoConfigurationContainerView?.alpha = 0
            self.bottomToolBarView?.alpha = 0
        }completion: {_ in
            self.videoConfigurationContainerView?.isHidden = true
            self.bottomToolBarView?.isHidden = true
        }
    }
    
    func exitFullScreen() {

        guard let videoPlayerContainerView = videoPlayerContainerView else {return}
        videoPlayerContainerView.exitingFullScreen()

        hidingTopAnchorConstraintOfThumbnailView?.isActive = false
        hidingTopAnchorConstraintOfBottomToolBarView?.isActive = false
        hidingBottomAnchorConstraintOfVideoPlayerView?.isActive = false
        
        showingTopAnchorConstraintOfThumbnailView?.isActive = true
        showingTopAnchorConstraintOfThumbnailView?.isActive = true
        showingTopAnchorConstraintOfBottomToolBarView?.isActive = true
        
        
        self.videoConfigurationContainerView?.isHidden = false
        self.bottomToolBarView?.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.videoConfigurationContainerView?.alpha = 1
            self.bottomToolBarView?.alpha = 1
        }
    }
    
    func playPauseTapped(isVideoPlaying: Bool){
        videoPlayerContainerView?.playPauseTapped(isVideoPlaying: isVideoPlaying)
    }
    
    func videoPlayingFinished(){
        videoPlayerContainerView?.videoPlayingFinished()
    }
    
    func textViewBecameActive() {
        videoPlayerContainerView?.shouldEnableDoneAndBackButton(false)
    }
    
    func textViewEndActive() {
        videoPlayerContainerView?.shouldEnableDoneAndBackButton(true)
    }
    
}

extension AnnotatorViewController: DataLossProtocol{
    
    func showElementDurationAlert() {
        let elementDurationAlert = UIAlertController(title: nil, message: "Element duration is beyond the video length", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
        })
        elementDurationAlert.addAction(okAction)
        
        DispatchQueue.main.async {
           self.present(elementDurationAlert, animated: true, completion: nil)
        }
    }
    
    func showRemoveAudioAlert(){
        let dataLossAlert = UIAlertController(title: "Not Allowed", message: "Please delete the existing audio before recording the new one.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
//            self.viewModel.dimissAnnotationVC()
        })
        dataLossAlert.addAction(okAction)
        
        DispatchQueue.main.async {
           self.present(dataLossAlert, animated: true, completion: nil)
        }
    }
    
    func showTxtLimitReachedAlert(){
        let txtLimitReachedAlert = UIAlertController(title: "Limit Reached", message: "Please delete some of the existing text.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in})
        txtLimitReachedAlert.addAction(okAction)
        
        DispatchQueue.main.async {
           self.present(txtLimitReachedAlert, animated: true, completion: nil)
        }
    }

    func showPauseVideoBeforeRecordingAudioAlert(){
        let dataLossAlert = UIAlertController(title: "Not Allowed", message: "Please pause your video before recording audio", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
//            self.viewModel.dimissAnnotationVC()
        })
        dataLossAlert.addAction(okAction)
        
        DispatchQueue.main.async {
           self.present(dataLossAlert, animated: true, completion: nil)
        }
    }
    
    func showDataLossAlert() {
        let dataLossAlert = UIAlertController(title: nil, message: "Your changes are not saved. Are you sure you want to proceed?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Proceed", style: .destructive, handler: { (action) in
            self.viewModel.dimissAnnotationVC()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        dataLossAlert.addAction(okAction)
        dataLossAlert.addAction(cancelAction)
        
        DispatchQueue.main.async {
           self.present(dataLossAlert, animated: true, completion: nil)
        }
    }
    
    func showAudioPersmissionNotGrantedAlert() {
        let isIpad = iPad
        let iPadTitle = "Access to Microphone is disabled"
        let iPadMsg = "Please go to Settings and turn on Microphone to record audio."
        let iPhoneMsg = "Access to Microphone is disabled. Please go to Settings and turn on Microphone to record audio."
        
        let alertTitle = isIpad ? iPadTitle : nil
        let alertMessage = isIpad ? iPadMsg: iPhoneMsg
        let alertStyle = isIpad ? UIAlertController.Style.alert: UIAlertController.Style.actionSheet
        
        let audioPermissionAlert = UIAlertController(title: alertTitle,
                                                     message: alertMessage,
                                                     preferredStyle: alertStyle)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default){_ in
            self.openSettings()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        audioPermissionAlert.addAction(settingsAction)
        audioPermissionAlert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(audioPermissionAlert, animated: true, completion: nil)
        }

    }
    
    private func openSettings(){
        openApplicationSetting()
    }
    
    func getParentViewHeight() -> CGFloat {
        view.frame.size.height
    }
}

extension AnnotatorViewController: AudioRecordingNotifyingProtocol{
    func started() {
        videoPlayerContainerView?.audioRecordingStarted()
    }
    
    func cancelled(){
        videoPlayerContainerView?.audioRecordingEnded()
    }
    
    func ended() {
        videoPlayerContainerView?.audioRecordingEnded()
    }
}

extension AnnotatorViewController: UINavigationControllerDelegate {
    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        guard let orientation = navigationController.topViewController?.supportedInterfaceOrientations else {
            return .all
        }
        return orientation
    }
}
