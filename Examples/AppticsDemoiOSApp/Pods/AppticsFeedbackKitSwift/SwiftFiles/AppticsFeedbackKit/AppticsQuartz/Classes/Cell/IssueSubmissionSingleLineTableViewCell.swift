//
//  IssueSubmissionSingleLineTableViewCell.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 22/11/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import UIKit

class IssueSubmissionSingleLineTableViewCell: UITableViewCell, IssueSubmissionTableViewCell{
    static let resuseID = "IssueSubmissionSingleLineTableViewCell"
    private let placeHolderTextColor = UIColor.lightGray
    
    var vm: IssueSumissionCellVM?{
        didSet{
            vm?.view = self
            updateDisplayTextAndPlaceholderText()
        }
    }
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    
    private lazy var displayLabel: UILabel = {
        let displayLabel = UILabel()
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.font = UIFont.systemFont(ofSize: 16)
        displayLabel.textColor = UIColor.label
        return displayLabel
    }()
    
    private lazy var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.font = UIFont.systemFont(ofSize: 12)
        errorLabel.textColor = UIColor.systemRed
        errorLabel.numberOfLines = 2
        return errorLabel
    }()
    
    private var isEmptyEmailCase = false
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 5
        textField.delegate = self
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        containerView.addSubviews(displayLabel, textField)
        
        let topPaddingOfTextView: CGFloat = 10
        
        NSLayoutConstraint.activate([
            displayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            displayLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            displayLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            displayLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
            
            textField.leadingAnchor.constraint(equalTo: displayLabel.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: displayLabel.trailingAnchor),
            textField.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: topPaddingOfTextView),
            textField.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(withModel model: IssueSumissionCellVM){
        self.vm = model
        self.vm?.view = self
        updateDisplayTextAndPlaceholderText()
    }
    
    private func updateDisplayTextAndPlaceholderText(){
        guard let vm = vm else {return}
        
        textField.placeholder = vm.rowModel.placeHolder
        if vm.rowModel.isMandatory{
            let mandatoryText = self.getMandatoryText(forDisplayTxt:  vm.rowModel.displayName)
            displayLabel.attributedText = mandatoryText
        }else{
            displayLabel.text = vm.rowModel.displayName
        }
        
        if let modelValue = vm.value{
            switch modelValue{
            case .value(let val):
                textField.text = val
            }
        }else{
            textField.text = ""
        }
        
        if let _ = vm as? EmailAddressVM{
            if !isEmptyEmailCase{
                textField.isEnabled = false
                textField.textColor = .gray
            }
            if textField.text?.isEmpty ?? false{
                textField.isEnabled = true
                textField.textColor = nil
                isEmptyEmailCase = true
            }
        }
    }
    
    func showEmptyContentErrorMessage(_ str: String) {
        errorLabel.text = str        
        if errorLabel.superview == nil{
            let topPaddingOfErrorLabel: CGFloat = 10
            containerView.addSubview(errorLabel)
            NSLayoutConstraint.activate([
                errorLabel.leadingAnchor.constraint(equalTo: displayLabel.leadingAnchor),
                errorLabel.trailingAnchor.constraint(equalTo: displayLabel.trailingAnchor),
                errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: topPaddingOfErrorLabel),
                errorLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
    }
    
    func hideEmptyContentErrorMessage(){
        if errorLabel.superview != nil {
            errorLabel.removeFromSuperview()
            vm?.refreshAfterRemovingError()
        }
    }
}


extension IssueSubmissionSingleLineTableViewCell: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        vm?.value = .value(textField.text ?? "")
        hideEmptyContentErrorMessage()
//        guard let vm = vm as? AddToExistingTicketVM else {return}
//        vm.switchChanged(to: switchView.isOn)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
