//
//  HandlerView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 04/10/23.
//

import UIKit

protocol HandlerViewDelegate: AnyObject{
    func shouldStartPan(_ newCenter: CGPoint, withOldCenter oldCenter: CGPoint) -> Bool
    func allowPan(_ newCenter: CGPoint, withOldCenter oldCenter: CGPoint) -> Bool
    func panAction(_ newCenter: CGPoint, withOldCenter oldCenter: CGPoint, velocity: CGFloat)
    func panEnded()
}

class HandlerView: UIView{
    var shouldAddCurveAtFront = true
    var yOffset: CGFloat = 0
    
    weak var delegate: HandlerViewDelegate?
    var isShownOutsideOfParent: Bool = false
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.masksToBounds = true
        containerView.isUserInteractionEnabled = false
        return containerView
    }()
    
    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = AnnotationEditorViewColors.handlerViewCenterLineColor
        lineView.isUserInteractionEnabled = false
        return lineView
    }()
    
    private lazy var topArcLayer : CAShapeLayer = {
        let topArcLayer = CAShapeLayer()
        topArcLayer.zPosition = 0
        return topArcLayer
    }()
    
    private lazy var bottomArcLayer : CAShapeLayer = {
        let bottomArcLayer = CAShapeLayer()
        bottomArcLayer.zPosition = 0
        return bottomArcLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubviews(containerView)
        containerView.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            lineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            lineView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 1),
            lineView.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        pangesture.delegate = self
        pangesture.cancelsTouchesInView = true
        addGestureRecognizer(pangesture)
    }
    
    @objc func panAction(_ gestureRecognizer: UIPanGestureRecognizer){
        guard let superview = self.superview else { return }
        let translation = gestureRecognizer.translation(in: superview)
        let velocity = gestureRecognizer.velocity(in: superview).x
        var newCenter = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        if isShownOutsideOfParent{
            newCenter.x = max(-bounds.width / 2, min(superview.bounds.width + bounds.width / 2, newCenter.x))
            newCenter.y = max(bounds.height / 2, min(superview.bounds.height - bounds.height / 2, newCenter.y))
        }else{
            newCenter.x = max(bounds.width / 2, min(superview.bounds.width - bounds.width / 2, newCenter.x))
            newCenter.y = max(bounds.height / 2, min(superview.bounds.height - bounds.height / 2, newCenter.y))
        }
        if newCenter != center{
            let canSetNewCenter = delegate?.allowPan(newCenter, withOldCenter: center) ?? false
            if canSetNewCenter{
                delegate?.panAction(newCenter, withOldCenter: center, velocity: velocity)
            }
        }
        gestureRecognizer.setTranslation(.zero, in: superview)
        
        if gestureRecognizer.state == .ended{
            delegate?.panEnded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        configureInsideCornerRadius()
    }
    
    func applyCornerRadus(of cornerRadius: CGFloat, toCorners corners: CACornerMask, bgColor: UIColor){
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.maskedCorners = corners
        containerView.backgroundColor = bgColor
    }
    
    private func configureInsideCornerRadius(){
        let topPath = UIBezierPath()
        let bottomPath = UIBezierPath()
        
        let xOffset: CGFloat = containerView.layer.cornerRadius
        
        if shouldAddCurveAtFront{
            topPath.move(to: CGPoint(x: frame.size.width, y: yOffset))
            topPath.addLine(to: CGPoint(x: frame.size.width + xOffset , y: yOffset))
            topPath.addArc(withCenter: CGPoint(x: frame.size.width + xOffset , y: xOffset+yOffset), radius: xOffset, startAngle: CGFloat(Double.pi/2 * 3), endAngle: CGFloat(Double.pi), clockwise: false)
            topPath.addLine(to: CGPoint(x: frame.size.width, y: yOffset))
            
            bottomPath.move(to: CGPoint(x: frame.size.width, y: frame.size.height-yOffset))
            bottomPath.addLine(to: CGPoint(x: frame.size.width + xOffset, y: frame.size.height - yOffset))
            bottomPath.addArc(withCenter: CGPoint(x: frame.size.width + xOffset , y: frame.size.height - yOffset - xOffset ), radius: xOffset, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: true)
            bottomPath.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height-yOffset))
    
        }else{
            topPath.move(to: CGPoint(x: 0, y: yOffset))
            topPath.addLine(to: CGPoint(x: -xOffset, y: yOffset))
            topPath.addArc(withCenter: CGPoint(x: -xOffset, y: xOffset + yOffset), radius: xOffset, startAngle: CGFloat(Double.pi/2 * 3), endAngle: CGFloat(2*Double.pi), clockwise: true)
            topPath.addLine(to: CGPoint(x: 0, y: yOffset))
            
            bottomPath.move(to: CGPoint(x: 0, y: frame.size.height-yOffset))
            bottomPath.addLine(to: CGPoint(x: -xOffset, y: frame.size.height-yOffset))
            bottomPath.addArc(withCenter: CGPoint(x: -xOffset, y: frame.size.height - (xOffset+yOffset)), radius: xOffset, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(2*Double.pi), clockwise: false)
            bottomPath.addLine(to: CGPoint(x: 0, y: frame.size.height-yOffset))
        }
    
        if topArcLayer.superlayer == nil{
            layer.addSublayer(topArcLayer)
            topArcLayer.lineWidth = 0
        }
        
        if bottomArcLayer.superlayer == nil{
            layer.addSublayer(bottomArcLayer)
            bottomArcLayer.lineWidth = 0
        }
        
        topArcLayer.fillColor = containerView.backgroundColor?.cgColor
        bottomArcLayer.fillColor = containerView.backgroundColor?.cgColor
        topArcLayer.strokeColor = containerView.backgroundColor?.cgColor
        bottomArcLayer.strokeColor = containerView.backgroundColor?.cgColor

        topArcLayer.path = topPath.cgPath
        bottomArcLayer.path = bottomPath.cgPath
    }
}

extension HandlerView: UIGestureRecognizerDelegate{
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let superview = self.superview, let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {return false}
        let translation = panGesture.translation(in: superview)
        
        var newCenter = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        if isShownOutsideOfParent{
            newCenter.x = max(-bounds.width / 2, min(superview.bounds.width + bounds.width / 2, newCenter.x))
            newCenter.y = max(bounds.height / 2, min(superview.bounds.height - bounds.height / 2, newCenter.y))
        }else{
            newCenter.x = max(bounds.width / 2, min(superview.bounds.width - bounds.width / 2, newCenter.x))
            newCenter.y = max(bounds.height / 2, min(superview.bounds.height - bounds.height / 2, newCenter.y))
        }
        let shouldStart = delegate?.shouldStartPan(newCenter, withOldCenter: center) ?? true
        return shouldStart
    }
}
