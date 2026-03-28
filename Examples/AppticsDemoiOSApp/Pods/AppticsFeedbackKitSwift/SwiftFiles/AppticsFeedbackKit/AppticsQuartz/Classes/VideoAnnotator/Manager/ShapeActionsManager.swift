//
//  ShapeActionsManager.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 18/10/23.
//

import UIKit
import CoreMedia

enum UndoableActionType{
    case addition(AddedShapeDetails, AnnotationShapeViewProtocol, ShapeRowViewProtocol),
         deletion(AddedShapeDetails, AnnotationShapeViewProtocol, ShapeRowViewProtocol),
         colorChange(UIColor, UIColor, AnnotationShapeViewProtocol, ShapeRowViewProtocol),
         frameChange((CGFloat, CGFloat, CGFloat, CGFloat), (CGFloat, CGFloat, CGFloat, CGFloat), AnnotationShapeViewProtocol, ShapeRowViewProtocol, ArrowPoints?, ArrowPoints?),
         borderStyleChange(BorderStyleType, BorderStyleType, AnnotationShapeViewProtocol, ShapeRowViewProtocol),
         borderWidthChange(BorderWidth, BorderWidth, AnnotationShapeViewProtocol, ShapeRowViewProtocol),
         txtSizeChange(FontSize, FontSize, AnnotationShapeViewProtocol, ShapeRowViewProtocol),
         txtOpacityChange(TextBG, TextBG, AnnotationShapeViewProtocol, ShapeRowViewProtocol),
         txtStyleChange(TextStyle, TextStyle, AnnotationShapeViewProtocol, ShapeRowViewProtocol),
         videoTrimming(CMTime, CMTime, CMTime, CMTime),
         videoTrimmingDeletion(CMTime, CMTime),
         shapeRowViewTimeChanges(CGFloat, CGFloat ,CGFloat, CGFloat, CMTime, CMTime, CMTime, CMTime, AnnotationShapeViewProtocol, ShapeRowViewProtocol),
         audioAddition(AudioModel),
         audioDeletion(AudioModel),
         audioOfRecordedVideoDeletion
}

struct Action: CustomStringConvertible{
    var description: String{
        switch type{
        case .addition: return "Addition"
        case .deletion: return "Deletion"
        case .colorChange: return "Color Change"
        case .frameChange: return "Frame Change"
        case .borerStyleChange: return "Border Style Change"
        case .borderWidthChange: return "Border Width Change"
        case .txtSizeChange: return "Font Size Change"
        case .txtStyleChange: return "Font Style Change"
        case .videoTrimming: return "Video Trimming"
        case .videoTrimmingDeletion: return "Video Trimming Deletion"
        case .shapeDisplayingTimeChange: return "Shape View Time Changes"
        case .audioAddition: return "Audio Addition"
        case .audioDeletion: return "Audio Deletion"
        case .audioOfRecordedVideoDeletion: return "Audio Of Recorded Video Deletion"
        case .txtOpacityChange: return "Text Opactiy change"
        }
    }
    
    enum ActionType{
        case frameChange(from: (CGFloat, CGFloat, CGFloat, CGFloat), to: (CGFloat, CGFloat, CGFloat, CGFloat))
        case colorChange(from: Int, to: Int)
        case deletion(details: AddedShapeDetails)
        case addition(details: AddedShapeDetails)
        case borerStyleChange(from: BorderStyleType, to: BorderStyleType)
        case borderWidthChange(from: BorderWidth, to: BorderWidth)
        case txtSizeChange(from: FontSize, to: FontSize)
        case txtOpacityChange(from: TextBG, to: TextBG)
        case txtStyleChange(from: TextStyle, to: TextStyle)
        case videoTrimming(oldStartTime: CMTime, oldEndTime: CMTime, newStartTime: CMTime, newEndTime: CMTime)
        case videoTrimmingDeletion(startTime: CMTime, endTime: CMTime)
        case shapeDisplayingTimeChange(oldXOffset: CGFloat, oldWidth: CGFloat, newXOffset: CGFloat, newWidth: CGFloat, oldStartTime: CMTime, oldEndTime: CMTime, newStartTime: CMTime, newEndTime: CMTime)
        case audioAddition(model: AudioModel)
        case audioDeletion(model: AudioModel)
        case audioOfRecordedVideoDeletion
    }
    let type: ActionType
    let sourceView: AnnotationShapeViewProtocol?
    let rowView: ShapeRowViewProtocol?
    let arrowPointsChange: (ArrowPoints, ArrowPoints)?
    
    init(type: ActionType, sourceView: AnnotationShapeViewProtocol? = nil, rowView: ShapeRowViewProtocol? = nil, arrowPointsChange: (ArrowPoints, ArrowPoints)? = nil) {
        self.type = type
        self.sourceView = sourceView
        self.rowView = rowView
        self.arrowPointsChange = arrowPointsChange
    }
}


protocol UndoProtocol{
    var areActionsAvailable: Bool { get }
    var noOfActionsAvailable: Int { get }
    func add(_ : Action)
    func remove() -> Action?
}


class UndoActionManager: UndoProtocol, CustomStringConvertible{
    
    var description: String{
        return String(describing: stack)
    }
    
    private var stack = Stack<Action>()
    
    var noOfActionsAvailable: Int {
        stack.noOfElements
    }
    
    var areActionsAvailable: Bool{
        !stack.isEmpty
    }
    
    func add(_ action: Action) {
        stack.push(action)
    }
    
    @discardableResult func remove() -> Action? {
        stack.pop()
    }
    
    func removeAll() {
        stack.removeAll()
    }
}
