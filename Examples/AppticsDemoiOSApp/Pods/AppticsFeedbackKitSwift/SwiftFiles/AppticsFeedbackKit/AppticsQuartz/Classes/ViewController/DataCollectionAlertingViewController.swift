//
//  DataCollectionAlertingViewController.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 18/11/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import UIKit


class DataCollectionAlertingViewController: UIViewController{
    
    var scrollView: UIScrollView?
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var dataConsentView: DataConsentView = {
        let dataConsentView = DataConsentView()
        dataConsentView.translatesAutoresizingMaskIntoConstraints = false
        return dataConsentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
//        disableDarkMode()
    }
    
    private func configure(){
        view.addSubview(containerView)
        
        view.backgroundColor = IssueRecordingViewColors.dataConsentViewBGColor
        
        let leadingPaddingOfContainerView: CGFloat = 20
        let trailingPaddingOfContainerView: CGFloat = 20
        let topPaddingOfContainerView: CGFloat = 33
        let bottomPaddingOfContainerView: CGFloat = 33
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingPaddingOfContainerView),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -trailingPaddingOfContainerView),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPaddingOfContainerView),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomPaddingOfContainerView)
        ])
        
        containerView.addSubview(dataConsentView)
        
        NSLayoutConstraint.activate([
            dataConsentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dataConsentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dataConsentView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dataConsentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
    }
}
