//
//  ShapesAdditionToolBarView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 20/09/23.
//

import UIKit

//protocol ShapesAdditionToolBarViewProtocol: UIView{
//    var toolBarShapeBuilder: ToolBarShapesBuilderProtocol { get }
//    var viewModel: ShapesAdditionToolBarViewModelProtocol { get }
//}
//
//protocol ShapesAdditionToolBarViewModelProtocol{
//    func add(shape: AddedShape)
//}

//class ShapesAdditionToolBarView: UIStackView, ShapesAdditionToolBarViewProtocol{
//    let toolBarShapeBuilder: ToolBarShapesBuilderProtocol
//    let viewModel: ShapesAdditionToolBarViewModelProtocol
//
//    let shapeViewWidth: CGFloat = 30
//    let shapeViewHeight: CGFloat = 30
//
//    var shapes: [Shape] = []
//
//    init(toolBarShapeBuilder: ToolBarShapesBuilderProtocol = ToolBarShapesBuilder(), viewModel: ShapesAdditionToolBarViewModelProtocol) {
//        self.toolBarShapeBuilder = toolBarShapeBuilder
//        self.viewModel = viewModel
//        super.init(frame: .zero)
//        configure()
//    }
//
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func configure(){
//        axis = .vertical
//        distribution = .fillEqually
//        alignment = .center
//        spacing = 8
//
//        shapes = toolBarShapeBuilder.getShapesToDisplayInToolbar()
//        shapes.enumerated().forEach { (index,currentShape) in
//            let shapeView = toolBarShapeBuilder.getViewForShape(currentShape)
//            shapeView.tag = index
//            shapeView.translatesAutoresizingMaskIntoConstraints = false
//            addArrangedSubview(shapeView)
//
//            NSLayoutConstraint.activate([
//                shapeView.widthAnchor.constraint(equalToConstant: shapeViewWidth),
//                shapeView.heightAnchor.constraint(equalToConstant: shapeViewHeight)
//            ])
//
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(shapeTapped(_:)))
//            tapGesture.numberOfTapsRequired = 1
//            shapeView.addGestureRecognizer(tapGesture)
//        }
//    }
//
//    @objc func shapeTapped(_ sender: UITapGestureRecognizer){
//        guard let view = sender.view else {return}
//        let viewTag = view.tag
//        if viewTag < shapes.count{
//            viewModel.add(shape: shapes[viewTag])
//        }
//    }
//}

