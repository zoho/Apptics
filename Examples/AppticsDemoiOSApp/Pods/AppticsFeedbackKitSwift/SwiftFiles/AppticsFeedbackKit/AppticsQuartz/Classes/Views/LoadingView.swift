//
//  LoadingView.swift
//  
//
//  Created by Jaffer Sheriff U on 30/05/24.
//

import UIKit

class LoadingView: UIView{
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        containerView.isUserInteractionEnabled = true
        return containerView
    }()
    
    private let centerContainerView: UIView = {
        let centerContainerView = UIView()
        centerContainerView.translatesAutoresizingMaskIntoConstraints = false
        centerContainerView.backgroundColor = UIColor.white
        centerContainerView.isUserInteractionEnabled = true
        centerContainerView.layer.cornerRadius = 10
        centerContainerView.backgroundColor = LoadingViewColors.loadingViewBg
        centerContainerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        return centerContainerView
    }()
    
    private let innerContainerView: UIView = {
        let innerContainerView = UIView()
        innerContainerView.translatesAutoresizingMaskIntoConstraints = false
        return innerContainerView
    }()
    
    private let rotatingProgressView: RotatingProgressView = {
        let rotatingProgressView = RotatingProgressView()
        rotatingProgressView.translatesAutoresizingMaskIntoConstraints = false
        rotatingProgressView.backgroundColor = LoadingViewColors.circularLoaderUnfilledColor
        return rotatingProgressView
    }()
    
    
    private let submittingLabel: UILabel = {
        let submittingLabel = UILabel()
        submittingLabel.translatesAutoresizingMaskIntoConstraints = false
        submittingLabel.text = IssueSubmissionViewStringsProvider.submittingText
        submittingLabel.textColor = LoadingViewColors.submittingTextColor
        submittingLabel.font = UIFont.systemFont(ofSize: 16)
        return submittingLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
        overrideUserInterfaceStyle = QuartzKit.shared.uiMode
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoading(){
        rotatingProgressView.animate()
    }
    
    private func configure(){
        
        let centerContainerViewWidth: CGFloat = 250
        let centerContainerViewHeight: CGFloat = 160
        
        let rotatingProgressViewWidth: CGFloat = 50
        let rotatingProgressViewHeight: CGFloat = 50
        
        addSubview(containerView)
        containerView.addSubview(centerContainerView)
        centerContainerView.addSubview(innerContainerView)
        innerContainerView.addSubviews(rotatingProgressView, submittingLabel)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            centerContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            centerContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            centerContainerView.widthAnchor.constraint(equalToConstant: centerContainerViewWidth),
            centerContainerView.heightAnchor.constraint(equalToConstant: centerContainerViewHeight),
            
            innerContainerView.centerXAnchor.constraint(equalTo: centerContainerView.centerXAnchor),
            innerContainerView.centerYAnchor.constraint(equalTo: centerContainerView.centerYAnchor),
            innerContainerView.widthAnchor.constraint(equalTo: centerContainerView.widthAnchor),
            innerContainerView.heightAnchor.constraint(lessThanOrEqualTo: centerContainerView.heightAnchor),
            
            rotatingProgressView.topAnchor.constraint(equalTo: innerContainerView.topAnchor),
            rotatingProgressView.centerXAnchor.constraint(equalTo: innerContainerView.centerXAnchor),
            rotatingProgressView.heightAnchor.constraint(equalToConstant: rotatingProgressViewWidth),
            rotatingProgressView.widthAnchor.constraint(equalToConstant: rotatingProgressViewHeight),
            
            submittingLabel.leadingAnchor.constraint(greaterThanOrEqualTo: innerContainerView.leadingAnchor),
            submittingLabel.trailingAnchor.constraint(lessThanOrEqualTo: innerContainerView.trailingAnchor),
            submittingLabel.centerXAnchor.constraint(equalTo: innerContainerView.centerXAnchor),
            submittingLabel.topAnchor.constraint(equalTo: rotatingProgressView.bottomAnchor, constant: 15),
            submittingLabel.bottomAnchor.constraint(equalTo: innerContainerView.bottomAnchor)
        ])
    }
}
