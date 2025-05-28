//
//  IssueSubmissionDescriptionTableViewCell.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 22/11/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import UIKit

class IssueSubmissionDescriptionTableViewCell: UITableViewCell, IssueSubmissionTableViewCell{
    var vm: IssueSumissionCellVM?
    static let resuseID = "IssueSubmissionDescriptionTableViewCell"
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    
    private lazy var displayLabel: UILabel = {
        let displayLabel = UILabel()
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.font = UIFont.systemFont(ofSize: 16)
        displayLabel.textColor = UIColor.black
        return displayLabel
    }()
    
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialConfiguration()
    }
    
    private func initialConfiguration(){
        contentView.addSubview(containerView)
//        containerView.backgroundColor = .purple
        
        let leadingConstant: CGFloat = 20
        let trailingConstant: CGFloat = 20
        let topConstant: CGFloat = 10
        let bottomConstant: CGFloat = 10
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: leadingConstant),
            containerView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -trailingConstant),
            containerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: topConstant),
            containerView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -bottomConstant),
        ])
        
        containerView.addSubviews(displayLabel, textView)
        
        let topPaddingOfTextView: CGFloat = 10
        
        NSLayoutConstraint.activate([
            displayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            displayLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            displayLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            displayLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
            
            textView.leadingAnchor.constraint(equalTo: displayLabel.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: displayLabel.trailingAnchor),
            textView.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: topPaddingOfTextView),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            textView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withModel model: IssueSumissionCellVM) {
        self.vm = model
        
        if model.rowModel.isMandatory{
            let mandatoryText = self.getMandatoryText(forDisplayTxt:  model.rowModel.displayName)
            displayLabel.attributedText = mandatoryText
        }else{
            displayLabel.text = model.rowModel.displayName
        }
    }
}
