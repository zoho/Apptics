//
//  ToolBarView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 01/11/23.
//

import UIKit

protocol ToolBarViewProtocol: UIView {
    var currentState: State { get set }
    func audioButton(shouldEnable: Bool)
}

class ToolBarView: UIScrollView {
    
    var viewModel: ToolBarViewModelProtocol
    
    private let widthOfTickButton: CGFloat = 30
    private let heightOfTickButton: CGFloat = 30
    
    private let widthOfRecordButton: CGFloat = 50
    private let heightOfRecordButton: CGFloat = 50
    
    
    static let colorPalatteCollectionViewCellId = "CollectionCell"
    static let borderStylePalatteTableViewCellId = "TableCell"
    
    private var containers: [UIView] = []
    
    
    init(viewModel: ToolBarViewModelProtocol ) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.viewModel.view = self
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let itemSpacing: CGFloat = 5.0
    
    var currentState: State = .initialShapeAddition {
        didSet{
            switch currentState {
            case .initialShapeAddition:
                showInitialShapeAdditionState()
            case .videoTrimming:
                showVideoTrimmingState()
            case .rectOvalShapeAddition:
                showRectOvalShapeAdditionState()
            case .maskBlurShapeAddition:
                showMaskBlurShapeAdditionState()
            case .shapeAttribute(let color, let isOval):
                showShapeAttributeState(withColor: color, isOval: isOval)
            case .arrowShapeAttribute(let color):
                showArrowShapeAttributeState(withColor: color)
            case .blockAttribute(let color):
                showBlockAttributeState(withColor: color)
            case .shapeColorPalatte(let colors,let selectedIndex):
                showShapeAttributeColorPalatte(withColors: colors, selectedColorIndex: selectedIndex)
            case .textColorPalatte(let colors,let selectedIndex):
                showTextAttributeColorPalatte(withColors: colors, selectedColorIndex: selectedIndex)
            case .blockColorPalatte(let colors,let selectedIndex):
                showBlockColorPalatte(withColors: colors, selectedColorIndex: selectedIndex)
            case .arrowColorPalatte(let colors,let selectedIndex):
                showArrowColorPalatte(withColors: colors, selectedColorIndex: selectedIndex)
            case .borderStylePalatte(_, _, _, _):
                showBorderSelectionPalatte()
            case .borderWidthPalatte(let model, _, _) :
                showBorderWidthPalatte(withModel: model)
            case .arrowBorderWidthPalatte(let model, _):
                showArrowBorderWidthPalatte(withModel: model)
            case .audioRecording(let isRecording):
                showAudioRecordingState(isRecording: isRecording)
            case .videoTrimmingWithDuration(let durationStr):
                showVideoTrimmingState(withDuration: durationStr)
            case .textAttribute(let color):
                showTextAttributeState(color: color)
            case .textEditMode(let text):
                showTextEditModeState(withText: text)
            case .textSizeMode(let model):
                showTxtSizeAttributeView(model:model)
            case .textStyleMode(let model):
                showTxtStyleAttributeView(model:model)
            case .textBGMode(let model):
                showTxtBGAttributeView(model: model)
            case .audioRecordingButtonEnabled(let enabled):
                audioButton(shouldEnable: enabled)
            
            }
        }
    }
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = itemSpacing
        return stackView
    }()
    
    private lazy var videoTrimmedDurationContainerView: UIView = {
        let videoTrimmedDurationContainerView = UIView()
        videoTrimmedDurationContainerView.translatesAutoresizingMaskIntoConstraints = false
        return videoTrimmedDurationContainerView
    }()
    
    private lazy var rectOvalContainerView: UIView = {
        let rectOvalContainerView = UIView()
        rectOvalContainerView.translatesAutoresizingMaskIntoConstraints = false
        return rectOvalContainerView
    }()
    
    private lazy var maskBlurContainerView: UIView = {
        let maskBlurContainerView = UIView()
        maskBlurContainerView.translatesAutoresizingMaskIntoConstraints = false
        return maskBlurContainerView
    }()
    
    private lazy var shapeAttributeContainerView: UIView = {
        let shapeAttributeContainerView = UIView()
        shapeAttributeContainerView.translatesAutoresizingMaskIntoConstraints = false
        return shapeAttributeContainerView
    }()
    
    private lazy var arrowShapeAttributeContainerView: UIView = {
        let arrowShapeAttributeContainerView = UIView()
        arrowShapeAttributeContainerView.translatesAutoresizingMaskIntoConstraints = false
        return arrowShapeAttributeContainerView
    }()
    
    private lazy var textAttributeContainerView: UIView = {
        let textAttributeContainerView = UIView()
        textAttributeContainerView.translatesAutoresizingMaskIntoConstraints = false
        return textAttributeContainerView
    }()
    
    private lazy var blockAttributeContainerView: UIView = {
        let blockAttributeContainerView = UIView()
        blockAttributeContainerView.translatesAutoresizingMaskIntoConstraints = false
        return blockAttributeContainerView
    }()
    
    private lazy var audioRecorderContainerView: UIView = {
        let audioRecorderContainerView = UIView()
        audioRecorderContainerView.translatesAutoresizingMaskIntoConstraints = false
        return audioRecorderContainerView
    }()
    
    private lazy var recordAudioButton: UIButton = {
        let recordAudioButton = UIButton()
        recordAudioButton.translatesAutoresizingMaskIntoConstraints = false
        recordAudioButton.addTarget(self, action: #selector(recordOrStopAction), for: .touchUpInside)
        recordAudioButton.imageView?.contentMode = .center
        recordAudioButton.backgroundColor = .blue
        if #available(iOS 13.0, *) {
            let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
            if let micImage = UIImage(systemName: "mic", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate),
               let stopImage = UIImage(systemName: "stop.fill", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate){
                recordAudioButton.setImage(micImage, for: .normal)
                recordAudioButton.setImage(stopImage, for: .selected)
            }
        } else {
            // Fallback on earlier versions
        }
        recordAudioButton.tintColor = AnnotationEditorViewColors.recordAudioIconColor
        recordAudioButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        recordAudioButton.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return recordAudioButton
    }()
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        return timeLabel
    }()
    
    private lazy var tickButton: UIButton = {
        let tickButton = UIButton()
        tickButton.translatesAutoresizingMaskIntoConstraints = false
        tickButton.addTarget(self, action: #selector(okAction), for: .touchUpInside)
        tickButton.setImage(UIImage.named("tick"), for: .normal)
        tickButton.imageView?.contentMode = .scaleAspectFit
        tickButton.backgroundColor = UIColor(red: 225.0/255.0, green: 227.0/255.0, blue: 244.0/255.0, alpha: 1)
        return tickButton
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        closeButton.setImage(UIImage.named("down"), for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.backgroundColor = UIColor(red: 242.0/255.0, green: 243.0/255.0, blue: 245.0/255.0, alpha: 1)
        return closeButton
    }()
    private let sizeOfCollectionViewCell = CGSize(width: 25, height: 25)
    private let heightOfCollectionView: CGFloat = 60
    private let widthOfCollectionView: CGFloat = 130
    
    private let widthOfBorderStyleTableView: CGFloat = 130
    
    private let heightOfBorderWidthContainerView: CGFloat = 60
    private let widthOfBorderWidthContainerView: CGFloat = 130
    
    private let heightOfTxtSizeContainerView: CGFloat = 60
    private let heightOfTxtOpacityContainerView: CGFloat = 60
    private let widthOfTxtOpacityContainerView: CGFloat = 130
    
    private let widthOfTxtSizeContainerView: CGFloat = 130
    
    private let widthOfTxtStyleTableView: CGFloat = 130
    
    
    private lazy var colorPalatteCollectionView: ColorPalatteCollectionView = {
        let collectionView = ColorPalatteCollectionView(delegate: self)
        return collectionView
    }()
    
    private let heightOfCell: CGFloat = 25
    private let heightOfHeaderView: CGFloat = 7
    private let heightOfFooterView: CGFloat = 7
    
    private var borderStyleTableViewCenterXConstraint: NSLayoutConstraint?
    private var borderStyleTableViewTrailingConstraint: NSLayoutConstraint?
    private var borderStyleTableViewWidthConstraint: NSLayoutConstraint?
    private var borderStyleTableViewHeightConstraint: NSLayoutConstraint?
    private var borderStyleTableViewBottomConstraint: NSLayoutConstraint?

    
    private lazy var borderStyleTableView: PopUpTableView = {
        let tableView = PopUpTableView(tableDelegate: self)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: heightOfHeaderView))
        headerView.backgroundColor = AnnotationEditorViewColors.shapeColorPickerBGColor
        headerView.layer.cornerRadius = 5
        tableView.tableHeaderView = headerView
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: heightOfFooterView))
        footerView.backgroundColor = AnnotationEditorViewColors.shapeColorPickerBGColor
        footerView.layer.cornerRadius = 5
        tableView.tableFooterView = footerView
        footerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        tableView.register(BorderStyleTableViewCell.self, forCellReuseIdentifier: ToolBarView.borderStylePalatteTableViewCellId)
        tableView.backgroundColor = AnnotationEditorViewColors.shapeColorPickerBGColor
        return tableView
    }()
    
    
    //    private lazy var borderStyleContainerView: UIView = {
    //        let borderStyleContainerView = UIView()
    //        borderStyleContainerView.translatesAutoresizingMaskIntoConstraints = false
    //        return borderStyleContainerView
    //    }()
    //
    
    
    private var strokeWidthValue: Int = 0 {
        didSet{
            strokeWidthValueLabel.text = "\(strokeWidthValue) px"
        }
    }
    
    private var txtSizeValue: Int = 0 {
        didSet{
            txtSizeValueLabel.text = "\(txtSizeValue)"
        }
    }
    
    private var txtBGValue: CGFloat = 0 {
        didSet{
            let sliderValue = Int(txtBGValue * 100)
            txtOpacityValueLabel.text = "\(sliderValue) %"
        }
    }
    
    
    private lazy var borderWidthPalatteContainerView: UIView = {
        let borderWidthPalatteContainerView = UIView()
        borderWidthPalatteContainerView.layer.cornerRadius = 5
        
        borderWidthPalatteContainerView.clipsToBounds = true

        borderWidthPalatteContainerView.layer.shadowColor = UIColor.black.cgColor
        borderWidthPalatteContainerView.layer.shadowRadius = 4
        borderWidthPalatteContainerView.layer.shadowOpacity = 0.25
        borderWidthPalatteContainerView.layer.masksToBounds = false
        borderWidthPalatteContainerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        return borderWidthPalatteContainerView
    }()
    
    private lazy var txtSizeContainerView: UIView = {
        let txtSizeContainerView = UIView()
        txtSizeContainerView.layer.cornerRadius = 5
        
        txtSizeContainerView.clipsToBounds = true

        txtSizeContainerView.layer.shadowColor = UIColor.black.cgColor
        txtSizeContainerView.layer.shadowRadius = 4
        txtSizeContainerView.layer.shadowOpacity = 0.25
        txtSizeContainerView.layer.masksToBounds = false
        txtSizeContainerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        return txtSizeContainerView
    }()
    
    private lazy var txtBGContainerView: UIView = {
        let txtBGContainerView = UIView()
        txtBGContainerView.layer.cornerRadius = 5
        
        txtBGContainerView.clipsToBounds = true

        txtBGContainerView.layer.shadowColor = UIColor.black.cgColor
        txtBGContainerView.layer.shadowRadius = 4
        txtBGContainerView.layer.shadowOpacity = 0.25
        txtBGContainerView.layer.masksToBounds = false
        txtBGContainerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        return txtBGContainerView
    }()
    
    
    private lazy var strokeWidthLabel: UILabel = {
        let strokeWidthLabel = UILabel()
        strokeWidthLabel.translatesAutoresizingMaskIntoConstraints = false
        strokeWidthLabel.font = UIFont.systemFont(ofSize: 12)
        strokeWidthLabel.textColor = AnnotationEditorViewColors.strokeWidthLabelTxtColor
        strokeWidthLabel.text = "Border Width"
        return strokeWidthLabel
    }()
    
    private lazy var txtOpacityLabel: UILabel = {
        let txtOpacityLabel = UILabel()
        txtOpacityLabel.translatesAutoresizingMaskIntoConstraints = false
        txtOpacityLabel.font = UIFont.systemFont(ofSize: 12)
        txtOpacityLabel.textColor = AnnotationEditorViewColors.strokeWidthLabelTxtColor
        txtOpacityLabel.text = "Opacity"
        return txtOpacityLabel
    }()
    
    private lazy var txtOpacityValueLabel: UILabel = {
        let txtOpacityValueLabel = UILabel()
        txtOpacityValueLabel.translatesAutoresizingMaskIntoConstraints = false
        txtOpacityValueLabel.font = UIFont.systemFont(ofSize: 14)
        txtOpacityValueLabel.textColor = UIColor.label
        return txtOpacityValueLabel
    }()
    
    private lazy var txtOpacitySlider: UISlider = {
        let txtOpacitySlider = UISlider()
        txtOpacitySlider.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 13.0, *) {
            let configuration = UIImage.SymbolConfiguration(pointSize: 18)
            let image = UIImage(systemName: "circle.fill", withConfiguration: configuration)
            txtOpacitySlider.setThumbImage(image, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        txtOpacitySlider.addTarget(self, action: #selector(txtBGSliderChanged(_:)), for: .valueChanged)
        txtOpacitySlider.addTarget(self, action: #selector(txtBGSliderChangesEnded(_:)), for: .touchUpInside)
        txtOpacitySlider.addTarget(self, action: #selector(txtBGSliderChangesEnded(_:)), for: .touchUpOutside)
        return txtOpacitySlider
    }()
    
    
    private lazy var txtSizeLabel: UILabel = {
        let txtSizeLabel = UILabel()
        txtSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        txtSizeLabel.font = UIFont.systemFont(ofSize: 12)
        txtSizeLabel.textColor = AnnotationEditorViewColors.strokeWidthLabelTxtColor
        txtSizeLabel.text = "Text Size"
        return txtSizeLabel
    }()
    
    private lazy var strokeWidthValueLabel: UILabel = {
        let strokeWidthValueLabel = UILabel()
        //        strokeWidthValueLabel.backgroundColor = .orange
        strokeWidthValueLabel.translatesAutoresizingMaskIntoConstraints = false
        strokeWidthValueLabel.font = UIFont.systemFont(ofSize: 14)
        strokeWidthValueLabel.textColor = UIColor.label
        return strokeWidthValueLabel
    }()
    
    private lazy var txtSizeValueLabel: UILabel = {
        let txtSizeValueLabel = UILabel()
        txtSizeValueLabel.translatesAutoresizingMaskIntoConstraints = false
        txtSizeValueLabel.font = UIFont.systemFont(ofSize: 14)
        txtSizeValueLabel.textColor = UIColor.label
        return txtSizeValueLabel
    }()
    
    
    private lazy var strokeWidthSlider: UISlider = {
        let strokeWidthSlider = UISlider()
        strokeWidthSlider.translatesAutoresizingMaskIntoConstraints = false
    
        if #available(iOS 13.0, *) {
            let configuration = UIImage.SymbolConfiguration(pointSize: 18)
            let image = UIImage(systemName: "circle.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate).withTintColor(.systemBlue)
            strokeWidthSlider.setThumbImage(image, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        //        strokeWidthSlider.thumbTintColor = UIColor(red: 54.0/255.0, green: 90.0/255.0, blue: 240.0/255.0, alpha: 1)
        strokeWidthSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        strokeWidthSlider.addTarget(self, action: #selector(sliderChangesEnded(_:)), for: .touchUpInside)
        strokeWidthSlider.addTarget(self, action: #selector(sliderChangesEnded(_:)), for: .touchUpOutside)
        return strokeWidthSlider
    }()
    
    
    private lazy var txtSizeSlider: UISlider = {
        let txtSizeSlider = UISlider()
        txtSizeSlider.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 13.0, *) {
            let configuration = UIImage.SymbolConfiguration(pointSize: 18)
            let image = UIImage(systemName: "circle.fill", withConfiguration: configuration)
            txtSizeSlider.setThumbImage(image, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        txtSizeSlider.addTarget(self, action: #selector(txtSliderChanged(_:)), for: .valueChanged)
        txtSizeSlider.addTarget(self, action: #selector(txtSliderChangesEnded(_:)), for: .touchUpInside)
        txtSizeSlider.addTarget(self, action: #selector(txtSliderChangesEnded(_:)), for: .touchUpOutside)
        return txtSizeSlider
    }()
        
    private var shapeAttributeColorView: ImageWithLabelView? = nil
    private var txtAttributeColorView: ImageWithLabelView? = nil
    private var blockAttributeColorView: ImageWithLabelView? = nil
    private var arrowAttributeColorView: ImageWithLabelView? = nil
    private var arrowBorderWidthView: ImageWithLabelView? = nil
    
    private var borderStyleView: ImageWithLabelView? = nil
    private var borderWidthView: ImageWithLabelView? = nil
    private var audioButtonView: ImageWithLabelView? = nil
    
    private var txtEditAttributeView: ImageWithLabelView? = nil
    private var txtSizeAttributeView: ImageWithLabelView? = nil
    private var txtStyleAttributeView: ImageWithLabelView? = nil
    private var txtBGAttributeView: ImageWithLabelView? = nil
    
    private var colors: [UIColor] = []
    private var selectedColorIndex: Int = 0
    
    
    private func configureView(){
        
        backgroundColor = AnnotationEditorViewColors.bottomToolBarColor
        
        addSubviews(mainStackView, rectOvalContainerView, maskBlurContainerView, videoTrimmedDurationContainerView, shapeAttributeContainerView, arrowShapeAttributeContainerView, blockAttributeContainerView, audioRecorderContainerView, textAttributeContainerView)
        
        containers.append(contentsOf: [mainStackView, rectOvalContainerView, maskBlurContainerView, videoTrimmedDurationContainerView, shapeAttributeContainerView, arrowShapeAttributeContainerView, blockAttributeContainerView, audioRecorderContainerView, textAttributeContainerView])
        
        videoTrimmedDurationContainerView.addSubviews(timeLabel, tickButton, closeButton)
        audioRecorderContainerView.addSubview(recordAudioButton)
        
        hideAllContainersExcept(view: mainStackView)
        
        let trailingPaddingOfTickButton: CGFloat = 13
        let leadingPaddingOfCloseButton: CGFloat = 13
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor),
            mainStackView.heightAnchor.constraint(equalTo: heightAnchor),
            
            rectOvalContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            rectOvalContainerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            rectOvalContainerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            rectOvalContainerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            rectOvalContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            rectOvalContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            maskBlurContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            maskBlurContainerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            maskBlurContainerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            maskBlurContainerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            maskBlurContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            maskBlurContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            shapeAttributeContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            shapeAttributeContainerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            shapeAttributeContainerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            shapeAttributeContainerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            shapeAttributeContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            shapeAttributeContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            arrowShapeAttributeContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            arrowShapeAttributeContainerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            arrowShapeAttributeContainerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            arrowShapeAttributeContainerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            arrowShapeAttributeContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            arrowShapeAttributeContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            textAttributeContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            textAttributeContainerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            textAttributeContainerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            textAttributeContainerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            textAttributeContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            textAttributeContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            
            blockAttributeContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            blockAttributeContainerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            blockAttributeContainerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            blockAttributeContainerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            blockAttributeContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            blockAttributeContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([ // Video Trimming View Constraints
            videoTrimmedDurationContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoTrimmedDurationContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            videoTrimmedDurationContainerView.topAnchor.constraint(equalTo: topAnchor),
            videoTrimmedDurationContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            closeButton.leadingAnchor.constraint(equalTo: videoTrimmedDurationContainerView.leadingAnchor, constant: leadingPaddingOfCloseButton),
            closeButton.centerYAnchor.constraint(equalTo: videoTrimmedDurationContainerView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: widthOfTickButton),
            closeButton.heightAnchor.constraint(equalToConstant: heightOfTickButton),
            
            timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: videoTrimmedDurationContainerView.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: tickButton.leadingAnchor),
            timeLabel.centerXAnchor.constraint(equalTo: videoTrimmedDurationContainerView.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: videoTrimmedDurationContainerView.centerYAnchor),
            
            tickButton.centerYAnchor.constraint(equalTo: videoTrimmedDurationContainerView.centerYAnchor),
            tickButton.trailingAnchor.constraint(equalTo: videoTrimmedDurationContainerView.trailingAnchor,
                                                 constant: -trailingPaddingOfTickButton),
            tickButton.widthAnchor.constraint(equalToConstant: widthOfTickButton),
            tickButton.heightAnchor.constraint(equalToConstant: heightOfTickButton)
                                    ])
        
        NSLayoutConstraint.activate([ // Audio Recorder View Constraints
            audioRecorderContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            audioRecorderContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            audioRecorderContainerView.topAnchor.constraint(equalTo: topAnchor),
            audioRecorderContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            recordAudioButton.centerXAnchor.constraint(equalTo: audioRecorderContainerView.centerXAnchor),
            recordAudioButton.centerYAnchor.constraint(equalTo: audioRecorderContainerView.centerYAnchor),
            recordAudioButton.widthAnchor.constraint(equalToConstant: widthOfRecordButton),
            recordAudioButton.heightAnchor.constraint(equalToConstant: heightOfRecordButton)
                                    ])
        recordAudioButton.layer.cornerRadius = min(widthOfRecordButton, heightOfRecordButton) / 2
        configureMainStackView()
        configureRectOvalContainerView()
        configureShapeAttributeView()
        configureArrowShapeAttributeView()
        configureTextAttributeView()
        configureBlockAttributeView()
        configureMaskBlurShapeAdditionView()
        configureBorderWidthPalatteView()
        configureTxtSizeContainerView()
        configureTxtBGContainerView()
    }
    
    private func configureMainStackView(){
        viewModel.items.forEach { model in
            let imgWithTextView = ImageWithLabelView(nameAndImageNameModel: model, delegate: viewModel)
            mainStackView.addArrangedSubview(imgWithTextView)
            
            if model.type == .audio{
                audioButtonView = imgWithTextView
            }
        }
    }
    
    private func configureRectOvalContainerView(){
        var prevRectOvalShapeView: ImageWithLabelView? = nil
        viewModel.rectOvalShapeAdditionItems.forEach { model in
            let imgWithTextView = ImageWithLabelView(nameAndImageNameModel: model, delegate: viewModel)
            imgWithTextView.translatesAutoresizingMaskIntoConstraints = false
            rectOvalContainerView.addSubview(imgWithTextView)
            
            if let prevView = prevRectOvalShapeView{
                NSLayoutConstraint.activate([
                    imgWithTextView.leadingAnchor.constraint(equalTo: prevView.trailingAnchor, constant: itemSpacing),
                    imgWithTextView.topAnchor.constraint(equalTo: prevView.topAnchor),
                    imgWithTextView.bottomAnchor.constraint(equalTo: prevView.bottomAnchor),
                    imgWithTextView.trailingAnchor.constraint(lessThanOrEqualTo: rectOvalContainerView.trailingAnchor),
                    imgWithTextView.widthAnchor.constraint(equalTo: prevView.widthAnchor)
                ])
            }else{
                NSLayoutConstraint.activate([
                    imgWithTextView.leadingAnchor.constraint(equalTo: rectOvalContainerView.leadingAnchor),
                    imgWithTextView.topAnchor.constraint(equalTo: rectOvalContainerView.topAnchor),
                    imgWithTextView.bottomAnchor.constraint(equalTo: rectOvalContainerView.bottomAnchor)
                ])
            }
            prevRectOvalShapeView = imgWithTextView
        }
        
        if let prevView = prevRectOvalShapeView{
            NSLayoutConstraint.activate([
                prevView.trailingAnchor.constraint(equalTo: rectOvalContainerView.trailingAnchor)
            ])
        }
    }
    
    private func configureShapeAttributeView(){
        var prevShapeAttributeView: ImageWithLabelView? = nil
        viewModel.shapeAttributesItems.forEach { model in
            let imgWithTextView = ImageWithLabelView(nameAndImageNameModel: model, delegate: viewModel)
            imgWithTextView.translatesAutoresizingMaskIntoConstraints = false
            //            imgWithTextView.backgroundColor = .yellow
            shapeAttributeContainerView.addSubview(imgWithTextView)
            
            if let prevView = prevShapeAttributeView{
                NSLayoutConstraint.activate([
                    imgWithTextView.leadingAnchor.constraint(equalTo: prevView.trailingAnchor, constant: itemSpacing),
                    imgWithTextView.topAnchor.constraint(equalTo: prevView.topAnchor),
                    imgWithTextView.bottomAnchor.constraint(equalTo: prevView.bottomAnchor),
                    imgWithTextView.trailingAnchor.constraint(lessThanOrEqualTo: shapeAttributeContainerView.trailingAnchor),
                    imgWithTextView.widthAnchor.constraint(equalTo: prevView.widthAnchor)
                ])
            }else{
                NSLayoutConstraint.activate([
                    imgWithTextView.leadingAnchor.constraint(equalTo: shapeAttributeContainerView.leadingAnchor),
                    imgWithTextView.topAnchor.constraint(equalTo: shapeAttributeContainerView.topAnchor),
                    imgWithTextView.bottomAnchor.constraint(equalTo: shapeAttributeContainerView.bottomAnchor),
                    imgWithTextView.widthAnchor.constraint(equalToConstant: 70)
                ])
            }
            prevShapeAttributeView = imgWithTextView
            switch model.type{
            case .shapeColor:  shapeAttributeColorView = imgWithTextView
            case .borderStyle: borderStyleView = imgWithTextView
            case .borderWidth: borderWidthView = imgWithTextView
            default: break
            }
        }
        
        if let prevView = prevShapeAttributeView{
            NSLayoutConstraint.activate([
                prevView.trailingAnchor.constraint(equalTo: shapeAttributeContainerView.trailingAnchor)
            ])
        }
    }
    
    func configureArrowShapeAttributeView(){
        var prevShapeAttributeView: ImageWithLabelView? = nil
        viewModel.arrowShapeAttributesItems.forEach { model in
            let imgWithTextView = ImageWithLabelView(nameAndImageNameModel: model, delegate: viewModel)
            imgWithTextView.translatesAutoresizingMaskIntoConstraints = false
            arrowShapeAttributeContainerView.addSubview(imgWithTextView)
            
            if let prevView = prevShapeAttributeView{
                NSLayoutConstraint.activate([
                    imgWithTextView.leadingAnchor.constraint(equalTo: prevView.trailingAnchor, constant: itemSpacing),
                    imgWithTextView.topAnchor.constraint(equalTo: prevView.topAnchor),
                    imgWithTextView.bottomAnchor.constraint(equalTo: prevView.bottomAnchor),
                    imgWithTextView.trailingAnchor.constraint(lessThanOrEqualTo: arrowShapeAttributeContainerView.trailingAnchor),
                    imgWithTextView.widthAnchor.constraint(equalTo: prevView.widthAnchor)
                ])
            }else{
                NSLayoutConstraint.activate([
                    imgWithTextView.leadingAnchor.constraint(equalTo: arrowShapeAttributeContainerView.leadingAnchor),
                    imgWithTextView.topAnchor.constraint(equalTo: arrowShapeAttributeContainerView.topAnchor),
                    imgWithTextView.bottomAnchor.constraint(equalTo: arrowShapeAttributeContainerView.bottomAnchor),
                    imgWithTextView.widthAnchor.constraint(equalToConstant: 70)
                ])
            }
            prevShapeAttributeView = imgWithTextView
            switch model.type{
            case .arrowColor:  arrowAttributeColorView = imgWithTextView
            case .arrowWidth: arrowBorderWidthView = imgWithTextView
            default: break
            }
        }
        
        if let prevView = prevShapeAttributeView{
            NSLayoutConstraint.activate([
                prevView.trailingAnchor.constraint(equalTo: arrowShapeAttributeContainerView.trailingAnchor)
            ])
        }
    }
    
    private func configureTextAttributeView(){
        var prevTextAttributeView: ImageWithLabelView? = nil
        viewModel.textAttributesItems.forEach { model in
            let imgWithTextView = ImageWithLabelView(nameAndImageNameModel: model, delegate: viewModel)
            imgWithTextView.translatesAutoresizingMaskIntoConstraints = false
            //            imgWithTextView.backgroundColor = .yellow
            textAttributeContainerView.addSubview(imgWithTextView)
            
            if let prevView = prevTextAttributeView{
                NSLayoutConstraint.activate([
                    imgWithTextView.leadingAnchor.constraint(equalTo: prevView.trailingAnchor, constant: itemSpacing),
                    imgWithTextView.topAnchor.constraint(equalTo: prevView.topAnchor),
                    imgWithTextView.bottomAnchor.constraint(equalTo: prevView.bottomAnchor),
                    imgWithTextView.trailingAnchor.constraint(lessThanOrEqualTo: textAttributeContainerView.trailingAnchor),
                    imgWithTextView.widthAnchor.constraint(equalTo: prevView.widthAnchor)
                ])
            }else{
                NSLayoutConstraint.activate([
                    imgWithTextView.leadingAnchor.constraint(equalTo: textAttributeContainerView.leadingAnchor),
                    imgWithTextView.topAnchor.constraint(equalTo: textAttributeContainerView.topAnchor),
                    imgWithTextView.bottomAnchor.constraint(equalTo: textAttributeContainerView.bottomAnchor)
                ])
            }
            prevTextAttributeView = imgWithTextView
            switch model.type{
            case .shapeColor: txtAttributeColorView = imgWithTextView
            case .textEdit: txtEditAttributeView = imgWithTextView
            case .textSize: txtSizeAttributeView = imgWithTextView
            case .textStyle: txtStyleAttributeView = imgWithTextView
            case .textBG: txtBGAttributeView = imgWithTextView
            default: break
            }
        }
        
        if let prevView = prevTextAttributeView{
            NSLayoutConstraint.activate([
                prevView.trailingAnchor.constraint(equalTo: textAttributeContainerView.trailingAnchor)
            ])
        }
    }
    
    private func configureBlockAttributeView(){
        var prevBlockAttributeView: ImageWithLabelView? = nil
        viewModel.blockAttributesItems.forEach { model in
            let imgWithTextView = ImageWithLabelView(nameAndImageNameModel: model, delegate: viewModel)
            imgWithTextView.translatesAutoresizingMaskIntoConstraints = false
            blockAttributeContainerView.addSubview(imgWithTextView)
            
            if let prevView = prevBlockAttributeView{
                NSLayoutConstraint.activate([
                    imgWithTextView.leadingAnchor.constraint(equalTo: prevView.trailingAnchor, constant: itemSpacing),
                    imgWithTextView.topAnchor.constraint(equalTo: prevView.topAnchor),
                    imgWithTextView.bottomAnchor.constraint(equalTo: prevView.bottomAnchor),
                    imgWithTextView.trailingAnchor.constraint(lessThanOrEqualTo: blockAttributeContainerView.trailingAnchor),
                    imgWithTextView.widthAnchor.constraint(equalTo: prevView.widthAnchor)
                ])
            }else{
                NSLayoutConstraint.activate([
                    imgWithTextView.leadingAnchor.constraint(equalTo: blockAttributeContainerView.leadingAnchor),
                    imgWithTextView.topAnchor.constraint(equalTo: blockAttributeContainerView.topAnchor),
                    imgWithTextView.bottomAnchor.constraint(equalTo: blockAttributeContainerView.bottomAnchor)
                ])
            }
            prevBlockAttributeView = imgWithTextView
            
            switch model.type{
            case .blockColor:  blockAttributeColorView = imgWithTextView
            default: ()
            }
        }
        
        if let prevView = prevBlockAttributeView{
            NSLayoutConstraint.activate([
                prevView.trailingAnchor.constraint(equalTo: blockAttributeContainerView.trailingAnchor)
            ])
        }
    }
    
    private func configureMaskBlurShapeAdditionView(){
        var prevMaskBlurShapeView: ImageWithLabelView? = nil
        viewModel.maskBlurShapeAdditionItems.forEach { model in
            let imgWithTextView = ImageWithLabelView(nameAndImageNameModel: model, delegate: viewModel)
            imgWithTextView.translatesAutoresizingMaskIntoConstraints = false
            maskBlurContainerView.addSubview(imgWithTextView)
            
            if let prevView = prevMaskBlurShapeView{
                NSLayoutConstraint.activate([
                    imgWithTextView.leadingAnchor.constraint(equalTo: prevView.trailingAnchor, constant: itemSpacing),
                    imgWithTextView.topAnchor.constraint(equalTo: prevView.topAnchor),
                    imgWithTextView.bottomAnchor.constraint(equalTo: prevView.bottomAnchor),
                    imgWithTextView.trailingAnchor.constraint(lessThanOrEqualTo: maskBlurContainerView.trailingAnchor),
                    imgWithTextView.widthAnchor.constraint(equalTo: prevView.widthAnchor)
                ])
            }else{
                NSLayoutConstraint.activate([
                    imgWithTextView.leadingAnchor.constraint(equalTo: maskBlurContainerView.leadingAnchor),
                    imgWithTextView.topAnchor.constraint(equalTo: maskBlurContainerView.topAnchor),
                    imgWithTextView.bottomAnchor.constraint(equalTo: maskBlurContainerView.bottomAnchor),
                    imgWithTextView.widthAnchor.constraint(equalToConstant: 70)
                ])
            }
            prevMaskBlurShapeView = imgWithTextView
        }
        
        if let prevView = prevMaskBlurShapeView{
            NSLayoutConstraint.activate([
                prevView.trailingAnchor.constraint(equalTo: maskBlurContainerView.trailingAnchor)
            ])
        }
    }
    
    private func configureBorderWidthPalatteView(){
        borderWidthPalatteContainerView.addSubviews(strokeWidthLabel,strokeWidthValueLabel,strokeWidthSlider)
        
        let leadingPaddingOfStrokeWidthLabel: CGFloat = 8
        let topPaddingOfStrokeWidthLabel: CGFloat = 8
        
        let trailingPaddingOfStrokeValueLabel: CGFloat = 8
        let spaceBetweenStrokeWidthValueAndLabel: CGFloat = 5
        
        let topPaddingOfSlider: CGFloat = 5
        let bottomPaddingOfSlider: CGFloat = 5
        let sliderHeight: CGFloat = 16
        
        NSLayoutConstraint.activate([
            strokeWidthLabel.leadingAnchor.constraint(equalTo: borderWidthPalatteContainerView.leadingAnchor, constant: leadingPaddingOfStrokeWidthLabel),
            strokeWidthLabel.trailingAnchor.constraint(lessThanOrEqualTo: borderWidthPalatteContainerView.trailingAnchor),
            strokeWidthLabel.topAnchor.constraint(equalTo: borderWidthPalatteContainerView.topAnchor, constant: topPaddingOfStrokeWidthLabel),
            strokeWidthLabel.heightAnchor.constraint(equalTo: strokeWidthValueLabel.heightAnchor),
            
            strokeWidthValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: strokeWidthLabel.trailingAnchor, constant: spaceBetweenStrokeWidthValueAndLabel),
            strokeWidthValueLabel.trailingAnchor.constraint(equalTo: borderWidthPalatteContainerView.trailingAnchor, constant: -trailingPaddingOfStrokeValueLabel),
            strokeWidthValueLabel.centerYAnchor.constraint(equalTo: strokeWidthLabel.centerYAnchor),
            strokeWidthValueLabel.topAnchor.constraint(equalTo: strokeWidthLabel.topAnchor),
            
            strokeWidthSlider.topAnchor.constraint(equalTo: strokeWidthLabel.bottomAnchor, constant: topPaddingOfSlider),
            strokeWidthSlider.bottomAnchor.constraint(lessThanOrEqualTo: borderWidthPalatteContainerView.bottomAnchor, constant: -bottomPaddingOfSlider),
            strokeWidthSlider.leadingAnchor.constraint(equalTo: strokeWidthLabel.leadingAnchor),
            strokeWidthSlider.trailingAnchor.constraint(equalTo: strokeWidthValueLabel.trailingAnchor),
            strokeWidthSlider.heightAnchor.constraint(equalToConstant: sliderHeight),
        ])
    }
    
    private func configureTxtBGContainerView(){
        txtBGContainerView.addSubviews(txtOpacityLabel,txtOpacityValueLabel,txtOpacitySlider)
        
        let leadingPaddingOfTxtOpacityLabel: CGFloat = 8
        let topPaddingOfTxtOpacityLabel: CGFloat = 8
        
        let trailingPaddingOfTxtOpacityValueLabel: CGFloat = 8
        let spaceBetweenTxtOpacityValueAndLabel: CGFloat = 5
        
        let topPaddingOfSlider: CGFloat = 5
        let bottomPaddingOfSlider: CGFloat = 5
        
        let sliderHeight: CGFloat = 16
        
        NSLayoutConstraint.activate([
            txtOpacityLabel.leadingAnchor.constraint(equalTo: txtBGContainerView.leadingAnchor, constant: leadingPaddingOfTxtOpacityLabel),
            txtOpacityLabel.trailingAnchor.constraint(lessThanOrEqualTo: txtBGContainerView.trailingAnchor),
            txtOpacityLabel.topAnchor.constraint(equalTo: txtBGContainerView.topAnchor, constant: topPaddingOfTxtOpacityLabel),
            txtOpacityLabel.heightAnchor.constraint(equalTo: txtOpacityValueLabel.heightAnchor),
            
            txtOpacityValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: txtOpacityLabel.trailingAnchor, constant: spaceBetweenTxtOpacityValueAndLabel),
            txtOpacityValueLabel.trailingAnchor.constraint(equalTo: txtBGContainerView.trailingAnchor, constant: -trailingPaddingOfTxtOpacityValueLabel),
            txtOpacityValueLabel.topAnchor.constraint(equalTo: txtOpacityLabel.topAnchor),
            
            txtOpacitySlider.topAnchor.constraint(equalTo: txtOpacityLabel.bottomAnchor, constant: topPaddingOfSlider),
            txtOpacitySlider.bottomAnchor.constraint(lessThanOrEqualTo: txtBGContainerView.bottomAnchor, constant: -bottomPaddingOfSlider),
            txtOpacitySlider.leadingAnchor.constraint(equalTo: txtOpacityLabel.leadingAnchor),
            txtOpacitySlider.trailingAnchor.constraint(equalTo: txtOpacityValueLabel.trailingAnchor),
            txtOpacitySlider.heightAnchor.constraint(equalToConstant: sliderHeight)
        ])
    }
    
    private func configureTxtSizeContainerView(){
        txtSizeContainerView.addSubviews(txtSizeLabel,txtSizeValueLabel,txtSizeSlider)
        
        let leadingPaddingOfTxtSizeLabel: CGFloat = 8
        let topPaddingOfTxtSizeLabel: CGFloat = 8
        
        let trailingPaddingOfTxtSizeValueLabel: CGFloat = 8
        let spaceBetweenTxtSizeValueAndLabel: CGFloat = 5
        
        let topPaddingOfSlider: CGFloat = 5
        let bottomPaddingOfSlider: CGFloat = 5
        
        let sliderHeight: CGFloat = 16
        
        NSLayoutConstraint.activate([
            txtSizeLabel.leadingAnchor.constraint(equalTo: txtSizeContainerView.leadingAnchor, constant: leadingPaddingOfTxtSizeLabel),
            txtSizeLabel.trailingAnchor.constraint(lessThanOrEqualTo: txtSizeContainerView.trailingAnchor),
            txtSizeLabel.topAnchor.constraint(equalTo: txtSizeContainerView.topAnchor, constant: topPaddingOfTxtSizeLabel),
            txtSizeLabel.heightAnchor.constraint(equalTo: txtSizeValueLabel.heightAnchor),
            
            txtSizeValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: txtSizeLabel.trailingAnchor, constant: spaceBetweenTxtSizeValueAndLabel),
            txtSizeValueLabel.trailingAnchor.constraint(equalTo: txtSizeContainerView.trailingAnchor, constant: -trailingPaddingOfTxtSizeValueLabel),
            txtSizeValueLabel.topAnchor.constraint(equalTo: txtSizeLabel.topAnchor),
            
            txtSizeSlider.topAnchor.constraint(equalTo: txtSizeLabel.bottomAnchor, constant: topPaddingOfSlider),
            txtSizeSlider.bottomAnchor.constraint(lessThanOrEqualTo: txtSizeContainerView.bottomAnchor, constant: -bottomPaddingOfSlider),
            txtSizeSlider.leadingAnchor.constraint(equalTo: txtSizeLabel.leadingAnchor),
            txtSizeSlider.trailingAnchor.constraint(equalTo: txtSizeValueLabel.trailingAnchor),
            txtSizeSlider.heightAnchor.constraint(equalToConstant: sliderHeight)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tickButton.layer.cornerRadius = min(widthOfTickButton,heightOfTickButton) / 2.0
        closeButton.layer.cornerRadius = min(widthOfTickButton,heightOfTickButton) / 2.0
    }
    
    @objc func okAction(){
        viewModel.trimmingConfirmationButtonClicked()
    }
    
    @objc private func closeAction(){
        viewModel.trimmingCancelButtonClicked()
    }
    

    
    @objc private func recordOrStopAction(){
        viewModel.audioRecordingButtonTapped()
    }
    
    func updateAudioRecorderButtonUI(isRecording: Bool){
        recordAudioButton.isSelected = isRecording
        if isRecording{
//            recordAudioButton.tintColor = .red
            recordAudioButton.backgroundColor = .red
        }else{
//            recordAudioButton.tintColor = .blue
            recordAudioButton.backgroundColor = .blue
        }
    }
    
    @objc private func sliderChanged(_ sender: UISlider){
        let sliderValue = Int(sender.value)
        strokeWidthValue = sliderValue
        
        viewModel.updateBorderWidth(to: sliderValue)
    }
    
    @objc private func sliderChangesEnded(_ sender: UISlider){
        let sliderValue = Int(sender.value)
        strokeWidthValue = sliderValue
        
        viewModel.borderWidthChangesEnded(to: strokeWidthValue)
    }
    
    @objc private func txtSliderChanged(_ sender: UISlider){
        let sliderValue = Int(sender.value)
        txtSizeValue = sliderValue
        
        viewModel.updateTextSize(to: txtSizeValue)
    }
    
    @objc private func txtSliderChangesEnded(_ sender: UISlider){
        let sliderValue = Int(sender.value)
        txtSizeValue = sliderValue
        
        viewModel.textSizeChangesEnded(to: txtSizeValue)
    }
    
    @objc private func txtBGSliderChanged(_ sender: UISlider){
        let sliderValue = String(format: "%.2f", sender.value)
        txtBGValue = CGFloat((sliderValue as NSString).floatValue)
        
        viewModel.updateTextOpacity(to: txtBGValue)
    }
    
    @objc private func txtBGSliderChangesEnded(_ sender: UISlider){
        let sliderValue = String(format: "%.2f", sender.value)
        txtBGValue = CGFloat((sliderValue as NSString).floatValue)
        
        viewModel.textOpacityChangesEnded(to: txtBGValue)
    }
}

extension ToolBarView: ToolBarViewProtocol {
    
    private func removeAllContraintsOfTableView(){
        borderStyleTableViewCenterXConstraint?.isActive = false
        borderStyleTableViewTrailingConstraint?.isActive = false
        borderStyleTableViewWidthConstraint?.isActive = false
        borderStyleTableViewHeightConstraint?.isActive = false
        borderStyleTableViewBottomConstraint?.isActive = false
    }

    func showTxtStyleAttributeView(model: TextStyle){
        if borderStyleTableView.superview != nil{
            hideAllPalattes()
            return
        }
        hideAllPalattes()
        removeAllContraintsOfTableView()
        
        let requiredHeight = CGFloat(viewModel.getTableViewItemsToShow().count) * heightOfCell + heightOfHeaderView + heightOfFooterView
        guard let superView = superview, let txtStyleAttributeView = txtStyleAttributeView else {return}
        
        if borderStyleTableView.superview == nil{
            superView.addSubview(borderStyleTableView)
            superView.bringSubviewsToFront(borderStyleTableView)
            
            let yPadding:CGFloat = 10
            
            borderStyleTableView.translatesAutoresizingMaskIntoConstraints = false
            let borderStyleTableViewWConstraint = borderStyleTableView.widthAnchor.constraint(equalToConstant: widthOfTxtStyleTableView)
            let borderStyleTableViewHConstraint = borderStyleTableView.heightAnchor.constraint(equalToConstant: requiredHeight)
            let borderStyleTableViewBConstraint = borderStyleTableView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -yPadding)
            let borderStyleTableViewCenterXConstraint = borderStyleTableView.centerXAnchor.constraint(equalTo: txtStyleAttributeView.centerXAnchor)
            
            self.borderStyleTableViewCenterXConstraint = borderStyleTableViewCenterXConstraint
            self.borderStyleTableViewWidthConstraint = borderStyleTableViewWConstraint
            self.borderStyleTableViewHeightConstraint = borderStyleTableViewHConstraint
            self.borderStyleTableViewBottomConstraint = borderStyleTableViewBConstraint
            
            NSLayoutConstraint.activate([
                borderStyleTableViewCenterXConstraint,
                borderStyleTableViewHConstraint,
                borderStyleTableViewWConstraint,
                borderStyleTableViewBConstraint
            ])
            
            borderStyleTableView.reloadData()
        }
    }
    
    func showTxtBGAttributeView(model: TextBG){
        if txtBGContainerView.superview != nil{
            hideAllPalattes()
            return
        }
        hideAllPalattes()
        
        txtBGContainerView.backgroundColor = AnnotationEditorViewColors.shapeColorPickerBGColor
        txtBGValue = model.opacity
        
        txtOpacitySlider .minimumValue = 0
        txtOpacitySlider.maximumValue = 1
        txtOpacitySlider.value = Float((model.opacity))
        
        if txtBGContainerView.superview == nil{
            let yOfTxtOpacityContainerView: CGFloat = frame.origin.y - heightOfTxtOpacityContainerView
            let frameOfTxtOpacityContainerView = CGRect(x: 0,
                                                         y: yOfTxtOpacityContainerView,
                                                         width: widthOfTxtOpacityContainerView,
                                                         height: heightOfTxtOpacityContainerView)
            txtBGContainerView.frame = frameOfTxtOpacityContainerView
            
            superview?.addSubview(txtBGContainerView)
            
            if let txtBGAttributeView = txtBGAttributeView{
                let yPadding: CGFloat = 10
                let centerOfTxtOpacityContainerView = CGPoint(
                    x: textAttributeContainerView.frame.origin.x + txtBGAttributeView.frame.origin.x + (txtBGAttributeView.frame.size.width / 2.0),
                    y: center.y - (frame.size.height / 2.0) - (heightOfTxtOpacityContainerView/2.0) - yPadding )
                txtBGContainerView.center = CGPoint(x: centerOfTxtOpacityContainerView.x, y: centerOfTxtOpacityContainerView.y)
                if let superview = superview{
                    if (txtBGContainerView.frame.origin.x + txtBGContainerView.frame.size.width) > superview.frame.size.width{
                        let diff = (txtBGContainerView.frame.origin.x + txtBGContainerView.frame.size.width) - superview.frame.size.width
                        txtBGContainerView.center = CGPoint(x: txtBGContainerView.center.x - diff - 5, y: centerOfTxtOpacityContainerView.y)
                    }
                }
            }
            
            txtBGContainerView.addInvertedTriangle()
        }
    }
    
    func showTxtSizeAttributeView(model: FontSize){
        if txtSizeContainerView.superview != nil{
            hideAllPalattes()
            return
        }
        hideAllPalattes()
        
        txtSizeContainerView.backgroundColor = AnnotationEditorViewColors.shapeColorPickerBGColor
        txtSizeValue = model.selectedFontSize
        
        txtSizeSlider.minimumValue = Float(model.minFontSize)
        txtSizeSlider.maximumValue = Float(model.maxFontSize)
        txtSizeSlider.value = Float(model.selectedFontSize)
        
        if txtSizeContainerView.superview == nil{
            let yOfTxtSizeContainerView: CGFloat = frame.origin.y - heightOfTxtSizeContainerView
            let frameOfTxtSizeContainerView = CGRect(x: 0,
                                                         y: yOfTxtSizeContainerView,
                                                         width: widthOfTxtSizeContainerView,
                                                         height: heightOfTxtSizeContainerView)
            txtSizeContainerView.frame = frameOfTxtSizeContainerView
            
            superview?.addSubview(txtSizeContainerView)
            
            if let txtSizeAttributeView = txtSizeAttributeView{
                let yPadding:CGFloat = 10
                let centerOfTxtSizeContainerView = CGPoint(
                    x: textAttributeContainerView.frame.origin.x + txtSizeAttributeView.frame.origin.x + (txtSizeAttributeView.frame.size.width / 2.0),
                    y: center.y - (frame.size.height / 2.0) - (heightOfBorderWidthContainerView/2.0) - yPadding )
                txtSizeContainerView.center = CGPoint(x: centerOfTxtSizeContainerView.x, y: centerOfTxtSizeContainerView.y)
            }
            
            txtSizeContainerView.addInvertedTriangle()
        }
    }
    
    func showArrowBorderWidthPalatte(withModel borderWidthModel: BorderWidth){
        if borderWidthPalatteContainerView.superview != nil{
            hideAllPalattes()
            return
        }
        hideAllPalattes()
        
        borderWidthPalatteContainerView.backgroundColor = AnnotationEditorViewColors.shapeColorPickerBGColor
        strokeWidthValue = borderWidthModel.selectedWidth
        
        strokeWidthSlider.minimumValue = Float(borderWidthModel.minWidth)
        strokeWidthSlider.maximumValue = Float(borderWidthModel.maxWidth)
        strokeWidthSlider.value = Float(borderWidthModel.selectedWidth)
        
        
        if borderWidthPalatteContainerView.superview == nil{
            let yOfBorderWidthContainerView: CGFloat = frame.origin.y - heightOfBorderWidthContainerView
            let frameOfBorderWidthContainerView = CGRect(x: 0,
                                                         y: yOfBorderWidthContainerView,
                                                         width: widthOfBorderWidthContainerView,
                                                         height: heightOfBorderWidthContainerView)
            borderWidthPalatteContainerView.frame = frameOfBorderWidthContainerView
            
            superview?.addSubview(borderWidthPalatteContainerView)
            if let borderWidthView = arrowBorderWidthView{
                let yPadding:CGFloat = 10
                let centerOfBorderWidthContainerView = CGPoint(
                    x: arrowShapeAttributeContainerView.frame.origin.x + borderWidthView.frame.origin.x + (borderWidthView.frame.size.width / 2.0),
                    y: center.y - (frame.size.height / 2.0) - (heightOfBorderWidthContainerView/2.0) - yPadding )
                borderWidthPalatteContainerView.center = CGPoint(x: centerOfBorderWidthContainerView.x, y: centerOfBorderWidthContainerView.y)
            }
            
            borderWidthPalatteContainerView.addInvertedTriangle()
        }
    }
    
    func showBorderWidthPalatte(withModel borderWidthModel: BorderWidth){
        if borderWidthPalatteContainerView.superview != nil{
            hideAllPalattes()
            return
        }
        hideAllPalattes()
        
        borderWidthPalatteContainerView.backgroundColor = AnnotationEditorViewColors.shapeColorPickerBGColor
        strokeWidthValue = borderWidthModel.selectedWidth
        
        strokeWidthSlider.minimumValue = Float(borderWidthModel.minWidth)
        strokeWidthSlider.maximumValue = Float(borderWidthModel.maxWidth)
        strokeWidthSlider.value = Float(borderWidthModel.selectedWidth)
        
        
        if borderWidthPalatteContainerView.superview == nil{
            let yOfBorderWidthContainerView: CGFloat = frame.origin.y - heightOfBorderWidthContainerView
            let frameOfBorderWidthContainerView = CGRect(x: 0,
                                                         y: yOfBorderWidthContainerView,
                                                         width: widthOfBorderWidthContainerView,
                                                         height: heightOfBorderWidthContainerView)
            borderWidthPalatteContainerView.frame = frameOfBorderWidthContainerView
            
            superview?.addSubview(borderWidthPalatteContainerView)
            
            if let borderWidthView = borderWidthView{
                let yPadding:CGFloat = 10
                let centerOfBorderWidthContainerView = CGPoint(
                    x: shapeAttributeContainerView.frame.origin.x + borderWidthView.frame.origin.x + (borderWidthView.frame.size.width / 2.0),
                    y: center.y - (frame.size.height / 2.0) - (heightOfBorderWidthContainerView/2.0) - yPadding )
                borderWidthPalatteContainerView.center = CGPoint(x: centerOfBorderWidthContainerView.x, y: centerOfBorderWidthContainerView.y)
            }
            
            borderWidthPalatteContainerView.addInvertedTriangle()
        }
    }
    
    func showBorderSelectionPalatte(){
        if borderStyleTableView.superview != nil {
            hideAllPalattes()
            return
        }
        hideAllPalattes()
        removeAllContraintsOfTableView()
        
        let requiredHeight = CGFloat(viewModel.getTableViewItemsToShow().count) * heightOfCell + heightOfHeaderView + heightOfFooterView
        guard let superView = superview,  let borderStyleView = borderStyleView else {return}
        
        if borderStyleTableView.superview == nil{
            superView.addSubview(borderStyleTableView)
            superView.bringSubviewsToFront(borderStyleTableView)
            let yPadding:CGFloat = 10
            borderStyleTableView.translatesAutoresizingMaskIntoConstraints = false
            
            let hConstraint = borderStyleTableView.heightAnchor.constraint(equalToConstant: requiredHeight)
            let wConstraint = borderStyleTableView.widthAnchor.constraint(equalToConstant: widthOfBorderStyleTableView)
            let bConstraint = borderStyleTableView.bottomAnchor.constraint(equalTo: topAnchor, constant: -yPadding)
            let cConstraint = borderStyleTableView.centerXAnchor.constraint(equalTo: borderStyleView.centerXAnchor)
            self.borderStyleTableViewHeightConstraint = hConstraint
            self.borderStyleTableViewWidthConstraint = wConstraint
            self.borderStyleTableViewBottomConstraint = bConstraint
            self.borderStyleTableViewCenterXConstraint = cConstraint
            NSLayoutConstraint.activate([
                hConstraint,
                wConstraint,
                bConstraint,
                cConstraint
            ])
            borderStyleTableView.reloadData()
        }
    }
    
    func showTextAttributeColorPalatte(withColors colors: [UIColor], selectedColorIndex: Int){
        showShapeAttributeColorPalatte(withColors: colors, selectedColorIndex: selectedColorIndex)
    }
    
    func showShapeAttributeColorPalatte(withColors colors: [UIColor], selectedColorIndex: Int){
        if colorPalatteCollectionView.superview != nil {
            hideAllPalattes()
            return
        }
        hideAllPalattes()
        
        self.colors = colors
        self.selectedColorIndex = selectedColorIndex

        
        if colorPalatteCollectionView.superview == nil{
            let yOfCollectionView: CGFloat = frame.origin.y - heightOfCollectionView
            let frameOfCollectionView = CGRect(x: 0,
                                               y: yOfCollectionView,
                                               width: widthOfCollectionView,
                                               height: heightOfCollectionView)
            colorPalatteCollectionView.frame = frameOfCollectionView
            superview?.addSubview(colorPalatteCollectionView)
            
            var sourceView: UIView? = nil
            var containerView: UIView? = nil
            
            switch currentState{
            case .textColorPalatte:
                sourceView = txtAttributeColorView
                containerView = textAttributeContainerView
            case .shapeColorPalatte:
                sourceView = shapeAttributeColorView
                containerView = shapeAttributeContainerView
            default: break
            }
            
            if let colorView = sourceView, let holdView = containerView {
                let yPadding:CGFloat = 10
                var xCenter = holdView.frame.origin.x + colorView.frame.origin.x + (colorView.frame.size.width / 2.0)
                let xVal = xCenter - colorPalatteCollectionView.frame.size.width/2.0
                xCenter = (xVal > 0) ? xCenter : colorPalatteCollectionView.frame.size.width/2.0
                let centerOfCollectionView = CGPoint(
                    x: xCenter,
                    y: center.y - (frame.size.height / 2.0) - (heightOfCollectionView/2.0) - yPadding )
                colorPalatteCollectionView.center = CGPoint(x: centerOfCollectionView.x, y: centerOfCollectionView.y)
            }
            colorPalatteCollectionView.addInvertedTriangle()
        }
    }
    
    func showArrowColorPalatte(withColors colors: [UIColor], selectedColorIndex: Int){
        if colorPalatteCollectionView.superview != nil {
            hideAllPalattes()
            return
        }
        hideAllPalattes()
        
        self.colors = colors
        self.selectedColorIndex = selectedColorIndex
        
        if colorPalatteCollectionView.superview == nil{
            let yOfCollectionView: CGFloat = frame.origin.y - heightOfCollectionView
            let frameOfCollectionView = CGRect(x: 0,
                                               y: yOfCollectionView,
                                               width: widthOfCollectionView,
                                               height: heightOfCollectionView)
            colorPalatteCollectionView.frame = frameOfCollectionView
            superview?.addSubview(colorPalatteCollectionView)
            
            if let colorView = arrowAttributeColorView {
                let yPadding:CGFloat = 10
                let centerOfCollectionView = CGPoint(
                    x: arrowShapeAttributeContainerView.frame.origin.x + colorView.frame.origin.x + (colorView.frame.size.width / 2.0),
                    y: center.y - (frame.size.height / 2.0) - (heightOfCollectionView/2.0) - yPadding )
                colorPalatteCollectionView.center = CGPoint(x: centerOfCollectionView.x, y: centerOfCollectionView.y)
            }
            colorPalatteCollectionView.addInvertedTriangle()
        }
    }
    
    func showBlockColorPalatte(withColors colors: [UIColor], selectedColorIndex: Int){
        if colorPalatteCollectionView.superview != nil {
            hideAllPalattes()
            return
        }
        hideAllPalattes()
        
        self.colors = colors
        self.selectedColorIndex = selectedColorIndex
        
        if colorPalatteCollectionView.superview == nil{
            let yOfCollectionView: CGFloat = frame.origin.y - heightOfCollectionView
            let frameOfCollectionView = CGRect(x: 0,
                                               y: yOfCollectionView,
                                               width: widthOfCollectionView,
                                               height: heightOfCollectionView)
            colorPalatteCollectionView.frame = frameOfCollectionView
            superview?.addSubview(colorPalatteCollectionView)
            
            if let colorView = blockAttributeColorView {
                let yPadding:CGFloat = 10
                let centerOfCollectionView = CGPoint(
                    x: blockAttributeContainerView.frame.origin.x + colorView.frame.origin.x + (colorView.frame.size.width / 2.0),
                    y: center.y - (frame.size.height / 2.0) - (heightOfCollectionView/2.0) - yPadding )
                colorPalatteCollectionView.center = CGPoint(x: centerOfCollectionView.x, y: centerOfCollectionView.y)
            }
            colorPalatteCollectionView.addInvertedTriangle()
        }
    }
    
    func hideAllPalattes(){
        hideColorPalatte()
        hideBorderStylePalatte()
        hideBorderWidthPalatte()
        hideTxtSizeView()
        hideTxtStyleView()
        hideTxtBGView()
    }
    
    func hideColorPalatte() {
        colorPalatteCollectionView.removeFromSuperview()
    }
    
    func hideBorderStylePalatte() {
        borderStyleTableView.removeFromSuperview()
    }
    
    func hideBorderWidthPalatte() {
        borderWidthPalatteContainerView.removeFromSuperview()
    }
    
    func hideTxtSizeView() {
        txtSizeContainerView.removeFromSuperview()
    }
    
    func hideTxtBGView(){
        txtBGContainerView.removeFromSuperview()
    }
    
    func hideTxtStyleView(){
        borderStyleTableView.removeFromSuperview()
    }
    
    func audioButton(shouldEnable: Bool) {
        audioButtonView?.shouldEnable = shouldEnable
    }
    
}

extension ToolBarView: UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToolBarView.colorPalatteCollectionViewCellId, for: indexPath)
        let leftPadding: CGFloat = 4
        let rightPadding: CGFloat = 4
        let topPadding: CGFloat = 4
        let bottomPadding: CGFloat = 4
        let view = UIView(frame: CGRect(x: leftPadding,
                                        y: topPadding,
                                        width: cell.frame.size.width - (leftPadding + rightPadding),
                                        height: cell.frame.size.height - (topPadding + bottomPadding)))
        view.layer.cornerRadius = min (view.bounds.width, view.bounds.height) / 2.0
        view.backgroundColor = colors[indexPath.row]
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        cell.contentView.addSubview(view)
        
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        if indexPath.row == selectedColorIndex{
            cell.backgroundColor = colors[indexPath.row].withAlphaComponent(0.3)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let previouslySelectedIndex = IndexPath(row: selectedColorIndex, section: 0)
        let newSelectedIndex = IndexPath(row: indexPath.row, section: 0)
        selectedColorIndex = indexPath.row
        refreshForCellSelectionUI(atIndexPath: previouslySelectedIndex)
        refreshForCellSelectionUI(atIndexPath: newSelectedIndex)
        
        switch currentState{
        case .shapeColorPalatte:
            shapeAttributeColorView?.configureForColorView(withSelectedColor: colors[selectedColorIndex])
        case .blockColorPalatte:
            blockAttributeColorView?.configureForColorView(withSelectedColor: colors[selectedColorIndex])
        case .textColorPalatte:
            shapeAttributeColorView?.configureForColorView(withSelectedColor: colors[selectedColorIndex])
        case .arrowColorPalatte:
            arrowAttributeColorView?.configureForColorView(withSelectedColor: colors[selectedColorIndex])
        default: break
        }
        
        viewModel.colorSelected(atIndex: indexPath.row)
    }
    
    
    private func refreshForCellSelectionUI(atIndexPath indexPath: IndexPath){
        guard let cell = colorPalatteCollectionView.cellForItem(at: indexPath) else {return}
        if indexPath.row == selectedColorIndex{
            cell.backgroundColor = colors[indexPath.row].withAlphaComponent(0.3)
        }else{
            cell.backgroundColor = .clear
        }
    }
}

extension ToolBarView{
    
    func showInitialShapeAdditionState() {
        hideAllContainersExcept(view: mainStackView)
    }
    
    func showVideoTrimmingState(withDuration duration: String? = nil){
        hideAllContainersExcept(view: videoTrimmedDurationContainerView)
        if let duration = duration{
            timeLabel.text = duration
        }
    }
    
    func showTextAttributeState(color: UIColor){
        hideAllContainersExcept(view: textAttributeContainerView)
        txtAttributeColorView?.configureForColorView(withSelectedColor:color)
    }
    
    func showTextEditModeState(withText text: String){
        hideAllPalattes()
        txtEditAttributeView?.makeFirstResponder(withText: text)
    }
    
    func showRectOvalShapeAdditionState(){
        hideAllContainersExcept(view: rectOvalContainerView)
    }
    
    func showMaskBlurShapeAdditionState(){
        hideAllContainersExcept(view: maskBlurContainerView)
    }
    
    func showShapeAttributeState(withColor selectedColor: UIColor? = nil, isOval: Bool) {
        hideAllContainersExcept(view: shapeAttributeContainerView)
        
        if let selectedColor = selectedColor{
            shapeAttributeColorView?.configureForColorView(withSelectedColor:selectedColor, isOval: isOval)
        }
    }
    
    func showArrowShapeAttributeState(withColor selectedColor: UIColor? = nil) {
        hideAllContainersExcept(view: arrowShapeAttributeContainerView)
        
        if let selectedColor = selectedColor{
            arrowAttributeColorView?.configureForColorView(withSelectedColor:selectedColor)
        }
    }
    
    func showBlockAttributeState(withColor selectedColor: UIColor? = nil) {
        hideAllContainersExcept(view: blockAttributeContainerView)
        
        if let selectedColor = selectedColor{
            blockAttributeColorView?.configureForColorView(withSelectedColor:selectedColor)
        }
    }
    
    
    func showAudioRecordingState(isRecording: Bool = false) {
        hideAllContainersExcept(view: audioRecorderContainerView)
        
        updateAudioRecorderButtonUI(isRecording: isRecording)
    }
    
    
    private func hideAllContainersExcept(view: UIView){
        containers.forEach { container in
            container.isHidden = true
        }
        hideAllPalattes()
//        hideColorPalatte()
//        hideBorderStylePalatte()
//        hideBorderWidthPalatte()
        view.isHidden = false
        bringSubviewsToFront(view)
    }
    
}


extension ToolBarView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getTableViewItemsToShow().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToolBarView.borderStylePalatteTableViewCellId, for: indexPath) as? BorderStyleTableViewCell else {
            fatalError("Cell Not Found")
        }
        
        
        let textToShow = viewModel.getTableViewItemsToShow()[indexPath.row].displayText
        cell.configureWith(text: textToShow, isSelected: indexPath.row == viewModel.getTableSelectedIndex())
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightOfCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previouslySelectedIndex = IndexPath(row: viewModel.getTableSelectedIndex(), section: 0)
        let newSelectedIndex = IndexPath(row: indexPath.row, section: 0)
        viewModel.setTableSelected(index: indexPath.row)
        refreshTableViewCellSelectionUI(atIndexPath: previouslySelectedIndex)
        refreshTableViewCellSelectionUI(atIndexPath: newSelectedIndex)
        
//        let borderStyleType = viewModel.borderStyleModel[indexPath.row].type
//        viewModel.borderStyleSelected(borderStyleType)
        viewModel.itemSelected()

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    private func refreshTableViewCellSelectionUI(atIndexPath indexPath: IndexPath){
        guard let cell = borderStyleTableView.cellForRow(at: indexPath) as? BorderStyleTableViewCell else {return}
        let textToShow = viewModel.getTableViewItemsToShow()[indexPath.row].displayText
        cell.configureWith(text: textToShow, isSelected: indexPath.row == viewModel.getTableSelectedIndex())
    }
}




