//
//  AddedShapeDetails.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 25/10/23.
//

import UIKit
import CoreMedia

struct AddedShapeDetails{
    
    struct ShapeBoundingRectangle: Equatable{ // Represent x,y,width & height of shape interms of factor [0-1] of video bounding rectangle
        private var x: CGFloat
        private var y: CGFloat
        private var width: CGFloat
        private var height: CGFloat
        private var parentSize: CGSize
        private var arrowPoints: ArrowPoints? = nil
        
        init(rect: CGRect, referenceSize: CGSize) {
            let computedX = rect.origin.x / referenceSize.width
            let computedY = rect.origin.y  / referenceSize.height
            let computedWidth = rect.size.width / referenceSize.width
            let computedHeight = rect.size.height / referenceSize.height
            
            x = computedX
            y = computedY
            width = computedWidth
            height = computedHeight
            parentSize = referenceSize
        }
        
        func getDimentionFactors() -> (CGFloat, CGFloat, CGFloat, CGFloat){
            (x, y, width, height)
        }
        
        func getArrowPts() -> ArrowPoints?{
            arrowPoints
        }
        
        func getFrame(in referenceSize: CGSize) -> CGRect{
            let xRet = referenceSize.width * x
            let yRet = referenceSize.height * y
            let widthRet = referenceSize.width * width
            let heightRet = referenceSize.height * height
            return CGRectMake(xRet, yRet, widthRet, heightRet)
        }
    
        mutating func updateFrame(rect: CGRect, parentViewSize: CGSize, arrowPts: ArrowPoints? = nil) {
            parentSize = parentViewSize
            arrowPoints = arrowPts
            
            let computedX = rect.origin.x / parentSize.width
            let computedY = rect.origin.y  / parentSize.height
            let computedWidth = rect.size.width / parentSize.width
            let computedHeight = rect.size.height / parentSize.height
            
            x = computedX
            y = computedY
            width = computedWidth
            height = computedHeight
        }
        
        mutating func update(arrowPts: ArrowPoints? = nil){
            arrowPoints = arrowPts
        }
        
    }
    var shape: AddedShape
    var shapeRect: (x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        rect.getDimentionFactors()
    }
    
    var arrowPoints: ArrowPoints? {
        rect.getArrowPts()
    }
    
    private(set) var rect: ShapeBoundingRectangle
    private(set) var startTime: CMTime
    private(set) var endTime: CMTime
        
    var rowView: ShapeRowViewProtocol? = nil // View added in stack view
    
    init(shape: AddedShape,
         rect: CGRect,
         refSize: CGSize,
         startTime: CMTime,
         endTime: CMTime,
         view: ShapeRowViewProtocol? = nil) {
        self.shape = shape
        self.rect = ShapeBoundingRectangle.init(rect: rect, referenceSize: refSize)
        self.startTime = startTime
        self.endTime = endTime
        self.rowView = view
    }
    
    mutating func update(startTime: CMTime, endTime: CMTime){
        self.startTime = startTime
        self.endTime = endTime
    }
    
    mutating func update(color: UIColor){
        shape.type.updateColor(color)
    }
    
    mutating func update(borderStyle: BorderStyleType){
        shape.type.updateBorderStyle(borderStyle)
    }
    
    mutating func update(txtStyle: TextStyle){
        shape.type.updateTextStyle(txtStyle)
    }
    
    mutating func update(txt: String){
        shape.type.updateText(txt)
    }
    
    mutating func update(borderWidth: Int){
        shape.type.updateBorderWidth(borderWidth)
    }
    
    
    mutating func update(fontSize: Int){
        var nFontSize = FontSize()
        nFontSize.updateSelectedFontSize(fontSize)
        shape.type.updateText(fontSize: nFontSize)
    }
    
    mutating func update(opacity: CGFloat){
        shape.type.updateTextOpacity(opacity)
    }
    
    mutating func update(frame: CGRect, parentViewSize: CGSize, arrowPoints: ArrowPoints? = nil){
        self.rect.updateFrame(rect: frame, parentViewSize: parentViewSize, arrowPts: arrowPoints)
    }
    
    mutating func update(arrowPoints: ArrowPoints? = nil){
        self.rect.update(arrowPts: arrowPoints)
    }
}
