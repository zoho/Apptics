//
//  AnnotationRectangleCircleView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 03/10/23.
//

import UIKit

struct ArrowPoints: Equatable{
    let start: CGRect
    let end: CGRect
}

protocol AnnotationShapeDelegateProtocol: AnyObject{
    func tapped(view: AnnotationShapeViewProtocol)
    func tappedOutside()
    
    func textBecameFirstResponder(view: AnnotationShapeViewProtocol)
    func frameChangeEnded(view: AnnotationShapeViewProtocol, arrowPoints: ArrowPoints?)
    func updateArrowPoints(view: AnnotationShapeViewProtocol, arrowPoints: ArrowPoints?)
    func textViewEditingEnded(view: AnnotationShapeViewProtocol)
    func showTextExceededAlert()
    func textEntered(_ text: String)
    func getParentViewHeight() -> CGFloat
}

protocol AnnotationShapeViewProtocol: UIView{
    var model: AnnotationRectangleCircleShapeModelProtocol { get set}
    var delegate: AnnotationShapeDelegateProtocol? {get set}
    func refreshTextElementToAdjustFrameBasedOnContent()
    func refreshArrowView(startFrom: CGRect?, endAt: CGRect?)
}


class AnnotationRectangleCircleView: UIView, AnnotationShapeViewProtocol{
    
    var model: AnnotationRectangleCircleShapeModelProtocol{
        didSet{
            refreshSelectionState()
            refreshAllShapeProperties()
        }
    }
    weak var delegate: AnnotationShapeDelegateProtocol?
    
    private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    
    private let minWidthOfContainerAllowedDuringResizing: CGFloat = 2
    private let minHeightOfContainerAllowedDuringResizing: CGFloat = 2
    
    private let leadingPaddingContainerView: CGFloat = 4
    private let trailingPaddingContainerView: CGFloat = 4
    private let topPaddingContainerView: CGFloat = 4
    private let bottomPaddingContainerView: CGFloat = 4
    
    static let widthOfCornerView: CGFloat = 20
    static let heightOfCornerView: CGFloat = 20
    
    private let dashPattern: [NSNumber] = [5,3]
    private var txtViewFrameBeforeCentering: CGRect? = nil
    private var isTextStartedEditing = false
    private var keyboardHeight: CGFloat = 0
    
    private var isArrowFrameInitiated: Bool = false
    private var isTextViewInitialCenteringDone: Bool = false
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        return containerView
    }()
    
    private lazy var shapeSelectionBorderView: UIView = {
        let shapeSelectionBorderView = UIView()
        shapeSelectionBorderView.translatesAutoresizingMaskIntoConstraints = false
        shapeSelectionBorderView.clipsToBounds = true
        return shapeSelectionBorderView
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    lazy var arrowLayer : CAShapeLayer = {
        let arrowLayer = CAShapeLayer()
        return arrowLayer
    }()
    
    private lazy var textView: BGColoredTextView = {
        let textView = BGColoredTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.isSelectable = true
        return textView
    }()

    private var topLeftPanViewWidthConstraint: NSLayoutConstraint? = nil
    private var topRightPanViewWidthConstraint: NSLayoutConstraint? = nil
    private var botttomLeftPanViewWidthConstraint: NSLayoutConstraint? = nil
    private var bottomRightPanViewWidthConstraint: NSLayoutConstraint? = nil
    
    private var topLeftPanViewHeightConstraint: NSLayoutConstraint? = nil
    private var topRightPanViewHeightConstraint: NSLayoutConstraint? = nil
    private var botttomLeftPanViewHeightConstraint: NSLayoutConstraint? = nil
    private var bottomRightPanViewHeightConstraint: NSLayoutConstraint? = nil
    
    private var normalScreenRatioFactor: CGFloat = 0
    
    private lazy var topLeftPanView: ShapeCornerView = {
        let topLeftPanView = ShapeCornerView(type: .topLeft, delegate: self)
        topLeftPanView.translatesAutoresizingMaskIntoConstraints = false
//        topLeftPanView.backgroundColor = .brown
        return topLeftPanView
    }()
    
    private lazy var topRightPanView: ShapeCornerView = {
        let topRightPanView = ShapeCornerView(type: .topRight, delegate: self)
        topRightPanView.translatesAutoresizingMaskIntoConstraints = false
//        topRightPanView.backgroundColor = .brown
        return topRightPanView
    }()
    
    private lazy var bottomLeftPanView: ShapeCornerView = {
        let bottomLeftPanView = ShapeCornerView(type: .bottomLeft, delegate: self)
        bottomLeftPanView.translatesAutoresizingMaskIntoConstraints = false
//        bottomLeftPanView.backgroundColor = .brown
        return bottomLeftPanView
    }()
    
    private lazy var bottomRightPanView: ShapeCornerView = {
        let bottomRightPanView = ShapeCornerView(type: .bottomRight, delegate: self)
        bottomRightPanView.translatesAutoresizingMaskIntoConstraints = false
//        bottomRightPanView.backgroundColor = .brown
        return bottomRightPanView
    }()
    
    private lazy var startArrowPanView: ShapeCornerView = {
        let startArrowPanView = ShapeCornerView(type: .arrowStart, delegate: self)
//        startArrowPanView.translatesAutoresizingMaskIntoConstraints = false
//        startArrowPanView.backgroundColor = .brown
        startArrowPanView.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleRightMargin]
        return startArrowPanView
    }()
    
    private lazy var endArrowPanView: ShapeCornerView = {
        let endArrowPanView = ShapeCornerView(type: .arrowEnd, delegate: self)
//        endArrowPanView.translatesAutoresizingMaskIntoConstraints = false
//        endArrowPanView.backgroundColor = .brown
        endArrowPanView.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin]
        return endArrowPanView
    }()
    
    private lazy var dashedLayer: CAShapeLayer = {
        let dashedLayer = CAShapeLayer()
        dashedLayer.fillColor = UIColor.clear.cgColor
        return dashedLayer
    }()
    
    init(model: AnnotationRectangleCircleShapeModelProtocol, delegate: AnnotationShapeDelegateProtocol) {
        self.model = model
        self.delegate = delegate
        super.init(frame: .zero)
        configure()
        refreshSelectionState()
        refreshAllShapeProperties()
        normalScreenRatioFactor = model.screenRatio
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addArrowPanningView(){
        addSubview(containerView)
        containerView.clipsToBounds = false // Needed for arrow drawing
        addSubviews(startArrowPanView, endArrowPanView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addPanningViewAtFourCorners(){
        addSubview(containerView)
        addSubviews(topLeftPanView,topRightPanView,bottomLeftPanView,bottomRightPanView)
        
        let widthOfCornerView = AnnotationRectangleCircleView.widthOfCornerView
        let heightOfCornerView = AnnotationRectangleCircleView.heightOfCornerView
        
        
        let tLeftWidthConstraint = topLeftPanView.widthAnchor.constraint(equalToConstant: widthOfCornerView)
        let tRightWidthConstraint = topRightPanView.widthAnchor.constraint(equalToConstant: widthOfCornerView)
        let bLeftWidthConstraint =  bottomLeftPanView.widthAnchor.constraint(equalToConstant: widthOfCornerView)
        let bRightWidthConstraint = bottomRightPanView.widthAnchor.constraint(equalToConstant: widthOfCornerView)
        
        let tLeftHeightConstraint = topLeftPanView.heightAnchor.constraint(equalToConstant: heightOfCornerView)
        let tRightHeightConstraint = topRightPanView.heightAnchor.constraint(equalToConstant: heightOfCornerView)
        let bLeftHeightConstraint =  bottomLeftPanView.heightAnchor.constraint(equalToConstant: heightOfCornerView)
        let bRightHeightConstraint = bottomRightPanView.heightAnchor.constraint(equalToConstant: heightOfCornerView)
        
        topLeftPanViewWidthConstraint = tLeftWidthConstraint
        topRightPanViewWidthConstraint = tRightWidthConstraint
        botttomLeftPanViewWidthConstraint = bLeftWidthConstraint
        bottomRightPanViewWidthConstraint = bRightWidthConstraint
        
        topLeftPanViewHeightConstraint = tLeftHeightConstraint
        topRightPanViewHeightConstraint = tRightHeightConstraint
        botttomLeftPanViewHeightConstraint = bLeftHeightConstraint
        bottomRightPanViewHeightConstraint = bRightHeightConstraint
        
        NSLayoutConstraint.activate([
            topLeftPanView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLeftPanView.topAnchor.constraint(equalTo: topAnchor),
            tLeftWidthConstraint,
            tLeftHeightConstraint,
            
            topRightPanView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topRightPanView.topAnchor.constraint(equalTo: topAnchor),
            tRightWidthConstraint,
            tRightHeightConstraint,
            
            bottomLeftPanView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLeftPanView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bLeftWidthConstraint,
            bLeftHeightConstraint,
            
            bottomRightPanView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomRightPanView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bRightWidthConstraint,
            bRightHeightConstraint,
        ])
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: topLeftPanView.centerXAnchor),
            containerView.trailingAnchor.constraint(equalTo: topRightPanView.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: topLeftPanView.centerYAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomLeftPanView.centerYAnchor)
        ])
    }
    
    private func configure() {
//        self.backgroundColor = .orange
//        containerView.backgroundColor = .yellow
        
        switch model.shape.type{
            
        case .rectangle:
            addPanningViewAtFourCorners()
            break
            
        case .circle(let color, _, _) :
            addPanningViewAtFourCorners()
            shapeSelectionBorderView.layer.borderWidth = 1
            insertSubview(shapeSelectionBorderView, at: 0)
            
            shapeSelectionBorderView.layer.borderColor = color.withAlphaComponent(0.2).cgColor
            NSLayoutConstraint.activate([
                shapeSelectionBorderView.leadingAnchor.constraint(equalTo: topLeftPanView.centerXAnchor),
                shapeSelectionBorderView.trailingAnchor.constraint(equalTo: topRightPanView.centerXAnchor),
                shapeSelectionBorderView.topAnchor.constraint(equalTo: topLeftPanView.centerYAnchor),
                shapeSelectionBorderView.bottomAnchor.constraint(equalTo: bottomLeftPanView.centerYAnchor)
            ])
            
        case .arrow(_, _, _):
            addArrowPanningView()
            containerView.layer.addSublayer(arrowLayer)
            
        case .blur:
            addPanningViewAtFourCorners()
            containerView.addSubview(blurView)
            NSLayoutConstraint.activate([
                blurView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                blurView.topAnchor.constraint(equalTo: containerView.topAnchor),
                blurView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
            
        case .text(let color, let textString, let fontSize, let textStyle, let textBG):
            removeObservers()
            addKeyboardObservers()
            addPanningViewAtFourCorners()
            
            let attributedString = NSMutableAttributedString(string: textString)
            let size = getFontSize(withLevel: fontSize.selectedFontSize)
            
            let paragraphStyle = getParagraphStyle()
            
            let backgroundColor = UIColor.white.withAlphaComponent(textBG.opacity) // Set alpha component here
            var attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: color,
                .paragraphStyle: paragraphStyle
            ]
            
            let selectedFontSize = size
            switch textStyle {
            case .regular:
                attributes[.font] = UIFont.systemFont(ofSize: selectedFontSize)
            case .bold:
                attributes[.font] = UIFont.boldSystemFont(ofSize: selectedFontSize)
            case .italic:
                attributes[.font] = UIFont.italicSystemFont(ofSize: selectedFontSize)
            case .boldItalic:
                attributes[.font] = UIFont.systemFont(ofSize: selectedFontSize).boldItalic()
            }
        
            attributedString.addAttributes(attributes, range: NSRange(location: 0, length: textString.count))
            textView.attributedText = attributedString
            
            containerView.addSubview(textView)
            
            NSLayoutConstraint.activate([
                textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                textView.topAnchor.constraint(equalTo: containerView.topAnchor),
                textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                textView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                textView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
            ])
            shapeSelectionBorderView.layer.borderWidth = 2
            insertSubview(shapeSelectionBorderView, at: 0)
            shapeSelectionBorderView.layer.borderColor = color.cgColor
            NSLayoutConstraint.activate([
                shapeSelectionBorderView.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: -5),
                shapeSelectionBorderView.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 5),
                shapeSelectionBorderView.topAnchor.constraint(equalTo: textView.topAnchor),
                shapeSelectionBorderView.bottomAnchor.constraint(equalTo: textView.bottomAnchor)
            ])
            textView.becomeFirstResponder()
            textView.bgColor = backgroundColor
        case .block:
            addPanningViewAtFourCorners()
            break
            
        }
        
        containerView.layer.addSublayer(dashedLayer)
        
        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(tapGesture)
    }
    
    private func getParagraphStyle() -> NSMutableParagraphStyle{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        return paragraphStyle
    }
    
    private func getFontSize(withLevel level: Int) -> CGFloat{
        let lvl = 16 + (level - 1) * 2
        let fontSize = CGFloat(lvl) * model.screenRatio
        return CGFloat(fontSize)
    }
    
    private func getWidthSize(withLevel level: Int) -> CGFloat{
        let lvl = 2.0 + Double(level - 1) * 0.8
        let widthSize = CGFloat(lvl) * model.screenRatio
        return CGFloat(widthSize)
    }
    
    private func reframeArrowPanViews(newWidth: CGFloat, newHeight: CGFloat){
        var newFrameOfStartArrowPanView = startArrowPanView.frame
        if startArrowPanView.frame.origin.x == 0{
            newFrameOfStartArrowPanView = CGRectMake(newFrameOfStartArrowPanView.origin.x,
                                                     newFrameOfStartArrowPanView.origin.y,
                                                     newWidth,
                                                     newFrameOfStartArrowPanView.size.height)
        }else{
            newFrameOfStartArrowPanView = CGRectMake(self.frame.size.width - newWidth,
                                                     newFrameOfStartArrowPanView.origin.y,
                                                     newWidth,
                                                     newFrameOfStartArrowPanView.size.height)
        }
        
        if startArrowPanView.frame.origin.y == 0{
            newFrameOfStartArrowPanView = CGRectMake(newFrameOfStartArrowPanView.origin.x,
                                                     newFrameOfStartArrowPanView.origin.y,
                                                     newFrameOfStartArrowPanView.size.width,
                                                     newHeight)
        }else{
            newFrameOfStartArrowPanView = CGRectMake(newFrameOfStartArrowPanView.origin.x,
                                                     self.frame.size.height - newHeight,
                                                     newFrameOfStartArrowPanView.size.width,
                                                     newHeight)
        }
        
        var newFrameOfEndArrowPanView = endArrowPanView.frame
        if endArrowPanView.frame.origin.x == 0{
            newFrameOfEndArrowPanView = CGRectMake(newFrameOfEndArrowPanView.origin.x,
                                                   newFrameOfEndArrowPanView.origin.y,
                                                   newWidth,
                                                   newFrameOfEndArrowPanView.size.height)
        }else{
            newFrameOfEndArrowPanView = CGRectMake(self.frame.size.width - newWidth,
                                                   newFrameOfEndArrowPanView.origin.y,
                                                   newWidth,
                                                   newFrameOfEndArrowPanView.size.height)
        }
        
        if endArrowPanView.frame.origin.y == 0{
            newFrameOfEndArrowPanView = CGRectMake(newFrameOfEndArrowPanView.origin.x,
                                                   newFrameOfEndArrowPanView.origin.y,
                                                   newFrameOfEndArrowPanView.size.width,
                                                   newHeight)
        }else{
            newFrameOfEndArrowPanView = CGRectMake(newFrameOfEndArrowPanView.origin.x,
                                                   self.frame.size.height - newHeight,
                                                   newFrameOfEndArrowPanView.size.width,
                                                   newHeight)
        }
        
        startArrowPanView.frame = newFrameOfStartArrowPanView
        endArrowPanView.frame = newFrameOfEndArrowPanView
    }
    
    func refreshCornerPanViews(isInFullScreen: Bool) -> CGFloat {
        guard normalScreenRatioFactor != 0 else {return 0 }
        
        let widthConstant = AnnotationRectangleCircleView.widthOfCornerView
        let heightConstant = AnnotationRectangleCircleView.heightOfCornerView

        var isTextElement = false
        if case .text(_, _, _, _, _) = model.shape.type {
            isTextElement = true
        }
        
        if isInFullScreen, !isTextElement{
            let newScreenRatioFactor = model.screenRatio
            let newWidth = (widthConstant * newScreenRatioFactor) / normalScreenRatioFactor
            let newHeight = newWidth
            
            if let topLeftConstaint = topLeftPanViewWidthConstraint, topLeftConstaint.constant != newWidth{
                topLeftPanViewWidthConstraint?.constant = newWidth
                topRightPanViewWidthConstraint?.constant = newWidth
                botttomLeftPanViewWidthConstraint?.constant = newWidth
                bottomRightPanViewWidthConstraint?.constant = newWidth
                
                topLeftPanViewHeightConstraint?.constant = newHeight
                topRightPanViewHeightConstraint?.constant = newHeight
                botttomLeftPanViewHeightConstraint?.constant = newHeight
                bottomRightPanViewHeightConstraint?.constant = newHeight
            }
            if startArrowPanView.superview != nil{
                reframeArrowPanViews(newWidth: newWidth, newHeight: newHeight)
            }
        }else{
            if let topLeftConstaint = topLeftPanViewWidthConstraint, topLeftConstaint.constant != widthConstant{
                topLeftPanViewWidthConstraint?.constant = widthConstant
                topRightPanViewWidthConstraint?.constant = widthConstant
                botttomLeftPanViewWidthConstraint?.constant = widthConstant
                bottomRightPanViewWidthConstraint?.constant = widthConstant
                
                topLeftPanViewHeightConstraint?.constant = heightConstant
                topRightPanViewHeightConstraint?.constant = heightConstant
                botttomLeftPanViewHeightConstraint?.constant = heightConstant
                bottomRightPanViewHeightConstraint?.constant = heightConstant
            }
            
            if startArrowPanView.superview != nil{
                reframeArrowPanViews(newWidth: widthConstant, newHeight: heightConstant)
            }
        }
        return normalScreenRatioFactor
    }
    
    func refreshTextElementToAdjustFrameBasedOnContent() {
        let widthOfCornerView = AnnotationRectangleCircleView.widthOfCornerView
        let heightOfCornerView = AnnotationRectangleCircleView.heightOfCornerView
        switch model.shape.type{
        case .text:
            guard let superview = superview else {return}
            let maxAvailableWidth = superview.frame.size.width - (widthOfCornerView + textView.textContainerInset.right + textView.textContainerInset.left)
            let maxAvailableHeight = superview.frame.size.height - (heightOfCornerView + textView.textContainerInset.top + textView.textContainerInset.bottom)
            
            let sizeOfTxtView = textView.sizeThatFits(CGSize(width: maxAvailableWidth, height: maxAvailableHeight))
            let newWidth = max(sizeOfTxtView.width, minWidthOfContainerAllowedDuringResizing) + widthOfCornerView
            var newHeight = max(sizeOfTxtView.height, minHeightOfContainerAllowedDuringResizing) + heightOfCornerView
            var newFrame: CGRect
            
            if newHeight > maxAvailableHeight {
                newHeight = maxAvailableHeight
            }
            
            let yBottom = newHeight + frame.origin.y - (heightOfCornerView + textView.textContainerInset.top + textView.textContainerInset.bottom)
            let xEnd = newWidth + frame.origin.x - (widthOfCornerView + textView.textContainerInset.right + textView.textContainerInset.left)
            
            let newX: CGFloat
            let newY: CGFloat
            if yBottom >= maxAvailableHeight{
                let diff = yBottom - maxAvailableHeight
                newY = frame.origin.y - diff
            }else{
                newY = frame.origin.y
            }
            
            if xEnd >= maxAvailableWidth{
                let diff = xEnd - maxAvailableWidth
                newX = frame.origin.x - diff
            }else{
                newX = frame.origin.x
            }
            
            newFrame = CGRect(x: newX,
                              y: newY,
                              width: newWidth,
                              height: newHeight)
            
            if isTextStartedEditing{
                let pHeight = delegate?.getParentViewHeight() ?? 0.0
                let yPad: CGFloat = 20.0
                let isKHidingContent = (newY + newHeight + yPad) > (pHeight - keyboardHeight)
                if isKHidingContent{ // While editing keyboard is hiding the text element
                    let keyBoardHidingDiff = (newY + newHeight + yPad) - (pHeight - keyboardHeight)
                    let yPt = (newY - keyBoardHidingDiff) > 0 ? (newY - keyBoardHidingDiff) : 0
                    newFrame = CGRect(x: newX,
                                      y: yPt,
                                      width: newWidth,
                                      height: newHeight - keyBoardHidingDiff)
                }
            }
            
            if frame != newFrame{
                UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction] ) {
                    self.frame = newFrame
                }
            }
        default: break
        }
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let superview = self.superview else { return }
        var arrowPoints: ArrowPoints? = nil
        switch model.shape.type {
        case .arrow:
            if gestureRecognizer.state == .began {
                let point = gestureRecognizer.location(in: self)
                if let strokePath = arrowLayer.path?.copy(strokingWithWidth: 40, lineCap: CGLineCap.round, lineJoin: CGLineJoin.round, miterLimit: 1), !strokePath.contains(point) {
                    gestureRecognizer.isEnabled = false
                    gestureRecognizer.isEnabled = true
                    return
                }
            }
            arrowPoints = ArrowPoints(start: startArrowPanView.frame, end: endArrowPanView.frame)
        default:
            break
        }
        
        let translation = gestureRecognizer.translation(in: superview)
        
        var newCenter = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        newCenter.x = max(bounds.width / 2, min(superview.bounds.width - bounds.width / 2, newCenter.x))
        newCenter.y = max(bounds.height / 2, min(superview.bounds.height - bounds.height / 2, newCenter.y))
        
        self.center = newCenter
        
        gestureRecognizer.setTranslation(.zero, in: superview)
        
        if gestureRecognizer.state == .ended {
            delegate?.frameChangeEnded(view: self, arrowPoints: arrowPoints)
        }
    }
    
    func refreshArrowView(startFrom: CGRect?, endAt: CGRect?) {
        guard let startFrom = startFrom, let endAt = endAt, case .arrow = model.shape.type else {return}
        startArrowPanView.frame = startFrom
        endArrowPanView.frame = endAt
        reAssignAutoResizingMaskForArrowStartAndEndHandlerView()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshColorBorderSyleAndWidth()
    }
    
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        switch model.shape.type {
        case .arrow:
            let point = gestureRecognizer.location(in: self)
            if let strokePath = arrowLayer.path?.copy(strokingWithWidth: 40, lineCap: CGLineCap.round, lineJoin: CGLineJoin.round, miterLimit: 1), strokePath.contains(point) {
                delegate?.tapped(view: self)
            }else{
                delegate?.tappedOutside()
            }
        default:
            if !isTextStartedEditing{
                delegate?.tapped(view: self)
            }
        }
    }
    
    private func refreshSelectionState(){
        
        panGesture.isEnabled = model.isSelected
        if case .text = model.shape.type{ // For text element hide all resizing views
            topLeftPanView.isHidden = true
            topRightPanView.isHidden = true
            bottomLeftPanView.isHidden = true
            bottomRightPanView.isHidden = true
            
            if isTextStartedEditing{ // When Text is in editing mode dont enable panning of view
                panGesture.isEnabled = false
            }
        }else if case .arrow = model.shape.type {
            startArrowPanView.isHidden = !model.isSelected
            endArrowPanView.isHidden = !model.isSelected
        }else{
            topLeftPanView.isHidden = !model.isSelected
            topRightPanView.isHidden = !model.isSelected
            bottomLeftPanView.isHidden = !model.isSelected
            bottomRightPanView.isHidden = !model.isSelected
        }
    }
    
    private func refreshColorBorderSyleAndWidth(){
        switch model.shape.type {
        case .circle(let color, let style, let width) :
            refreshCircleShape(color: color, style: style, width: width)
        case .rectangle(let color, let style, let width):
            refreshRectangleShape(color: color, style: style, width: width)
        case .arrow(let color, let style, let width):
            if !isArrowFrameInitiated{
                let widthOfCornerView = AnnotationRectangleCircleView.widthOfCornerView
                let heightOfCornerView = AnnotationRectangleCircleView.heightOfCornerView
                self.startArrowPanView.frame = CGRect(x: 0, y: 0, width: widthOfCornerView, height: heightOfCornerView)
                self.endArrowPanView.frame = CGRect(x: self.frame.size.width - widthOfCornerView, y: 0, width: widthOfCornerView, height: heightOfCornerView)
                isArrowFrameInitiated = true
                delegate?.updateArrowPoints(view: self, arrowPoints: ArrowPoints(start: startArrowPanView.frame, end: endArrowPanView.frame))
            }
            refreshArrowShape(color: color, style: style, width: width)
        default: break
        }
    }
    
    private func refreshAllShapeProperties(){
        switch model.shape.type {
        case .circle(let color, let style, let width) :
            refreshCircleShape(color: color, style: style, width:width)
        case .rectangle(let color, let style, let width):
            refreshRectangleShape(color: color, style: style, width: width)
        case .arrow(let color, let style, let width):
            refreshArrowShape(color: color, style: style, width: width)
        case .text(let color, let textString, let fontSize, let textStyle, let textBG):
            refreshTextShape(color: color, textString: textString, fontSize: fontSize, textStyle: textStyle, textBG: textBG)
        case .block(let color):
            refreshBlockView(color: color)
        default: break
        }
    }
    
    private func configureContainterViewProperties(color: UIColor){
        containerView.layer.borderColor = color.cgColor
        guard let borderWidth = model.shape.getBorderWidth() else {return}
        containerView.layer.borderWidth = CGFloat(borderWidth)
    }
    
    func editTextTapped(){
        textView.becomeFirstResponder()
    }
    
    deinit{
        removeObservers()
    }
}

extension AnnotationRectangleCircleView: UITextViewDelegate{
    func makeViewToAdjustBasedOnKeyBoardSize(){
        guard let superview = self.superview else { return }
        let newCenter = CGPoint(x: superview.frame.size.width/2.0, y: superview.frame.size.height/2.0)
        let pHeight = delegate?.getParentViewHeight() ?? 0.0
        let availHeight = (pHeight - keyboardHeight)
        let yPad: CGFloat = 20.0
        
        if (newCenter.y + frame.size.height/2.0 + yPad) > availHeight{
            let newCenter = CGPoint(x: superview.frame.size.width/2.0, y: availHeight/2.0)
            self.center = newCenter
            
            let keyBoardHidingDiff = (frame.origin.y + frame.size.height + yPad) - (pHeight - keyboardHeight)
            let yPt = (frame.origin.y - keyBoardHidingDiff) > 0 ? (frame.origin.y - keyBoardHidingDiff) : 0
            frame = CGRect(x: frame.origin.x,
                           y: yPt,
                           width: frame.size.width,
                           height: frame.size.height - keyBoardHidingDiff)
        }else{
            self.center = newCenter
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if model.isSelected{
            isTextStartedEditing = true
            textView.isScrollEnabled = true
            delegate?.textBecameFirstResponder(view: self)
            txtViewFrameBeforeCentering = frame
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                UIView.animate(withDuration: 0.2) {
                    self.makeViewToCenterInItsSuperView()
                }
            }
            return true
        }else{
            delegate?.tapped(view: self)
            return false
        }
    }
    
    func textViewDidChange(_ txtView: UITextView) {
        delegate?.textEntered(txtView.text)
        refreshTextElementToAdjustFrameBasedOnContent()
        makeViewToCenterInItsSuperView()
        checkTheTxtSizeAndAlertIfTextExceeded()
    }
    
    func checkTheTxtSizeAndAlertIfTextExceeded(){
        guard let superview = self.superview else { return }
        let widthOfCornerView = AnnotationRectangleCircleView.widthOfCornerView
        let heightOfCornerView = AnnotationRectangleCircleView.heightOfCornerView
    
        let maxAvailableWidth = superview.frame.size.width - (widthOfCornerView + textView.textContainerInset.right + textView.textContainerInset.left)
        let maxAvailableHeight = superview.frame.size.height - ( heightOfCornerView + textView.textContainerInset.top + textView.textContainerInset.bottom)
        
        let sizeOfTxtView = textView.sizeThatFits(CGSize(width: maxAvailableWidth, height: maxAvailableHeight))
        
        if sizeOfTxtView.height >= maxAvailableHeight{
            // Show Size execeeded alert
            delegate?.showTextExceededAlert()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        isTextStartedEditing = false
        textView.isScrollEnabled = false
        guard let superview = self.superview else { return }
        let widthOfCornerView = AnnotationRectangleCircleView.widthOfCornerView
        let heightOfCornerView = AnnotationRectangleCircleView.heightOfCornerView
        
        guard var txtViewFrameBeforeCentering = txtViewFrameBeforeCentering else {return}
        if !isTextViewInitialCenteringDone { // After intial shape addition and textview resigned case, make shape view centered in its superview
            txtViewFrameBeforeCentering = self.frame
            isTextViewInitialCenteringDone = true
        }
        
        let maxAvailableWidth = superview.frame.size.width - (widthOfCornerView + textView.textContainerInset.right + textView.textContainerInset.left)
        let maxAvailableHeight = superview.frame.size.height - ( heightOfCornerView + textView.textContainerInset.top + textView.textContainerInset.bottom)
        
        let sizeOfTxtView = textView.sizeThatFits(CGSize(width: maxAvailableWidth, height: maxAvailableHeight))
        var finalFrame = frame
        
        if sizeOfTxtView.height >= maxAvailableHeight{
            // Show Size execeeded alert
            
            let newWidth = max(sizeOfTxtView.width, minWidthOfContainerAllowedDuringResizing) + widthOfCornerView
            let newHeight = max(maxAvailableHeight, minHeightOfContainerAllowedDuringResizing) + heightOfCornerView
            
            if (txtViewFrameBeforeCentering.origin.x + newWidth >= superview.frame.size.width) { // Applying computed width makes txt view to go out of bounds
                let xDelta = superview.frame.size.width - (txtViewFrameBeforeCentering.origin.x + txtViewFrameBeforeCentering.size.width)
                let x = txtViewFrameBeforeCentering.origin.x - ( newWidth - (txtViewFrameBeforeCentering.size.width + xDelta))
                
                finalFrame = CGRect(x: x ,
                                    y: 0,
                                    width: newWidth,
                                    height: newHeight)
                
            }else{
                finalFrame = CGRect(x: txtViewFrameBeforeCentering.origin.x,
                                    y: 0,
                                    width: newWidth,
                                    height: maxAvailableHeight)
            }
        }else{
            let newWidth = max(sizeOfTxtView.width, minWidthOfContainerAllowedDuringResizing) + widthOfCornerView
            let newHeight = max(sizeOfTxtView.height, minHeightOfContainerAllowedDuringResizing) + heightOfCornerView
            
            if (txtViewFrameBeforeCentering.origin.x + newWidth >= superview.frame.size.width) { // Applying computed width makes txt view to go out of bounds
                let xDelta = superview.frame.size.width - (txtViewFrameBeforeCentering.origin.x + txtViewFrameBeforeCentering.size.width)
                let x = txtViewFrameBeforeCentering.origin.x - ( newWidth - (txtViewFrameBeforeCentering.size.width + xDelta))
                if (txtViewFrameBeforeCentering.origin.y + newHeight) > superview.frame.size.height{ // Height also exceeded the superview height
                    let yDelta = superview.frame.size.height - (txtViewFrameBeforeCentering.origin.y + txtViewFrameBeforeCentering.size.height)
                    let yValue = txtViewFrameBeforeCentering.origin.y - ( newHeight - (txtViewFrameBeforeCentering.size.height + yDelta) )
                    finalFrame = CGRect(x: x ,
                                        y: yValue,
                                        width: newWidth,
                                        height: newHeight)
                }else{
                    finalFrame = CGRect(x: x ,
                                        y: txtViewFrameBeforeCentering.origin.y,
                                        width: newWidth,
                                        height: newHeight)
                }
            }else{
                if (txtViewFrameBeforeCentering.origin.y + newHeight) > superview.frame.size.height{ // Height exceeded the superview height
                    let yDelta = superview.frame.size.height - (txtViewFrameBeforeCentering.origin.y + txtViewFrameBeforeCentering.size.height)
                    let yValue = txtViewFrameBeforeCentering.origin.y - ( newHeight - (txtViewFrameBeforeCentering.size.height + yDelta) )
                    finalFrame = CGRect(x: txtViewFrameBeforeCentering.origin.x ,
                                        y: yValue,
                                        width: newWidth,
                                        height: newHeight)
                }else{
                    finalFrame = CGRect(x: txtViewFrameBeforeCentering.origin.x ,
                                        y: txtViewFrameBeforeCentering.origin.y,
                                        width: newWidth,
                                        height: newHeight)
                }
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.frame = finalFrame
            self.delegate?.textViewEditingEnded(view: self)
        }
    }
    
    private func makeViewToCenterInItsSuperView(){
        guard let superview = self.superview else { return }
        let newCenter = CGPoint(x: superview.frame.size.width/2.0, y: superview.frame.size.height/2.0)
        let pHeight = delegate?.getParentViewHeight() ?? 0.0
        let availHeight = (pHeight - keyboardHeight)
        let yPad: CGFloat = 20.0
        
        if (newCenter.y + frame.size.height/2.0 + yPad) > availHeight{
            let keyBoardHidingDiff = (frame.origin.y + frame.size.height + yPad) - (pHeight - keyboardHeight)
            let yPt = (frame.origin.y - keyBoardHidingDiff) > 0 ? (frame.origin.y - keyBoardHidingDiff) : 0
            frame = CGRect(x: superview.frame.size.width/2.0 - frame.size.width/2.0,
                           y: yPt,
                           width: frame.size.width,
                           height: frame.size.height - keyBoardHidingDiff)
        }else{
            self.center = newCenter
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardHeight = 0
    }
    
    private func addKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
}

extension AnnotationRectangleCircleView: CornerViewDelegateProtocol{
    func panEnded(type: CornerViewType) {
        var arrowPoints: ArrowPoints? = nil
        switch type{
        case .arrowStart, .arrowEnd:
            let firstHolderFrame = self.convert(startArrowPanView.frame, to: self.superview)
            let secondHolderFrame = self.convert(endArrowPanView.frame, to: self.superview)

            let minX = min(firstHolderFrame.minX, secondHolderFrame.minX)
            let maxX = max(firstHolderFrame.maxX, secondHolderFrame.maxX)

            let minY = min(firstHolderFrame.minY, secondHolderFrame.minY)
            let maxY = max(firstHolderFrame.maxY, secondHolderFrame.maxY)
            
            self.frame.origin.x = minX
            self.frame.origin.y = minY

            self.frame.size.width = maxX - minX
            self.frame.size.height = maxY - minY
            var startArrowPanViewFrame = self.convert(firstHolderFrame, from: self.superview)
            var endArrowPanViewFrame = self.convert(secondHolderFrame, from: self.superview)
            
            if (startArrowPanViewFrame.origin.x < 0) && (startArrowPanViewFrame.origin.x > -0.1){
                startArrowPanViewFrame.origin.x = 0
            }
            if (endArrowPanViewFrame.origin.x < 0) && (endArrowPanViewFrame.origin.x > -0.1){
                endArrowPanViewFrame.origin.x = 0
            }
            
            startArrowPanView.frame = startArrowPanViewFrame
            endArrowPanView.frame = endArrowPanViewFrame
            arrowPoints = ArrowPoints(start: startArrowPanView.frame, end: endArrowPanView.frame)
            reAssignAutoResizingMaskForArrowStartAndEndHandlerView()
            
        default: break
        }
        delegate?.frameChangeEnded(view: self, arrowPoints: arrowPoints)
    }
    
    private func reAssignAutoResizingMaskForArrowStartAndEndHandlerView(){
        let startPanViewHorizontalMask: UIView.AutoresizingMask
        let startPanViewVerticalMask: UIView.AutoresizingMask
        
        if startArrowPanView.frame.origin.x == 0 {
            startPanViewHorizontalMask = .flexibleRightMargin
        }else{
            startPanViewHorizontalMask = .flexibleLeftMargin
        }
        
        if startArrowPanView.frame.origin.y == 0{
            startPanViewVerticalMask = .flexibleBottomMargin
        }else{
            startPanViewVerticalMask = .flexibleTopMargin
        }
        
        let endPanViewHorizontalMask: UIView.AutoresizingMask
        let endPanViewVerticalMask: UIView.AutoresizingMask

        
        if endArrowPanView.frame.origin.x == 0{
            endPanViewHorizontalMask = .flexibleRightMargin
        }else{
            endPanViewHorizontalMask = .flexibleLeftMargin
        }
        
        if endArrowPanView.frame.origin.y == 0{
            endPanViewVerticalMask = .flexibleBottomMargin
        }else{
            endPanViewVerticalMask = .flexibleTopMargin
        }
        
        startArrowPanView.autoresizingMask = [startPanViewHorizontalMask, startPanViewVerticalMask]
        endArrowPanView.autoresizingMask = [endPanViewHorizontalMask, endPanViewVerticalMask]
    }
    
    func panAction(_ translation: CGPoint, type: CornerViewType) {
        guard let superview = self.superview else { return }
        let widthOfCornerView = AnnotationRectangleCircleView.widthOfCornerView
        let heightOfCornerView = AnnotationRectangleCircleView.heightOfCornerView
        
        var newFrame = frame
        switch type{
        case .topLeft:
            var nX = frame.origin.x + translation.x
            var nY = frame.origin.y + translation.y
            var nWidth = frame.size.width - translation.x
            var nHeight = frame.size.height - translation.y
            
            if nWidth <= (widthOfCornerView + widthOfCornerView + minWidthOfContainerAllowedDuringResizing) {
                nX = frame.origin.x
                nWidth =  frame.size.width
            }
            
            if nHeight <= (heightOfCornerView + heightOfCornerView + minHeightOfContainerAllowedDuringResizing) {
                nY = frame.origin.y
                nHeight = frame.size.height
            }
            
            if nX <= 0 {
                nX = frame.origin.x
                nWidth = frame.size.width
            }
            
            if nY <= 0 {
                nY = frame.origin.y
                nHeight = frame.size.height
            }
            
            newFrame =  CGRect(x: nX, y: nY, width: nWidth, height: nHeight)
            
            
        case .topRight:
            
            var nY = frame.origin.y + translation.y
            var nWidth = frame.size.width + translation.x
            var nHeight = frame.size.height - translation.y
            
            if nWidth <= (widthOfCornerView + widthOfCornerView + minWidthOfContainerAllowedDuringResizing) {
                nWidth =  frame.size.width
            }
            
            if nHeight <= (heightOfCornerView + heightOfCornerView + minHeightOfContainerAllowedDuringResizing) {
                nY = frame.origin.y
                nHeight = frame.size.height
            }
            
            if nY <= 0 {
                nY = frame.origin.y
                nHeight = frame.size.height
            }
            
            if nWidth + frame.origin.x > superview.frame.size.width {
                nWidth = frame.size.width
            }
            
            
            newFrame =  CGRect(x: frame.origin.x, y: nY, width: nWidth, height: nHeight)
            
        case .bottomLeft:
            
            var nX = frame.origin.x + translation.x
            var nWidth = frame.size.width - translation.x
            var nHeight = frame.size.height + translation.y
            
            if nWidth <= (widthOfCornerView + widthOfCornerView + minWidthOfContainerAllowedDuringResizing) {
                nX = frame.origin.x
                nWidth =  frame.size.width
            }
            
            if nHeight <= (heightOfCornerView + heightOfCornerView + minHeightOfContainerAllowedDuringResizing) {
                nHeight = frame.size.height
            }
            
            if nX <= 0 {
                nX = frame.origin.x
                nWidth = frame.size.width
            }
            
            if nHeight + frame.origin.y > superview.frame.size.height {
                nHeight = frame.size.height
            }
            
            newFrame =  CGRect(x: nX, y: frame.origin.y, width: nWidth, height: nHeight)
            
        case .bottomRight:
            
            var nWidth = frame.size.width + translation.x
            var nHeight = frame.size.height + translation.y
            
            if nWidth <= (widthOfCornerView + widthOfCornerView + minWidthOfContainerAllowedDuringResizing) {
                nWidth =  frame.size.width
            }
            
            if nHeight <= (heightOfCornerView + heightOfCornerView + minHeightOfContainerAllowedDuringResizing) {
                nHeight = frame.size.height
            }
            
            if nWidth + frame.origin.x > superview.frame.size.width {
                nWidth = frame.size.width
            }
            if nHeight + frame.origin.y > superview.frame.size.height {
                nHeight = frame.size.height
            }
            newFrame =  CGRect(x: frame.origin.x, y: frame.origin.y, width: nWidth, height: nHeight)
        
        case .arrowStart:
            var aX = startArrowPanView.frame.origin.x + translation.x
            var aY = startArrowPanView.frame.origin.y + translation.y
            if aX + frame.origin.x < 0 {
                aX = -1*frame.origin.x
            }
            if aX + startArrowPanView.frame.size.width + frame.origin.x > superview.frame.size.width {
                aX = superview.frame.size.width - frame.origin.x - startArrowPanView.frame.size.width
            }
            if aY + frame.origin.y < 0 {
                aY = -1*frame.origin.y
            }
            if aY + startArrowPanView.frame.size.height + frame.origin.y > superview.frame.size.height {
                aY = superview.frame.size.height - frame.origin.y - startArrowPanView.frame.size.height
            }
            startArrowPanView.frame = CGRect(x: aX, y: aY, width: startArrowPanView.frame.size.width, height: startArrowPanView.frame.size.height)
            setNeedsLayout()
            
        case .arrowEnd:
            var aX = endArrowPanView.frame.origin.x + translation.x
            var aY = endArrowPanView.frame.origin.y + translation.y
            if aX + frame.origin.x < 0 {
                aX = -1*frame.origin.x
            }
            if aX + endArrowPanView.frame.size.width + frame.origin.x > superview.frame.size.width {
                aX = superview.frame.size.width - frame.origin.x - endArrowPanView.frame.size.width
            }
            if aY + frame.origin.y < 0 {
                aY = -1*frame.origin.y
            }
            if aY + endArrowPanView.frame.size.height + frame.origin.y > superview.frame.size.height {
                aY = superview.frame.size.height - frame.origin.y - endArrowPanView.frame.size.height
            }
            endArrowPanView.frame = CGRect(x: aX, y: aY, width: endArrowPanView.frame.size.width, height: endArrowPanView.frame.size.height)
            setNeedsLayout()
        }
        frame = newFrame
    }
}

extension AnnotationRectangleCircleView{
    
    private func refreshCircleShape(color: UIColor, style: BorderStyleType, width: BorderWidth){
        let circleXPadding: CGFloat = shapeSelectionBorderView.layer.borderWidth
        let circleYPadding: CGFloat = shapeSelectionBorderView.layer.borderWidth
        let lWidth = getWidthSize(withLevel: width.selectedWidth)

        shapeSelectionBorderView.isHidden = !model.isSelected
        dashedLayer.isHidden = false
        dashedLayer.strokeColor = color.cgColor
        dashedLayer.lineWidth = lWidth
        
        let shapeRect = CGRect(x: lWidth + circleXPadding,
                               y: lWidth + circleYPadding,
                               width: containerView.bounds.size.width - 2*lWidth - 2*circleXPadding,
                               height: containerView.bounds.size.height - 2*lWidth - 2*circleYPadding)
        dashedLayer.path = UIBezierPath(ovalIn: shapeRect).cgPath
        
        
        switch style{
        case .dashed:
            dashedLayer.lineDashPattern = dashPattern
            containerView.layer.borderColor = UIColor.clear.cgColor
            
        case .solid:
            dashedLayer.lineDashPattern = nil
            containerView.layer.borderColor = UIColor.clear.cgColor
        }
        shapeSelectionBorderView.layer.borderColor = color.withAlphaComponent(0.2).cgColor
    }
    
    private func refreshRectangleShape(color: UIColor, style: BorderStyleType, width: BorderWidth){
        let lWidth = getWidthSize(withLevel: width.selectedWidth)

        switch style{
        case .dashed:
            let shapeRect = CGRect(x: CGFloat(width.selectedWidth),
                                   y: CGFloat(width.selectedWidth),
                                   width: containerView.bounds.size.width - 2*CGFloat(width.selectedWidth),
                                   height: containerView.bounds.size.height - 2*CGFloat(width.selectedWidth))
            dashedLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0).cgPath
            dashedLayer.isHidden = false
            dashedLayer.lineDashPattern = dashPattern
            dashedLayer.strokeColor = color.cgColor
            dashedLayer.lineWidth = lWidth
            containerView.layer.borderColor = UIColor.clear.cgColor
            
        case .solid:
            dashedLayer.isHidden = true
            
            containerView.layer.borderColor = color.cgColor
            containerView.layer.borderWidth = lWidth
        }
    }
    
    private func refreshArrowShape(color: UIColor, style: BorderStyleType, width: BorderWidth){
        let lWidth = getWidthSize(withLevel: width.selectedWidth)
        arrowLayer.lineWidth = CGFloat(lWidth)
        arrowLayer.fillColor = color.cgColor
        arrowLayer.strokeColor = color.cgColor
        let path = UIBezierPath.bezierPathWithArrowFromPoint(startPoint: startArrowPanView.center, endPoint: endArrowPanView.center, tailWidth: 1, headWidth: 10, headLength: 10)

        switch style{
        case .dashed:
            arrowLayer.lineDashPattern = dashPattern
        default: break
        }
        arrowLayer.path = path.cgPath
    }
    
    private func refreshTextShape(color: UIColor, textString: String, fontSize: FontSize, textStyle: TextStyle, textBG: TextBG){
        shapeSelectionBorderView.isHidden = !model.isSelected
        shapeSelectionBorderView.layer.borderColor = color.cgColor
        
        let attributedString = NSMutableAttributedString(string: textString)
        let size = getFontSize(withLevel: fontSize.selectedFontSize)
        let paragraphStyle = getParagraphStyle()
        
        let backgroundColor = UIColor.white.withAlphaComponent(textBG.opacity) // Set alpha component here
        var attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .paragraphStyle : paragraphStyle
        ]
        
        let selectedFontSize = size
        switch textStyle {
        case .regular:
            attributes[.font] = UIFont.systemFont(ofSize: selectedFontSize)
        case .bold:
            attributes[.font] = UIFont.boldSystemFont(ofSize: selectedFontSize)
        case .italic:
            attributes[.font] = UIFont.italicSystemFont(ofSize: selectedFontSize)
        case .boldItalic:
            attributes[.font] = UIFont.systemFont(ofSize: selectedFontSize).boldItalic()
        }
        
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: textString.count))
        textView.attributedText = attributedString
        textView.bgColor = backgroundColor
        refreshTextElementToAdjustFrameBasedOnContent()
    }
    
    private func refreshBlockView(color: UIColor){
        containerView.backgroundColor = color
    }
}


extension UIBezierPath {
    class func getAxisAlignedArrowPoints(points: inout [CGPoint], forLength: CGFloat, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) {
        let tailLength = forLength - headLength
        points.append(CGPointMake(0, tailWidth / 2))
        points.append(CGPointMake(tailLength, tailWidth / 2))
        points.append(CGPointMake(tailLength, headWidth / 2))
        points.append(CGPointMake(forLength, 0))
        points.append(CGPointMake(tailLength, -headWidth / 2))
        points.append(CGPointMake(tailLength, -tailWidth / 2))
        points.append(CGPointMake(0, -tailWidth / 2))
    }
    
    class func transformForStartPoint(startPoint: CGPoint, endPoint: CGPoint, length: CGFloat) -> CGAffineTransform {
        let cosine: CGFloat = (endPoint.x - startPoint.x) / length
        let sine: CGFloat = (endPoint.y - startPoint.y) / length
        
        return CGAffineTransformMake(cosine, sine, -sine, cosine, startPoint.x, startPoint.y)
    }
    
    class func bezierPathWithArrowFromPoint(startPoint: CGPoint,
                                            endPoint: CGPoint,
                                            tailWidth: CGFloat,
                                            headWidth: CGFloat,
                                            headLength: CGFloat) -> UIBezierPath
    {
        let xdiff = Float(endPoint.x) - Float(startPoint.x)
        let ydiff = Float(endPoint.y) - Float(startPoint.y)
        let length = hypotf(xdiff, ydiff)
        
        var points = [CGPoint]()
        getAxisAlignedArrowPoints(points: &points, forLength: CGFloat(length), tailWidth: tailWidth, headWidth: headWidth, headLength: headLength)
        
        let transform: CGAffineTransform = transformForStartPoint(startPoint: startPoint, endPoint: endPoint, length: CGFloat(length))
        
        let cgPath = CGMutablePath()
        cgPath.addLines(between: points, transform: transform)
        cgPath.closeSubpath()
        
        let uiPath = UIBezierPath(cgPath: cgPath)
        return uiPath

    }
}
