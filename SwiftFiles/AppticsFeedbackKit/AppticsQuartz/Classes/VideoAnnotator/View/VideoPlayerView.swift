//
//  VideoPlayerView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 14/09/23.
//

import UIKit
import AVFoundation


protocol VideoPlayerViewProtocol: UIView{
    var viewModel: VideoPlayerViewModelProtocol{ get }
    func getCurrentTime() -> CMTime
    func seek(to time: CMTime)
    func seekForShapeHandlerChanges(to time: CMTime)
    func seekHandlerChangesEnded()
    func play()
    func pause()
    func restart()
    func sound(shouldEnable: Bool)
    func isVideoPlaying() -> Bool
    func isSoundEnabled() -> Bool
    func totalVideoDuration() -> CMTime
    func getCurrentItemStatus() -> AVPlayerItem.Status?
    func getVideoPlayerBoundingBoxSize() -> CGSize
    // Shape Additions
    func addView(_ view: UIView, withFrame rect: CGRect)
    func getViewForShapeAddition() -> UIView
    
    func enteringFullScreen()
    func exitingFullScreen()
    func videoPlayingFinished()
    func shouldEnableAudioTrackFromRecordedVideo(_ shoudlEnable:Bool)
    func addMaskView(belowTxtView: UIView)
    func removeMaskViewAddedForTxtView()
    func setScreen(newRatio: CGFloat, normalRatio: CGFloat)
}


class ViewPlayerView: UIView{
    
    var viewModel: VideoPlayerViewModelProtocol
    
    private var player: AVPlayer
    private var playerLayer: AVPlayerLayer
    private var labelObserver: Any?
    private var scrollObserver: Any?
    
    private var isSeekedToEnd: Bool = false
    
    private var normalScreenRatioFactor: CGFloat = 1.0
    private var newScreenRatioFactor: CGFloat = 1.0
    
    private var totalVideoPlayBackDuration: CMTime{
        self.player.currentItem?.duration ?? CMTime(seconds: 0, preferredTimescale: 1)
    }
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.clipsToBounds = true
        return containerView
    }()
    
    private enum OtherConstants{
        static let statusKeyPath = "status"
    }
    
    private var txtFieldMaskingView: UIView = {
        let txtFieldMaskingView = UIView()
        txtFieldMaskingView.translatesAutoresizingMaskIntoConstraints = false
        txtFieldMaskingView.backgroundColor = AnnotationEditorViewColors.textMaskingViewBGColor
        return txtFieldMaskingView
    }()
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage.named("done")?.withRenderingMode(.alwaysTemplate)
        doneButton.setImage(img, for: .normal)
        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        doneButton.tintColor = QuartzKit.shared.primaryColor ?? UIColor.label
        return doneButton
    }()
    
    
    init(viewModel: AnnotatorViewModelProtocol) {
        self.viewModel = viewModel
        let playerItem = AVPlayerItem(url: viewModel.videoFileUrl)
        player = AVPlayer(playerItem: playerItem)
        player.automaticallyWaitsToMinimizeStalling = false
        player.volume = 1.0
        
        playerLayer = AVPlayerLayer(player: player)
        super.init(frame: .zero)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        configurePlayer()
        addPlayerFinishNotification()
        addTapGesture()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let isInFullScreenMode = !containerView.isUserInteractionEnabled

        var widthOfCornerView = AnnotationRectangleCircleView.widthOfCornerView
        var heightOfCornerView = AnnotationRectangleCircleView.heightOfCornerView
        if isInFullScreenMode{
            
            widthOfCornerView = (widthOfCornerView * newScreenRatioFactor) / normalScreenRatioFactor
            heightOfCornerView = (heightOfCornerView * newScreenRatioFactor) / normalScreenRatioFactor
            
            let playerContainerAllowedSize = CGSizeMake(frame.size.width , frame.size.height)
            let playerFrame = scaledVideoFrame(boundingBox: playerContainerAllowedSize)
            containerView.frame = CGRectMake(0,
                                             0,
                                             playerFrame.size.width + widthOfCornerView,
                                             playerFrame.size.height + heightOfCornerView)

            playerLayer.frame = CGRect(x: widthOfCornerView/2.0, y: heightOfCornerView/2.0, width: playerFrame.width, height: playerFrame.height)
            containerView.center = CGPoint(x: frame.width/2.0 , y: frame.height/2.0)
        }else{
            let playerContainerAllowedSize = CGSizeMake(frame.size.width - widthOfCornerView , frame.size.height - heightOfCornerView)
            let playerFrame = scaledVideoFrame(boundingBox: playerContainerAllowedSize)
            containerView.frame = CGRectMake(0,
                                             0,
                                             playerFrame.size.width + widthOfCornerView,
                                             playerFrame.size.height + heightOfCornerView)

            playerLayer.frame = CGRect(x: widthOfCornerView/2.0, y: heightOfCornerView/2.0, width: playerFrame.width, height: playerFrame.height)
            containerView.center = CGPoint(x: frame.width/2.0 , y: frame.height/2.0)
        }
        
        //        let playerContainerAllowedSize = CGSizeMake(frame.size.width - widthOfCornerView , frame.size.height - heightOfCornerView)
        //        let playerFrame = scaledVideoFrame(boundingBox: playerContainerAllowedSize)
        //        containerView.frame = CGRectMake(playerFrame.origin.x - widthOfCornerView / 2.0 ,
        //                                         playerFrame.origin.y - heightOfCornerView / 2.0,
        //                                         playerFrame.size.width + widthOfCornerView,
        //                                         playerFrame.size.height + heightOfCornerView)
        //
        //        playerLayer.frame = CGRect(x: widthOfCornerView/2.0, y: heightOfCornerView/2.0, width: playerFrame.width, height: playerFrame.height)

//        containerView.frame = CGRect(x: 0,
//                                     y: 0,
//                                     width: frame.width,
//                                     height: frame.height)
//        playerLayer.frame = CGRect(x: widthOfCornerView/2.0, y: heightOfCornerView/2.0 , width: frame.size.width - widthOfCornerView, height: frame.size.height - heightOfCornerView)
        viewModel.updateShapesWithNewParentSize(containerView.frame.size, isInFullScreenPreview: isInFullScreenMode)
    }
    
    private func configurePlayer() {
        addSubview(containerView)
        playerLayer.videoGravity = .resizeAspect // You can adjust this based on your needs
        playerLayer.cornerRadius = 10
        playerLayer.masksToBounds = true
        containerView.layer.addSublayer(playerLayer)
        
        self.player.currentItem?.addObserver(self, forKeyPath: OtherConstants.statusKeyPath,options: .new, context: nil)
    }
    
    private func addPlayerFinishNotification(){
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func addTapGesture(){
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tapgesture)
    }
    
    @objc private func videoDidFinishPlaying(_ sender: NSNotification) {
        guard let playerItem = sender.object as? AVPlayerItem,
              let currentItem = player.currentItem else {return}
        if playerItem == currentItem {
            viewModel.didFinishAndRestart()
        }
    }
    
    @objc private func tapped() {
        viewModel.tapped()
    }
    
    private func addTimeObserver() {
    
        removeObserversFromPlayer()
        let labelUpdatingInterval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let labelObserver =  player.addPeriodicTimeObserver(forInterval: labelUpdatingInterval , queue: DispatchQueue.main) { [weak self] _ in
            guard let self = self else { return }
            let playerTime = self.player.currentTime()
            self.viewModel.updateLabelText(time: playerTime, withTotalDuration: self.totalVideoPlayBackDuration)
        }
        self.labelObserver = labelObserver
        
        let scrollUpdatingInterval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        let scrollObserver = player.addPeriodicTimeObserver(forInterval: scrollUpdatingInterval , queue: DispatchQueue.main) { [weak self] _ in
            guard let self = self else { return }
            if self.isSeekedToEnd{return} // When seeked to end tolerance is allowed so don't allow for content offset adjustment since tolerance will cause small amt of wrong offset
            let currentPlayBackTime = self.player.currentTime()
            let playerTime = (CMTimeGetSeconds(currentPlayBackTime) < 0) ? CMTimeMakeWithSeconds(0, preferredTimescale: currentPlayBackTime.timescale) : currentPlayBackTime
            //            print("addPeriodicTimeObserver:\(CMTimeGetSeconds(playerTime)), total:\(CMTimeGetSeconds(totalVideoPlayBackDuration))")
            self.viewModel.updateScroll(time: playerTime, withTotalDuration: self.totalVideoPlayBackDuration)
        }
        self.scrollObserver = scrollObserver
    }
    
    private func removeObserversFromPlayer(){
        if let lObserver = labelObserver, let sObserver = scrollObserver{
            player.removeTimeObserver(lObserver)
            player.removeTimeObserver(sObserver)
            labelObserver = nil
            scrollObserver = nil
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == OtherConstants.statusKeyPath, let playerItem = object as? AVPlayerItem, playerItem.status == .readyToPlay {
            viewModel.readyToPlayVideo(withTotalDuration: totalVideoPlayBackDuration)
            addTimeObserver()
        }
    }
    
    deinit {
        if let currentItem = player.currentItem {
            currentItem.removeObserver(self, forKeyPath: OtherConstants.statusKeyPath)
        }
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func getVideoSize(from fileURL: URL) -> CGSize? {
        let asset = AVAsset(url: fileURL)
        let videoTrack = asset.tracks(withMediaType: AVMediaType.video).first
        
        if let videoSize = videoTrack?.naturalSize {
            return videoSize
        } else {
            return nil
        }
    }
    
    func scaledVideoFrame(boundingBox: CGSize) -> CGRect {
        guard let videoSize = getVideoSize(from: viewModel.videoFileUrl) else { return .zero}
        
        let videoWidth = videoSize.width
        let videoHeight = videoSize.height
        
        let boundingBoxWidth = boundingBox.width
        let boundingBoxHeight = boundingBox.height
        
        // Calculate aspect ratios
        let videoAspectRatio = videoWidth / videoHeight
        let boundingBoxAspectRatio = boundingBoxWidth / boundingBoxHeight
        
        var scaledVideoWidth: CGFloat
        var scaledVideoHeight: CGFloat
        
        if videoAspectRatio > boundingBoxAspectRatio {
            // Video is wider than bounding box, scale based on width
            scaledVideoWidth = boundingBoxWidth
            scaledVideoHeight = scaledVideoWidth / videoAspectRatio
        } else {
            // Video is taller than bounding box, scale based on height
            scaledVideoHeight = boundingBoxHeight
            scaledVideoWidth = scaledVideoHeight * videoAspectRatio
        }
        
        // Calculate the origin to center the scaled video frame in the bounding box
        let xOrigin = (boundingBoxWidth - scaledVideoWidth) / 2
        let yOrigin = (boundingBoxHeight - scaledVideoHeight) / 2
        
        let scaledVideoFrame = CGRect(x: xOrigin, y: yOrigin, width: scaledVideoWidth, height: scaledVideoHeight)
        return scaledVideoFrame
    }
}

extension ViewPlayerView: VideoPlayerViewProtocol{
    
    func setScreen(newRatio: CGFloat, normalRatio: CGFloat){
        newScreenRatioFactor = newRatio
        normalScreenRatioFactor = normalRatio
    }
    
    @objc private func doneAction(){
        removeMaskViewAddedForTxtView()
        viewModel.doneTappedForTxtField()
    }
    
    @objc private func maskViewTapped(){
        doneAction()
    }
    
    func addMaskView(belowTxtView: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(maskViewTapped))
        txtFieldMaskingView.addGestureRecognizer(tapGesture)
        containerView.clipsToBounds = false
        containerView.insertSubview(txtFieldMaskingView, belowSubview: belowTxtView)
        self.addSubview(doneButton)
                 
        NSLayoutConstraint.activate([
            txtFieldMaskingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -100),
            txtFieldMaskingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 100),
            txtFieldMaskingView.topAnchor.constraint(equalTo: topAnchor, constant: -100),
            txtFieldMaskingView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 30),
            
            doneButton.widthAnchor.constraint(equalToConstant: 30),
            doneButton.heightAnchor.constraint(equalToConstant: 30),
            doneButton.topAnchor.constraint(equalTo: topAnchor),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6)
        ])
    }
    
    func removeMaskViewAddedForTxtView(){
        txtFieldMaskingView.gestureRecognizers?.removeAll()
        txtFieldMaskingView.removeFromSuperview()
        doneButton.removeFromSuperview()
    }
    
    func getCurrentItemStatus() -> AVPlayerItem.Status? {
        self.player.currentItem?.status
    }
    
    func getVideoPlayerBoundingBoxSize() -> CGSize{
        containerView.frame.size
    }
    
    func seek(to time: CMTime) {
        isSeekedToEnd = (time == totalVideoPlayBackDuration)
        if isSeekedToEnd{
            player.seek(to: time) // Allowing tolerance when seeking to end since without tolerance empty frame is shown
        }else{
            player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
        viewModel.videoPlayerSeeked(to: time)
    }
    
    func seekForShapeHandlerChanges(to time: CMTime){
        removeObserversFromPlayer()
        isSeekedToEnd = (time == totalVideoPlayBackDuration)
        if isSeekedToEnd{
            player.seek(to: time) // Allowing tolerance when seeking to end since without tolerance empty frame is shown
        }else{
            player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    
    func seekHandlerChangesEnded(){
        addTimeObserver()
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func restart(){
        player.seek(to: CMTime.zero, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        viewModel.videoPlayerSeeked(to: .zero)
    }
    
    func isVideoPlaying() -> Bool{
        player.rate != 0
    }
    
    func getCurrentTime() -> CMTime {
        player.currentTime()
    }
    
    func totalVideoDuration() -> CMTime {
        totalVideoPlayBackDuration
    }
    
    func addView(_ view: UIView, withFrame rect: CGRect) {
        view.frame = rect
        containerView.addSubview(view)
    }
    
    func isSoundEnabled() -> Bool {
        !player.isMuted
    }
    
    func sound(shouldEnable: Bool) {
        player.isMuted = !shouldEnable
    }
    
    func getViewForShapeAddition() -> UIView {
        containerView
    }
    
    func enteringFullScreen() {
        containerView.isUserInteractionEnabled = false
        alpha = 0
        UIView.animate(withDuration: 0.25, delay: 0.25) {
            self.alpha = 1
        }
    }
    
    func exitingFullScreen() {
        containerView.isUserInteractionEnabled = true
        alpha = 0
        UIView.animate(withDuration: 0.25, delay: 0.25) {
            self.alpha = 1
        }
    }
    
    func videoPlayingFinished(){
        pause()
    }
    
    func shouldEnableAudioTrackFromRecordedVideo(_ shoudlEnable: Bool){
        player.volume = shoudlEnable ? 1: 0
    }
}
