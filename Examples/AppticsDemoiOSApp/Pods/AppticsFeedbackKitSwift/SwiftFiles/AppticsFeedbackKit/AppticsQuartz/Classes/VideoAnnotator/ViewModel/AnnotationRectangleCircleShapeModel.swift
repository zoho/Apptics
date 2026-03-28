//
//  AnnotationRectangleCircleShapeModel.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 29/12/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import UIKit

protocol AnnotationRectangleCircleShapeModelProtocol{
    var shape: AddedShape { get }
    var isSelected: Bool { get }
    
    var removeImageSystemName: String { get }
    var resizeImageSystemName: String { get }
    var copyImageSystemName: String { get }
    var screenRatio: CGFloat { get } // Ratio of screenwidth to video width
    
    mutating func setSelected(to selected: Bool)
    mutating func setColor(to color: UIColor)
    mutating func setText(_ : String)
    mutating func setBorderStyle(to borderStyle: BorderStyleType)
    mutating func setBorderWidth(to: Int)
    mutating func setTextSize(to: Int)
    mutating func setTextOpacity(to: CGFloat)
    mutating func setTextStyle(to txtStyle: TextStyle)
    mutating func setScreenSize(to ratio: CGFloat)
}


struct AnnotationRectangleCircleShapeModel: AnnotationRectangleCircleShapeModelProtocol {
    
    var shape: AddedShape
    let lineThickness: Int
    var isSelected: Bool
    
    var removeImageSystemName: String
    var copyImageSystemName: String
    var resizeImageSystemName: String
    var screenRatio: CGFloat
    
    init(shape: AddedShape, isSelected: Bool = true, defaultProvider: DefaultShapeAttributesProviderProtocol, aspectRatio: CGFloat) {
        self.shape = shape
        self.isSelected = isSelected
        
        switch shape.type{
        case .rectangle(_, _, let borderWidth):
            self.lineThickness = borderWidth.selectedWidth
        case .circle(_, _, let borderWidth):
            self.lineThickness = borderWidth.selectedWidth
        default:
            self.lineThickness = defaultProvider.defaultLineThickness
        }
        
        self.removeImageSystemName = defaultProvider.removeImageSystemName
        self.resizeImageSystemName = defaultProvider.resizeImageSystemName
        self.copyImageSystemName = defaultProvider.copyImageSystemName
        self.screenRatio = aspectRatio
    }
    
    mutating func setSelected(to selected: Bool) {
        self.isSelected = selected
    }
    
    mutating func setColor(to color: UIColor) {
        shape.type.updateColor(color)
    }
    
    mutating func setBorderStyle(to borderStyle: BorderStyleType) {
        shape.type.updateBorderStyle(borderStyle)
    }
    
    mutating func setBorderWidth(to: Int){
        shape.type.updateBorderWidth(to)
    }
    
    mutating func setText(_ text: String) {
        shape.type.updateText(text)
    }
    
    mutating func setTextSize(to: Int) {
        shape.type.updateTextSize(to)
    }
    
    mutating func setTextOpacity(to: CGFloat){
        shape.type.updateTextOpacity(to)
    }
    
    mutating func setTextStyle(to txtStyle: TextStyle){
        shape.type.updateTextStyle(txtStyle)
    }
    
    mutating func setScreenSize(to ratio: CGFloat){
        self.screenRatio = ratio
    }
}
