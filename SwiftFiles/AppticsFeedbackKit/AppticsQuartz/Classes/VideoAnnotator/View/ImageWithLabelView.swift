//
//  ImageWithLabelView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 25/10/23.
//

import UIKit

class ImageWithLabelView: UIView {
    private var enteredString: String = "" {
        didSet{
            iAccesView.labelText = enteredString
        }
    }
    
    override var canBecomeFirstResponder: Bool { return true }
    override var canResignFirstResponder: Bool { return true }
    
    let nameAndImageNameModel: NameAndImageNameModel
    var delegate: ShapeActionDelegateProtocol?
    
    private let widthOfImgView: CGFloat = 20
    private let heightOfImgView: CGFloat = 20
    
    private var isOvalShape: Bool = false
    
    var shouldEnable = true {
        didSet{
            updateUIAfterEnableOrDisable()
        }
    }
    
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        if let img =  UIImage.named(nameAndImageNameModel.imgName){
            imgView.image = img.withRenderingMode(.alwaysTemplate)
        }
        else{
            if !nameAndImageNameModel.imgName.isEmpty{
                let sysImg = UIImage(systemName: nameAndImageNameModel.imgName)
                imgView.image = sysImg?.withRenderingMode(.alwaysTemplate)
            }
        }
        
        imgView.tintColor = AnnotationEditorViewColors.toolBarIconsColor
        return imgView
    }()
    
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = nameAndImageNameModel.name
        textLabel.textAlignment = .center
        textLabel.textColor = AnnotationEditorViewColors.toolBarTextColor
        return textLabel
    }()
    
    init(nameAndImageNameModel: NameAndImageNameModel, delegate: ShapeActionDelegateProtocol? = nil) {
        self.nameAndImageNameModel = nameAndImageNameModel
        self.delegate = delegate
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(){
        addSubviews(imgView,textLabel)
        
        let paddingBetweenImageAndLabel: CGFloat = 5
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: topAnchor),
            imgView.widthAnchor.constraint(equalToConstant: widthOfImgView),
            imgView.heightAnchor.constraint(equalToConstant: heightOfImgView),
            imgView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor,constant: paddingBetweenImageAndLabel),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapped(){
        if shouldEnable{
            delegate?.tapped(model: nameAndImageNameModel)
        }
    }
    
    private lazy var iAccesView: CustomInputAccessoryView = {
        let frameOfInputAccessoryView = CGRect(x: 0, y: 0, width: 0, height: 70)
        let customView = CustomInputAccessoryView(withDelegate: self, frame: frameOfInputAccessoryView )
        return customView
    }()
    
    override var inputAccessoryView: UIView?{
        iAccesView
    }
    
    func makeFirstResponder(withText text: String){
        enteredString = text
        becomeFirstResponder()
        iAccesView.makeFirstResponser()
    }
    
    func configureForColorView(withSelectedColor selectedColor: UIColor, isOval: Bool = true){
        isOvalShape = isOval
        imgView.backgroundColor = selectedColor
        if selectedColor == UIColor.white || selectedColor == UIColor.black{
            imgView.layer.borderColor = UIColor.label.withAlphaComponent(0.5).cgColor
            imgView.layer.borderWidth = 1
        }else{
            imgView.layer.borderWidth = 0
        }
        imgView.clipsToBounds = true
        imgView.layer.masksToBounds = true
        
        setNeedsLayout()
    }
    
    private func updateUIAfterEnableOrDisable(){
        alpha = shouldEnable ? 1 : 0.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isOvalShape{
            imgView.layer.cornerRadius = widthOfImgView/2.0
        }else{
            imgView.layer.cornerRadius = 4
        }
    }
    
}

extension ImageWithLabelView: UIKeyInput{
    
    var hasText: Bool {
        !enteredString.isEmpty
    }
    
    func insertText(_ text: String) {
        enteredString = enteredString + text
    }
    
    func deleteBackward() {
        if !enteredString.isEmpty{
            enteredString.removeLast()
        }
    }
}

extension ImageWithLabelView: CustomInputAccessoryViewDelegate{
    func doneTapped(withText text: String){
        if shouldEnable{
            delegate?.textEntered(model: nameAndImageNameModel, text: text)
        }
    }
}

