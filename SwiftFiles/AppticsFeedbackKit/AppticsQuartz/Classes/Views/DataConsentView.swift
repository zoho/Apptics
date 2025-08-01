//
//  DataConsentView.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 18/11/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import UIKit

struct DataConsentDataSource{
    let titleText = QuartzKitStrings.localized("dataconsentscreen.label.consenttitle")
    
    let consentTexts = [
        QuartzKitStrings.localized("dataconsentscreen.label.consent1"),
        QuartzKitStrings.localized("dataconsentscreen.label.consent2"),
        QuartzKitStrings.localized("dataconsentscreen.label.consent4"),
        QuartzKitStrings.localized("dataconsentscreen.label.consent5")
    ]
}


class DataConsentView: UIView{
    let model: DataConsentDataSource = DataConsentDataSource()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var consentTextLabel: UILabel = {
        let consentTextLabel = UILabel()
        consentTextLabel.translatesAutoresizingMaskIntoConstraints = false
        consentTextLabel.textColor = IssueRecordingViewColors.dataConsentTextColor
        consentTextLabel.text = model.titleText
        consentTextLabel.numberOfLines = 2
        consentTextLabel.font = UIFont.systemFont(ofSize: 14)
        
        return consentTextLabel
    }()
    
    private func configure(){
        addSubviews(scrollView)
        scrollView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        containerView.addSubview(consentTextLabel)
        
        NSLayoutConstraint.activate([
            consentTextLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            consentTextLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            consentTextLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            consentTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor)
        ])
        
        var prevView: QuickTipRowView? = nil
        let topPadding: CGFloat = 16
        
        for tipText in model.consentTexts{
            let rowView = QuickTipRowView(text: tipText)
            rowView.translatesAutoresizingMaskIntoConstraints = false
            rowView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
            containerView.addSubview(rowView)
            
            if let prevView = prevView{
                NSLayoutConstraint.activate([
                    rowView.topAnchor.constraint(equalTo: prevView.bottomAnchor, constant: topPadding),
                    rowView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    rowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    rowView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
                ])
            }else{
                NSLayoutConstraint.activate([
                    rowView.topAnchor.constraint(equalTo: consentTextLabel.bottomAnchor, constant: topPadding),
                    rowView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    rowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    rowView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
                ])
            }
            prevView = rowView
        }
        
    }
}
