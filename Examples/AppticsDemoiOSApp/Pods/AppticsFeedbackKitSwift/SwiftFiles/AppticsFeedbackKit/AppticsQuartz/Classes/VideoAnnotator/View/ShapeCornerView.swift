//
//  ShapeCornerView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 31/10/23.
//

import UIKit

enum CornerViewType {
    case topLeft, topRight, bottomLeft, bottomRight, arrowStart, arrowEnd
}


protocol CornerViewDelegateProtocol{
    func panAction(_ : CGPoint, type: CornerViewType)
    func panEnded(type: CornerViewType)
}

class ShapeCornerView: UIView{
    let delegate: CornerViewDelegateProtocol?

    private let borderThickness: CGFloat = 1
    private let borderColor = QuartzKit.shared.primaryColor ?? UIColor.blue
    private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    
    let type: CornerViewType
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        return containerView
    }()
    
    init(type: CornerViewType, delegate: CornerViewDelegateProtocol? = nil){
        self.type = type
        self.delegate = delegate
        super.init(frame: .zero)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubview(containerView)
        backgroundColor = .clear
        containerView.backgroundColor = .white
        
        addGestureRecognizer(panGesture)
        
        containerView.layer.borderColor = borderColor.cgColor
        containerView.layer.borderWidth = borderThickness
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: 10),
            containerView.heightAnchor.constraint(equalToConstant: 10),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let superview = self.superview else { return }
        let translation = gestureRecognizer.translation(in: superview)
        delegate?.panAction(translation, type: type)
        gestureRecognizer.setTranslation(.zero, in: superview)
        
        if gestureRecognizer.state == .ended {
            delegate?.panEnded(type: type)
        }
    }
}
