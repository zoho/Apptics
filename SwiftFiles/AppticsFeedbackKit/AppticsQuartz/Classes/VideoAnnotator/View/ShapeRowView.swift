//
//  ShapeRowView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 04/10/23.
//

import UIKit

protocol ShapeRowViewModelProtocol{
    var shapeDetail: AddedShapeDetails { get }
    var xOffset: CGFloat { get set}
    var width: CGFloat { get set}
    var isSelected: Bool { get set}
    
    mutating func setSelected(to selected: Bool)
    mutating func update(x: CGFloat, width: CGFloat)
}

struct ShapeRowViewModel: ShapeRowViewModelProtocol{
    
    let shapeDetail: AddedShapeDetails
    var xOffset: CGFloat
    var width: CGFloat
    var isSelected: Bool
    
    mutating func setSelected(to selected: Bool){
        self.isSelected = selected
    }
    
    mutating func update(x: CGFloat, width: CGFloat) {
        self.xOffset = x
        self.width = width
    }
    
}

protocol ShapeSizeUpdationDelegateProtocol:AnyObject {
    func canPanTo(offset: CGFloat, totalWidth: CGFloat) -> Bool
    func canLongPressPanTo(start: CGFloat, end: CGFloat, totalWidth: CGFloat) -> Bool
    func showPanningElementOutOfTrimmedDurationAlert()
    
    func getTimeOffsetFor(totalWidth: CGFloat, offset: CGFloat) -> CGFloat
    
    func getTrimStartTimeOffsetFor(totalWidth: CGFloat) -> CGFloat
    func getTrimEndTimeOffsetFor(totalWidth: CGFloat) -> CGFloat
    
    func shouldStartLongPress(forStart: CGFloat, end: CGFloat, totalWidth: CGFloat) -> Bool
    func longPressStarted()
    func shapesLongPressChanging(xOffset offset: Double, totalWidth: CGFloat, view: UIView)
    func shapesLongPressEnded(forBlockViewFrame blockViewFrame: CGRect, totalWidth: CGFloat, view: UIView, isElementOutsideOfTrimRangeAllowed: Bool)
    func shapeSizeUpdated(withBlockViewFrame blockViewFrame: CGRect, totalWidth: CGFloat, view: UIView, isLeftHandler: Bool, isElementOutsideOfTrimRangeAllowed: Bool)
    func shapeSizeUpdating(offset: CGFloat, blockViewFrame: CGRect, totalWidth: CGFloat, view: UIView)
    
    func scrollToSelected(view: ShapeRowViewProtocol)
    func tappedBlock(view: ShapeRowViewProtocol, isElementOutsideOfTrimRangeAllowed: Bool)
    func longPressed(view: ShapeRowViewProtocol)
}

protocol ShapeRowViewProtocol: UIView {
    var model: ShapeRowViewModelProtocol {get set}
    var scrollDelegate: ShapeRowViewScrollingDelete? {get set}
}

protocol ShapeRowViewScrollingDelete: AnyObject{
    func getParentScrollView() -> UIScrollView
}

class ShapeRowView: UIView, ShapeRowViewProtocol {
    var model: ShapeRowViewModelProtocol{
        didSet{
            refreshHandlersViewBasedOnSelectionState()
            refreshFrontAndBackEndBasedOnModel()
        }
    }
    weak var shapeSizeUpdationDelegate: ShapeSizeUpdationDelegateProtocol? = nil
    weak var scrollDelegate: ShapeRowViewScrollingDelete? = nil
    
    private let handlerViewColor = AnnotationEditorViewColors.selectionBorderColor
    private let borderWidth = 1.0
    private let handlerViewWidth: CGFloat = 14

    private let widthOfShapeTypeIndicatorView: CGFloat = 16
    private let heightOfShapeTypeIndicatorView: CGFloat = 16
    
    private let blurSystemImgName = "circle.hexagongrid"
    private let arrowSystemImgName = "arrow.up.right"
    private let textSystemImgName = "t.square"
    private let rectangleSystemImgName = "square"
    private let circleSystemImgName = "circle"
    private let blockSystemImgName = "square.fill"
    
    private var frontHandlerLeadConstraint: NSLayoutConstraint? = nil
    private var backHandlerTrailConstraint: NSLayoutConstraint? = nil
    
    private var isInitialPaddingSetForBackHandlerView = false

    private let shapeIndicatorViewColor = AnnotationEditorViewColors.shapeIndicatorViewBGColor
    private let shapeIndicatorViewCornerRadius: CGFloat = 2
    
    private var isLeftHandlerAction = false
    private var startingXPtOfLongPressGesture: CGFloat = 0
    
    private var frontHandlerLeftSideAutoScrollTimer: Timer? = nil
    private var frontHandlerRightSideAutoScrollTimer: Timer? = nil
    
    private var backHandlerLeftSideAutoScrollTimer: Timer? = nil
    private var backHandlerRightSideAutoScrollTimer: Timer? = nil

    private var frontHandlerAutoScrollingDelta: CGFloat = 0.04 // Amt by which auto scrolling should start before reaching the end
    private var backHandlerAutoScrollingDelta: CGFloat = 0.04
    
    private var longPressAutoScrollDelta: CGFloat = 0.02 // Amt by which auto scrolling should start before reaching the end
    
    private var shapeLongPressAutoScrollToRightTimer: Timer? = nil
    private var shapeLongPressAutoScrollToLeftTimer: Timer? = nil
    
    private var shouldIgnoreIfElementIsOutside = true
    private var shouldShowHandlersOutsideOfView = true
    private var minWidthOfShapeView: CGFloat = 18
    
    private var blockViewCornerRadius: CGFloat = 4
    
    private func refreshHandlersViewBasedOnSelectionState(){
        frontHandlerView.isHidden = !model.isSelected
        backHandlerView.isHidden = !model.isSelected
        topLineView.isHidden = !model.isSelected
        bottomLineView.isHidden = !model.isSelected
        
        if model.isSelected{
            shapeSizeUpdationDelegate?.scrollToSelected(view: self)
        }
    }
    
    private lazy var blockView: UIView = {
        let blockView = UIView()
        blockView.translatesAutoresizingMaskIntoConstraints = false
        let blockViewBGColor = AnnotationEditorViewColors.shapeBlockViewBGColor
        blockView.backgroundColor = QuartzKit.shared.primaryLightColor ?? blockViewBGColor
        blockView.layer.masksToBounds = true
        blockView.layer.cornerRadius = 4
        return blockView
    }()
    
    private lazy var shapeTypeIndicatorView: UIView = {
        let shapeTypeIndicatorView = UIView()
        shapeTypeIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return shapeTypeIndicatorView
    }()
    
    private lazy var frontHandlerView: HandlerView = {
        let frontHandlerView = HandlerView()
        frontHandlerView.delegate = self
        frontHandlerView.yOffset = borderWidth
        frontHandlerView.translatesAutoresizingMaskIntoConstraints = false
        frontHandlerView.shouldAddCurveAtFront = true
        frontHandlerView.layer.masksToBounds = false
        return frontHandlerView
    }()
    
    private lazy var backHandlerView: HandlerView = {
        let backHandlerView = HandlerView()
        backHandlerView.delegate = self
        backHandlerView.yOffset = borderWidth
        backHandlerView.translatesAutoresizingMaskIntoConstraints = false
        backHandlerView.shouldAddCurveAtFront = false
        backHandlerView.layer.masksToBounds = false
        return backHandlerView
    }()
    
    private lazy var topLineView: UIView = {
        let topLineView = UIView()
        topLineView.backgroundColor = handlerViewColor
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        return topLineView
    }()
    
    private lazy var bottomLineView: UIView = {
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = handlerViewColor
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        return bottomLineView
    }()
    
    init(model: ShapeRowViewModelProtocol) {
        self.model = model
        super.init(frame: .zero)
        configure()
        configureShapeTypeIndicatorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureShapeTypeIndicatorView(){
        
        blockView.addSubview(shapeTypeIndicatorView)
        
        NSLayoutConstraint.activate([
            shapeTypeIndicatorView.centerXAnchor.constraint(equalTo: blockView.centerXAnchor),
            shapeTypeIndicatorView.centerYAnchor.constraint(equalTo: blockView.centerYAnchor),
            shapeTypeIndicatorView.widthAnchor.constraint(equalToConstant: widthOfShapeTypeIndicatorView),
            shapeTypeIndicatorView.heightAnchor.constraint(equalToConstant: heightOfShapeTypeIndicatorView)
        ])
        
        var shapeIndicatorImgView: UIImageView?
        switch model.shapeDetail.shape.type{
        case .circle:
            let imgView = getImageViewToAddInIndicatorView(withSysName: circleSystemImgName)
            shapeTypeIndicatorView.addSubview(imgView)
            shapeIndicatorImgView = imgView
            
        case .rectangle:
            let imgView = getImageViewToAddInIndicatorView(withSysName: rectangleSystemImgName)
            shapeTypeIndicatorView.addSubview(imgView)
            shapeIndicatorImgView = imgView
            
        case .arrow:
            let imgView = getImageViewToAddInIndicatorView(withSysName: arrowSystemImgName)
            shapeTypeIndicatorView.addSubview(imgView)
            shapeIndicatorImgView = imgView
        
        case .blur:
            let imgView = getImageViewToAddInIndicatorView(withSysName: blurSystemImgName)
            shapeTypeIndicatorView.addSubview(imgView)
            shapeIndicatorImgView = imgView
            
        case .text:
            let imgView = getImageViewToAddInIndicatorView(withSysName: textSystemImgName)
            shapeTypeIndicatorView.addSubview(imgView)
            shapeIndicatorImgView = imgView
            
        case .block:
            let imgView = getImageViewToAddInIndicatorView(withSysName: blockSystemImgName)
            shapeTypeIndicatorView.addSubview(imgView)
            shapeIndicatorImgView = imgView
        }
        
        if let shapeIndicatorImgView = shapeIndicatorImgView{
            NSLayoutConstraint.activate([
                shapeIndicatorImgView.leadingAnchor.constraint(lessThanOrEqualTo: shapeTypeIndicatorView.leadingAnchor),
                shapeIndicatorImgView.trailingAnchor.constraint(greaterThanOrEqualTo: shapeTypeIndicatorView.trailingAnchor),
                shapeIndicatorImgView.centerXAnchor.constraint(equalTo: shapeTypeIndicatorView.centerXAnchor),
                shapeIndicatorImgView.topAnchor.constraint(equalTo: shapeTypeIndicatorView.topAnchor),
                shapeIndicatorImgView.bottomAnchor.constraint(equalTo: shapeTypeIndicatorView.bottomAnchor)
            ])
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switch model.shapeDetail.shape.type{
        case .circle:
            shapeTypeIndicatorView.layer.borderColor = shapeIndicatorViewColor.cgColor
        case .rectangle:
            shapeTypeIndicatorView.layer.borderColor = shapeIndicatorViewColor.cgColor
        case .block:
            shapeTypeIndicatorView.backgroundColor = shapeIndicatorViewColor
        default: break
        }
        frontHandlerView.applyCornerRadus(of: blockViewCornerRadius, toCorners: [.layerMinXMaxYCorner, .layerMinXMinYCorner], bgColor: handlerViewColor)
        backHandlerView.applyCornerRadus(of: blockViewCornerRadius, toCorners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner], bgColor: handlerViewColor)
    }
    
    private func getImageViewToAddInIndicatorView(withSysName sysName: String) -> UIImageView {
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .heavy)
            let imgView = UIImageView(image: UIImage(systemName: sysName, withConfiguration: config))
            imgView.contentMode = .scaleAspectFit
            imgView.tintColor = shapeIndicatorViewColor
            imgView.translatesAutoresizingMaskIntoConstraints = false
            return imgView
        } else {
            // Fallback on earlier versions
        }
        return UIImageView()
    }
    
    
    private func configure(){
        clipsToBounds = false
        frontHandlerView.isShownOutsideOfParent = shouldShowHandlersOutsideOfView
        backHandlerView.isShownOutsideOfParent = shouldShowHandlersOutsideOfView
        
            
        addSubviews(blockView,frontHandlerView,backHandlerView,topLineView,bottomLineView)
        
        let leadPadding: CGFloat = model.xOffset
        if shouldShowHandlersOutsideOfView{
            let trailingConstraintOutside = backHandlerView.trailingAnchor.constraint(equalTo: trailingAnchor)
            backHandlerTrailConstraint = trailingConstraintOutside
            
            let leadConstraintOutside = frontHandlerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadPadding-handlerViewWidth)
            frontHandlerLeadConstraint = leadConstraintOutside
            
            NSLayoutConstraint.activate([
                leadConstraintOutside,
                trailingConstraintOutside,
                
                blockView.leadingAnchor.constraint(equalTo: frontHandlerView.trailingAnchor),
                blockView.trailingAnchor.constraint(equalTo: backHandlerView.leadingAnchor),
                blockView.topAnchor.constraint(equalTo: topAnchor),
                blockView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }else{
            let trailingConstraint = backHandlerView.trailingAnchor.constraint(equalTo: trailingAnchor)
            backHandlerTrailConstraint = trailingConstraint
            
            let leadConstraint = frontHandlerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadPadding)
            frontHandlerLeadConstraint = leadConstraint
            
            NSLayoutConstraint.activate([
                leadConstraint,
                trailingConstraint,
            
                blockView.leadingAnchor.constraint(equalTo: frontHandlerView.leadingAnchor),
                blockView.trailingAnchor.constraint(equalTo: backHandlerView.trailingAnchor),
                blockView.topAnchor.constraint(equalTo: topAnchor),
                blockView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            
            frontHandlerView.topAnchor.constraint(equalTo: topAnchor),
            frontHandlerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            frontHandlerView.widthAnchor.constraint(equalToConstant: handlerViewWidth),
            
            backHandlerView.topAnchor.constraint(equalTo: topAnchor),
            backHandlerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backHandlerView.widthAnchor.constraint(equalToConstant: handlerViewWidth),
            
            topLineView.leadingAnchor.constraint(equalTo: frontHandlerView.trailingAnchor),
            topLineView.topAnchor.constraint(equalTo: topAnchor),
            topLineView.trailingAnchor.constraint(equalTo: backHandlerView.leadingAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: borderWidth),
            
            bottomLineView.leadingAnchor.constraint(equalTo: frontHandlerView.trailingAnchor),
            bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: backHandlerView.leadingAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: borderWidth)
        ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(blockViewTapped))
        blockView.addGestureRecognizer(tapGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(blockViewLongPressed(sender:)))
        longPressGestureRecognizer.delegate = self
        blockView.addGestureRecognizer(longPressGestureRecognizer)
        
        frontHandlerView.applyCornerRadus(of: blockViewCornerRadius, toCorners: [.layerMinXMaxYCorner, .layerMinXMinYCorner], bgColor: handlerViewColor ?? .clear)
        backHandlerView.applyCornerRadus(of: blockViewCornerRadius, toCorners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner], bgColor: handlerViewColor ?? .clear)

    }
    /* Long Press Shape Panning Logic Based On Finger Movement
    @objc func blockViewLongPressed(sender: UILongPressGestureRecognizer){
        switch sender.state {
        case .began:
            if !model.isSelected{
                longPressStarted()
            }
            let location = sender.location(in: self)
            startingXPtOfLongPressGesture = location.x
            let expandAnimation = UIViewPropertyAnimator(duration: 0.1, curve: .linear){
                self.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
            }
            expandAnimation.addCompletion { _ in
                let contractAnimation = UIViewPropertyAnimator(duration: 0.1, curve: .linear){
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                contractAnimation.startAnimation()
            }
            expandAnimation.startAnimation()
            self.shapeSizeUpdationDelegate?.longPressStarted()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            
        case .changed:
    
            let location = sender.location(in: self)
            let diff = startingXPtOfLongPressGesture - location.x
            let canPanRight = location.x > startingXPtOfLongPressGesture
            let canPanLeft = !canPanRight
            print(canPanRight)
            guard let fLeadConstriant = frontHandlerLeadConstraint, let bTrailConstraint = backHandlerTrailConstraint else {return}
            let fHanlerNewConstant = fLeadConstriant.constant - diff
            let bHanlerNewConstant = bTrailConstraint.constant - diff
            
            let startPt = shouldShowHandlersOutsideOfView ? (fHanlerNewConstant + handlerViewWidth) : fHanlerNewConstant
            let endPt = shouldShowHandlersOutsideOfView ? (self.frame.size.width + bHanlerNewConstant + handlerViewWidth) : (self.frame.size.width + bHanlerNewConstant)
            
            let canLongPressPan = self.shapeSizeUpdationDelegate?.canLongPressPanTo(start: startPt, end: endPt, totalWidth: frame.size.width) ?? true
            guard canLongPressPan else {return}
            let blockViewEndingPt = shouldShowHandlersOutsideOfView ? (fHanlerNewConstant + handlerViewWidth + blockView.frame.size.width) : (fHanlerNewConstant + blockView.frame.size.width)
            
            if startPt >= 0, blockViewEndingPt <= self.frame.size.width {
                UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction] ) {
                    self.frontHandlerLeadConstraint?.constant = fHanlerNewConstant
                    self.backHandlerTrailConstraint?.constant = bHanlerNewConstant
                }
            }
            startingXPtOfLongPressGesture = location.x
            
            if let scrollView = scrollDelegate?.getParentScrollView(){
                let contentOffset = scrollView.contentOffset
                let scrollDelta: CGFloat = scrollView.contentSize.width * 0.01 // Amt by which scrolling offset is added with (1%)
                let padDelta: CGFloat = scrollView.contentSize.width * 0.02 // Amt by which view is scrolled before reaching end border (1.5%)
                if (blockView.frame.origin.x + blockView.frame.width + padDelta) > scrollView.contentOffset.x + scrollView.frame.size.width / 2 { // Block view scrolled to Right
                    let diff = (blockView.frame.origin.x + blockView.frame.width) - (scrollView.contentOffset.x + scrollView.frame.size.width / 2.0) + scrollDelta
                    var xOffset = min(contentOffset.x + diff, contentOffset.x + scrollView.frame.size.width/2.0)
                    xOffset = xOffset < contentOffset.x ? contentOffset.x : xOffset
                    UIView.animate(withDuration: 0.2){
                        scrollView.setContentOffset( CGPoint(x: xOffset, y: contentOffset.y), animated: false)
                        scrollView.layoutIfNeeded()
                    }
                } else if (blockView.frame.origin.x - padDelta) < (scrollView.contentOffset.x - (scrollView.frame.size.width / 2.0) ) { // Block view scrolled to Left
                    let diff = (scrollView.contentOffset.x - (scrollView.frame.size.width / 2.0) ) - blockView.frame.origin.x + scrollDelta
                    var xOffset = max(contentOffset.x - diff, 0)
                    xOffset = xOffset > contentOffset.x ? contentOffset.x : xOffset
                    UIView.animate(withDuration: 0.2){
                        scrollView.setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: false)
                        scrollView.layoutIfNeeded()
                    }
                }
            }
        case .ended:
            startingXPtOfLongPressGesture = 0
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.shapeSizeUpdationDelegate?.shapesLongPressEnded(forBlockViewFrame: self.blockView.frame, totalWidth: self.bounds.size.width, view: self)
        default: break
        }
    }
     */
    
//    Long Press Shape Panning Logic Based On Auto Scroll
    @objc func blockViewLongPressed(sender: UILongPressGestureRecognizer){
        switch sender.state {
        case .began:
            if !model.isSelected{
                longPressStarted()
            }
            let location = sender.location(in: self)
            startingXPtOfLongPressGesture = location.x
            let expandAnimation = UIViewPropertyAnimator(duration: 0.1, curve: .linear){
                self.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
            }
            expandAnimation.addCompletion { _ in
                let contractAnimation = UIViewPropertyAnimator(duration: 0.1, curve: .linear){
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                contractAnimation.startAnimation()
            }
            expandAnimation.startAnimation()
            self.shapeSizeUpdationDelegate?.longPressStarted()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            
        case .changed:
    
            let location = sender.location(in: self)
            let diff = startingXPtOfLongPressGesture - location.x
            let canAutoScrollToRight = location.x >= startingXPtOfLongPressGesture
            let canAutoScrollToLeft = !canAutoScrollToRight
            guard let fLeadConstriant = frontHandlerLeadConstraint, let bTrailConstraint = backHandlerTrailConstraint else {return}
            
            let fHanlerNewConstant = fLeadConstriant.constant - diff
            let bHanlerNewConstant = bTrailConstraint.constant - diff
            
            let startPt = shouldShowHandlersOutsideOfView ? (fHanlerNewConstant + handlerViewWidth) : fHanlerNewConstant
            let endPt = shouldShowHandlersOutsideOfView ? (self.frame.size.width + bHanlerNewConstant + handlerViewWidth) : (self.frame.size.width + bHanlerNewConstant)
            
            if shouldIgnoreIfElementIsOutside == false{
                let canLongPressPan = self.shapeSizeUpdationDelegate?.canLongPressPanTo(start: startPt, end: endPt, totalWidth: frame.size.width) ?? true
                guard canLongPressPan else {return}
            }
            let blockViewEndingPt = shouldShowHandlersOutsideOfView ? (fHanlerNewConstant + handlerViewWidth + blockView.frame.size.width) : (fHanlerNewConstant + blockView.frame.size.width)
            
            if startPt >= 0, blockViewEndingPt < self.frame.size.width{
                if self.shapeLongPressAutoScrollToRightTimer == nil && self.shapeLongPressAutoScrollToLeftTimer == nil{
                    UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction] ) {
                        self.frontHandlerLeadConstraint?.constant = fHanlerNewConstant
                        self.backHandlerTrailConstraint?.constant = bHanlerNewConstant
                        self.blockView.layoutIfNeeded()
                    }
                }else{ // Auto scroll is active & user is moving his finger
//                    let omega = round(diff)
//                    print("Omega")
//                    UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction, .layoutSubviews] ) {
//                        self.frontHandlerLeadConstraint?.constant = fLeadConstriant.constant - omega/2.0
//                        self.backHandlerTrailConstraint?.constant =  bTrailConstraint.constant - omega/2.0
//                        self.layoutIfNeeded()
//                    }
                }
            }
            
            if let scrollView = scrollDelegate?.getParentScrollView(){
                let scrollDelta: CGFloat = scrollView.contentSize.width * longPressAutoScrollDelta // Amt by which scrolling offset is added with
                if ((blockView.frame.origin.x + blockView.frame.width + scrollDelta) > scrollView.contentOffset.x + scrollView.frame.size.width / 2) { // Block view scrolled to Right
                    if canAutoScrollToRight{
                        if self.shapeLongPressAutoScrollToRightTimer == nil{
                            let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(longPressAutoScrollToRight), userInfo: nil, repeats: true)
                            self.shapeLongPressAutoScrollToRightTimer = timer
                            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
                        }
                    }else{
                        invalidateLongPressTimer()
                    }
                } else if (blockView.frame.origin.x - scrollDelta) < (scrollView.contentOffset.x - (scrollView.frame.size.width / 2.0)) { // Block view scrolled to Left
                    if canAutoScrollToLeft{
                        if self.shapeLongPressAutoScrollToLeftTimer == nil{
                            let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(longPressAutoScrollToLeft), userInfo: nil, repeats: true)
                            self.shapeLongPressAutoScrollToLeftTimer = timer
                            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
                        }
                    }else{
                        invalidateLongPressTimer()
                    }
                }else{
                 
                }
                
                startingXPtOfLongPressGesture = location.x
                self.shapeSizeUpdationDelegate?.shapesLongPressChanging(xOffset: blockView.frame.origin.x, totalWidth: self.bounds.size.width, view: self)
            }
        case .ended:
            invalidateLongPressTimer()
            startingXPtOfLongPressGesture = 0
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.shapeSizeUpdationDelegate?.shapesLongPressEnded(forBlockViewFrame: self.blockView.frame, totalWidth: self.bounds.size.width, view: self, isElementOutsideOfTrimRangeAllowed: shouldIgnoreIfElementIsOutside)
        default: break
        }
    }
    
    @objc func longPressStarted(){
        shapeSizeUpdationDelegate?.longPressed(view: self)
    }
    
    @objc func blockViewTapped(){
        shapeSizeUpdationDelegate?.tappedBlock(view: self, isElementOutsideOfTrimRangeAllowed: shouldIgnoreIfElementIsOutside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isInitialPaddingSetForBackHandlerView{
            isInitialPaddingSetForBackHandlerView = true
            let blockViewWidth: CGFloat = model.width
            if shouldShowHandlersOutsideOfView{
                let trailingPadding = bounds.width - (model.xOffset + blockViewWidth + handlerViewWidth)
                backHandlerTrailConstraint?.constant = -trailingPadding
            }else{
                let trailingPadding = bounds.width - (model.xOffset + blockViewWidth)
                backHandlerTrailConstraint?.constant = -trailingPadding
            }
        }
        
//        if case .circle = model.shapeDetail.shape.type{
//            shapeTypeIndicatorView.layer.cornerRadius = min(widthOfShapeTypeIndicatorView, heightOfShapeTypeIndicatorView) / 2.0
//        }
    }
    
    func refreshFrontAndBackEndBasedOnModel(){
        if shouldShowHandlersOutsideOfView{
            frontHandlerLeadConstraint?.constant = model.xOffset - handlerViewWidth
            backHandlerTrailConstraint?.constant = -(bounds.width - ( model.xOffset + model.width + handlerViewWidth))
        }else{
            frontHandlerLeadConstraint?.constant = model.xOffset
            backHandlerTrailConstraint?.constant = -(bounds.width - ( model.xOffset + model.width ))
        }
    }
}

extension ShapeRowView: HandlerViewDelegate{
    
    func shouldStartPan(_ newCenter: CGPoint, withOldCenter oldCenter: CGPoint) -> Bool {
        if shouldIgnoreIfElementIsOutside{return true}
        
        var xOffset: CGFloat = 0
        
        if frontHandlerView.center == oldCenter{ // Panning on Left Handler
            xOffset = shouldShowHandlersOutsideOfView ? (newCenter.x + handlerViewWidth/2.0) : (newCenter.x - handlerViewWidth/2.0)
        }else{ // Panning on Right Handler
            xOffset = shouldShowHandlersOutsideOfView ? (newCenter.x - handlerViewWidth/2.0) : (newCenter.x + handlerViewWidth/2.0)
        }
        let canPan = self.shapeSizeUpdationDelegate?.canPanTo(offset: xOffset, totalWidth: frame.size.width) ?? true
        guard canPan else {
            self.shapeSizeUpdationDelegate?.showPanningElementOutOfTrimmedDurationAlert()
            return false
//            return true
        }
        return true
    }

    func panAction(_ newCenter: CGPoint, withOldCenter oldCenter: CGPoint, velocity: CGFloat) {
//        invalidateTimer()
        
        let leftHandlerCenter = frontHandlerView.center
        let diff = newCenter.x - oldCenter.x
        
        isLeftHandlerAction = (leftHandlerCenter == oldCenter)
        var timeOffset: CGFloat = 0
        let canAutoScrollToRight = velocity > 0
        let canAutoScrollToLeft = velocity < 0
        
        if leftHandlerCenter == oldCenter { // Panning on Left Handler
            let existingPaddingConstant = frontHandlerLeadConstraint?.constant ?? 0
            let leadPadding: CGFloat = existingPaddingConstant + diff
            let xStart = shouldShowHandlersOutsideOfView ? (leadPadding + handlerViewWidth) : leadPadding
            if shouldIgnoreIfElementIsOutside == false{
                let canPan = self.shapeSizeUpdationDelegate?.canPanTo(offset: xStart, totalWidth: frame.size.width) ?? true
                guard canPan else {
                    let offset = self.shapeSizeUpdationDelegate?.getTimeOffsetFor(totalWidth: frame.size.width, offset: xStart) ?? 0
                    UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                        self.frontHandlerLeadConstraint?.constant = self.shouldShowHandlersOutsideOfView ? offset - self.handlerViewWidth : offset
                        self.layoutIfNeeded()
                    }
                    return
                }
            }
            frontHandlerLeadConstraint?.constant = leadPadding
            timeOffset = blockView.frame.origin.x
            
            if let scrollView = scrollDelegate?.getParentScrollView(){
                let padDelta: CGFloat = scrollView.contentSize.width * frontHandlerAutoScrollingDelta // Amt by which view is scrolled before reaching end border
                if (leadPadding - padDelta) < (scrollView.contentOffset.x - (scrollView.frame.size.width / 2.0) ) { // Left Handler view scrolled to Left
                    if canAutoScrollToLeft{
                        if self.frontHandlerLeftSideAutoScrollTimer == nil{
                            let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(frontHandlerAutoScrollToLeft), userInfo: nil, repeats: true)
                            self.frontHandlerLeftSideAutoScrollTimer = timer
                            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
                        }
                    }else{
                        invalidateTimer()
                    }
                }else if (leadPadding + handlerViewWidth + padDelta) > (scrollView.contentOffset.x + (scrollView.frame.size.width / 2.0) ) { // Left Handler view scrolled to Right
                    if canAutoScrollToRight{
                        if self.frontHandlerRightSideAutoScrollTimer == nil{
                            let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(frontHandlerAutoScrollToRight), userInfo: nil, repeats: true)
                            self.frontHandlerRightSideAutoScrollTimer = timer
                            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
                        }
                    }else{
                        invalidateTimer()
                    }
                }
            }
        }else{
            let existingPaddingConstant = backHandlerTrailConstraint?.constant ?? 0
            let trailPadding: CGFloat = existingPaddingConstant + diff
            
            timeOffset = (blockView.frame.origin.x + blockView.frame.size.width)
            
            let xPt = shouldShowHandlersOutsideOfView ? (blockView.frame.origin.x + blockView.frame.size.width + diff) : (frame.size.width + trailPadding)
            if shouldIgnoreIfElementIsOutside == false{
                let canPan = self.shapeSizeUpdationDelegate?.canPanTo(offset: xPt, totalWidth: frame.size.width) ?? true
                guard canPan else {
                    let offset = self.shapeSizeUpdationDelegate?.getTimeOffsetFor(totalWidth: frame.size.width, offset: xPt) ?? 0
                    UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                        self.backHandlerTrailConstraint?.constant = self.shouldShowHandlersOutsideOfView ? -(self.frame.size.width - offset - self.handlerViewWidth) : -(self.frame.size.width - offset)
                        self.layoutIfNeeded()
                    }
                    invalidateTimer()
                    return
                }
            }
            backHandlerTrailConstraint?.constant = trailPadding
            
            if let scrollView = scrollDelegate?.getParentScrollView(){
                let padDelta: CGFloat = scrollView.contentSize.width * backHandlerAutoScrollingDelta // Amt by which view is scrolled before reaching end border
                
                if (blockView.frame.origin.x + blockView.frame.size.width + padDelta) > (scrollView.contentOffset.x + (scrollView.frame.size.width / 2.0)){  // Right Handler view scrolled to Right
                    if canAutoScrollToRight{
                        if self.backHandlerRightSideAutoScrollTimer == nil{
                            let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(backHandlerAutoScrollToRight), userInfo: nil, repeats: true)
                            self.backHandlerRightSideAutoScrollTimer = timer
                            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
                        }
                    }else{
                        invalidateTimer()
                    }
                } else if (blockView.frame.origin.x + blockView.frame.size.width - padDelta) < (scrollView.contentOffset.x - (scrollView.frame.size.width / 2.0)) { // Right Handler view scrolled to Left
                    if canAutoScrollToLeft{
                        if self.backHandlerLeftSideAutoScrollTimer == nil{
                            let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(backHandlerAutoScrollToLeft), userInfo: nil, repeats: true)
                            self.backHandlerLeftSideAutoScrollTimer = timer
                            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
                        }
                    }else{
                        invalidateTimer()
                    }
                }
            }
        }
        shapeSizeUpdationDelegate?.shapeSizeUpdating(offset: timeOffset, blockViewFrame: blockView.frame, totalWidth: bounds.size.width, view: self)
    }
    
    func allowPan(_ newCenter: CGPoint, withOldCenter oldCenter: CGPoint) -> Bool{
        let leftHandlerCenter = frontHandlerView.center
        let rightHandlerCenter = backHandlerView.center
        if leftHandlerCenter == oldCenter{ // Panning on Left Handler
            if shouldShowHandlersOutsideOfView{
                return newCenter.x + handlerViewWidth + minWidthOfShapeView < rightHandlerCenter.x
            }else{
                return newCenter.x + handlerViewWidth < rightHandlerCenter.x
            }
        }else{ // Panning on Right Handler
            if shouldShowHandlersOutsideOfView{
                return newCenter.x - handlerViewWidth - minWidthOfShapeView > leftHandlerCenter.x
            }else{
                return newCenter.x - handlerViewWidth > leftHandlerCenter.x
            }
        }
    }
    
    func panEnded() {
        invalidateTimer()
        shapeSizeUpdationDelegate?.shapeSizeUpdated(withBlockViewFrame: blockView.frame, totalWidth: bounds.size.width, view: self, isLeftHandler: isLeftHandlerAction, isElementOutsideOfTrimRangeAllowed: shouldIgnoreIfElementIsOutside)
    }
}


extension ShapeRowView{
    
    @objc private func frontHandlerAutoScrollToLeft(){
        if let scrollView = scrollDelegate?.getParentScrollView(){
            let diff: CGFloat = scrollView.contentSize.width * 0.01 // Amt by which view is auto scrolled (1%)
            let contentOffset = scrollView.contentOffset
            let existingPaddingConstant = frontHandlerLeadConstraint?.constant ?? 0
            var xOffset = contentOffset.x - diff
            var leadPadding: CGFloat = existingPaddingConstant - diff
            
            let xStart = shouldShowHandlersOutsideOfView ? (existingPaddingConstant - diff + handlerViewWidth) : (existingPaddingConstant - diff)
            if xOffset > (scrollView.frame.size.width / 2.0) {
                if shouldIgnoreIfElementIsOutside == false{
                    let canPan = self.shapeSizeUpdationDelegate?.canPanTo(offset: xStart, totalWidth: frame.size.width) ?? true
                    guard canPan else { // If video is trimmed then stop auto scrolling to left
                        let startTimeOffset = self.shapeSizeUpdationDelegate?.getTrimStartTimeOffsetFor(totalWidth: frame.size.width) ?? 0
                        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                            self.frontHandlerLeadConstraint?.constant = self.shouldShowHandlersOutsideOfView ? (startTimeOffset - self.handlerViewWidth) : startTimeOffset
                            scrollView.layoutIfNeeded()
                        }
                        invalidateTimer()
                        return
                    }
                }
                
                UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                    self.frontHandlerLeadConstraint?.constant = leadPadding
                    scrollView.setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: false)
                    scrollView.layoutIfNeeded()
                }
            }else{
                let padDelta: CGFloat = scrollView.contentSize.width * frontHandlerAutoScrollingDelta // Keep it same as the value that is there while starting auto scroll
                xOffset = (scrollView.frame.size.width / 2.0) - padDelta
                leadPadding = 0 - handlerViewWidth
                UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                    self.frontHandlerLeadConstraint?.constant = leadPadding
                    scrollView.setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: false)
                    scrollView.layoutIfNeeded()
                }
                invalidateTimer()
            }
        }
    }
    
    @objc private func frontHandlerAutoScrollToRight(){
        if let scrollView = scrollDelegate?.getParentScrollView(){
            let diff: CGFloat = scrollView.contentSize.width * 0.01 // Amt by which view is auto scrolled (1%)
            let contentOffset = scrollView.contentOffset
            let existingPaddingConstant = frontHandlerLeadConstraint?.constant ?? 0
            let xOffset = contentOffset.x + diff
            let leadPadding: CGFloat = existingPaddingConstant + diff
            
            let xStart = shouldShowHandlersOutsideOfView ? (existingPaddingConstant + diff + handlerViewWidth) : (existingPaddingConstant + diff)
            let xPt = shouldShowHandlersOutsideOfView ? (leadPadding + minWidthOfShapeView) :leadPadding
            
            if xPt < (backHandlerView.frame.origin.x - handlerViewWidth/2.0) {
                if shouldIgnoreIfElementIsOutside == false{
                    let canPan = self.shapeSizeUpdationDelegate?.canPanTo(offset: xStart, totalWidth: frame.size.width) ?? true
                    guard canPan else { // If video is trimmed then stop auto scrolling to right
                        let offset = self.shapeSizeUpdationDelegate?.getTimeOffsetFor(totalWidth: frame.size.width, offset: xStart) ?? 0
                        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                            self.frontHandlerLeadConstraint?.constant = self.shouldShowHandlersOutsideOfView ? (offset - self.handlerViewWidth) : offset
                            scrollView.layoutIfNeeded()
                        }
                        invalidateTimer()
                        return
                    }
                }
                
                UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                    self.frontHandlerLeadConstraint?.constant = leadPadding
                    scrollView.setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: false)
                    scrollView.layoutIfNeeded()
                }
            }else{
                invalidateTimer()
            }
        }
    }
    
    @objc private func backHandlerAutoScrollToLeft(){
        if let scrollView = scrollDelegate?.getParentScrollView(){
            let diff: CGFloat = scrollView.contentSize.width * 0.01 // Amt by which view is auto scrolled (1%)
            let contentOffset = scrollView.contentOffset
            let existingPaddingConstant = backHandlerTrailConstraint?.constant ?? 0
            let xOffset = contentOffset.x - diff
            let trailPadding: CGFloat = existingPaddingConstant - diff
            
            let trailPaddingFromFront = scrollView.contentSize.width + trailPadding - scrollView.frame.size.width
            if trailPaddingFromFront > (frontHandlerView.frame.origin.x + handlerViewWidth + minWidthOfShapeView) {
                if shouldIgnoreIfElementIsOutside == false{
                    let canPan = self.shapeSizeUpdationDelegate?.canPanTo(offset: trailPaddingFromFront, totalWidth: frame.size.width) ?? true
                    guard canPan else {
                        let endTimeOffset = self.shapeSizeUpdationDelegate?.getTrimStartTimeOffsetFor(totalWidth: frame.size.width) ?? 0
                        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                            self.backHandlerTrailConstraint?.constant = self.shouldShowHandlersOutsideOfView ? -(self.frame.size.width - endTimeOffset - self.handlerViewWidth) :-(self.frame.size.width - endTimeOffset)
                            scrollView.layoutIfNeeded()
                        }
                        invalidateTimer()
                        return
                    }
                }
                
                UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                    self.backHandlerTrailConstraint?.constant = trailPadding
                    scrollView.setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: false)
                    scrollView.layoutIfNeeded()
                }
            }else{
                invalidateTimer()
            }
        }
    }
    
    @objc private func backHandlerAutoScrollToRight(){
        if let scrollView = scrollDelegate?.getParentScrollView(){
            let diff: CGFloat = scrollView.contentSize.width * 0.01 // Amt by which view is auto scrolled (1%)
            let contentOffset = scrollView.contentOffset
            let existingPaddingConstant = backHandlerTrailConstraint?.constant ?? 0
            var xOffset = contentOffset.x + diff
            var trailPadding: CGFloat = existingPaddingConstant + diff
            if xOffset < (scrollView.contentSize.width - 1.5*scrollView.frame.width){
                if shouldIgnoreIfElementIsOutside == false{
                    let canPan = self.shapeSizeUpdationDelegate?.canPanTo(offset: frame.size.width + trailPadding, totalWidth: frame.size.width) ?? true
                    guard canPan else {
                        let endTimeOffset = self.shapeSizeUpdationDelegate?.getTrimEndTimeOffsetFor(totalWidth: frame.size.width) ?? 0
                        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                            self.backHandlerTrailConstraint?.constant = self.shouldShowHandlersOutsideOfView ? -(self.frame.size.width - endTimeOffset - self.handlerViewWidth) : -(self.frame.size.width - endTimeOffset)
                            scrollView.layoutIfNeeded()
                        }
                        invalidateTimer()
                        return
                    }
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                    self.backHandlerTrailConstraint?.constant = trailPadding
                    scrollView.setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: false)
                    scrollView.layoutIfNeeded()
                }
            }else{
                let padDelta: CGFloat = scrollView.contentSize.width * backHandlerAutoScrollingDelta // Keep it same as the value that is there while starting auto scroll
                xOffset = scrollView.contentSize.width - 1.5*scrollView.frame.width + padDelta
                trailPadding = 0
                
                UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                    self.backHandlerTrailConstraint?.constant = self.shouldShowHandlersOutsideOfView ? trailPadding + self.handlerViewWidth : trailPadding
                    scrollView.setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: false)
                    scrollView.layoutIfNeeded()
                }
                invalidateTimer()
            }
        }
    }
    
    private func invalidateTimer(){
        frontHandlerLeftSideAutoScrollTimer?.invalidate()
        frontHandlerLeftSideAutoScrollTimer = nil
        
        frontHandlerRightSideAutoScrollTimer?.invalidate()
        frontHandlerRightSideAutoScrollTimer = nil
        
        backHandlerLeftSideAutoScrollTimer?.invalidate()
        backHandlerLeftSideAutoScrollTimer = nil
        
        backHandlerRightSideAutoScrollTimer?.invalidate()
        backHandlerRightSideAutoScrollTimer = nil
    }
    
    private func invalidateLongPressTimer(){
        shapeLongPressAutoScrollToRightTimer?.invalidate()
        shapeLongPressAutoScrollToRightTimer = nil
        
        shapeLongPressAutoScrollToLeftTimer?.invalidate()
        shapeLongPressAutoScrollToLeftTimer = nil
    }
}


extension ShapeRowView: UIGestureRecognizerDelegate{
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let _ = gestureRecognizer as? UILongPressGestureRecognizer else {return true}
        if shouldIgnoreIfElementIsOutside {return true}
        
//        guard let frontHandlerLeadConstraint = frontHandlerLeadConstraint, let backHandlerTrailConstraint = backHandlerTrailConstraint else {return false}
//        let fHanlerNewConstant = shouldShowHandlersOutsideOfView ? (frontHandlerLeadConstraint.constant + handlerViewWidth) : frontHandlerLeadConstraint.constant
//        let bHanlerNewConstant = shouldShowHandlersOutsideOfView ? (backHandlerTrailConstraint.constant + handlerViewWidth) : backHandlerTrailConstraint.constant
//        let trailPaddingFromFront = self.frame.size.width + bHanlerNewConstant

//        let shouldStartLongPress = self.shapeSizeUpdationDelegate?.shouldStartLongPress(forStart: fHanlerNewConstant, end: trailPaddingFromFront, totalWidth: frame.size.width) ?? true
        
        let shouldStartLongPress = self.shapeSizeUpdationDelegate?.shouldStartLongPress(forStart: blockView.frame.origin.x, end: blockView.frame.origin.x + blockView.frame.size.width, totalWidth: frame.size.width) ?? true
        guard shouldStartLongPress else{
            self.shapeSizeUpdationDelegate?.showPanningElementOutOfTrimmedDurationAlert()
            return false
//            return true
        }
        return true
    }
    
}

extension ShapeRowView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if super.point(inside: point, with: event) { return true }
        for subview in subviews {
            let subviewPoint = subview.convert(point, from: self)
            if subview.point(inside: subviewPoint, with: event) { return true }
        }
        return false
    }
}



extension ShapeRowView{
    
    @objc private func longPressAutoScrollToRight(){
        
        if let scrollView = scrollDelegate?.getParentScrollView(){
            let diff: CGFloat = round(scrollView.contentSize.width * 0.02) // Amt by which view is auto scrolled (2%)
            guard let fLeadConstriant = frontHandlerLeadConstraint, let bTrailConstraint = backHandlerTrailConstraint else {return}
            let fHanlerNewConstant = fLeadConstriant.constant + diff
            let bHanlerNewConstant = bTrailConstraint.constant + diff
                        
            let startPt = shouldShowHandlersOutsideOfView ? (fHanlerNewConstant + handlerViewWidth) : fHanlerNewConstant
            let endPt = shouldShowHandlersOutsideOfView ? (self.frame.size.width + bHanlerNewConstant + handlerViewWidth) : (self.frame.size.width + bHanlerNewConstant)
            if shouldIgnoreIfElementIsOutside == false{
                let canLongPressPan = self.shapeSizeUpdationDelegate?.canLongPressPanTo(start: startPt, end: endPt, totalWidth: frame.size.width) ?? true
                guard canLongPressPan else {
                    let offset = self.shapeSizeUpdationDelegate?.getTimeOffsetFor(totalWidth: frame.size.width, offset: endPt) ?? 0
                    let delta: CGFloat = 10
                    let bConst = self.shouldShowHandlersOutsideOfView ? -(self.frame.size.width - offset - self.handlerViewWidth) - delta : -(self.frame.size.width - offset)
                    let fConst = abs(bConst - bTrailConstraint.constant) + fLeadConstriant.constant
                    let xContentOffset = scrollView.contentOffset.x + abs(bConst - bTrailConstraint.constant)
                    
                    UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                        self.frontHandlerLeadConstraint?.constant = fConst
                        self.backHandlerTrailConstraint?.constant = bConst
                        scrollView.setContentOffset(CGPoint(x: xContentOffset, y: scrollView.contentOffset.y), animated: false)
                        self.layoutIfNeeded()
                    }
                    invalidateLongPressTimer()
                    return
                }
            }
            let blockViewEndingPt = shouldShowHandlersOutsideOfView ? (fHanlerNewConstant + handlerViewWidth + blockView.frame.size.width) : (fHanlerNewConstant + blockView.frame.size.width)
            
            if startPt >= 0, blockViewEndingPt <= self.frame.size.width {
                let offset = scrollView.contentOffset.x + diff
                UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction, .layoutSubviews] ) {
                    self.frontHandlerLeadConstraint?.constant = fHanlerNewConstant
                    self.backHandlerTrailConstraint?.constant = bHanlerNewConstant
                    scrollView.setContentOffset(CGPoint(x: offset, y: scrollView.contentOffset.y), animated: false)
                    self.layoutIfNeeded()
                }
            }else{
                let newFConst = self.shouldShowHandlersOutsideOfView ? (self.frame.size.width - self.blockView.frame.size.width - self.handlerViewWidth) : (self.frame.size.width + bHanlerNewConstant)
                let newBConst = self.shouldShowHandlersOutsideOfView ? self.handlerViewWidth : 0
                let offset = scrollView.contentOffset.x + newFConst - fLeadConstriant.constant
                UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction, .layoutSubviews] ) {
                    self.frontHandlerLeadConstraint?.constant = newFConst
                    self.backHandlerTrailConstraint?.constant = newBConst
                    scrollView.setContentOffset(CGPoint(x: offset, y: scrollView.contentOffset.y), animated: false)

                    scrollView.layoutIfNeeded()
                    self.blockView.layoutIfNeeded()
                }
                invalidateLongPressTimer()
            }
        }
    }
    
    
    @objc private func longPressAutoScrollToLeft(){
        if let scrollView = scrollDelegate?.getParentScrollView(){
            let diff: CGFloat = round(scrollView.contentSize.width * 0.02) // Amt by which view is auto scrolled (2%)
            
            guard let fLeadConstriant = frontHandlerLeadConstraint, let bTrailConstraint = backHandlerTrailConstraint else {return}
            let fHanlerNewConstant = fLeadConstriant.constant - (diff)
            let bHanlerNewConstant = bTrailConstraint.constant - (diff)
            
            let startPt = shouldShowHandlersOutsideOfView ? (fHanlerNewConstant + handlerViewWidth) : fHanlerNewConstant
            let endPt = shouldShowHandlersOutsideOfView ? (self.frame.size.width + bHanlerNewConstant + handlerViewWidth) : (self.frame.size.width + bHanlerNewConstant)
            if shouldIgnoreIfElementIsOutside == false{
                let canLongPressPan = self.shapeSizeUpdationDelegate?.canLongPressPanTo(start: startPt, end: endPt, totalWidth: frame.size.width) ?? true
                guard canLongPressPan else {
                    let offset = self.shapeSizeUpdationDelegate?.getTimeOffsetFor(totalWidth: frame.size.width, offset: startPt) ?? 0
                    let delta: CGFloat = 10
                    let fConst = self.shouldShowHandlersOutsideOfView ? (offset - handlerViewWidth + delta) : offset + delta
                    let bConst =  bTrailConstraint.constant - abs(fConst - fLeadConstriant.constant)
                    let xContentOffset = scrollView.contentOffset.x + abs(bConst - bTrailConstraint.constant)
                    
                    UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                        self.frontHandlerLeadConstraint?.constant = fConst
                        self.backHandlerTrailConstraint?.constant = bConst
                        scrollView.setContentOffset(CGPoint(x: xContentOffset, y: scrollView.contentOffset.y), animated: false)
                        self.layoutIfNeeded()
                    }
                    invalidateLongPressTimer()
                    return
                }
            }
            let blockViewEndingPt = shouldShowHandlersOutsideOfView ? (fHanlerNewConstant + handlerViewWidth + blockView.frame.size.width) : (fHanlerNewConstant + blockView.frame.size.width)
            
            if startPt >= 0, blockViewEndingPt <= self.frame.size.width {
                let xOffset = scrollView.contentOffset.x - (diff)
                UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction] ) {
                    self.frontHandlerLeadConstraint?.constant = fHanlerNewConstant
                    self.backHandlerTrailConstraint?.constant = bHanlerNewConstant
                    scrollView.setContentOffset(CGPoint(x: xOffset, y: scrollView.contentOffset.y), animated: false)
                    scrollView.layoutIfNeeded()
                }
            }else{
                let newFConst = self.shouldShowHandlersOutsideOfView ? -self.handlerViewWidth : 0
                let newBConst = (-self.frame.size.width + self.blockView.frame.size.width + self.handlerViewWidth)
                let offset = scrollView.contentOffset.x - (fLeadConstriant.constant - newFConst)
                
                UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction] ) {
                    self.frontHandlerLeadConstraint?.constant = newFConst
                    self.backHandlerTrailConstraint?.constant = newBConst
                    scrollView.setContentOffset(CGPoint(x: offset, y: scrollView.contentOffset.y), animated: false)
                    scrollView.layoutIfNeeded()
                    self.blockView.layoutIfNeeded()
                }
                invalidateLongPressTimer()
            }
        }
    }
}
