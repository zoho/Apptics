//
//  QuickTipRowView.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 18/11/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import UIKit

class QuickTipRowView: UIView{
    
    let tipText: String
    
    private let tipsBulletViewWidth: CGFloat = 6
    private let tipsBulletViewHeight: CGFloat = 6
    private let paddingBetweenBulletAndText: CGFloat = 16
    private let helpDocumentationUrlStr = "https://help.zoho.com/portal/en/kb/creator/developer-guide/others/zia-help-assistant/articles/introducing-quartz-for-creator"
    
    private lazy var tipsBulletView: UIView = {
        let tipsBulletView = UIView()
        tipsBulletView.backgroundColor = UIColor(red: 190.0/255.0, green: 192.0/255.0, blue: 200.0/255.0, alpha: 0.7)
        tipsBulletView.translatesAutoresizingMaskIntoConstraints = false
        return tipsBulletView
    }()
    
    
    private let tipTextFont = UIFont.systemFont(ofSize: 14)
    private let tipTextColor = IssueRecordingViewColors.quickTipsTextColor
    
    private lazy var tipsTextLabel: SelectionDisabledTextView = {
        let tipsTextLabel = SelectionDisabledTextView()
        tipsTextLabel.textAlignment = .left
        tipsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        tipsTextLabel.backgroundColor = .clear
        tipsTextLabel.text = tipText
        tipsTextLabel.isScrollEnabled = false
        tipsTextLabel.isUserInteractionEnabled = true
        tipsTextLabel.isEditable = false
        tipsTextLabel.textContainer.maximumNumberOfLines = 3
        tipsTextLabel.textContainerInset = .zero
        tipsTextLabel.textContainer.lineBreakMode = .byTruncatingTail
        tipsTextLabel.textColor = tipTextColor
        tipsTextLabel.font = tipTextFont
        tipsTextLabel.dataDetectorTypes = UIDataDetectorTypes.all
        tipsTextLabel.isSelectable = true
        return tipsTextLabel
    }()
    
    init(text: String) {
        self.tipText = text
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        tipsBulletView.layer.cornerRadius = tipsBulletViewWidth/2.0
        
        addSubviews(tipsBulletView, tipsTextLabel)
        NSLayoutConstraint.activate([
            tipsBulletView.leadingAnchor.constraint(equalTo: leadingAnchor),
            //            tipsBulletView.topAnchor.constraint(equalTo: topAnchor),
            tipsBulletView.widthAnchor.constraint(equalToConstant: tipsBulletViewWidth),
            tipsBulletView.heightAnchor.constraint(equalToConstant: tipsBulletViewHeight),
            
            tipsTextLabel.leadingAnchor.constraint(equalTo: tipsBulletView.trailingAnchor, constant: paddingBetweenBulletAndText),
            tipsTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            tipsTextLabel.topAnchor.constraint(equalTo: topAnchor),
            tipsTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            tipsTextLabel.centerYAnchor.constraint(equalTo: tipsBulletView.centerYAnchor)
        ])
    }
    
    func makeTappableLink(content: String){
        guard let helpDocumentationUrl = URL(string: helpDocumentationUrlStr) else {return}
        let helpDocumentationTxt = content
        let attributedString = NSMutableAttributedString(string: tipText)
        
        let linkRange = (tipText as NSString).range(of: helpDocumentationTxt)
        attributedString.addAttribute(.link, value: helpDocumentationUrl, range: linkRange)
        
        if let primaryColor = QuartzKit.shared.primaryColor{
            self.tipsTextLabel.linkTextAttributes = [
                 .foregroundColor: primaryColor,
             ]
        }else{
            attributedString.addAttribute(.strokeWidth, value: -3 , range: linkRange)
            attributedString.addAttribute(.strokeColor, value: QuartzColor.viewDetailsLabel.color , range: linkRange)
        }

        let range = NSMakeRange(0, tipText.count - linkRange.length)
        if (range.location != NSNotFound && range.location + range.length <= attributedString.length && range.length > 0 ) {
            attributedString.addAttribute(.foregroundColor,
                                          value: tipTextColor ,
                                          range: range)
        }
        
        attributedString.addAttribute(.font, value: tipTextFont, range: NSRange(location: 0, length: tipText.count))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        tipsTextLabel.attributedText = attributedString
    }
    
}
