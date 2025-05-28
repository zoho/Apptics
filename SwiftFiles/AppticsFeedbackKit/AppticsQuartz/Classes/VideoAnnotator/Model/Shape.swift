//
//  AddedShape.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 01/11/23.
//

import UIKit

struct AddedShape: Equatable{
    
    typealias TextModel = (color: UIColor, textString: String, fontSize: FontSize, textStyle: TextStyle, textBG: TextBG)
    var type: ShapeType
    
    func getBorderWidth() -> Int? {
        switch self.type{
        case .rectangle(_, _, let borderWidth):
            return borderWidth.selectedWidth
        case .circle(_, _, let borderWidth):
            return borderWidth.selectedWidth
        case .arrow(_, _, let borderWidth):
            return borderWidth.selectedWidth
        default:
            return nil
        }
    }
    
    func getBorderStyle() -> BorderStyleType? {
        switch self.type{
        case .rectangle(_, let borderStyle, _):
            return borderStyle
        case .circle(_, let borderStyle, _):
            return borderStyle
        default:
            return nil
        }
    }
    
    
    func getBorderWidthModel() -> BorderWidth? {
        switch self.type{
        case .rectangle(_, _, let borderWidth):
            return borderWidth
        case .circle(_, _, let borderWidth):
            return borderWidth
        case .arrow(_, _, let borderWidth):
            return borderWidth
        default:
            return nil
        }
    }
    
    func getEnteredText() -> String? {
        guard let model = getTextModel() else {return nil}
        return model.textString
    }
    
    func getTextModel() -> (color: UIColor, textString: String, fontSize: FontSize, textStyle: TextStyle, textBG: TextBG)? {
        switch self.type{
        case .text(let color, let textString, let fontSize, let textStyle, let textBg):
            return (color, textString, fontSize, textStyle, textBg)
        default:
            return nil
        }
    }
    
    func getShapeColor() -> UIColor? {
        switch self.type{
        case .block(let color): return color
        case .circle(let color, _, _): return color
        case .arrow(let color, _, _): return color
        case .rectangle(let color, _, _): return color
        case .text(let color, _, _, _, _): return color
        default: return nil
        }
    }
}

enum BorderStyleType: Equatable{
    case solid, dashed
}

enum TextStyle: Equatable, CaseIterable{
    case regular, bold, italic, boldItalic
    
    var displayValue: String{
        switch self {
        case .regular:
            return "Regular"
        case .bold:
            return "Bold"
        case .italic:
            return "Italics"
        case .boldItalic:
            return "Bold-Italics"
        }
    }
}

struct TextBG: Equatable{
    let opacity: CGFloat
}

struct BorderWidth: Equatable{
    let minWidth: Int
    let maxWidth: Int
    let selectedWidth: Int
    
    init(minWidth: Int = 1, maxWidth: Int = 6, selectedWidth: Int = 3) {
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.selectedWidth = selectedWidth
    }
}

struct FontSize: Equatable{
    let minFontSize: Int
    let maxFontSize: Int
    private(set) var selectedFontSize: Int
    
    init(minFont: Int = 1, maxFont: Int = 10, selectedFont: Int = 4) {
        self.minFontSize = minFont
        self.maxFontSize = maxFont
        self.selectedFontSize = selectedFont
    }
    
    mutating func updateSelectedFontSize(_ to: Int){
        self.selectedFontSize = to
    }
}

enum ShapeType: Equatable{
    case rectangle(color: UIColor, borderStyle: BorderStyleType, borderWidth: BorderWidth)
    case circle(color: UIColor, borderStyle: BorderStyleType, borderWidth: BorderWidth)
    case arrow(color: UIColor, borderStyle: BorderStyleType, borderWidth: BorderWidth)
    case blur
    case text(color: UIColor, textString: String, fontSize: FontSize, textStyle: TextStyle, textBG: TextBG)
    case block(color: UIColor)
    
//    mutating func updateColor(_ newColor: UIColor){
//        switch self {
//        case .rectangle(let color, let borderStyle, let borderWidth):
//            self = .rectangle(color: newColor, borderStyle: borderStyle, borderWidth: borderWidth)
//        case .circle(let color, let borderStyle, let borderWidth):
//            self = .circle(color: newColor, borderStyle: borderStyle, borderWidth: borderWidth)
//        case .text(let color, let textString, let fontSize, let textStyle):
//            self = .text(color: newColor, textString: textString, fontSize: fontSize, textStyle: textStyle)
//        case .block(let color):
//            self = .block(color: newColor)
//        default:break
//        }
//    }
    
    mutating func updateColor(_ newColor: UIColor){
        switch self {
        case .rectangle(_, let borderStyle, let borderWidth):
            self = .rectangle(color: newColor, borderStyle: borderStyle, borderWidth: borderWidth)
        case .circle(_, let borderStyle, let borderWidth):
            self = .circle(color: newColor, borderStyle: borderStyle, borderWidth: borderWidth)
        case .arrow(_, let borderStyle, let borderWidth):
            self = .arrow(color: newColor, borderStyle: borderStyle, borderWidth: borderWidth)
        case .text(_, let textString, let fontSize, let textStyle, let textBg):
            self = .text(color: newColor, textString: textString, fontSize: fontSize, textStyle: textStyle, textBG: textBg)
        case .block(_):
            self = .block(color: newColor)
        default:break
        }
    }
    
    mutating func updateBorderStyle(_ newBorderStyle: BorderStyleType){
        switch self {
        case .rectangle(let color, _, let borderWidth):
            self = .rectangle(color: color, borderStyle: newBorderStyle, borderWidth: borderWidth)
        case .circle(let color, _, let borderWidth):
            self = .circle(color: color, borderStyle: newBorderStyle, borderWidth: borderWidth)
        case .arrow(let color, _, let borderWidth):
            self = .arrow(color: color, borderStyle: newBorderStyle, borderWidth: borderWidth)
        default:break
        }
    }
    
    mutating func updateText(_ text: String){
        switch self {
        case .text(let color, _ , let fontSize, let textStyle, let textBg):
            self = .text(color: color, textString: text, fontSize: fontSize, textStyle: textStyle, textBG: textBg)
    
        default:break
        }
    }

    mutating func updateTextOpacity(_ newOpacity: CGFloat){
        switch self {
        case .text(let color, let txt, let fontSize, let textStyle,_):
            let textBg = TextBG(opacity: newOpacity)
            self = .text(color: color, textString: txt, fontSize: fontSize, textStyle: textStyle, textBG: textBg)
    
        default:break
        }
    }
    
    mutating func updateTextSize(_ newSize: Int){
        switch self {
        case .text(let color,let txt , _, let textStyle, let textBg):
            let size = FontSize(selectedFont: newSize)
            self = .text(color: color, textString: txt, fontSize: size, textStyle: textStyle, textBG: textBg)
    
        default:break
        }
    }
    
    mutating func updateTextStyle(_ newStyle: TextStyle){
        switch self {
        case .text(let color,let txt , let fontSize, _, let textBg):
            self = .text(color: color, textString: txt, fontSize: fontSize, textStyle: newStyle, textBG: textBg)
            
        default:break
        }
    }
    
    mutating func updateBorderWidth(_ newBorderWidth: Int){
        switch self {
        case .rectangle(let color, let borderStyle, let borderWidth ):
            let newModel = BorderWidth(minWidth: borderWidth.minWidth, maxWidth: borderWidth.maxWidth, selectedWidth: newBorderWidth)
            self = .rectangle(color: color, borderStyle: borderStyle, borderWidth: newModel)
        case .circle(let color, let borderStyle, let borderWidth):
            let newModel = BorderWidth(minWidth: borderWidth.minWidth, maxWidth: borderWidth.maxWidth, selectedWidth: newBorderWidth)
            self = .circle(color: color, borderStyle: borderStyle, borderWidth: newModel)
        case .arrow(let color, let borderStyle, let borderWidth):
            let newModel = BorderWidth(minWidth: borderWidth.minWidth, maxWidth: borderWidth.maxWidth, selectedWidth: newBorderWidth)
            self = .arrow(color: color, borderStyle: borderStyle, borderWidth: newModel)

        default:break
        }
    }
    
    mutating func updateText(text updatedText: String? = nil, fontSize newFontSize: FontSize) {
        switch self {
        
        case .text(let color, let textString, _, let textStyle, let textBg):
            if let txt = updatedText{
                self = .text(color: color, textString: txt, fontSize: newFontSize, textStyle: textStyle, textBG: textBg)
            }else{
                self = .text(color: color, textString: textString, fontSize: newFontSize, textStyle: textStyle, textBG: textBg)
            }
        default:break
            
        }
    }
}


//enum ShapeType: Equatable{
//    case rectangle(color: UIColor, borderStyle: BorderStyleType, borderWidth: BorderWidth)
//    case circle(color: UIColor, borderStyle: BorderStyleType, borderWidth: BorderWidth)
//    case blur
//    case text(color: UIColor, textString: String, fontSize: FontSize, textStyle: TextStyle)
//    case block(color: UIColor)
//}

