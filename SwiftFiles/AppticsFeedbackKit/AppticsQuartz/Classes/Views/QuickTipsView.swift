//
//  QuickTipsView.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 18/11/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import UIKit

class QuickTipsDataSource{
    let tipTitle = "Quick Tips"
    let tips: [String] = [
        "You can record your screen for a maximum of 5 minutes.",
        "You can trim, edit and annotate the recorded video.",
        "Do not close the app when the screen is being recorded.",
        "To learn more, please visit our help documentation"
    ]
}

class QuickTipsView: UIView{
    
    let dataSource: QuickTipsDataSource = QuickTipsDataSource()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var quickTipsLabel: UILabel = {
        let quickTipsLabel = UILabel()
        quickTipsLabel.translatesAutoresizingMaskIntoConstraints = false
        quickTipsLabel.textColor = IssueRecordingViewColors.quickTipsTitleTextColor
        quickTipsLabel.text = dataSource.tipTitle
        quickTipsLabel.font = UIFont.systemFont(ofSize: 14)
        return quickTipsLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
  
        if let primaryColor = QuartzKit.shared.primaryColor{
            if #available(iOS 13.0, *){
                backgroundColor = UIColor { $0.userInterfaceStyle == .dark ? (IssueRecordingViewColors.quickTipsViewBGColor ?? UIColor.white ) : primaryColor.withAlphaComponent(0.05) }
            }else{
                backgroundColor = primaryColor
            }
        }else{
            backgroundColor = IssueRecordingViewColors.quickTipsViewBGColor
        }
        
        layer.cornerRadius = 5.0
        
        addSubviews(containerView)
        containerView.addSubviews(quickTipsLabel)

        
        let leadingPaddingOfContainerView: CGFloat = 16
        let topPaddingOfContainerView: CGFloat = 16
        let trailingPaddingOfContainerView: CGFloat = 16
        let bottomPaddingOfContainerView: CGFloat = 16
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingPaddingOfContainerView),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingPaddingOfContainerView),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: topPaddingOfContainerView),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPaddingOfContainerView)
        ])
        
        NSLayoutConstraint.activate([
            quickTipsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            quickTipsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            quickTipsLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            quickTipsLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
        ])
        
        var prevView: QuickTipRowView? = nil
        let topPadding: CGFloat = 16
        
        for index in 0..<dataSource.tips.count{
            let tipText = dataSource.tips[index]
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
                    rowView.topAnchor.constraint(equalTo: quickTipsLabel.bottomAnchor, constant: topPadding),
                    rowView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    rowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    rowView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
                ])
            }
            prevView = rowView
            if index == dataSource.tips.count-1{
                let comp = tipText.components(separatedBy: " ")
                let helpDocumentationTxt = comp.suffix(2).joined(separator: " ")
                rowView.makeTappableLink(content: helpDocumentationTxt)
            }
        }
        
    }
}
