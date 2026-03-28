//
//  ConcreteVideoPlayerViewsFactory.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 15/09/23.
//

import Foundation

protocol VideoPlayerViewFactory {
    func createVideoPlayerContainerView(viewModel: AnnotatorViewModelProtocol) -> VideoPlayerContainerViewProtocol
    func createVideoPlayerAndControlViewAndTimeIndicatorView(viewModel: AnnotatorViewModelProtocol) -> (VideoPlayerViewProtocol, VideoControlViewProtocol, PlayerTimeIndicatorView)
    func createAnnotationConfigurationContainerView(viewModel: AnnotatorViewModelProtocol) -> AnnotationConfigurationViewProcotol
}

class ConcreteVideoPlayerViewFactory: VideoPlayerViewFactory {
    
    func createVideoPlayerContainerView(viewModel: AnnotatorViewModelProtocol) -> VideoPlayerContainerViewProtocol{
        VideoPlayerContainerView(viewModel: viewModel)
    }
    
    func createVideoPlayerAndControlViewAndTimeIndicatorView(viewModel: AnnotatorViewModelProtocol) -> (VideoPlayerViewProtocol, VideoControlViewProtocol, PlayerTimeIndicatorView){
        var vm = viewModel
        let videoPlayerView = ViewPlayerView(viewModel: vm)
        let controlView = VideoControlView(viewModel: viewModel)
        let timeIndicatorView = PlayerTimeIndicatorView()
        
        vm.playerViewDelegate = videoPlayerView
        vm.controlViewDelegate = controlView
        vm.timeLabelUpdaterDelegate = timeIndicatorView
        
        return (videoPlayerView, controlView, timeIndicatorView)
    }
    
    func createAnnotationConfigurationContainerView(viewModel: AnnotatorViewModelProtocol) -> AnnotationConfigurationViewProcotol{
        AnnotationConfigurationContainerView(viewModel: viewModel)
    }
}

protocol AnnotationConfigurationViewFactory{
    func createVideoThumbnailView(viewModel: AnnotatorViewModelProtocol) -> VideoThumbnailViewProtocol
}

class ConcreteAnnotationConfigurationViewFactory: AnnotationConfigurationViewFactory {
    
    func createVideoThumbnailView(viewModel: AnnotatorViewModelProtocol) -> VideoThumbnailViewProtocol{
        let videoThumbnailView = VideoThumbnailView(viewModel: viewModel)
        var vm = viewModel
        vm.videoThumbnailViewDelegate = videoThumbnailView
        return videoThumbnailView
    }
    
    
}
