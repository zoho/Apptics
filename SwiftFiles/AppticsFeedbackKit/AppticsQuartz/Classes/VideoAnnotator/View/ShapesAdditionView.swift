//
//  ShapesAdditionView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 20/10/23.
//

import UIKit

enum NameAndImageNameModelType{
    case cut, mask, shapes, text, audio, rectangle, oval, arrow, shapeColor, arrowColor, arrowWidth, blockColor, borderStyle, borderWidth, block, blur, textEdit, textSize, textStyle, textBG
}

struct NameAndImageNameModel{
    let name: String
    let imgName: String
    let type: NameAndImageNameModelType
}

struct ShapeAddViewDefaultsProvider{
    private let cutModel = NameAndImageNameModel(name: "Trim", imgName: "cut", type: .cut)
    private let maskModel = NameAndImageNameModel(name: "Mask", imgName: "blur", type: .mask)
    private let shapesModel = NameAndImageNameModel(name: "Shapes", imgName: "circlerect", type: .shapes)
    private let textModel = NameAndImageNameModel(name: "Text", imgName: "text", type: .text)
    private let audioModel = NameAndImageNameModel(name: "Audio", imgName: "mic", type: .audio)

    private let blockModel = NameAndImageNameModel(name: "Block", imgName: "block", type: .block)
    private let blurModel = NameAndImageNameModel(name: "Blur", imgName: "blur", type: .blur)
    
    private let rectangleModel = NameAndImageNameModel(name: "Rectangle", imgName: "rectangle", type: .rectangle)
    private let ovalModel = NameAndImageNameModel(name: "Oval", imgName: "ellipse", type: .oval)
    private let arrowModel = NameAndImageNameModel(name: "Arrow", imgName: "line", type: .arrow)
    
    private let shapeColorModel = NameAndImageNameModel(name: "Color", imgName: "", type: .shapeColor)
    private let blockColorModel = NameAndImageNameModel(name: "Color", imgName: "", type: .blockColor)
    
    private let arrowColorModel = NameAndImageNameModel(name: "Color", imgName: "", type: .arrowColor)
    private let arrowWidthModel = NameAndImageNameModel(name: "Width", imgName: "borderwidth", type: .arrowWidth)
    
    private let borderStyleModel = NameAndImageNameModel(name: "Style", imgName: "borderstyle", type: .borderStyle)
    private let borderWidthModel = NameAndImageNameModel(name: "Width", imgName: "borderwidth", type: .borderWidth)
    
    private let editTextModel = NameAndImageNameModel(name: "Edit", imgName: "pencil", type: .textEdit)
    private let textSizeModel = NameAndImageNameModel(name: "Size", imgName: "textsize", type: .textSize)
    private let textStyleModel = NameAndImageNameModel(name: "Style", imgName: "textstyle", type: .textStyle)
    private let textBackgroundModel = NameAndImageNameModel(name: "Background", imgName: "text_background", type: .textBG)
    
    func getListOfModelsToDisplayInShapeAdditionView() -> [NameAndImageNameModel]{
        return [cutModel,maskModel,shapesModel,textModel,audioModel]
    }
    
    func getListOfModelsToDisplayInShapeAdditionViewAfterShapesTapped() -> [NameAndImageNameModel]{
        return [rectangleModel,ovalModel,arrowModel]
    }
    
    func getListOfModelsToDisplayInShapeAdditionViewAfterMaskTapped() -> [NameAndImageNameModel]{
        return [blockModel,blurModel]
    }
    
    func getListOfModelsToShowInShapeAttributesView() -> [NameAndImageNameModel]{
        return [shapeColorModel,borderStyleModel,borderWidthModel]
    }
    
    func getListOfModelsToShowInArrowShapeAttributesView() -> [NameAndImageNameModel]{
        return [arrowColorModel,arrowWidthModel]
    }
    
    func getListOfModelsToShowInTextAttributesView() -> [NameAndImageNameModel]{
        return [shapeColorModel,textSizeModel,textStyleModel,textBackgroundModel]
//        return [editTextModel,shapeColorModel,textSizeModel,textStyleModel]
    }
    
    func getListOfModelsToShowInBlockAttributesView() -> [NameAndImageNameModel]{
        return [blockColorModel]
    }
    
    
}
