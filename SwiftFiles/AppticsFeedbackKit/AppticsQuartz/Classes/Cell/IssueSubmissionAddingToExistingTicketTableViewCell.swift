//
//  IssueSubmissionAddingToExistingTicketTableViewCell.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 18/01/24.
//  Copyright © 2024 Zoho. All rights reserved.
//

import UIKit

class IssueSubmissionAddingToExistingTicketTableViewCell: UITableViewCell, IssueSubmissionTableViewCell{
    var vm: IssueSumissionCellVM?
    static let resuseID = "IssueSubmissionAddingToExistingTicketTableViewCell"
    
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
    
    private lazy var switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        switchView.onTintColor = UIColor(red: 0, green: 150.0/255.0, blue: 255.0/255.0, alpha: 1)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialConfiguration()
    }
    
    private func initialConfiguration(){
        contentView.addSubview(containerView)
        
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
        
        containerView.addSubviews(switchView, displayLabel)
                
        let widthOfSwitch: CGFloat = 50
        let heightOfSwitch: CGFloat = 30
        let leadingPaddingOfDisplayLabel: CGFloat = 10
        
        NSLayoutConstraint.activate([
            switchView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            switchView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor),
            switchView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
            switchView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            switchView.heightAnchor.constraint(equalToConstant: heightOfSwitch),
            switchView.widthAnchor.constraint(equalToConstant: widthOfSwitch),
            
            displayLabel.leadingAnchor.constraint(equalTo: switchView.trailingAnchor, constant: leadingPaddingOfDisplayLabel),
            displayLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            displayLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            displayLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            displayLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withModel model: IssueSumissionCellVM) {
        self.vm = model
        self.vm?.view = self
        if model.rowModel.isMandatory{
            let mandatoryText = self.getMandatoryText(forDisplayTxt: model.rowModel.displayName)
            displayLabel.attributedText = mandatoryText
        }else{
            displayLabel.text = model.rowModel.displayName
        }
        
    }
    
    @objc private func switchChanged(){
        guard let vm = vm as? AddToExistingTicketVM else {return}
        vm.switchChanged(to: switchView.isOn)
    }
}
