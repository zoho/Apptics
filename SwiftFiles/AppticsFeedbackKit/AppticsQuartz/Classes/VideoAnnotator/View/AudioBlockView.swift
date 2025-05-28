//
//  AudioBlockView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 29/10/23.
//

import UIKit

protocol AudioBlockViewDelegate: AnyObject{
    
    func allowPan(_ : CGPoint, withOldCenter: CGPoint) -> Bool
    func panAction(_ : CGPoint, withOldCenter: CGPoint)
    
    func allowPanOnLeftHandlerView(_ : CGPoint) -> Bool
    func allowPanOnRightHandlerView(_ : CGPoint) -> Bool
    
    func panActionOnLeftHandlerView(_ : CGPoint)
    func panActionOnRightHandlerView(_ : CGPoint)
}

class AudioBlockView: UIView{
    
    weak var delegate: AudioBlockViewDelegate? = nil
    private let widthOfImageView: CGFloat = 11
    private let heightOfImageView: CGFloat = 15
    
    private let mininmumWidthOfViewToShowAudioImageView: CGFloat = 18 * 2
    private let widthOfHandlerView: CGFloat = 10
    
    var isSelected: Bool = false{
        didSet{
            self.layer.borderWidth = isSelected ? borderWidth : 0
            self.layer.borderColor =  isSelected ? handlerViewColor?.cgColor : UIColor.clear.cgColor
        }
    }
    
    lazy var imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.named("audio")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let handlerViewColor = AnnotationEditorViewColors.selectionBorderColor
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    private let borderWidth = 1.0
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(){
        backgroundColor = AnnotationEditorViewColors.recordedAudioBlockViewBG
        layer.cornerRadius = 4.0
        addSubviews(imgView)
        
        NSLayoutConstraint.activate([
            imgView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imgView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imgView.widthAnchor.constraint(equalToConstant: widthOfImageView),
            imgView.heightAnchor.constraint(equalToConstant: heightOfImageView)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.isHidden = !(frame.size.width > mininmumWidthOfViewToShowAudioImageView)
    }
    
    func configureTapGestureWith(target: Any?, action: Selector?) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tapGesture)
    }
}
