//
//  IssueSubmissionTableFooterView.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 13/12/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import UIKit

protocol FooterViewModel{
    func submitPressed()
}

class IssueSubmissionTableFooterView: UITableViewHeaderFooterView{
    var viewModel: FooterViewModel?
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    

    private lazy var submitButton: UIButton = {
        let submitButton = UIButton()
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = QuartzKit.shared.primaryColor ?? .systemBlue
        submitButton.setTitleColor(QuartzKit.shared.colorOnPrimaryColor ?? UIColor.label, for: .normal)
        submitButton.layer.cornerRadius = 5
        return submitButton
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubview(containerView)
        
        let leadingPadding: CGFloat = 20
        let trailingPadding: CGFloat = 20
        let topPadding: CGFloat = 10
        let bottomPadding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: leadingPadding),
            containerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -trailingPadding),
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: topPadding),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -bottomPadding)
        ])
        
        containerView.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            submitButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            submitButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func configure(viewModel: FooterViewModel){
        self.viewModel = viewModel
    }
    
    @objc private func submitTapped(){
        self.viewModel?.submitPressed()
    }
}
