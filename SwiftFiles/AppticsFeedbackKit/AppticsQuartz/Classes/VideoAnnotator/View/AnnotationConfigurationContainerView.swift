//
//  AnnotationConfigurationContainerView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 18/09/23.
//

import UIKit

protocol AnnotationConfigurationViewProcotol: UIView{
    var viewModel: AnnotatorViewModelProtocol{ get }
    var viewFactory: AnnotationConfigurationViewFactory{ get }
}

class AnnotationConfigurationContainerView: UIView, AnnotationConfigurationViewProcotol{
    var viewModel: AnnotatorViewModelProtocol
    var viewFactory: AnnotationConfigurationViewFactory

    init(viewModel: AnnotatorViewModelProtocol, viewFactory: AnnotationConfigurationViewFactory = ConcreteAnnotationConfigurationViewFactory()){
        self.viewModel = viewModel
        self.viewFactory = viewFactory
        super.init(frame: .zero)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        backgroundColor = AnnotationEditorViewColors.thumbnailContainerViewBGColor

        let topPadding: CGFloat = 10
        let bottomPadding: CGFloat = 10
        let leadingPadding: CGFloat = 10
        let trailingPadding: CGFloat = 10

        let videoThumbnailScrollView = viewFactory.createVideoThumbnailView(viewModel: viewModel)
        videoThumbnailScrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(videoThumbnailScrollView)
        
        NSLayoutConstraint.activate([
            videoThumbnailScrollView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: leadingPadding),
            videoThumbnailScrollView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -trailingPadding),
            videoThumbnailScrollView.topAnchor.constraint(equalTo: topAnchor, constant: topPadding),
            videoThumbnailScrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding)
        ])
        
        let trackerView = UIView()
        trackerView.translatesAutoresizingMaskIntoConstraints = false
        trackerView.backgroundColor = QuartzKit.shared.primaryColor ?? UIColor(red: 54.0/255.0, green: 90.0/255.0, blue: 240.0/255.0, alpha: 1)
//        trackerView.layer.cornerRadius = 5
        trackerView.isUserInteractionEnabled = false
        addSubview(trackerView)
        
        NSLayoutConstraint.activate([
            trackerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            trackerView.topAnchor.constraint(equalTo: topAnchor,constant: 0),
            trackerView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 0),
            trackerView.widthAnchor.constraint(equalToConstant: 2)
        ])
        
    }
}
