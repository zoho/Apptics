//
//  RotatingProgressView.swift
//  
//
//  Created by Jaffer Sheriff U on 30/05/24.
//

import UIKit

class RotatingProgressView: UIView{
    private var progress: CGFloat = 0.3{
        didSet{setNeedsLayout()}
    }
    
    private var color = QuartzKit.shared.primaryColor ?? UIColor.systemBlue

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private let bgMask = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private var ringWidth: CGFloat = 3
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        setupLayers()
    }
    
    private func setupLayers() {
        bgMask.lineWidth = ringWidth
        bgMask.fillColor = nil
        bgMask.strokeColor = UIColor.black.cgColor
        layer.mask = bgMask
        
        progressLayer.lineWidth = ringWidth
        progressLayer.fillColor = nil
        layer.addSublayer(progressLayer)
        layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)
    }
    
    func animate(){
        createAnimation()
    }
    
    private func createAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = CGFloat(Double.pi / 2)
        rotationAnimation.toValue = CGFloat(2.5 * Double.pi)
        rotationAnimation.repeatCount = Float.infinity
        rotationAnimation.duration = 0.75
        layer.removeAnimation(forKey: "rotationAnimation")
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: 5, dy: 5)).cgPath
        bgMask.path = circlePath
        
        progressLayer.path = circlePath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = progress
        progressLayer.strokeColor = color.cgColor
    }
}
