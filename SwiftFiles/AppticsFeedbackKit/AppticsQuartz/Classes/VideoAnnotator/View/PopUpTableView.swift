//
//  PopUpTableView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 05/11/23.
//

import UIKit

class PopUpTableView: UITableView{
    
    weak var tableDelegate: (UITableViewDelegate & UITableViewDataSource)?
    
    private let triangleLayer: CAShapeLayer = {
        let triangleLayer = CAShapeLayer()
        triangleLayer.fillColor = AnnotationEditorViewColors.shapeColorPickerBGColor?.cgColor
        return triangleLayer
    }()
    
    init(tableDelegate: UITableViewDelegate & UITableViewDataSource){
        self.tableDelegate = tableDelegate
        super.init(frame: .zero, style: .plain)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        triangleLayer.path = getTrianglePath().cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        self.translatesAutoresizingMaskIntoConstraints = false
        delegate = tableDelegate
        dataSource = tableDelegate
        separatorStyle = .none
        layer.cornerRadius = 5
        clipsToBounds = true
        isScrollEnabled = false
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.25
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 1, height: 1)
        
        setNeedsLayout()
        layoutIfNeeded()
        
        addInvertedPopUpTriangle()
    }
    
    func getTrianglePath() -> UIBezierPath{
        let trianglePath = UIBezierPath()
        let triangleSize: CGFloat = 12
        
        trianglePath.move(to: CGPoint(x: bounds.midX - triangleSize/2, y: bounds.height))
        trianglePath.addLine(to: CGPoint(x: bounds.midX + triangleSize/2 , y: bounds.height))
        trianglePath.addLine(to: CGPoint(x: bounds.midX , y: bounds.height + triangleSize))
        trianglePath.close()
        
        return trianglePath
    }
    
    func addInvertedPopUpTriangle() {
        triangleLayer.path = getTrianglePath().cgPath
        layer.addSublayer(triangleLayer)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        triangleLayer.fillColor = AnnotationEditorViewColors.shapeColorPickerBGColor?.cgColor
    }
}


extension UIView {
    
    func addInvertedTriangle() {
        let trianglePath = UIBezierPath()
        let triangleLayer = CAShapeLayer()
        let triangleSize: CGFloat = 12
        
        trianglePath.move(to: CGPoint(x: bounds.midX - triangleSize/2, y: bounds.height))
        trianglePath.addLine(to: CGPoint(x: bounds.midX + triangleSize/2 , y: bounds.height))
        trianglePath.addLine(to: CGPoint(x: bounds.midX , y: bounds.height + triangleSize))
        
        trianglePath.close()
        
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.fillColor = AnnotationEditorViewColors.shapeColorPickerBGColor?.cgColor
        
        layer.addSublayer(triangleLayer)
    }
}
