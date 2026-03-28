//
//  IssueRecordingView.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 18/11/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import UIKit

protocol IssueRecordingViewDelegate: AnyObject{
    func startRecording()
    func endRecording()
    func showDataCollectionMessage()
    func notConnectedToInternet()
}

struct IssueRecordingViewDataSource{
    let screenRecordingInfoText = QuartzKitStrings.localized("issuerecordscreen.label.recordinginfo")
    let iAgreeText = QuartzKitStrings.localized("issuerecordscreen.label.iagreetext")
    let optionToTrimText = QuartzKitStrings.localized("issuerecordscreen.label.optiontotrim")
    let startRecordingButtonText = QuartzKitStrings.localized("issuerecordscreen.label.startrecording")
    let endRecordingButtonText = QuartzKitStrings.localized("issuerecordscreen.label.endrecording")
    let recordingInProgressText = QuartzKitStrings.localized("issuerecordscreen.label.recordinginprogress")
}


class IssueRecordingView: UIView, UITextViewDelegate{
    let txtDataSource: IssueRecordingViewDataSource = IssueRecordingViewDataSource()
    
    weak var delegate: IssueRecordingViewDelegate?
    
    private let viewDetailsText = "viewDetailsTapped"
    
    private let startRecordingButtonEnabledBGColor = QuartzKit.shared.primaryColor ?? IssueRecordingViewColors.startRecordingButtonEnabledBgColor
    private let startRecordingButtonEnabledTextColor = QuartzKit.shared.colorOnPrimaryColor ?? IssueRecordingViewColors.startRecordingButtonEnabledTxtColor
    private let startRecordingButtonDisabledBGColor = IssueRecordingViewColors.startRecordingButtonDisabledBgColor
    private let startRecordingButtonDisabledTextColor = IssueRecordingViewColors.startRecordingButtonDisabledTxtColor
    private var issueRecordingImg: UIImage?
    private var helpDocUrlStr: String?
    
    private lazy var screenRecordingImageView: UIImageView = {
        let screenRecordingImageView = UIImageView()
        if let issueRecordingImg = issueRecordingImg {
            screenRecordingImageView.image = issueRecordingImg
        }else{
            let img = UIImage.named("screen_recording")
            screenRecordingImageView.image = img
        }
        screenRecordingImageView.translatesAutoresizingMaskIntoConstraints = false
        screenRecordingImageView.contentMode = .scaleAspectFit
        return screenRecordingImageView
    }()
    
    private lazy var screenRecordingInfoLabel: UILabel = {
        let screenRecordingInfoLabel = UILabel()
        screenRecordingInfoLabel.textColor = IssueRecordingViewColors.quicklyRecordIssueLabelTextColor
        screenRecordingInfoLabel.numberOfLines = 3
        screenRecordingInfoLabel.textAlignment = .center
        //        screenRecordingInfoLabel.backgroundColor = .gray
        screenRecordingInfoLabel.font = UIFont.systemFont(ofSize: 14)
        screenRecordingInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        return screenRecordingInfoLabel
    }()
    
    private lazy var recordingInProgressLabel: UILabel = {
        let recordingInProgressLabel = UILabel()
        recordingInProgressLabel.textColor = UIColor.label.withAlphaComponent(0.7)
        recordingInProgressLabel.numberOfLines = 1
        recordingInProgressLabel.textAlignment = .center
        recordingInProgressLabel.font = UIFont.systemFont(ofSize: 14)
        recordingInProgressLabel.translatesAutoresizingMaskIntoConstraints = false
        return recordingInProgressLabel
    }()
    
    private lazy var trimOptionLabel: UILabel = {
        let trimOptionLabel = UILabel()
        trimOptionLabel.numberOfLines = 2
        trimOptionLabel.textAlignment = .center
        trimOptionLabel.textColor = UIColor.label.withAlphaComponent(0.7)
        trimOptionLabel.backgroundColor = IssueRecordingViewColors.quickTipsViewBGColor
        trimOptionLabel.layer.cornerRadius = 10.0
        trimOptionLabel.layer.masksToBounds = true
        trimOptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return trimOptionLabel
    }()
    
    
    private lazy var iAgreeSwitch: UISwitch = {
        let iAgreeSwitch = UISwitch()
        iAgreeSwitch.translatesAutoresizingMaskIntoConstraints = false
        iAgreeSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        iAgreeSwitch.onTintColor = QuartzKit.shared.switchOnTintColor ?? IssueRecordingViewColors.viewDetailsLabelColor
        return iAgreeSwitch
    }()
    
    private lazy var startRecordingButton: UIButton = {
        let startRecordingButton = UIButton()
        startRecordingButton.translatesAutoresizingMaskIntoConstraints = false
        startRecordingButton.addTarget(self, action: #selector(startRecording), for: .touchUpInside)
        if #available(iOS 13.0, *) {
            let img = UIImage.init(systemName: "record.circle")?.withRenderingMode(.alwaysTemplate)
            startRecordingButton.setImage(img, for: .normal)
            startRecordingButton.setImage(img, for: .disabled)
            startRecordingButton.setImage(img, for: .highlighted)
            startRecordingButton.tintColor = startRecordingButtonDisabledTextColor
        } else {
            // Fallback on earlier versions
        }
        startRecordingButton.isEnabled = false
        startRecordingButton.setTitleColor(startRecordingButtonDisabledTextColor, for: .disabled)
        startRecordingButton.setTitleColor(startRecordingButtonEnabledTextColor, for: .normal)
        startRecordingButton.setTitleColor(startRecordingButtonEnabledTextColor, for: .highlighted)
        startRecordingButton.setTitleColor(startRecordingButtonEnabledTextColor, for: .selected)
        
        startRecordingButton.backgroundColor = startRecordingButtonDisabledBGColor
        startRecordingButton.layer.cornerRadius = 25
        startRecordingButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        startRecordingButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: -10, bottom: 5, right: 5)
        return startRecordingButton
    }()
    
    private lazy var endRecordingButton: UIButton = {
        let endRecordingButton = UIButton()
        endRecordingButton.translatesAutoresizingMaskIntoConstraints = false
        endRecordingButton.addTarget(self, action: #selector(endRecording), for: .touchUpInside)
        if #available(iOS 13.0, *) {
            let img = UIImage.init(systemName: "stop.fill")?.withRenderingMode(.alwaysTemplate)
            endRecordingButton.setImage(img, for: .normal)
            endRecordingButton.setImage(img, for: .disabled)
            endRecordingButton.tintColor = UIColor(red: 116.0/255.0, green: 121.0/255.0, blue: 138.0/255.0, alpha: 1)
        } else {
            // Fallback on earlier versions
        }
        
        endRecordingButton.setTitleColor(UIColor.white, for: .normal)
        endRecordingButton.tintColor = UIColor.white
        endRecordingButton.backgroundColor = UIColor.systemRed
        endRecordingButton.layer.cornerRadius = 25
        endRecordingButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        endRecordingButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: -10, bottom: 5, right: 5)
        return endRecordingButton
    }()
    
    
    private lazy var beforeStartingRecordingContainerView: UIView = {
        let beforeStartingRecordingContainerView = UIView()
        beforeStartingRecordingContainerView.translatesAutoresizingMaskIntoConstraints = false
        return beforeStartingRecordingContainerView
    }()
    
    private lazy var afterStartingRecordingContainerView: UIView = {
        let afterStartingRecordingContainerView = UIView()
        afterStartingRecordingContainerView.translatesAutoresizingMaskIntoConstraints = false
        return afterStartingRecordingContainerView
    }()
    
    private lazy var iAgreeTxtView: SelectionDisabledTextView = {
        let iAgreeTxtView = SelectionDisabledTextView()
        iAgreeTxtView.delegate = self
        iAgreeTxtView.textAlignment = .center
        iAgreeTxtView.translatesAutoresizingMaskIntoConstraints = false
        iAgreeTxtView.backgroundColor = .clear
        iAgreeTxtView.isScrollEnabled = false
        iAgreeTxtView.isUserInteractionEnabled = true
        iAgreeTxtView.isEditable = false
        iAgreeTxtView.textContainer.maximumNumberOfLines = 3
        iAgreeTxtView.textContainer.lineBreakMode = .byTruncatingTail
        iAgreeTxtView.textColor = IssueRecordingViewColors.iAgreeLabelColor
        return iAgreeTxtView
    }()
    
    private lazy var quickTipsView: QuickTipsView = {
        let quickTipsView = QuickTipsView(helpDocRefUrlStr: helpDocUrlStr)
        quickTipsView.translatesAutoresizingMaskIntoConstraints = false
        return quickTipsView
    }()
    
    init(withIssueRecordingImg img: UIImage?, helpDocRefUrlStr: String?) {
        super.init(frame: .zero)
        issueRecordingImg = img
        helpDocUrlStr = helpDocRefUrlStr
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange) -> Bool {
        if url.absoluteString == viewDetailsText {
            self.delegate?.showDataCollectionMessage()
            return false
        }
        return true
    }
    
    private func configureViewForNoRecordingInProgressState(){
        addSubviews(beforeStartingRecordingContainerView)
        beforeStartingRecordingContainerView.addSubviews(screenRecordingInfoLabel, iAgreeSwitch, iAgreeTxtView, startRecordingButton)
        
        screenRecordingInfoLabel.text = txtDataSource.screenRecordingInfoText
        iAgreeTxtView.text = txtDataSource.iAgreeText
        startRecordingButton.setTitle(txtDataSource.startRecordingButtonText, for: .normal)
        var learnMoreText: String? = nil
        if txtDataSource.iAgreeText.components(separatedBy: ".").count > 1{
            learnMoreText = txtDataSource.iAgreeText.components(separatedBy: ".").last
        }else{
            let compSeperatedBySpace =  txtDataSource.iAgreeText.components(separatedBy: " ")
            if compSeperatedBySpace.count > 2{
                learnMoreText = "\(compSeperatedBySpace[compSeperatedBySpace.count-2]) \(compSeperatedBySpace[compSeperatedBySpace.count-1])"
            }
        }
        if let learnMoreText = learnMoreText{
            
            let attributedString = NSMutableAttributedString(string: txtDataSource.iAgreeText)
            let linkRange = (txtDataSource.iAgreeText as NSString).range(of: learnMoreText)
            attributedString.addAttribute(.link, value: viewDetailsText, range: linkRange)
            
            if let primaryColor = QuartzKit.shared.primaryColor{
                iAgreeTxtView.linkTextAttributes = [
                    .foregroundColor: primaryColor,
                ]
            }else{
                attributedString.addAttribute(.strokeWidth, value: -3 , range: linkRange)
                attributedString.addAttribute(.strokeColor, value: IssueRecordingViewColors.viewDetailsLabelColor , range: linkRange)
            }
            
            let range = NSMakeRange(0, txtDataSource.iAgreeText.count - linkRange.length)
            if (range.location != NSNotFound && range.location + range.length <= attributedString.length && range.length > 0 ) {
                let txtColor = IssueRecordingViewColors.iAgreeLabelColor
                attributedString.addAttribute(.foregroundColor,
                                              value: txtColor ,
                                              range: range)
                
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: txtDataSource.iAgreeText.count))
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            iAgreeTxtView.attributedText = attributedString
        }
                
        let topPaddingOfContainer: CGFloat = 31
        let leadingPaddingOfContainer: CGFloat = 24
        let trailingPaddingOfContainer: CGFloat = 24
        
        let topPaddingOfIAgreeSwitch: CGFloat = 30
        let widthOfIAgreeSwitch: CGFloat = 50
        let heightOfIAgreeSwitch: CGFloat = 30
        
        let leadingPaddingOfIAgreeLabel: CGFloat = 10
        
        let topPaddingOfStartRecordingButton: CGFloat = 26
        let widthOfStartRecordingButton: CGFloat = 179
        let heightOfStartRecordingButton: CGFloat = 50
//        screenRecordingInfoLabel.backgroundColor = .purple
        
        
        NSLayoutConstraint.activate([
            beforeStartingRecordingContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingPaddingOfContainer),
            beforeStartingRecordingContainerView.topAnchor.constraint(equalTo: screenRecordingImageView.bottomAnchor, constant: topPaddingOfContainer),
            beforeStartingRecordingContainerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            beforeStartingRecordingContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingPaddingOfContainer),
            
            screenRecordingInfoLabel.leadingAnchor.constraint(equalTo: beforeStartingRecordingContainerView.leadingAnchor),
            screenRecordingInfoLabel.trailingAnchor.constraint(equalTo: beforeStartingRecordingContainerView.trailingAnchor),
            screenRecordingInfoLabel.topAnchor.constraint(equalTo: beforeStartingRecordingContainerView.topAnchor),
            screenRecordingInfoLabel.bottomAnchor.constraint(lessThanOrEqualTo: beforeStartingRecordingContainerView.bottomAnchor),
            
            iAgreeSwitch.leadingAnchor.constraint(equalTo: screenRecordingInfoLabel.leadingAnchor),
            iAgreeSwitch.topAnchor.constraint(greaterThanOrEqualTo: screenRecordingInfoLabel.bottomAnchor, constant: topPaddingOfIAgreeSwitch),
            iAgreeSwitch.widthAnchor.constraint(equalToConstant: widthOfIAgreeSwitch),
            iAgreeSwitch.heightAnchor.constraint(equalToConstant: heightOfIAgreeSwitch),
            iAgreeSwitch.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            
            iAgreeTxtView.leadingAnchor.constraint(equalTo: iAgreeSwitch.trailingAnchor, constant: leadingPaddingOfIAgreeLabel),
            iAgreeTxtView.topAnchor.constraint(equalTo: screenRecordingInfoLabel.bottomAnchor, constant: topPaddingOfIAgreeSwitch),
            iAgreeTxtView.trailingAnchor.constraint(equalTo: screenRecordingInfoLabel.trailingAnchor),
            iAgreeTxtView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            iAgreeTxtView.centerYAnchor.constraint(equalTo: iAgreeSwitch.centerYAnchor),
            
            startRecordingButton.leadingAnchor.constraint(greaterThanOrEqualTo: screenRecordingInfoLabel.leadingAnchor),
            startRecordingButton.trailingAnchor.constraint(lessThanOrEqualTo: screenRecordingInfoLabel.trailingAnchor),
            startRecordingButton.topAnchor.constraint(equalTo: iAgreeTxtView.bottomAnchor, constant: topPaddingOfStartRecordingButton),
            startRecordingButton.heightAnchor.constraint(equalToConstant: heightOfStartRecordingButton),
            startRecordingButton.widthAnchor.constraint(equalToConstant: widthOfStartRecordingButton),
            startRecordingButton.centerXAnchor.constraint(equalTo: beforeStartingRecordingContainerView.centerXAnchor),
            startRecordingButton.bottomAnchor.constraint(equalTo: beforeStartingRecordingContainerView.bottomAnchor)
        ])
    }
    
    private func configureViewForRecordingInProgressState(){
        addSubviews(afterStartingRecordingContainerView)
        afterStartingRecordingContainerView.addSubviews(recordingInProgressLabel, trimOptionLabel, endRecordingButton)
        
        let topPaddingOfContainer: CGFloat = 31
        let leadingPaddingOfContainer: CGFloat = 24
        let trailingPaddingOfContainer: CGFloat = 24
        
        let topPaddingOfTrimOptionLabel: CGFloat = 10
        
        let topPaddingOfrecordingInProgressLabel: CGFloat = 0
        let leadingPaddingOfTrimOptionLabel: CGFloat = 10
        let trailingPaddingOfTrimOptionLabel: CGFloat = 10
        let heightOfTrimOptionLabel: CGFloat = 50
        
        let topPaddingOfEndRecordingButton: CGFloat = 30
        let widthOfEndRecordingButton: CGFloat = 179
        let heightOfEndRecordingButton: CGFloat = 50

        
        recordingInProgressLabel.text = txtDataSource.recordingInProgressText
        endRecordingButton.setTitle(txtDataSource.endRecordingButtonText, for: .normal)
        if #available(iOS 13.0, *) {
            let attachment = NSTextAttachment()
            let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 14)
            attachment.image = UIImage(systemName: "info.circle", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate).withTintColor(UIColor.label.withAlphaComponent(0.7))
            let attachmentString = NSAttributedString(attachment: attachment)
            let trimOptionLabelStr = NSMutableAttributedString()
            trimOptionLabelStr.append(attachmentString)
            trimOptionLabelStr.append(NSAttributedString(string: " "))
            trimOptionLabelStr.append(NSAttributedString(string: txtDataSource.optionToTrimText))
            trimOptionLabelStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: trimOptionLabelStr.length))
            
            trimOptionLabel.attributedText = trimOptionLabelStr
        } else {
            trimOptionLabel.text = txtDataSource.optionToTrimText
        }
        
        NSLayoutConstraint.activate([
            afterStartingRecordingContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingPaddingOfContainer),
            afterStartingRecordingContainerView.topAnchor.constraint(equalTo: screenRecordingImageView.bottomAnchor, constant: topPaddingOfContainer),
            afterStartingRecordingContainerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            afterStartingRecordingContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingPaddingOfContainer),
            
            recordingInProgressLabel.leadingAnchor.constraint(equalTo: afterStartingRecordingContainerView.leadingAnchor),
            recordingInProgressLabel.topAnchor.constraint(equalTo: afterStartingRecordingContainerView.topAnchor, constant: topPaddingOfrecordingInProgressLabel),
            recordingInProgressLabel.trailingAnchor.constraint(equalTo: afterStartingRecordingContainerView.trailingAnchor),
            recordingInProgressLabel.centerXAnchor.constraint(equalTo: afterStartingRecordingContainerView.centerXAnchor),
            recordingInProgressLabel.bottomAnchor.constraint(lessThanOrEqualTo: afterStartingRecordingContainerView.bottomAnchor),
            
            trimOptionLabel.leadingAnchor.constraint(equalTo: afterStartingRecordingContainerView.leadingAnchor, constant: leadingPaddingOfTrimOptionLabel),
            trimOptionLabel.trailingAnchor.constraint(equalTo: afterStartingRecordingContainerView.trailingAnchor, constant: -trailingPaddingOfTrimOptionLabel),
            trimOptionLabel.topAnchor.constraint(equalTo: recordingInProgressLabel.bottomAnchor, constant: topPaddingOfTrimOptionLabel),
            trimOptionLabel.heightAnchor.constraint(equalToConstant: heightOfTrimOptionLabel),
            
            endRecordingButton.leadingAnchor.constraint(greaterThanOrEqualTo: afterStartingRecordingContainerView.leadingAnchor),
            endRecordingButton.trailingAnchor.constraint(lessThanOrEqualTo: afterStartingRecordingContainerView.trailingAnchor),
            endRecordingButton.topAnchor.constraint(equalTo: trimOptionLabel.bottomAnchor, constant: topPaddingOfEndRecordingButton),
            endRecordingButton.centerXAnchor.constraint(equalTo: afterStartingRecordingContainerView.centerXAnchor),
            endRecordingButton.widthAnchor.constraint(equalToConstant: widthOfEndRecordingButton),
            endRecordingButton.heightAnchor.constraint(equalToConstant: heightOfEndRecordingButton),
            endRecordingButton.bottomAnchor.constraint(equalTo: afterStartingRecordingContainerView.bottomAnchor)
        ])
    }
    
    private func configure(){
        addSubviews(screenRecordingImageView,quickTipsView)
        afterStartingRecordingContainerView.removeFromSuperview()
        beforeStartingRecordingContainerView.removeFromSuperview()
        
        let heightOfScreenRecordingImageView: CGFloat = 151
        let topPaddingOfQuickTipsViewFromContainerView: CGFloat = 30
        let bottomPaddingOfQuickTipsView: CGFloat = 10
        var topConstaintOfQuickTipsView: NSLayoutConstraint? = nil
        var leadingConstaintOfQuickTipsView: NSLayoutConstraint? = nil
        var trailingConstaintOfQuickTipsView: NSLayoutConstraint? = nil
        
        let leadingPaddingOfQuickTipsView: CGFloat = 10
        let trailingPaddingOfQuickTipsView: CGFloat = 10
        
        if ScreenRecorder.isScreenRecording(){
            configureViewForRecordingInProgressState()
            leadingConstaintOfQuickTipsView = quickTipsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingPaddingOfQuickTipsView)
            trailingConstaintOfQuickTipsView = quickTipsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingPaddingOfQuickTipsView)
            topConstaintOfQuickTipsView = quickTipsView.topAnchor.constraint(equalTo: afterStartingRecordingContainerView.bottomAnchor, constant: topPaddingOfQuickTipsViewFromContainerView)
        }else{
            configureViewForNoRecordingInProgressState()
            leadingConstaintOfQuickTipsView = quickTipsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingPaddingOfQuickTipsView)
            trailingConstaintOfQuickTipsView = quickTipsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingPaddingOfQuickTipsView)
            topConstaintOfQuickTipsView = quickTipsView.topAnchor.constraint(equalTo: beforeStartingRecordingContainerView.bottomAnchor, constant: topPaddingOfQuickTipsViewFromContainerView)
        }

        if let topConstaintOfQuickTipsView = topConstaintOfQuickTipsView,
           let leadingConstaintOfQuickTipsView = leadingConstaintOfQuickTipsView,
           let trailingConstaintOfQuickTipsView = trailingConstaintOfQuickTipsView{
            
            let leadingPaddingOfImgView: CGFloat = 37
            let trailingPaddingOfImgView: CGFloat = 37

            NSLayoutConstraint.activate([
                screenRecordingImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingPaddingOfImgView),
                screenRecordingImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingPaddingOfImgView),
                screenRecordingImageView.topAnchor.constraint(equalTo: topAnchor),
                screenRecordingImageView.heightAnchor.constraint(equalToConstant: heightOfScreenRecordingImageView),
                
                leadingConstaintOfQuickTipsView,
                trailingConstaintOfQuickTipsView,
                topConstaintOfQuickTipsView,
                quickTipsView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -bottomPaddingOfQuickTipsView)
            ])
        }
    }
    
    func replaceFirstAndSecondOccurrence(in text: String, target: String, firstReplacement: String, secondReplacement: String) -> String {
        var modified = text
        let range = (modified as NSString).range(of: target)
        
        if range.location != NSNotFound {
            modified = (modified as NSString).replacingCharacters(in: range, with: firstReplacement)
            let startIndex = modified.index(modified.startIndex, offsetBy: range.location + firstReplacement.count)
            if let secondRange = modified.range(of: target, range: startIndex..<modified.endIndex) {
                modified.replaceSubrange(secondRange, with: secondReplacement)
            }
        }
        
        return modified
    }
}

extension IssueRecordingView{
    func startRecordingButton(shouldEnable: Bool){
        startRecordingButton.isUserInteractionEnabled = shouldEnable
    }
    
    @objc private func startRecording(){
        if NetworkChecker.isConnectedToNetwork(){
            startRecordingButton(shouldEnable: false) // Prevents multiple tapping case
            if !ScreenRecorder.isScreenRecording(){
                delegate?.startRecording()
            }
        }else{
            delegate?.notConnectedToInternet()
        }
    }
    
    @objc private func endRecording(){
        delegate?.endRecording()
    }
    
    @objc private func switchChanged(){
        if iAgreeSwitch.isOn{
            startRecordingButton.tintColor = startRecordingButtonEnabledTextColor
            startRecordingButton.backgroundColor = startRecordingButtonEnabledBGColor
            startRecordingButton.isEnabled = true
        }else{
            startRecordingButton.tintColor = startRecordingButtonDisabledTextColor
            startRecordingButton.backgroundColor = startRecordingButtonDisabledBGColor
            startRecordingButton.isEnabled = false
        }
        
    }
}


class SelectionDisabledTextView: UITextView{
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let pos = closestPosition(to: point) else { return false }
        
        var textDirection = UITextDirection.layout(.left)
        let lang = CFStringTokenizerCopyBestStringLanguage(text as CFString, CFRange(location: 0, length: text.count))
        if let lang = lang {
            let direction = NSLocale.characterDirection(forLanguage: lang as String)
            if direction == .rightToLeft {
                textDirection = UITextDirection.layout(.right)
            }
        }
        
        guard let range = tokenizer.rangeEnclosingPosition(pos, with: .character, inDirection: textDirection) else { return false }
        let startIndex = offset(from: beginningOfDocument, to: range.start)
        return attributedText.attribute(.link, at: startIndex, effectiveRange: nil) != nil
    }
    
}


