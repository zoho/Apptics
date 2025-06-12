//
//  IssueSubmissionFileAttachementTableViewCell.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff U on 19/02/24.
//

import UIKit

class IssueSubmissionFileAttachementTableViewCell: UITableViewCell, IssueSubmissionTableViewCell{
    static let resuseID = "IssueSubmissionFileAttachementTableViewCell"
    
    private let fileSizeExceededLabelString = QuartzKitStrings.localized("issuesubmissionscreen.alert.filesizeexceeded")
    private let attachFilesString = QuartzKitStrings.localized("issuesubmissionscreen.label.attachfiles")

    private let fileSizeExceededLabelHeight: CGFloat = 30
    private let attachFileContainerHeight: CGFloat = 40
    
    var vm: IssueSumissionCellVM?{
        didSet{
            updateDisplayTextAndPlaceholderText()
        }
    }
    
    var shouldShowFileSizeExceededLabel: Bool = false {
        didSet{
            fileSizeExceededLabelConstraint?.constant = shouldShowFileSizeExceededLabel ? fileSizeExceededLabelHeight : 0
        }
    }
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var valueContainerView: UIView = {
        let valueContainerView = UIView()
        valueContainerView.translatesAutoresizingMaskIntoConstraints = false
        valueContainerView.layer.borderColor = UIColor.lightGray.cgColor
        valueContainerView.layer.borderWidth = 0.5
        valueContainerView.layer.cornerRadius = 5
        return valueContainerView
    }()
    
    private var fileSizeExceededLabelConstraint: NSLayoutConstraint? = nil
    private var attachFileContainerHeightConstraint: NSLayoutConstraint? = nil

    
    private lazy var displayLabel: UILabel = {
        let displayLabel = UILabel()
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.font = UIFont.systemFont(ofSize: 16)
        displayLabel.textColor = UIColor.label
        return displayLabel
    }()
    
    private lazy var fileSizeExceededLabel: UILabel = {
        let fileSizeExceededLabel = UILabel()
        fileSizeExceededLabel.translatesAutoresizingMaskIntoConstraints = false
        fileSizeExceededLabel.font = UIFont.systemFont(ofSize: 12)
        fileSizeExceededLabel.text = fileSizeExceededLabelString
        fileSizeExceededLabel.textColor = UIColor.systemRed
        fileSizeExceededLabel.numberOfLines = 2
        return fileSizeExceededLabel
    }()
    
    
    private lazy var attachFilesButtonContainerView: UIView = {
        let attachFilesButtonContainerView = UIView()
        attachFilesButtonContainerView.translatesAutoresizingMaskIntoConstraints = false
        attachFilesButtonContainerView.clipsToBounds = true
        return attachFilesButtonContainerView
    }()
    
    
    private lazy var attachFileImageView: UIImageView = {
        let attachFileImageView = UIImageView()
        attachFileImageView.translatesAutoresizingMaskIntoConstraints = false
        attachFileImageView.image = UIImage(systemName: "paperclip")?.withRenderingMode(.alwaysTemplate)
        attachFileImageView.tintColor = QuartzKit.shared.primaryColor ?? .systemBlue
        attachFileImageView.contentMode = .scaleAspectFit
        attachFileImageView.contentHuggingPriority(for: .horizontal)
        return attachFileImageView
    }()
    
    private lazy var attachFileTextLabel: UILabel = {
        let attachFileTextLabel = UILabel()
        attachFileTextLabel.translatesAutoresizingMaskIntoConstraints = false
        attachFileTextLabel.text = attachFilesString
        attachFileTextLabel.textColor = QuartzKit.shared.primaryColor ?? UIColor.systemBlue
        return attachFileTextLabel
    }()
    
    private lazy var filesAttachmentStackView: UIStackView = {
        let filesAttachmentStackView = UIStackView()
        filesAttachmentStackView.translatesAutoresizingMaskIntoConstraints = false
        filesAttachmentStackView.axis = .vertical
        filesAttachmentStackView.alignment = .fill
        filesAttachmentStackView.distribution = .equalSpacing
        filesAttachmentStackView.spacing = 5
        filesAttachmentStackView.clipsToBounds = true
        return filesAttachmentStackView
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
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedAttachFiles))
        attachFilesButtonContainerView.addGestureRecognizer(tapgesture)
        
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
        attachFilesButtonContainerView.addSubviews(attachFileImageView, attachFileTextLabel)
        
        NSLayoutConstraint.activate([
            attachFileImageView.leadingAnchor.constraint(equalTo: attachFilesButtonContainerView.leadingAnchor, constant: 10),
            attachFileImageView.centerYAnchor.constraint(equalTo: attachFilesButtonContainerView.centerYAnchor),
            attachFileImageView.widthAnchor.constraint(equalToConstant: 20),
            attachFileImageView.heightAnchor.constraint(equalToConstant: 20),
            
            attachFileTextLabel.leadingAnchor.constraint(equalTo: attachFileImageView.trailingAnchor, constant: 10),
            attachFileTextLabel.centerYAnchor.constraint(equalTo: attachFileImageView.centerYAnchor),
            attachFileTextLabel.trailingAnchor.constraint(equalTo: attachFilesButtonContainerView.trailingAnchor)
        ])
        
        containerView.addSubviews(displayLabel, valueContainerView, fileSizeExceededLabel)
        valueContainerView.addSubviews(attachFilesButtonContainerView, filesAttachmentStackView)
        
        let fileSizeExceededHeightConstraint = fileSizeExceededLabel.heightAnchor.constraint(equalToConstant: shouldShowFileSizeExceededLabel ? fileSizeExceededLabelHeight : 0)
        fileSizeExceededLabelConstraint = fileSizeExceededHeightConstraint
        
        
        let attachFileheightConstraint = attachFilesButtonContainerView.heightAnchor.constraint(equalToConstant: attachFileContainerHeight)
        attachFileContainerHeightConstraint = attachFileheightConstraint
        
        NSLayoutConstraint.activate([
            displayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            displayLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            displayLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            displayLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
            
            
            valueContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            valueContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            valueContainerView.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: 10),
            valueContainerView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
          
            filesAttachmentStackView.leadingAnchor.constraint(equalTo: valueContainerView.leadingAnchor),
            filesAttachmentStackView.trailingAnchor.constraint(equalTo: valueContainerView.trailingAnchor),
            filesAttachmentStackView.topAnchor.constraint(equalTo: valueContainerView.topAnchor),
            filesAttachmentStackView.bottomAnchor.constraint(lessThanOrEqualTo: valueContainerView.bottomAnchor),
            
            attachFilesButtonContainerView.leadingAnchor.constraint(equalTo: valueContainerView.leadingAnchor),
            attachFilesButtonContainerView.trailingAnchor.constraint(equalTo: valueContainerView.trailingAnchor),
            attachFilesButtonContainerView.topAnchor.constraint(equalTo: filesAttachmentStackView.bottomAnchor),
            attachFileheightConstraint,
            attachFilesButtonContainerView.bottomAnchor.constraint(lessThanOrEqualTo: valueContainerView.bottomAnchor),
          
            
            fileSizeExceededLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            fileSizeExceededLabel.topAnchor.constraint(equalTo: valueContainerView.bottomAnchor, constant: 10),
            fileSizeExceededLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            fileSizeExceededLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            fileSizeExceededHeightConstraint
        ])
//        displayLabel.backgroundColor = .purple
//        attachFilesButtonContainerView.backgroundColor = .red
//        valueContainerView.backgroundColor = .yellow
//        containerView.backgroundColor = .orange
    }
    
    
    @objc private func tappedAttachFiles(){
        if let viewModel = (vm as? FileAttachmentVM){
            viewModel.attachFileClicked()
        }
    }
    
    func configure(withModel model: IssueSumissionCellVM){
        self.vm = model
        self.vm?.view = self
        updateDisplayTextAndPlaceholderText()
    }
    
    private func updateDisplayTextAndPlaceholderText(){
        guard let vm = vm else {return}
        
        if vm.rowModel.isMandatory{
            let mandatoryText = self.getMandatoryText(forDisplayTxt:  vm.rowModel.displayName)
            displayLabel.attributedText = mandatoryText
        }else{
            displayLabel.text = vm.rowModel.displayName
        }
    }
    
    
    func showFile(at url: URL, withSize size: String){
        let fileView = FileAttachmentView(url: url, size: size)
        fileView.deletionDelegate = self
        fileView.translatesAutoresizingMaskIntoConstraints = false
        filesAttachmentStackView.addArrangedSubview(fileView)
    }
    
    func hideAttachFileButton(){
        attachFileContainerHeightConstraint?.constant = 0
    }
    
    func showAttachFileButton(){
        attachFileContainerHeightConstraint?.constant = attachFileContainerHeight
    }

}

extension IssueSubmissionFileAttachementTableViewCell: FileDeletionDelegate{
    func deleteFile(at url: URL, for view: UIView){
        filesAttachmentStackView.removeArrangedSubview(view)
        view.removeFromSuperview()
        if let viewModel = (vm as? FileAttachmentVM){
            viewModel.removeAttachedFile(at: url)
        }
    }
}


protocol FileDeletionDelegate: AnyObject{
    func deleteFile(at: URL, for: UIView)
}

class FileAttachmentView: UIView{
    
    private let selectedFileUrl: URL
    private let sizeStr: String
    
    weak var deletionDelegate: FileDeletionDelegate? = nil
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor.lightGray
        return separatorView
    }()
    
    private lazy var fileIconImageView: UIImageView = {
        let fileIconImageView = UIImageView()
        fileIconImageView.translatesAutoresizingMaskIntoConstraints = false
        fileIconImageView.image = UIImage(systemName: "doc")?.withRenderingMode(.alwaysTemplate)
        fileIconImageView.tintColor = UIColor.gray
        fileIconImageView.contentMode = .scaleAspectFit
        return fileIconImageView
    }()
    
    private lazy var trashIconImageView: UIImageView = {
        let trashIconImageView = UIImageView()
        trashIconImageView.translatesAutoresizingMaskIntoConstraints = false
        trashIconImageView.image = UIImage(systemName: "trash")?.withRenderingMode(.alwaysTemplate)
        trashIconImageView.tintColor = UIColor.gray
        trashIconImageView.contentMode = .scaleAspectFit
        trashIconImageView.isUserInteractionEnabled = true
//        trashIconImageView.backgroundColor = .red
        return trashIconImageView
    }()
    
    
    private lazy var fileNameLabel: UILabel = {
        let fileNameLabel = UILabel()
        fileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fileNameLabel.font = UIFont.systemFont(ofSize: 15,weight: .semibold)
        fileNameLabel.textColor = UIColor.label
        return fileNameLabel
    }()
    
    
    private lazy var sizeLabel: UILabel = {
        let sizeLabel = UILabel()
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.font = UIFont.systemFont(ofSize: 14)
        sizeLabel.textColor = UIColor.secondaryLabel
        return sizeLabel
    }()
    
    init(url: URL, size: String) {
        self.selectedFileUrl = url
        self.sizeStr = size
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        clipsToBounds = true
        addSubviews(containerView)
        containerView.addSubviews(fileIconImageView, fileNameLabel, sizeLabel, trashIconImageView, separatorView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            fileIconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            fileIconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            fileIconImageView.widthAnchor.constraint(equalToConstant: 20),
            fileIconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            fileNameLabel.leadingAnchor.constraint(equalTo: fileIconImageView.trailingAnchor, constant: 10),
            fileNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor),
            fileNameLabel.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor),
            fileNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
            
            sizeLabel.leadingAnchor.constraint(equalTo: fileNameLabel.leadingAnchor),
            sizeLabel.trailingAnchor.constraint(equalTo: fileNameLabel.trailingAnchor),
            sizeLabel.topAnchor.constraint(equalTo: fileNameLabel.bottomAnchor, constant: 5),
            sizeLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
            
            trashIconImageView.leadingAnchor.constraint(equalTo: fileNameLabel.trailingAnchor, constant: 10),
            trashIconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            trashIconImageView.widthAnchor.constraint(equalToConstant: 20),
            trashIconImageView.heightAnchor.constraint(equalToConstant: 20),
            trashIconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(deleteFileTapped))
        trashIconImageView.addGestureRecognizer(tapgesture)

        
        let fileName = (selectedFileUrl.absoluteString.components(separatedBy: "/").last?.removingPercentEncoding) ?? ""
        fileNameLabel.text = fileName
     
        sizeLabel.text = sizeStr
    }
    
    @objc private func deleteFileTapped(){
        deletionDelegate?.deleteFile(at: selectedFileUrl, for: self)
    }
    
}
