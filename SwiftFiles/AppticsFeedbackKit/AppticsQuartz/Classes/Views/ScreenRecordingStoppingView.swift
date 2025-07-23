//
//  ScreenRecordingStoppingView.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 15/12/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import UIKit

public protocol ScreenRecordingStoppingDelegate: AnyObject{
    func osScreenRecordingStartedWhileQuartzRecordingInProgress()
    func stopScreenRecording(isRecordingFailed: Bool)
    func screenRecordingStartedByQuartz()
}

class QuartzRecordingTimeNotifier {
    
    static let shared = QuartzRecordingTimeNotifier()
    private let totalAllowedRecordingSeconds = 5 * 60 // 5 Minutes
    
    var delegate: ScreenRecordingStoppingDelegate? = nil
    let screenRecordingStoppingNotification = Notification.Name("ScreenRecordingStopActionExecuted")
    
    private var sourceWindow : UIWindow? = nil
    private var currentRemainingSecondsOfRecording: Int
    private var timer: Timer? = nil
    
    private init() {
        currentRemainingSecondsOfRecording = totalAllowedRecordingSeconds
    }
    
    private lazy var recordingStoppingView: RecordingStoppingView = {
        let recordingStoppingView = RecordingStoppingView()
        recordingStoppingView.delegate = self
        return recordingStoppingView
    }()
    
    private func removeAllObserverFromSelf(){
        NotificationCenter.default.removeObserver(self)
    }
    
    func configure(inWindow window: UIWindow) {
        self.removeAllObserverFromSelf()
        sourceWindow = window
        currentRemainingSecondsOfRecording = totalAllowedRecordingSeconds
        let widthOfRecordingStoppingView: CGFloat = 90
        let heightOfRecordingStoppingView: CGFloat = 40
        
        let initialXOffset: CGFloat = 40
        let initialYOffset: CGFloat = 80
        
        let recordingStoppingViewFrame = CGRect(x: window.frame.size.width - widthOfRecordingStoppingView - initialXOffset, y: initialYOffset, width: widthOfRecordingStoppingView, height: heightOfRecordingStoppingView)
        
        recordingStoppingView.frame = recordingStoppingViewFrame
        recordingStoppingView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        window.addSubviews(recordingStoppingView)
        
        updateRecordingStoppingViewTextUI()

        let uiUpdatingTimer = Timer(timeInterval: 1, target: self, selector: #selector(updateRecordingStoppingViewTextUI), userInfo: nil, repeats: true)
        RunLoop.main.add(uiUpdatingTimer, forMode: RunLoop.Mode.common)
        
        timer = uiUpdatingTimer
    }
    
    @objc private func updateRecordingStoppingViewTextUI(){
        if UIApplication.shared.applicationState == .background{return}
        if currentRemainingSecondsOfRecording == 0 {
            //Stop Recording
            stopClicked()
            return
        }
        currentRemainingSecondsOfRecording -= 1
        sourceWindow?.bringSubviewsToFront(recordingStoppingView)
        
        let min = String(format: "%02d", currentRemainingSecondsOfRecording / 60)
        let sec = String(format: "%02d", currentRemainingSecondsOfRecording % 60)
        recordingStoppingView.timeStr = "\(min) : \(sec)"
    }
    
    private func removeRecordingStoppingView(){
        recordingStoppingView.removeFromSuperview()
    }
    
    deinit {
        self.removeAllObserverFromSelf()
    }
}

extension QuartzRecordingTimeNotifier: RecordingStoppingViewDelegate{
    func stopClicked(isRecordingFailed: Bool = false){
        postScreenRecordingStoppingNotification()
        timer?.invalidate()
        recordingStoppingView.removeFromSuperview()
        DispatchQueue.main.asyncAfter(deadline:.now()+0.1){
            self.delegate?.stopScreenRecording(isRecordingFailed: isRecordingFailed)
        }
    }
    
    func osScreenRecordingStartedWhileQuartzRecordingInprogress(){
        UserDefaults.standard.setValue(false, forKey: ScreenRecorder.isScreenRecordingStartedByQuartz) // Set while starting screen recording

        postScreenRecordingStoppingNotification()
        timer?.invalidate()
        recordingStoppingView.removeFromSuperview()
        delegate?.osScreenRecordingStartedWhileQuartzRecordingInProgress()
    }
    
    private func postScreenRecordingStoppingNotification(){
        NotificationCenter.default.post(name:screenRecordingStoppingNotification, object: nil)
    }
}

protocol RecordingStoppingViewDelegate: AnyObject{
    func stopClicked(isRecordingFailed: Bool)
}

class RecordingStoppingView: UIView{
    
    weak var delegate: RecordingStoppingViewDelegate? = nil
    var timeStr: String = "" {
        didSet{
            updateLabelText()
        }
    }
    
    private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
    
    private lazy var timeIndicatingLabel: UILabel = {
        let timeIndicatingLabel = UILabel()
        timeIndicatingLabel.font = UIFont.systemFont(ofSize: 13)
        timeIndicatingLabel.textColor = RecordingStoppinViewColors.screenRecordingStoppingViewTextColor
        timeIndicatingLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeIndicatingLabel
    }()

    private lazy var stopImgContainerView: UIView = {
        let stopImgContainerView = UIView()
        stopImgContainerView.translatesAutoresizingMaskIntoConstraints = false
        return stopImgContainerView
    }()
    
    private lazy var stopImageView: UIImageView = {
        let stopImageView = UIImageView()
        stopImageView.image = UIImage(systemName: "square.fill")
        stopImageView.tintColor = RecordingStoppinViewColors.screenRecordingStoppingViewTextColor
        stopImageView.translatesAutoresizingMaskIntoConstraints = false
        stopImageView.isUserInteractionEnabled = false
        stopImageView.contentMode = .scaleAspectFit
        return stopImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(frame.size.width, frame.size.height) / 2.0
        if #available(iOS 13.0, *) {
            layer.borderColor = RecordingStoppinViewColors.screenRecordingStoppingViewBorderColor.cgColor
        }
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let superview = self.superview else { return }
        let translation = gestureRecognizer.translation(in: superview)
        let newFrameX = min(max(0, frame.origin.x + translation.x), (superview.frame.size.width - frame.size.width) )
        let newFrameY = min(max(0, frame.origin.y + translation.y), (superview.frame.size.height - frame.size.height) )
        
        frame = CGRectMake(newFrameX, newFrameY, frame.size.width, frame.size.height)
        gestureRecognizer.setTranslation(.zero, in: superview)
    }
    
    private func configure(){
        
        addSubviews(timeIndicatingLabel,stopImgContainerView)
        stopImgContainerView.addSubview(stopImageView)
        backgroundColor = RecordingStoppinViewColors.screenRecordingStoppingViewBGColor
        
        layer.borderWidth = 1
        
        let widthOfStoppingImgView: CGFloat = 20
        
        let leadingPaddingOfTimeIndicationLabel: CGFloat = 12
        let topPaddingOfTimeIndicationLabel: CGFloat = 10
        let botoomPaddingOfTimeIndicationLabel: CGFloat = 10
        let trailingPadding: CGFloat = 12
        
        let leadingPaddingOfTimeLabel: CGFloat = 7
        NSLayoutConstraint.activate([
            timeIndicatingLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: leadingPaddingOfTimeIndicationLabel),
            timeIndicatingLabel.topAnchor.constraint(equalTo: topAnchor, constant: topPaddingOfTimeIndicationLabel),
            timeIndicatingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -botoomPaddingOfTimeIndicationLabel),
            timeIndicatingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stopImgContainerView.leadingAnchor.constraint(equalTo: timeIndicatingLabel.trailingAnchor, constant: 5),
            stopImgContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stopImgContainerView.topAnchor.constraint(equalTo: topAnchor),
            stopImgContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stopImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingPadding),
            stopImageView.centerYAnchor.constraint(equalTo: stopImgContainerView.centerYAnchor),
            stopImageView.widthAnchor.constraint(equalToConstant: 16),
            stopImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        updateLabelText()
        stopImgContainerView.addGestureRecognizer(tapGesture)
        addGestureRecognizer(panGesture)
    }
    
    private func updateLabelText(){
        timeIndicatingLabel.text = timeStr
    }
    
    @objc func tapped(){
        delegate?.stopClicked(isRecordingFailed: false)
    }
}
