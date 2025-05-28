//
//  IssueSubmissionVideoFileTableViewCell.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 22/11/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import UIKit

class IssueSubmissionVideoFileTableViewCell: UITableViewCell, IssueSubmissionTableViewCell{
    var vm: IssueSumissionCellVM? = nil
    
    static let resuseID = "IssueSubmissionVideoFileTableViewCell"
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var horizontalSeparator: UIView = {
        let horizontalSeparator = UIView()
        horizontalSeparator.translatesAutoresizingMaskIntoConstraints = false
        horizontalSeparator.backgroundColor = UIColor.lightGray
        return horizontalSeparator
    }()
    
    private lazy var verticalSeparator: UIView = {
        let verticalSeparator = UIView()
        verticalSeparator.translatesAutoresizingMaskIntoConstraints = false
        verticalSeparator.backgroundColor = UIColor.lightGray
        return verticalSeparator
    }()
    
    private lazy var displayLabel: UILabel = {
        let displayLabel = UILabel()
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.font = UIFont.systemFont(ofSize: 16)
        displayLabel.textColor = UIColor.label
        return displayLabel
    }()
    
    private lazy var imageAndButtonContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.cornerRadius = 5
        
        return containerView
    }()
    
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var playIconImageView: UIImageView = {
        let playIconImageView = UIImageView()
        playIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 13.0, *) {
            let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 15)
            let image = UIImage(systemName: "play.circle.fill", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)
            playIconImageView.image = image?.withRenderingMode(.alwaysTemplate)
            playIconImageView.tintColor = UIColor.label.withAlphaComponent(0.8)
            playIconImageView.contentMode = .scaleAspectFit
        }
        return playIconImageView
    }()
    
    private lazy var newRecordingButton: UIButton = {
        let newRecordingButton = UIButton()
        newRecordingButton.translatesAutoresizingMaskIntoConstraints = false
        newRecordingButton.setTitle("New Recording", for: .normal)
        newRecordingButton.setTitleColor(QuartzKit.shared.primaryColor ?? .systemBlue, for: .normal)
        newRecordingButton.titleLabel?.textAlignment = .center
        newRecordingButton.addTarget(self, action: #selector(newRecordingAction), for: .touchUpInside)
    
//        if #available(iOS 13.0, *) {
//            let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 15)
//            let image = UIImage(systemName: "arrow.clockwise", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)
//            newRecordingButton.setImage(image, for: .normal)
//            newRecordingButton.imageView?.tintColor = .systemBlue
//            newRecordingButton.imageView?.contentMode = .scaleAspectFit
//            newRecordingButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
//        } else {
//            // Fallback on earlier versions
//        }
        return newRecordingButton
    }()
    
    private lazy var editRecordingButton: UIButton = {
        let editRecordingButton = UIButton()
        editRecordingButton.translatesAutoresizingMaskIntoConstraints = false
        editRecordingButton.setTitle("Edit Recording", for: .normal)
        editRecordingButton.setTitleColor(QuartzKit.shared.primaryColor ?? .systemBlue, for: .normal)
        editRecordingButton.titleLabel?.textAlignment = .center
        editRecordingButton.addTarget(self, action: #selector(editRecordingAction), for: .touchUpInside)
//        if #available(iOS 13.0, *) {
//            let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 15)
//            let image = UIImage(systemName: "pencil", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)
//            editRecordingButton.setImage(image, for: .normal)
//            editRecordingButton.imageView?.tintColor = .systemBlue
//            editRecordingButton.imageView?.contentMode = .scaleAspectFit
//            editRecordingButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
//        }
        return editRecordingButton
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
        
        containerView.addSubviews(displayLabel, imageAndButtonContainerView)
        imageAndButtonContainerView.addSubviews(imgView, playIconImageView, newRecordingButton, editRecordingButton, horizontalSeparator, verticalSeparator)
        
        let imgViewTopPadding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            displayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            displayLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            displayLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            displayLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
            
            imageAndButtonContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageAndButtonContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageAndButtonContainerView.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: imgViewTopPadding),
            imageAndButtonContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: imageAndButtonContainerView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: imageAndButtonContainerView.trailingAnchor),
            imgView.topAnchor.constraint(equalTo: imageAndButtonContainerView.topAnchor),
            imgView.bottomAnchor.constraint(lessThanOrEqualTo: imageAndButtonContainerView.bottomAnchor),
            imgView.heightAnchor.constraint(equalToConstant: 150),
            
            playIconImageView.widthAnchor.constraint(equalToConstant: 40),
            playIconImageView.heightAnchor.constraint(equalToConstant: 40),
            playIconImageView.centerXAnchor.constraint(equalTo: imgView.centerXAnchor),
            playIconImageView.centerYAnchor.constraint(equalTo: imgView.centerYAnchor),
            
            newRecordingButton.leadingAnchor.constraint(equalTo: imgView.leadingAnchor),
            newRecordingButton.topAnchor.constraint(equalTo: imgView.bottomAnchor),
            newRecordingButton.heightAnchor.constraint(equalToConstant: 40),
            newRecordingButton.widthAnchor.constraint(equalTo: imgView.widthAnchor, multiplier: 0.5),
            newRecordingButton.bottomAnchor.constraint(equalTo: imageAndButtonContainerView.bottomAnchor),
            
            editRecordingButton.leadingAnchor.constraint(equalTo: newRecordingButton.trailingAnchor),
            editRecordingButton.topAnchor.constraint(equalTo: imgView.bottomAnchor),
            editRecordingButton.heightAnchor.constraint(equalToConstant: 40),
            editRecordingButton.widthAnchor.constraint(equalTo: imgView.widthAnchor, multiplier: 0.5),
            editRecordingButton.bottomAnchor.constraint(equalTo: imageAndButtonContainerView.bottomAnchor),
            
            horizontalSeparator.leadingAnchor.constraint(equalTo: imageAndButtonContainerView.leadingAnchor),
            horizontalSeparator.trailingAnchor.constraint(equalTo: imageAndButtonContainerView.trailingAnchor),
            horizontalSeparator.topAnchor.constraint(equalTo: imgView.bottomAnchor),
            horizontalSeparator.heightAnchor.constraint(equalToConstant: 0.5),
            
            verticalSeparator.leadingAnchor.constraint(equalTo: newRecordingButton.trailingAnchor),
            verticalSeparator.topAnchor.constraint(equalTo: imgView.bottomAnchor),
            verticalSeparator.bottomAnchor.constraint(equalTo:newRecordingButton.bottomAnchor),
            verticalSeparator.widthAnchor.constraint(equalToConstant: 0.5)
        ])
        
        playIconImageView.isHidden = true
        playIconImageView.isUserInteractionEnabled = false
        imgView.isUserInteractionEnabled = true
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        imgView.addGestureRecognizer(tapgesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withModel model: IssueSumissionCellVM) {
        self.vm = model
        self.vm?.view = self
        
        if model.rowModel.isMandatory{
            let mandatoryText = self.getMandatoryText(forDisplayTxt:  model.rowModel.displayName)
            displayLabel.attributedText = mandatoryText
        }else{
            displayLabel.text = model.rowModel.displayName
        }
        guard let model = model as? VideoVM else {return}
        self.imgView.image = model.thumbnailImage
        self.playIconImageView.isHidden = false
    }
    
    @objc private func tapped(){
        guard let vm = vm as? VideoVM else {return}
        vm.playTapped()
    }
    
    @objc private func newRecordingAction(){
        guard let vm = vm as? VideoVM else {return}
        vm.newRecordingTapped()
    }
    
    @objc private func editRecordingAction(){
        guard let vm = vm as? VideoVM else {return}
        vm.editTapped()
    }
}
