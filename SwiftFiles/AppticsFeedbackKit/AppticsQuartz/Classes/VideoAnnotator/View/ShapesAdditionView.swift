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
    private let cutModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.trim"), imgName: "cut", type: .cut)
    private let maskModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.mask"), imgName: "blur", type: .mask)
    private let shapesModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.shapes"), imgName: "circlerect", type: .shapes)
    private let textModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.text"), imgName: "text", type: .text)
    private let audioModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.audio"), imgName: "mic", type: .audio)

    private let blockModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.block"), imgName: "block", type: .block)
    private let blurModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.blur"), imgName: "blur", type: .blur)
    
    private let rectangleModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.rectangle"), imgName: "rectangle", type: .rectangle)
    private let ovalModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.oval"), imgName: "ellipse", type: .oval)
    private let arrowModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.arrow"), imgName: "line", type: .arrow)
    
    private let shapeColorModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.color"), imgName: "", type: .shapeColor)
    private let blockColorModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.color"), imgName: "", type: .blockColor)
    
    private let arrowColorModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.color"), imgName: "", type: .arrowColor)
    private let arrowWidthModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.width"), imgName: "borderwidth", type: .arrowWidth)
    
    private let borderStyleModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.style"), imgName: "borderstyle", type: .borderStyle)
    private let borderWidthModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.width"), imgName: "borderwidth", type: .borderWidth)
    
    private let editTextModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.edit"), imgName: "pencil", type: .textEdit)
    private let textSizeModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.size"), imgName: "textsize", type: .textSize)
    private let textStyleModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.style"), imgName: "textstyle", type: .textStyle)
    private let textBackgroundModel = NameAndImageNameModel(name: QuartzKitStrings.localized("videoannotationscreen.label.background"), imgName: "text_background", type: .textBG)
    
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
