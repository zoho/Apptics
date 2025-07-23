//
//  ToolBarViewModel.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 01/11/23.
//

import UIKit

struct BorderStyleModel{
    let text: String
    let type: BorderStyleType
}

protocol ToolBarViewModelProtocol: AnyObject, ShapeActionDelegateProtocol{
    var view: ToolBarViewProtocol? { get set }
    var annotatorViewModel: ToolBarActionExecutingProtocol? { get }
    var items: [NameAndImageNameModel] { get }
    var rectOvalShapeAdditionItems: [NameAndImageNameModel] { get }
    var maskBlurShapeAdditionItems: [NameAndImageNameModel] { get }
    
    var shapeAttributesItems: [NameAndImageNameModel] { get }
    var arrowShapeAttributesItems: [NameAndImageNameModel] { get }
    var textAttributesItems: [NameAndImageNameModel] { get }
    var blockAttributesItems: [NameAndImageNameModel] { get }
    
//    var borderStyleModel: [BorderStyleModel] { get }
//    
    
    func updateTrimmedVideoDuration(with: String)
    
    func trimmingConfirmationButtonClicked()
    func trimmingCancelButtonClicked()
    func updateViewAfterTrimming()
    func updateViewWithRectangelOvalShapeAddition()
    func updateViewWithMaskBlurShapeAddition()
    
    func showShapeRelatedAttributeOptions(selectedColor: UIColor, isOval: Bool)
    func showArrowRelatedAttributeOptions(selectedColor: UIColor)
    
    func showShapeColorAttributeOption(withColors: [UIColor], selectedColorIndex: Int)
    func showTextColorAttributeOption(withColors: [UIColor], selectedColorIndex: Int)
    
    func showBlockRelatedAttributeOptions(selectedColor: UIColor)
    func showBlockColorAttributeOption(withColors: [UIColor], selectedColorIndex: Int)
    
    func showArrowColorAttributeOption(withColors: [UIColor], selectedColorIndex: Int)
    func showArrowWidthAttributeOption(borderWidthModel: BorderWidth, selectedColor: UIColor)
    
    func showTextRelatedAttributeOptions(selectedColor: UIColor)
    
    func showBorderStyleAttributeOption(selectedBorderStyleType: BorderStyleType, selectedColor: UIColor, isOval: Bool)
    func showBorderWidthAttributeOption(borderWidthModel: BorderWidth, selectedColor: UIColor, isOval: Bool)
    
    func showAudioRecorder()
    
    func colorSelected(atIndex: Int)
    func itemSelected()
    
    func refreshUIBasedOnCurrentState()
    
    func updateUIBasedOnSelected(shapeType: ShapeType)
    //    func startAudioRecording()
    //    func stopAudioRecording()
    func audioRecordingButtonTapped()
    func audioRecordingButton(shouldEnable: Bool)
    
    func audioRecordingStarted()
    func audioRecordingEnded()
    func videoTapped()
    func shapeColorSelected(_ selectedColor: UIColor, isOval: Bool)
    func dismissBorderStyleMenu(_ selectedColor: UIColor, isOval: Bool)
    func dismissBorderWidthMenu(_ selectedColor: UIColor, isOval: Bool)
    func selectedShapeDeleted()
    func updateBorderWidth(to: Int)
    func borderWidthChangesEnded(to: Int)
    func dismissTxtRelatedMenus(_ selectedColor: UIColor)
    func updateTextSize(to: Int)
    func textSizeChangesEnded(to: Int)
    
    func updateTextOpacity(to: CGFloat)
    func textOpacityChangesEnded(to: CGFloat)
    
    func blockColorSelected(_ selectedColor: UIColor)
    func arrowColorSelected(_ selectedColor: UIColor)
    func textColorSelected(_ selectedColor: UIColor)
    
    func showTextEditWith(text: String)
    func showTextSizeSelectionWith(model: AddedShape.TextModel)
    func showTextStyleSelectionWith(model: AddedShape.TextModel)
    func showTextBGSelectionWith(model: AddedShape.TextModel)

    func setTableSelected(index: Int)
    
    func getTableViewItemsToShow() -> [TableModel]
    func getTableSelectedIndex() -> Int
}

struct TableModel{
    let displayText: String
}

protocol ShapeActionDelegateProtocol {
    func tapped(model: NameAndImageNameModel)
    func textEntered(model: NameAndImageNameModel, text: String)
}

enum State{
    case initialShapeAddition,
         videoTrimming,
         videoTrimmingWithDuration(String),
         rectOvalShapeAddition,
         maskBlurShapeAddition,
         shapeAttribute(UIColor, Bool),
         arrowShapeAttribute(UIColor),
         textAttribute(UIColor),
         textEditMode(String),
         textSizeMode(FontSize),
         textStyleMode(TextStyle),
         textBGMode(TextBG),
         shapeColorPalatte([UIColor],Int),
         textColorPalatte([UIColor],Int),
         blockAttribute(UIColor),
         blockColorPalatte([UIColor],Int),
         arrowColorPalatte([UIColor],Int),
         arrowBorderWidthPalatte(BorderWidth, UIColor),
         borderStylePalatte([BorderStyleModel] ,Int, UIColor, Bool),
         borderWidthPalatte(BorderWidth, UIColor, Bool),
         audioRecording(Bool),
         audioRecordingButtonEnabled(Bool)
}



class ToolBarViewModel: ToolBarViewModelProtocol{
    
    weak var view: ToolBarViewProtocol?
    weak var annotatorViewModel: ToolBarActionExecutingProtocol? = nil
    
    private let shapesDefaultProvider = ShapeAddViewDefaultsProvider()
    
    var items: [NameAndImageNameModel] = []
    var rectOvalShapeAdditionItems: [NameAndImageNameModel] = []
    var maskBlurShapeAdditionItems: [NameAndImageNameModel] = []
    
    var shapeAttributesItems: [NameAndImageNameModel] = []
    var arrowShapeAttributesItems: [NameAndImageNameModel] = []
    var textAttributesItems: [NameAndImageNameModel] = []
    var blockAttributesItems: [NameAndImageNameModel] = []
    
    private var currentState: State = .initialShapeAddition {
        didSet{
            view?.currentState = currentState
        }
    }
    
    
    private var tableSelectedIndex: Int = 0
    private var tableModels: [TableModel] = []
    
    lazy var borderStyleModel: [BorderStyleModel] = {
        let solid = BorderStyleModel(text: QuartzKitStrings.localized("videoannotationscreen.alert.stroketypesolid"), type: .solid)
        let dashed = BorderStyleModel(text: QuartzKitStrings.localized("videoannotationscreen.alert.stroketypedashed"), type: .dashed)
        return [solid,dashed]
    }()
    
    
    init(annotatorViewModel: ToolBarActionExecutingProtocol) {
        self.annotatorViewModel = annotatorViewModel
        configure()
    }
    
    private func configure(){
        items = shapesDefaultProvider.getListOfModelsToDisplayInShapeAdditionView()
        rectOvalShapeAdditionItems = shapesDefaultProvider.getListOfModelsToDisplayInShapeAdditionViewAfterShapesTapped()
        maskBlurShapeAdditionItems = shapesDefaultProvider.getListOfModelsToDisplayInShapeAdditionViewAfterMaskTapped()
        shapeAttributesItems = shapesDefaultProvider.getListOfModelsToShowInShapeAttributesView()
        arrowShapeAttributesItems = shapesDefaultProvider.getListOfModelsToShowInArrowShapeAttributesView()
        textAttributesItems = shapesDefaultProvider.getListOfModelsToShowInTextAttributesView()
        blockAttributesItems = shapesDefaultProvider.getListOfModelsToShowInBlockAttributesView()
    }
    
    func updateTrimmedVideoDuration(with text: String) {
        currentState = .videoTrimmingWithDuration(text)
    }
    
    func trimmingConfirmationButtonClicked() {
        annotatorViewModel?.trimmingConfirmationButtonClicked()
    }
    
    func trimmingCancelButtonClicked() {
        annotatorViewModel?.trimmingCancelButtonClicked()
    }
    
    func updateViewAfterTrimming() {
        currentState = .initialShapeAddition
        //        view?.updateViewAfterTrimming()
    }
    
    func shapeColorSelected(_ selectedColor: UIColor, isOval: Bool){
        switch currentState{
        case .textColorPalatte:
            currentState = .textAttribute(selectedColor)
        case .shapeColorPalatte:
            currentState = .shapeAttribute(selectedColor, isOval)
        default:
            currentState = .initialShapeAddition
            
        }
        currentState = .shapeAttribute(selectedColor, isOval)
    }
    
    func blockColorSelected(_ selectedColor: UIColor) {
        currentState = .blockAttribute(selectedColor)
    }
    
    func arrowColorSelected(_ selectedColor: UIColor) {
        currentState = .arrowShapeAttribute(selectedColor)
    }
    
    
    func textColorSelected(_ selectedColor: UIColor) {
        currentState = .textAttribute(selectedColor)
    }
    
    func dismissTxtRelatedMenus(_ selectedColor: UIColor){
        currentState = .textAttribute(selectedColor)
    }
    
    
    func updateViewWithRectangelOvalShapeAddition() {
        currentState = .rectOvalShapeAddition
    }
    func updateViewWithMaskBlurShapeAddition() {
        currentState = .maskBlurShapeAddition
    }
    
    func updateViewWithAudioRecorder() {
        currentState = .audioRecording(false)
    }
    
    func showShapeRelatedAttributeOptions(selectedColor: UIColor, isOval: Bool) {
        currentState = .shapeAttribute(selectedColor, isOval)
    }
    
    func showArrowRelatedAttributeOptions(selectedColor: UIColor){
        currentState = .arrowShapeAttribute(selectedColor)
    }
    
    func showBlockRelatedAttributeOptions(selectedColor: UIColor) {
        currentState = .blockAttribute(selectedColor)
    }
    
    func showTextRelatedAttributeOptions(selectedColor: UIColor) {
        currentState = .textAttribute(selectedColor)
    }
    
    func showAudioRecorder() {
        currentState = .audioRecording(false)
    }
    
    func showShapeColorAttributeOption(withColors colors: [UIColor], selectedColorIndex: Int) {
        currentState = .shapeColorPalatte(colors,selectedColorIndex)
    }
    
    func showTextColorAttributeOption(withColors colors: [UIColor], selectedColorIndex: Int) {
        currentState = .textColorPalatte(colors,selectedColorIndex)
    }
    
    func showBlockColorAttributeOption(withColors colors: [UIColor], selectedColorIndex: Int) {
        currentState = .blockColorPalatte(colors, selectedColorIndex)
    }
    
    func showArrowColorAttributeOption(withColors colors: [UIColor], selectedColorIndex: Int) {
        currentState = .arrowColorPalatte(colors, selectedColorIndex)
    }
    
    func showArrowWidthAttributeOption(borderWidthModel: BorderWidth, selectedColor: UIColor){
        currentState = .arrowBorderWidthPalatte(borderWidthModel, selectedColor)
    }
    
    func showBorderStyleAttributeOption(selectedIndex: Int, selectedColor: UIColor, isOval: Bool) {
        currentState = .borderStylePalatte(borderStyleModel, selectedIndex, selectedColor, isOval)
    }
    
    func showBorderStyleAttributeOption(selectedBorderStyleType: BorderStyleType, selectedColor: UIColor, isOval: Bool) {
        let selectedIndex = borderStyleModel.firstIndex { $0.type == selectedBorderStyleType }
        if let selectedIndex = selectedIndex{
            setTableModel(borderStyleModel)
            setTableSelected(index: selectedIndex)
            currentState = .borderStylePalatte(borderStyleModel, selectedIndex, selectedColor, isOval)
        }
    }
    
    func showBorderWidthAttributeOption(borderWidthModel: BorderWidth, selectedColor: UIColor, isOval: Bool) {
        currentState = .borderWidthPalatte(borderWidthModel, selectedColor, isOval)
    }
    
    func colorSelected(atIndex index: Int) {
        guard let annotatorViewModel = annotatorViewModel else {return}
        
        switch currentState {
        case .shapeColorPalatte:
            annotatorViewModel.shapeColorSelected(atIndex: index)
        case .blockColorPalatte:
            annotatorViewModel.blockColorSelected(atIndex: index)
        case .textColorPalatte:
            annotatorViewModel.textColorSelected(atIndex: index)
        case .arrowColorPalatte:
            annotatorViewModel.arrowColorSelected(atIndex: index)
           
        default: break
        }
    }
    
    
    func refreshUIBasedOnCurrentState() {
        switch currentState{
            
        case .initialShapeAddition: ()
        case .videoTrimming: ()
        case .rectOvalShapeAddition:
            currentState = .initialShapeAddition
            
        case .shapeAttribute:
            currentState = .initialShapeAddition
        case .arrowShapeAttribute:
            currentState = .initialShapeAddition
        case .shapeColorPalatte(_, _):
//            currentState = .shapeAttribute(colors[index])
            currentState = .initialShapeAddition
            
        case .borderWidthPalatte(_, let selectedColor, let isOval):
            currentState = .shapeAttribute(selectedColor, isOval)
        case .arrowBorderWidthPalatte(_, let selectedColor):
            currentState = .arrowShapeAttribute(selectedColor)
        case .audioRecording:
            currentState = .initialShapeAddition
        case .maskBlurShapeAddition:
            currentState = .initialShapeAddition
        case .blockAttribute:
            currentState = .maskBlurShapeAddition
        case .blockColorPalatte:
            currentState = .maskBlurShapeAddition
        case .borderStylePalatte(_, _, let color, let isOval):
            currentState = .shapeAttribute(color, isOval)
        case .textEditMode(_):
            currentState = .initialShapeAddition
        case .textAttribute(_):
            currentState = .initialShapeAddition
        case .textColorPalatte(_,_):
            currentState = .initialShapeAddition
        case .textSizeMode:
            currentState = .initialShapeAddition
            
        case .videoTrimmingWithDuration(_):
            break
        case .textStyleMode(_):
            currentState = .initialShapeAddition
        case .textBGMode(_):
            currentState = .initialShapeAddition
        case .audioRecordingButtonEnabled(_):
            currentState = .initialShapeAddition
        case .arrowColorPalatte(_, _):
            currentState = .initialShapeAddition
        
        }
    }
    
    func updateUIBasedOnSelected(shapeType: ShapeType) {
        switch shapeType {
        case .rectangle(let color, _, _):
            currentState = .shapeAttribute(color, false)
            //            view?.showShapeRelatedAttributeOptions(selectedColor: selectedColor)
        case .circle(let color, _, _):
            currentState = .shapeAttribute(color, true)
        case .arrow(color: let color, _,_):
            currentState = .arrowShapeAttribute(color)
        case .text(let color, _, _, _, _):
            currentState = .textAttribute(color)
        case .blur:
            currentState = .maskBlurShapeAddition
        case .block(let color):
            currentState = .blockAttribute(color)
        }
    }
    
    //    func startAudioRecording() {
    //        annotatorViewModel.audioStartRecordingButtonTapped()
    //    }
    //
    //    func stopAudioRecording() {
    //        annotatorViewModel.audioStopRecordingButtonTapped()
    //    }
    
    func audioRecordingButtonTapped() {
        annotatorViewModel?.audioRecordingButtonTapped()
    }
    
    func audioRecordingButton(shouldEnable: Bool){
        currentState = .audioRecordingButtonEnabled(shouldEnable)
    }
    
    
    func audioRecordingStarted() {
        currentState = .audioRecording(true)
    }
    
    func audioRecordingEnded() {
        refreshUIBasedOnCurrentState()
    }
    
    func videoTapped() {
//        print("Video Tapped")
        refreshUIBasedOnCurrentState()
    }
    
    func itemSelected() {
        guard let annotatorViewModel = annotatorViewModel else {return}
        switch currentState {
        case .textStyleMode:
            let allStyles = TextStyle.allCases
            let selectedStyle = allStyles[tableSelectedIndex]
            annotatorViewModel.textStyleSelected(selectedStyle)
        case .borderStylePalatte:
            let newBorderStyleType = borderStyleModel[tableSelectedIndex]
            annotatorViewModel.borderStyleSelected(newBorderStyleType.type)

        default:()
        }
    }
    
    func dismissBorderStyleMenu(_ selectedColor: UIColor, isOval: Bool) {
        if case .arrowBorderWidthPalatte = currentState{
            currentState = .arrowShapeAttribute(selectedColor)
        }else{
            currentState = .shapeAttribute(selectedColor, isOval)
        }
    }
    
    func dismissBorderWidthMenu(_ selectedColor: UIColor, isOval: Bool){
        currentState = .shapeAttribute(selectedColor, isOval)
    }
    
    func selectedShapeDeleted() {
        currentState = .initialShapeAddition
    }
    
    func updateBorderWidth(to value: Int) {
        annotatorViewModel?.borderWidthChangedTo(value)
    }
    
    func borderWidthChangesEnded(to value: Int) {
        annotatorViewModel?.borderWidthChangesEnded(value)
    }
    
    func updateTextSize(to: Int) {
        annotatorViewModel?.textSizeChanged(to)
    }
    
    func updateTextOpacity(to: CGFloat){
        annotatorViewModel?.textOpacityChanged(to)
    }
    
    func textSizeChangesEnded(to value: Int) {
        annotatorViewModel?.textSizeChangesEnded(value)
    }
    
    func textOpacityChangesEnded(to: CGFloat) {
        annotatorViewModel?.textOpacityChangesEnded(to)
    }
    
    func showTextEditWith(text: String) {
        currentState = .textEditMode(text)
    }
    
    func showTextSizeSelectionWith(model: AddedShape.TextModel) {
        currentState = .textSizeMode(model.fontSize)
    }
    
    func showTextStyleSelectionWith(model: AddedShape.TextModel) {
        
        let allModels = TextStyle.allCases
        guard let selectedModelIndex = allModels.firstIndex(of: model.textStyle) else {return}
        setTableModel(allModels)
        setTableSelected(index: selectedModelIndex)
        
        currentState = .textStyleMode(model.textStyle)
    }
    
    func showTextBGSelectionWith(model: AddedShape.TextModel){
        currentState = .textBGMode(model.textBG)
    }
    
    private func setTableModel(_ modelArray: [BorderStyleModel]) {
        tableModels = []
        
        modelArray.forEach { model in
            tableModels.append(TableModel(displayText: model.text))
        }
    }
    
    private func setTableModel(_ modelArray: [TextStyle]) {
        tableModels = []
        
        modelArray.forEach { model in
            tableModels.append(TableModel(displayText: model.displayValue))
        }
    }
    
    
    func setTableSelected(index: Int){
        tableSelectedIndex = index
    }
    
    func getTableViewItemsToShow() -> [TableModel] {
        tableModels
    }
    
    func getTableSelectedIndex() -> Int {
        tableSelectedIndex
    }
}

extension ToolBarViewModel: ShapeActionDelegateProtocol {
    func textEntered(model: NameAndImageNameModel, text: String) {
        annotatorViewModel?.textEntered(text)
    }
    
    func showPermissionAlert(){
        annotatorViewModel?.showAudioPermissionNotGrantedAlert()
    }
    
    func tapped(model: NameAndImageNameModel) {
        guard let annotatorViewModel = annotatorViewModel else {return}
        switch model.type {
        case .cut:
            annotatorViewModel.cutTapped()
        case .mask:
            annotatorViewModel.maskTapped()
        case .shapes:
            annotatorViewModel.shapesTapped()
        case .text:
            annotatorViewModel.textTapped()
        case .audio:
            annotatorViewModel.requestAudioPermission { isGranted in
                DispatchQueue.main.async {
                    if isGranted{
                        annotatorViewModel.audioTapped()
                    }else{
                        self.showPermissionAlert()
                    }
                }
            }
            
            //            annotatorViewModel.audioTapped()
        case .rectangle:
            annotatorViewModel.rectangleTapped()
        case .oval:
            annotatorViewModel.ovalTapped()
        case .arrow:
            annotatorViewModel.arrowTapped()
        case .arrowColor:
            annotatorViewModel.arrowColorTapped()
        case .arrowWidth:
            annotatorViewModel.arrowWidthTapped()
        case .shapeColor:
            switch currentState{
            case .textAttribute: annotatorViewModel.textColorTapped()
            case .textEditMode: annotatorViewModel.textColorTapped()
            case .textSizeMode: annotatorViewModel.textColorTapped()
            case .textStyleMode: annotatorViewModel.textColorTapped()
            case .textColorPalatte: annotatorViewModel.textColorTapped()
            case .textBGMode: annotatorViewModel.textColorTapped()
            default: annotatorViewModel.shapeColorTapped()
                
            }
        case .borderStyle:
            annotatorViewModel.borderStyleTapped()
            //            view?.showBorderStylePalatte()
        case .borderWidth:
            annotatorViewModel.borderWidthTapped()
            //            view?.showBorderWidthPalatte()
        case .block:
            annotatorViewModel.blockTapped()
        case .blur:
            annotatorViewModel.blurTapped()
        case .blockColor:
            annotatorViewModel.blockColorTapped()
        case .textEdit:
            annotatorViewModel.textEditTapped()
        case .textSize:
            annotatorViewModel.textSizeTapped()
        case .textStyle:
            annotatorViewModel.textStyleTapped()
        case .textBG:
            annotatorViewModel.textBgTapped()
        }
    }
}

extension ToolBarViewModel: BottomToolBarViewModelProtocol{
    func updateVideoTrimmed(text: String){
        currentState = .videoTrimmingWithDuration(text)
    }
}
