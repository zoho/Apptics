//
//  VideoThumbnailView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 18/09/23.
//

import UIKit
import AVFoundation

protocol VideoThumbnailViewProtocol: UIView {
    var viewModel: AnnotatorViewModelProtocol { get }
    var viewFactory: AnnotationConfigurationViewFactory { get }
    
    func autoScrollTo(time: CMTime, totalPlaybackDuration: CMTime,isRecordingInProgress: Bool)
    
    func addShape(withDetails details: AddedShapeDetails, currentTime: CMTime, totalPlaybackDuration: CMTime) -> ShapeRowViewProtocol
    func scrollTo(_ view: ShapeRowViewProtocol)
    func scrollToTime(_ time: CMTime, totalDuration: CMTime)
    
    func getViewForRowAddition() -> UIStackView
    func resetVideoTrimmingViews()
    func enableVideoTrimming()
    func disableVideoTrimming()
    func audioRecordingStarted(at startTime: CMTime)
    func audioRecordingEnded()
    
    func updateTheVideoTrimmingTo(startTime: CMTime, endTime: CMTime, totalDuration: CMTime)
    func adjustScrollBasedOn(startTime: CMTime, endTime: CMTime, totalDuration: CMTime)
}

class VideoThumbnailView: UIScrollView {
    
    var isAutoScroll = false
    var viewModel: AnnotatorViewModelProtocol
    var viewFactory: AnnotationConfigurationViewFactory
    
    private var frontMaskViewWidthConstraint: NSLayoutConstraint? = nil{
        didSet{
            updateUIOfFrontAndBackAssitView()
        }
    }
    
    private var backMaskViewWidthConstraint: NSLayoutConstraint? = nil{
        didSet{
            updateUIOfFrontAndBackAssitView()
        }
    }
    
    private var handlerViewHeight: CGFloat? = nil
    
    private struct UIConstants {
        static let shapesHolderStackViewSpacing: CGFloat = 5
        
        static let thumbnailHeight: CGFloat = 40 // Adjust as needed
        
        static let thumbnailSpacing: CGFloat = 0 // Adjust as needed
        static let shapeRowViewHeight: CGFloat = 26
        static let audioRowViewHeight: CGFloat = 26
        
        static let videoSliderViewHeight: CGFloat = 15
        static let handlerViewWidth: CGFloat = 15
        
        static let frontMaskViewColor = UIColor.label.withAlphaComponent(0.4)
        static let backMaskViewColor = UIColor.label.withAlphaComponent(0.4)
        
        static let thumbnailHolderViewCornerRadius: CGFloat = 5
        
        static let handlerViewCornerRadius: CGFloat = 5
        //        static let handlerViewColor = UIColor(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1)
        static let handlerViewColor = AnnotationEditorViewColors.selectionBorderColor
        
        static let borderViewColor = handlerViewColor
        static let borderViewThickness: CGFloat = 3
    }
    
    private var thumbnailHolderLeadingAnchor: NSLayoutConstraint?
    private var thumbnailHolderTrailingAnchor: NSLayoutConstraint?
    
    private let thumbNailGenerator = ThumbnailGenerator()
    private var contOffAtRotation: CGPoint?
    private var assistViewWidth: CGFloat = 4
    private var isLeftHandlerAction = false
    
    private var frontHandlerAutoScrollingDelta: CGFloat = 0.04 // Amt by which auto scrolling should start before reaching the end
    private var backHandlerAutoScrollingDelta: CGFloat = 0.04
    
    private var frontHandlerLeftSideAutoScrollTimer: Timer? = nil
    private var frontHandlerRightSideAutoScrollTimer: Timer? = nil
    private var backHandlerLeftSideAutoScrollTimer: Timer? = nil
    private var backHandlerRightSideAutoScrollTimer: Timer? = nil
    
    private var shouldShowHandlersOutsideOfView = true
    private var minWidthOfVideo: CGFloat = 10
    
    init(viewModel: AnnotatorViewModelProtocol, viewFactory: AnnotationConfigurationViewFactory = ConcreteAnnotationConfigurationViewFactory()) {
        self.viewModel = viewModel
        self.viewFactory = viewFactory
        super.init(frame: .zero)
        configure()
    }
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    private lazy var thumbnailContainerView: UIView = {
        let thumbnailContainerView = UIView()
//        thumbnailContainerView.backgroundColor = .red
        thumbnailContainerView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailContainerView.layer.cornerRadius = UIConstants.thumbnailHolderViewCornerRadius
        thumbnailContainerView.clipsToBounds = true
        return thumbnailContainerView
    }()
    
    class ThumbnailHolderView: UIView{
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            if super.point(inside: point, with: event) { return true }
            for subview in subviews {
                let subviewPoint = subview.convert(point, from: self)
                if subview.point(inside: subviewPoint, with: event) { return true }
            }
            return false
        }
    }
    
    private lazy var thumbnailHolderView: ThumbnailHolderView = {
        let containerView = ThumbnailHolderView()
        //        containerView.backgroundColor = .orange
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = UIConstants.thumbnailHolderViewCornerRadius
        containerView.clipsToBounds = true
        return containerView
    }()

    private lazy var shapesScrollView: UIScrollView = {
        let shapesScrollView = UIScrollView()
        shapesScrollView.translatesAutoresizingMaskIntoConstraints = false
        shapesScrollView.clipsToBounds = true
        shapesScrollView.isDirectionalLockEnabled = true
        shapesScrollView.showsVerticalScrollIndicator = false
        shapesScrollView.bounces = false
        return shapesScrollView
    }()
    
    private lazy var frontMaskView: UIView = {
        let frontMaskView = UIView()
        frontMaskView.backgroundColor = UIConstants.frontMaskViewColor
        frontMaskView.translatesAutoresizingMaskIntoConstraints = false
//        frontMaskView.backgroundColor = .clear

//        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        //always fill the view
//        blurEffectView.frame = frontMaskView.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

//        frontMaskView.addSubview(blurEffectView)
        
        return frontMaskView
    }()
    
    private lazy var backMaskView: UIView = {
        let backMaskView = UIView()
        backMaskView.backgroundColor = UIConstants.backMaskViewColor
        backMaskView.translatesAutoresizingMaskIntoConstraints = false
        return backMaskView
    }()
    
    private lazy var frontMaskStartPadAssistView: UIView = {
        let frontMaskStartPadAssistView = UIView()
        frontMaskStartPadAssistView.backgroundColor = AnnotationEditorViewColors.thumbnailContainerViewBGColor
        frontMaskStartPadAssistView.translatesAutoresizingMaskIntoConstraints = false
        return frontMaskStartPadAssistView
    }()
    
    private lazy var backMaskEndPadAssistView: UIView = {
        let backMaskEndPadAssistView = UIView()
        backMaskEndPadAssistView.backgroundColor = AnnotationEditorViewColors.thumbnailContainerViewBGColor
        backMaskEndPadAssistView.translatesAutoresizingMaskIntoConstraints = false
        return backMaskEndPadAssistView
    }()
    
    private lazy var frontHandlerView: HandlerView = {
        let frontHandlerView = HandlerView()
        frontHandlerView.delegate = self
        frontHandlerView.shouldAddCurveAtFront = true
        frontHandlerView.yOffset = UIConstants.borderViewThickness
        frontHandlerView.translatesAutoresizingMaskIntoConstraints = false
        frontHandlerView.layer.masksToBounds = false
        return frontHandlerView
    }()
    

    private lazy var backHandlerView: HandlerView = {
        let backHandlerView = HandlerView()
        backHandlerView.delegate = self
        backHandlerView.shouldAddCurveAtFront = false
        backHandlerView.yOffset = UIConstants.borderViewThickness
        backHandlerView.translatesAutoresizingMaskIntoConstraints = false
        backHandlerView.layer.masksToBounds = false
        return backHandlerView
    }()
    
    private lazy var frontMaskAssistView: UIView = { // To assist the work of front mask view to hide the corner radius background of front handler view
        let frontMaskAssistView = UIView()
        frontMaskAssistView.backgroundColor = UIConstants.frontMaskViewColor
        frontMaskAssistView.translatesAutoresizingMaskIntoConstraints = false
        return frontMaskAssistView
    }()
    
    private lazy var backMaskAssistView: UIView = {
        let backMaskAssistView = UIView()
        backMaskAssistView.backgroundColor = UIConstants.backMaskViewColor
        backMaskAssistView.translatesAutoresizingMaskIntoConstraints = false
        return backMaskAssistView
    }()
    
    private lazy var topLineView: UIView = {
        let topLineView = UIView()
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        topLineView.backgroundColor = UIConstants.borderViewColor
        return topLineView
    }()
    
    private lazy var bottomLineView: UIView = {
        let bottomLineView = UIView()
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        bottomLineView.backgroundColor = UIConstants.borderViewColor
        return bottomLineView
    }()
    
    class ShapesHolderStackView: UIStackView{
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            if super.point(inside: point, with: event) { return true }
            for subview in subviews {
                let subviewPoint = subview.convert(point, from: self)
                if subview.point(inside: subviewPoint, with: event) { return true }
            }
            return false
        }
    }
    
    private lazy var shapesHolderStackView: ShapesHolderStackView = {
        let shapesHolderStackView = ShapesHolderStackView()
        shapesHolderStackView.translatesAutoresizingMaskIntoConstraints = false
        shapesHolderStackView.axis = .vertical
        shapesHolderStackView.alignment = .fill
        shapesHolderStackView.distribution = .equalSpacing
        shapesHolderStackView.spacing = UIConstants.shapesHolderStackViewSpacing
        shapesHolderStackView.clipsToBounds = false
        return shapesHolderStackView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func tapped(){
        viewModel.scrollViewTapped()
    }
    
    private func configure() {
        delegate = self
        bounces = false
        layer.cornerRadius = 5
        showsHorizontalScrollIndicator = false
        
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        containerView.addGestureRecognizer(tapGesture)
        
        containerView.backgroundColor = UIColor.clear
        let thumbnailHolderViewTopPadding: CGFloat = 0
        let thumbnailHolderViewBottomPadding: CGFloat = 0
        
        containerView.addSubview(thumbnailContainerView)
        thumbnailContainerView.addSubview(thumbnailHolderView)
        
        
        let leadingAnchorConstraint = thumbnailContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let trailingAnchorConstraint = thumbnailContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        
        thumbnailHolderLeadingAnchor = leadingAnchorConstraint
        thumbnailHolderTrailingAnchor = trailingAnchorConstraint
        
        NSLayoutConstraint.activate([
            leadingAnchorConstraint,
            trailingAnchorConstraint,
            thumbnailContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: thumbnailHolderViewTopPadding),
            thumbnailContainerView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -thumbnailHolderViewBottomPadding),
            
            thumbnailHolderView.leadingAnchor.constraint(equalTo: thumbnailContainerView.leadingAnchor, constant: shouldShowHandlersOutsideOfView ? UIConstants.handlerViewWidth : 0),
            thumbnailHolderView.trailingAnchor.constraint(equalTo: thumbnailContainerView.trailingAnchor, constant: shouldShowHandlersOutsideOfView ? -UIConstants.handlerViewWidth : 0),
            thumbnailHolderView.topAnchor.constraint(equalTo: thumbnailContainerView.topAnchor),
            thumbnailHolderView.bottomAnchor.constraint(equalTo: thumbnailContainerView.bottomAnchor)
        ])
        
        containerView.insertSubview(shapesScrollView, belowSubview: thumbnailContainerView)
        shapesScrollView.addSubview(shapesHolderStackView)
        
        let shapeScrollViewTopPadding: CGFloat = 0
        let shapeScrollViewBottomPadding: CGFloat = 0
        
        NSLayoutConstraint.activate([
            shapesScrollView.leadingAnchor.constraint(equalTo: thumbnailContainerView.leadingAnchor),
            shapesScrollView.trailingAnchor.constraint(equalTo: thumbnailContainerView.trailingAnchor),
            shapesScrollView.topAnchor.constraint(equalTo: thumbnailContainerView.bottomAnchor, constant: shapeScrollViewTopPadding),
            shapesScrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -shapeScrollViewBottomPadding)
        ])
        
        let holderLeadingPaddng: CGFloat = shouldShowHandlersOutsideOfView ? UIConstants.handlerViewWidth : 0
        let holderTrailPaddng: CGFloat = shouldShowHandlersOutsideOfView ? UIConstants.handlerViewWidth : 0
        
        NSLayoutConstraint.activate([
            shapesHolderStackView.leadingAnchor.constraint(equalTo: shapesScrollView.leadingAnchor, constant: holderLeadingPaddng),
            shapesHolderStackView.trailingAnchor.constraint(equalTo: shapesScrollView.trailingAnchor, constant: -holderTrailPaddng),
            shapesHolderStackView.topAnchor.constraint(equalTo: shapesScrollView.topAnchor),
            shapesHolderStackView.bottomAnchor.constraint(equalTo: shapesScrollView.bottomAnchor),
            shapesHolderStackView.widthAnchor.constraint(equalTo: shapesScrollView.widthAnchor, constant: -(holderLeadingPaddng+holderTrailPaddng)),
        ])
        
        let asset = AVAsset(url: viewModel.videoFileUrl)
        
        thumbNailGenerator.generateThumbnail(for: asset, at: CMTime(seconds: 0.1, preferredTimescale: 50)) { image in
            guard let imageSize = image?.size else {return}
            self.configureThumbnailsView(withAsset: asset, imageSize: imageSize)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)

    }
    
    @objc private func deviceRotated(){
        contOffAtRotation = contentOffset
    }
    
    private func configureThumbnailsView(withAsset asset: AVAsset, imageSize imgSize: CGSize) {
        let totalDurationInCMTime = asset.duration
        let totalDurationInSeconds = CMTimeGetSeconds(totalDurationInCMTime)
        
        let allowedMaxDuration: CGFloat = 5 * 60 // Maximum allowed video recording duration is 5 min
        
        var minAllowedWidthForThumbnails: CGFloat
        var maxAllowedWidthForThumbnails: CGFloat
        
        if iPad {
            minAllowedWidthForThumbnails = 500
            maxAllowedWidthForThumbnails = 1500
        }else{
            minAllowedWidthForThumbnails = 500
            maxAllowedWidthForThumbnails = 1000
        }
        let curWidth = max(maxAllowedWidthForThumbnails * totalDurationInSeconds / allowedMaxDuration, minAllowedWidthForThumbnails) // Thumbnails image view width is calculated based on recorder
        
        let totalWidthToUseForThumbnails: CGFloat = curWidth
        let thumbnailWidth = (imgSize.width * UIConstants.thumbnailHeight) / (imgSize.height)
        let numberOfThumbnailsToCapture = Int(ceil(totalWidthToUseForThumbnails / thumbnailWidth))
        
        // Clear existing thumbnails
        thumbnailHolderView.subviews.forEach { $0.removeFromSuperview() }
        
        
        let thumbnailTimeInterval = thumbnailWidth * totalDurationInSeconds / (CGFloat(numberOfThumbnailsToCapture)*thumbnailWidth)
        
        var previousImageView: UIImageView? = nil
        
        for i in 0..<numberOfThumbnailsToCapture{
            let thumbnailView = UIImageView()
            thumbnailView.translatesAutoresizingMaskIntoConstraints = false
            thumbnailView.contentMode = .scaleAspectFit
            thumbnailHolderView.addSubview(thumbnailView)
            
            // Configure tap gesture recognizer
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(thumbnailTapped(_:)))
            thumbnailView.isUserInteractionEnabled = true
            thumbnailView.addGestureRecognizer(tapGestureRecognizer)
            
            DispatchQueue.global(qos: .userInitiated).async{[weak self] in
                // Calculate the time for the thumbnail
                let time = CMTime(seconds: Double(i) * thumbnailTimeInterval,
                                  preferredTimescale: totalDurationInCMTime.timescale)
                
                self?.thumbNailGenerator.generateThumbnail(for: asset, at: time) {image in
                    DispatchQueue.main.async {
                        thumbnailView.image = image
                    }
                }
            }
            
            if let previousImageView = previousImageView {
                NSLayoutConstraint.activate([
                    thumbnailView.leadingAnchor.constraint(equalTo: previousImageView.trailingAnchor, constant: UIConstants.thumbnailSpacing),
                    thumbnailView.heightAnchor.constraint(equalToConstant: UIConstants.thumbnailHeight),
                    thumbnailView.widthAnchor.constraint(equalToConstant: thumbnailWidth),
                    thumbnailView.topAnchor.constraint(equalTo: thumbnailHolderView.topAnchor),
                    thumbnailView.bottomAnchor.constraint(equalTo: thumbnailHolderView.bottomAnchor)
                ])
            } else {
                // First thumbnail
                NSLayoutConstraint.activate([
                    thumbnailView.leadingAnchor.constraint(equalTo: thumbnailHolderView.leadingAnchor),
                    thumbnailView.heightAnchor.constraint(equalToConstant: UIConstants.thumbnailHeight),
                    thumbnailView.widthAnchor.constraint(equalToConstant: thumbnailWidth),
                    thumbnailView.topAnchor.constraint(equalTo: thumbnailHolderView.topAnchor),
                    thumbnailView.bottomAnchor.constraint(equalTo: thumbnailHolderView.bottomAnchor),
                ])
            }
            previousImageView = thumbnailView
        }
        
        if let lastThumbnailView = previousImageView{
            NSLayoutConstraint.activate([
                lastThumbnailView.trailingAnchor.constraint(equalTo: thumbnailHolderView.trailingAnchor)
            ])
        }
        thumbnailHolderView.clipsToBounds = false
        frontHandlerView.isShownOutsideOfParent = shouldShowHandlersOutsideOfView
        backHandlerView.isShownOutsideOfParent = shouldShowHandlersOutsideOfView
        
        thumbnailHolderView.addSubviews(frontHandlerView,backHandlerView,frontMaskView,backMaskView,topLineView,bottomLineView)
        thumbnailHolderView.insertSubview(frontMaskAssistView, belowSubview: frontHandlerView)
        thumbnailHolderView.insertSubview(backMaskAssistView, belowSubview: backHandlerView)
    
        thumbnailHolderView.insertSubview(frontMaskStartPadAssistView, aboveSubview: frontMaskView)
        thumbnailHolderView.insertSubview(backMaskEndPadAssistView, aboveSubview: backMaskView)
        thumbnailHolderView.bringSubviewsToFront(frontHandlerView)
        thumbnailHolderView.bringSubviewsToFront(backHandlerView)
        
        
        let frontMaskViewWidthConstraint = frontMaskView.widthAnchor.constraint(equalToConstant: 0)
        let backMaskViewWidthConstraint = backMaskView.widthAnchor.constraint(equalToConstant: 0)
        self.frontMaskViewWidthConstraint = frontMaskViewWidthConstraint
        self.backMaskViewWidthConstraint = backMaskViewWidthConstraint
        
        
        NSLayoutConstraint.activate([
            frontMaskView.leadingAnchor.constraint(equalTo: thumbnailHolderView.leadingAnchor, constant: shouldShowHandlersOutsideOfView ? -UIConstants.handlerViewWidth : 0),
            frontMaskView.topAnchor.constraint(equalTo: thumbnailHolderView.topAnchor),
            frontMaskView.bottomAnchor.constraint(equalTo: thumbnailHolderView.bottomAnchor),
            frontMaskViewWidthConstraint,
            
            frontMaskStartPadAssistView.leadingAnchor.constraint(equalTo: frontMaskView.leadingAnchor),
            frontMaskStartPadAssistView.topAnchor.constraint(equalTo: frontMaskView.topAnchor),
            frontMaskStartPadAssistView.bottomAnchor.constraint(equalTo: frontMaskView.bottomAnchor),
            frontMaskStartPadAssistView.trailingAnchor.constraint(equalTo: thumbnailHolderView.leadingAnchor),
            
            frontHandlerView.leadingAnchor.constraint(equalTo: frontMaskView.trailingAnchor),
            frontHandlerView.widthAnchor.constraint(equalToConstant: UIConstants.handlerViewWidth),
            frontHandlerView.centerYAnchor.constraint(equalTo: thumbnailHolderView.centerYAnchor),
            frontHandlerView.heightAnchor.constraint(equalToConstant: UIConstants.thumbnailHeight),
            
            backHandlerView.trailingAnchor.constraint(equalTo: backMaskView.leadingAnchor),
            backHandlerView.widthAnchor.constraint(equalToConstant: UIConstants.handlerViewWidth),
            backHandlerView.centerYAnchor.constraint(equalTo: thumbnailHolderView.centerYAnchor),
            backHandlerView.heightAnchor.constraint(equalToConstant: UIConstants.thumbnailHeight),
            
            backMaskView.trailingAnchor.constraint(equalTo: thumbnailHolderView.trailingAnchor, constant: shouldShowHandlersOutsideOfView ? UIConstants.handlerViewWidth : 0),
            backMaskView.topAnchor.constraint(equalTo: thumbnailHolderView.topAnchor),
            backMaskView.bottomAnchor.constraint(equalTo: thumbnailHolderView.bottomAnchor),
            backMaskViewWidthConstraint,
            
            backMaskEndPadAssistView.trailingAnchor.constraint(equalTo: backMaskView.trailingAnchor),
            backMaskEndPadAssistView.topAnchor.constraint(equalTo: backMaskView.topAnchor),
            backMaskEndPadAssistView.bottomAnchor.constraint(equalTo: backMaskView.bottomAnchor),
            backMaskEndPadAssistView.leadingAnchor.constraint(equalTo: thumbnailHolderView.trailingAnchor),
            
            frontMaskAssistView.leadingAnchor.constraint(equalTo: frontMaskView.trailingAnchor),
            frontMaskAssistView.widthAnchor.constraint(equalToConstant: shouldShowHandlersOutsideOfView ? UIConstants.handlerViewWidth : assistViewWidth),
            frontMaskAssistView.centerYAnchor.constraint(equalTo: thumbnailHolderView.centerYAnchor),
            frontMaskAssistView.heightAnchor.constraint(equalTo: frontHandlerView.heightAnchor),
            
            backMaskAssistView.trailingAnchor.constraint(equalTo: backMaskView.leadingAnchor),
            backMaskAssistView.widthAnchor.constraint(equalToConstant: shouldShowHandlersOutsideOfView ? UIConstants.handlerViewWidth : assistViewWidth),
            backMaskAssistView.centerYAnchor.constraint(equalTo: thumbnailHolderView.centerYAnchor),
            backMaskAssistView.heightAnchor.constraint(equalTo: backMaskView.heightAnchor),
            
            topLineView.leadingAnchor.constraint(equalTo: frontHandlerView.trailingAnchor),
            topLineView.trailingAnchor.constraint(equalTo: backHandlerView.leadingAnchor),
            topLineView.topAnchor.constraint(equalTo: frontHandlerView.topAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: UIConstants.borderViewThickness),
            
            bottomLineView.leadingAnchor.constraint(equalTo: frontHandlerView.trailingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: backHandlerView.leadingAnchor),
            bottomLineView.bottomAnchor.constraint(equalTo: frontHandlerView.bottomAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: UIConstants.borderViewThickness),
        ])
        frontHandlerView.applyCornerRadus(of: UIConstants.handlerViewCornerRadius, toCorners: [.layerMinXMaxYCorner, .layerMinXMinYCorner], bgColor: UIConstants.handlerViewColor ?? .clear)
        backHandlerView.applyCornerRadus(of: UIConstants.handlerViewCornerRadius, toCorners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner], bgColor: UIConstants.handlerViewColor ?? .clear)
        
        should(enableTrimming: false)
        addUIForAudioTrack(totalDuration: totalDurationInCMTime)
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+1){
//            self.backgroundColor = .yellow
//            self.shapesScrollView.backgroundColor = .purple
//        }
    }
    
    
    private func should(enableTrimming: Bool) {
        frontHandlerView.isHidden = !enableTrimming
        backHandlerView.isHidden = !enableTrimming
        topLineView.isHidden = !enableTrimming
        bottomLineView.isHidden = !enableTrimming
                
        if shouldShowHandlersOutsideOfView{
            if enableTrimming{
                frontMaskAssistView.isHidden = false
                backMaskAssistView.isHidden = false
            }else{
                guard let frontMaskViewWidthConstraint = frontMaskViewWidthConstraint,
                      let backMaskViewWidthConstraint = backMaskViewWidthConstraint else {return}
                
                frontMaskAssistView.isHidden = (frontMaskViewWidthConstraint.constant == 0)
                backMaskAssistView.isHidden = (backMaskViewWidthConstraint.constant == 0)
            }
        }else{
            frontMaskAssistView.isHidden = !enableTrimming
            backMaskAssistView.isHidden = !enableTrimming
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !bounds.width.isNaN{

            thumbnailHolderLeadingAnchor?.constant =  shouldShowHandlersOutsideOfView ? (bounds.width/2 - UIConstants.handlerViewWidth) : (bounds.width/2)
            thumbnailHolderTrailingAnchor?.constant = shouldShowHandlersOutsideOfView ? -(bounds.width/2 - UIConstants.handlerViewWidth) : -(bounds.width/2)
        }
        contOffAtRotation = nil
    }
    
    @objc private func thumbnailTapped(_ sender: UITapGestureRecognizer) {
        viewModel.thumbnailTapped()
    }
    
    private var audioTrackViewModel: AudioViewModelProtocol? = nil
    
    private func addUIForAudioTrack(totalDuration: CMTime){
//        setNeedsLayout()
//        layoutIfNeeded()
//        let model = AudioViewModel(annotationVMDelegate: viewModel, totalWidthOfScrollView: contentSize.width, totalDurationOfVideo: totalDuration)
        
        let model = AudioRowViewModel(annotationVMDelegate: viewModel, totalDurationOfVideo: totalDuration)
                
        let shapeRowView = AudioTrackRowView(viewModel: model)

        let audioRowViewBGColor = AnnotationEditorViewColors.audioRowViewBGColor
        shapeRowView.backgroundColor = QuartzKit.shared.primaryColor?.withAlphaComponent(0.1) ?? audioRowViewBGColor
        shapeRowView.translatesAutoresizingMaskIntoConstraints = false
        shapesHolderStackView.addArrangedSubview(shapeRowView)
        
        NSLayoutConstraint.activate([
            shapeRowView.heightAnchor.constraint(equalToConstant: UIConstants.audioRowViewHeight),
            shapeRowView.widthAnchor.constraint(equalTo: shapesHolderStackView.widthAnchor)
            
        ])
        self.audioTrackViewModel = model
    }

    
    private func updateCurrentlyRecordingViewUI(withXOffset xOffset: CGFloat){
        audioTrackViewModel?.updateView(xOffset: xOffset)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        frontHandlerView.applyCornerRadus(of: UIConstants.handlerViewCornerRadius, toCorners: [.layerMinXMaxYCorner, .layerMinXMinYCorner], bgColor: UIConstants.handlerViewColor ?? .clear)
        backHandlerView.applyCornerRadus(of: UIConstants.handlerViewCornerRadius, toCorners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner], bgColor: UIConstants.handlerViewColor ?? .clear)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension VideoThumbnailView: VideoThumbnailViewProtocol{
    
    func autoScrollTo(time: CMTime, totalPlaybackDuration: CMTime, isRecordingInProgress: Bool) {
        let totalWidth = thumbnailHolderView.bounds.width
        let timeInFloat = round(CMTimeGetSeconds(time) * 100) / 100.0
        let totalTimeInFloat = round(CMTimeGetSeconds(totalPlaybackDuration) * 100) / 100.0
        
        let targetX = totalWidth * timeInFloat / totalTimeInFloat
        isAutoScroll = true
        let animationDuration = abs(targetX - contentOffset.x) > 100 ? 0.3 : 0.1
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.allowUserInteraction,.beginFromCurrentState]) {
            self.contentOffset = CGPoint(x: targetX, y: 0)
        }completion: {[weak self] _ in
            self?.isAutoScroll = false
        }        
        if isRecordingInProgress{
            updateCurrentlyRecordingViewUI(withXOffset: targetX)
        }
    }
    
    func addShape(withDetails details: AddedShapeDetails, currentTime: CMTime, totalPlaybackDuration: CMTime) -> ShapeRowViewProtocol {
        let totalPlayBackTimeInSec = CMTimeGetSeconds(totalPlaybackDuration)
        let totalWidthOfView = thumbnailHolderView.bounds.width
        let shapeStartimeInSec = CMTimeGetSeconds(details.startTime)
        let shapeEndTimeInSec = CMTimeGetSeconds(details.endTime)
        let xEnd = totalWidthOfView * shapeEndTimeInSec / totalPlayBackTimeInSec
        let xStart = totalWidthOfView * shapeStartimeInSec / totalPlayBackTimeInSec
        
        
        let model = ShapeRowViewModel(shapeDetail: details, xOffset: xStart, width: (xEnd - xStart), isSelected: true)
        let shapeRowView = ShapeRowView(model: model)
        shapeRowView.shapeSizeUpdationDelegate = viewModel
        shapeRowView.scrollDelegate = self
        shapeRowView.translatesAutoresizingMaskIntoConstraints = false
        shapesHolderStackView.addArrangedSubview(shapeRowView)
        
        
        NSLayoutConstraint.activate([
            shapeRowView.heightAnchor.constraint(equalToConstant: UIConstants.shapeRowViewHeight),
            shapeRowView.widthAnchor.constraint(equalTo: shapesHolderStackView.widthAnchor)
        ])
        
        setNeedsLayout()
        layoutIfNeeded()
        
        let yPoint = shapesScrollView.contentSize.height - shapesScrollView.bounds.height + shapesScrollView.contentInset.bottom
        if yPoint > 0 {
            let bottomOffset = CGPoint(x: 0, y: yPoint)
            shapesScrollView.setContentOffset(bottomOffset, animated: true)
        }
        return shapeRowView
    }
    
    func scrollTo(_ view: ShapeRowViewProtocol){
        let isCurrentlyVisible = view.frame.origin.y >= shapesScrollView.contentOffset.y &&
        view.frame.origin.y + view.frame.size.height <= shapesScrollView.contentOffset.y + shapesScrollView.bounds.height
        if !isCurrentlyVisible{
            var yOffset = view.frame.origin.y
            if yOffset + shapesScrollView.bounds.height > shapesScrollView.contentSize.height {
                yOffset = shapesScrollView.contentSize.height - shapesScrollView.bounds.height
            }
            shapesScrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
        }
    }
    
    func scrollToTime(_ time: CMTime, totalDuration: CMTime) {
        let requiredOffset = thumbnailHolderView.bounds.width * CMTimeGetSeconds(time) / CMTimeGetSeconds(totalDuration)
        UIView.animate(withDuration: 0.2) {
            self.contentOffset = CGPoint(x: requiredOffset , y: 0)
        }
    }
    
    func getViewForRowAddition() -> UIStackView {
        shapesHolderStackView
    }
    
    func enableVideoTrimming() {
        should(enableTrimming: true)
    }
    
    func disableVideoTrimming() {
        should(enableTrimming: false)
    }
    
    func resetVideoTrimmingViews() {
        frontMaskViewWidthConstraint?.constant = 0
        backMaskViewWidthConstraint?.constant = 0
    }
    
    func audioRecordingStarted(at startTime: CMTime){
        isUserInteractionEnabled = false
        audioTrackViewModel?.recordingStarted(at: startTime, xOffset: contentOffset.x)
    }
    
    func audioRecordingEnded(){
        isUserInteractionEnabled = true
    }
    
    func getFontAndBackMaskViewWidthConstants() -> (CGFloat,CGFloat)? {
        guard let frontMaskViewWidthConstraintConstant = frontMaskViewWidthConstraint?.constant,
              let backMaskViewWidthConstraintConstant = backMaskViewWidthConstraint?.constant else {return nil}
        return (frontMaskViewWidthConstraintConstant, backMaskViewWidthConstraintConstant)
    }
    
    private func updateUIOfFrontAndBackAssitView(){
        guard shouldShowHandlersOutsideOfView else {return}
        if let frontMaskViewWidthConstraint = frontMaskViewWidthConstraint{
            frontMaskAssistView.isHidden = frontMaskViewWidthConstraint.constant == 0
        }
        
        if let backMaskViewWidthConstraint = backMaskViewWidthConstraint{
            backMaskAssistView.isHidden = backMaskViewWidthConstraint.constant == 0
        }
    }
}



extension VideoThumbnailView: UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isAutoScroll = false
        viewModel.scrollViewBeganScrolling()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let contOffAtRotation = contOffAtRotation {
            self.setContentOffset(contOffAtRotation, animated: false)
            self.contOffAtRotation = nil
            setNeedsLayout()
            layoutIfNeeded()
        }
        if isAutoScroll == false{
            viewModel.scrollViewScrolling(withOffSet: scrollView.contentOffset, withReferenceWidth: thumbnailHolderView.bounds.width)
        }
        if shouldShowHandlersOutsideOfView{
            if scrollView.contentOffset.x < 0 {
                scrollView.contentOffset.x = 0
            }
            if scrollView.contentOffset.x + scrollView.frame.size.width > scrollView.contentSize.width{
                scrollView.contentOffset.x = scrollView.contentSize.width - scrollView.frame.size.width
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            viewModel.scrollViewEndScrolling(withOffSet: scrollView.contentOffset, withReferenceWidth: thumbnailHolderView.bounds.width)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.scrollViewEndScrolling(withOffSet: scrollView.contentOffset, withReferenceWidth: thumbnailHolderView.bounds.width)
    }
}

extension VideoThumbnailView: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panGestureRecognizer, ((otherGestureRecognizer.view as? HandlerView) != nil){
            return true
        }
        return false
    }
}

extension VideoThumbnailView: HandlerViewDelegate{
    func shouldStartPan(_ newCenter: CGPoint, withOldCenter oldCenter: CGPoint) -> Bool {
        true
    }
    
    func allowPan(_ newCenter: CGPoint, withOldCenter oldCenter: CGPoint) -> Bool {
        viewModel.trimmingStarted()
        if oldCenter == frontHandlerView.center {
            if shouldShowHandlersOutsideOfView{
                return newCenter.x + UIConstants.handlerViewWidth + minWidthOfVideo < backHandlerView.center.x
            }else{
                return newCenter.x - UIConstants.handlerViewWidth + minWidthOfVideo < backHandlerView.center.x
            }
        }else{
            if shouldShowHandlersOutsideOfView{
                return newCenter.x - UIConstants.handlerViewWidth - minWidthOfVideo > frontHandlerView.center.x
            }else{
                return newCenter.x + UIConstants.handlerViewWidth - minWidthOfVideo > frontHandlerView.center.x
            }
        }
    }
        
    func panAction(_ newCenter: CGPoint, withOldCenter oldCenter: CGPoint, velocity: CGFloat) {
//        invalidateTimer()
        var timeOffset: CGFloat = 0
        isLeftHandlerAction = (frontHandlerView.center == oldCenter)
        let canAutoScrollToRight = velocity > 0
        let canAutoScrollToLeft = velocity < 0

        if frontHandlerView.center == oldCenter { // Panning on Left Handler
            let diff = newCenter.x - oldCenter.x
            let existingWidthConstant = frontMaskViewWidthConstraint?.constant ?? 0
            let frontMaskViewWidthConstant: CGFloat = existingWidthConstant + diff
            if frontMaskViewWidthConstant >= 0 {
                frontMaskViewWidthConstraint?.constant = frontMaskViewWidthConstant
            }
            let padDelta: CGFloat = contentSize.width * frontHandlerAutoScrollingDelta // Amt by which view is scrolled before reaching end border
            if (frontMaskViewWidthConstant - padDelta) < (contentOffset.x - (frame.size.width / 2.0) ) { // Left Handler view scrolled to Left
                if canAutoScrollToLeft{
                    if self.frontHandlerLeftSideAutoScrollTimer == nil{
                        let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(frontHandlerAutoScrollToLeft), userInfo: nil, repeats: true)
                        self.frontHandlerLeftSideAutoScrollTimer = timer
                        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
                    }
                }else{
                    invalidateTimer()
                }
            }else if (frontMaskViewWidthConstant + padDelta) > (contentOffset.x + (frame.size.width / 2.0) ) { // Left Handler view scrolled to Right
                if canAutoScrollToRight{
                    if self.frontHandlerRightSideAutoScrollTimer == nil{
                        let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(frontHandlerAutoScrollToRight), userInfo: nil, repeats: true)
                        self.frontHandlerRightSideAutoScrollTimer = timer
                        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
                    }
                }else{
                    invalidateTimer()
                }
            }
            timeOffset = shouldShowHandlersOutsideOfView ? (frontHandlerView.frame.origin.x + frontHandlerView.frame.size.width) : (frontHandlerView.frame.origin.x)
            
        }else{
            let diff = oldCenter.x - newCenter.x
            let existingWidthConstant = backMaskViewWidthConstraint?.constant ?? 0
            let backMaskViewWidthConstant: CGFloat = existingWidthConstant + diff
            if backMaskViewWidthConstant >= 0 {
                backMaskViewWidthConstraint?.constant = backMaskViewWidthConstant
            }
                        
            let padDelta: CGFloat = contentSize.width * backHandlerAutoScrollingDelta // Amt by which view is scrolled before reaching end border
            
            if (backMaskView.frame.origin.x + padDelta) > (contentOffset.x + (frame.size.width / 2.0) ){  // Right Handler view scrolled to Right
                if canAutoScrollToRight{
                    if self.backHandlerRightSideAutoScrollTimer == nil{
                        let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(backHandlerAutoScrollToRight), userInfo: nil, repeats: true)
                        self.backHandlerRightSideAutoScrollTimer = timer
                        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
                    }
                }else{
                    invalidateTimer()
                }
            } else if (backMaskView.frame.origin.x - padDelta) < (contentOffset.x - (frame.size.width / 2.0) ) { // Right Handler view scrolled to Left
                if canAutoScrollToLeft{
                    if self.backHandlerLeftSideAutoScrollTimer == nil{
                        let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(backHandlerAutoScrollToLeft), userInfo: nil, repeats: true)
                        self.backHandlerLeftSideAutoScrollTimer = timer
                        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
                    }
                }else{
                    invalidateTimer()
                }
            }
            timeOffset = shouldShowHandlersOutsideOfView ? (backHandlerView.frame.origin.x) : (backHandlerView.frame.origin.x + backHandlerView.frame.size.width)
        }

        viewModel.trimInProgress(atOffset: timeOffset, totalWidth: thumbnailHolderView.frame.width)
    }
    
    func panEnded() {
        invalidateTimer()
        let startPt = shouldShowHandlersOutsideOfView ? (frontHandlerView.frame.origin.x + frontHandlerView.frame.size.width) : frontHandlerView.frame.origin.x
        let endPt = shouldShowHandlersOutsideOfView ? (backHandlerView.frame.origin.x) : (backHandlerView.frame.origin.x + backHandlerView.frame.size.width)
    
        viewModel.trimVideo(withTotalContentWidth: thumbnailHolderView.frame.width,
                            startPoint: startPt,
                            endPoint: endPt,
                            isStartTimeChanged: isLeftHandlerAction)
    }
    
    func updateTheVideoTrimmingTo(startTime: CMTime, endTime: CMTime, totalDuration: CMTime) {
        let frontHandlerX =  thumbnailHolderView.frame.width * CMTimeGetSeconds(startTime) / CMTimeGetSeconds(totalDuration)
        frontMaskViewWidthConstraint?.constant = frontHandlerX
        
        let backHandlerX =  thumbnailHolderView.frame.width - thumbnailHolderView.frame.width * CMTimeGetSeconds(endTime) / CMTimeGetSeconds(totalDuration)
        backMaskViewWidthConstraint?.constant = backHandlerX
        
        restrictScroll(from: startTime, to: endTime, totalDuration: totalDuration)
    }
    
    func adjustScrollBasedOn(startTime: CMTime, endTime: CMTime, totalDuration: CMTime){
        restrictScroll(from: startTime, to: endTime, totalDuration: totalDuration)
    }
    
    private func restrictScroll(from: CMTime, to: CMTime, totalDuration: CMTime){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
            let leadingPadding = self.thumbnailHolderView.bounds.size.width * CMTimeGetSeconds(from) / CMTimeGetSeconds(totalDuration)
            let trailingPadding = self.thumbnailHolderView.bounds.size.width - (self.thumbnailHolderView.bounds.size.width * CMTimeGetSeconds(to) / CMTimeGetSeconds(totalDuration))
            self.contentInset = UIEdgeInsets(top: 0, left: -leadingPadding, bottom: 0, right: -trailingPadding)
        }
    }
}

extension VideoThumbnailView: ShapeRowViewScrollingDelete{
    func getParentScrollView() -> UIScrollView {
        return self
    }
}

extension VideoThumbnailView{
    
    @objc private func frontHandlerAutoScrollToLeft(){
        let diff: CGFloat = contentSize.width * 0.01 // Amt by which view is auto scrolled (1%)
        let contentOffset = contentOffset
        let existingPaddingConstant = frontMaskViewWidthConstraint?.constant ?? 0
        var xOffset = contentOffset.x - diff
        var leadPadding: CGFloat = existingPaddingConstant - diff
        
        if xOffset > (frame.size.width / 2.0) {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                self.frontMaskViewWidthConstraint?.constant = leadPadding
                self.setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: false)
                self.layoutIfNeeded()
            }
        }else{
            let padDelta: CGFloat = contentSize.width * frontHandlerAutoScrollingDelta // Keep it same as the value that is there while starting auto scroll
            xOffset = (frame.size.width / 2.0) - padDelta
            leadPadding = 0
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                self.frontMaskViewWidthConstraint?.constant = leadPadding
                self.setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: false)
                self.layoutIfNeeded()
            }
            invalidateTimer()
        }
    }
    
    @objc private func frontHandlerAutoScrollToRight(){
        let diff: CGFloat = contentSize.width * 0.01 // Amt by which view is auto scrolled (1%)
        let contentOffset = contentOffset
        let existingPaddingConstant = frontMaskViewWidthConstraint?.constant ?? 0
        let xOffset = contentOffset.x + diff
        let leadPadding: CGFloat = existingPaddingConstant + diff

        if (leadPadding + UIConstants.handlerViewWidth) < (backHandlerView.frame.origin.x) {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                self.frontMaskViewWidthConstraint?.constant = leadPadding
                self.setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: false)
                self.layoutIfNeeded()
            }
        }else{
            invalidateTimer()
        }
    }
    
    @objc private func backHandlerAutoScrollToRight(){
        let diff: CGFloat = contentSize.width * 0.01 // Amt by which view is auto scrolled (1%)
        let contentOffset = contentOffset
        let existingPaddingConstant = backMaskViewWidthConstraint?.constant ?? 0
        var xOffset = contentOffset.x + diff
        var trailPadding: CGFloat = existingPaddingConstant - diff
        if xOffset < (contentSize.width - 1.5*frame.width){
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                self.backMaskViewWidthConstraint?.constant = trailPadding
                self.setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: false)
                self.layoutIfNeeded()
            }
        }else{
            let padDelta: CGFloat = contentSize.width * backHandlerAutoScrollingDelta // Keep it same as the value that is there while starting auto scroll
            xOffset = contentSize.width - 1.5*frame.width + padDelta
            trailPadding = 0
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                self.backMaskViewWidthConstraint?.constant = trailPadding
                self.setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: false)
                self.layoutIfNeeded()
            }
            invalidateTimer()
        }
    }
    
    @objc private func backHandlerAutoScrollToLeft(){
        let diff: CGFloat = contentSize.width * 0.01 // Amt by which view is auto scrolled (1%)
        let contentOffset = contentOffset
        let existingPaddingConstant = backMaskViewWidthConstraint?.constant ?? 0
        let xOffset = contentOffset.x - diff
        let trailPadding: CGFloat = existingPaddingConstant + diff
        let trailPaddingFromFront = contentSize.width - (existingPaddingConstant + diff) - frame.size.width

        if trailPaddingFromFront > (frontHandlerView.frame.origin.x + UIConstants.handlerViewWidth) {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                self.backMaskViewWidthConstraint?.constant = trailPadding
                self.setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: false)
                self.layoutIfNeeded()
            }
        }else{
            invalidateTimer()
        }
    }
    
    private func invalidateTimer(){
        frontHandlerLeftSideAutoScrollTimer?.invalidate()
        frontHandlerLeftSideAutoScrollTimer = nil
        
        frontHandlerRightSideAutoScrollTimer?.invalidate()
        frontHandlerRightSideAutoScrollTimer = nil
        
        backHandlerLeftSideAutoScrollTimer?.invalidate()
        backHandlerLeftSideAutoScrollTimer = nil
        
        backHandlerRightSideAutoScrollTimer?.invalidate()
        backHandlerRightSideAutoScrollTimer = nil
    }
}
