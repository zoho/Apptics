//
//  CustomInputAccessoryView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 05/11/23.
//

import UIKit

protocol CustomInputAccessoryViewDelegate: AnyObject{
    func doneTapped(withText: String)
}

class CustomInputAccessoryView: UIView {
    
    weak var delegate: CustomInputAccessoryViewDelegate?
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Enter the text"
        return label
    }()
    
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 2
        textField.leftView = UIView(frame: CGRectMake(0, 0, 5, 2))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRectMake(0, 0, 5, 2))
        textField.rightViewMode = .always
        return textField
    }()

    
    var labelText: String? {
        didSet {
            textField.text = labelText
        }
    }
    
    init(withDelegate delegate: CustomInputAccessoryViewDelegate, frame: CGRect){
        self.delegate = delegate
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {

        backgroundColor = UIColor(red: 201.0/255.0, green: 205.0/255.0, blue: 213.0/255.0, alpha: 1)
        addSubviews(label,doneButton,textField)

        
        let labelLeadingPadding: CGFloat = 10
        let labelTopPadding: CGFloat = 10
        
        let textFieldTopPadding: CGFloat = 5
        let textFieldBottomPadding: CGFloat = 10
        
        let doneTrailingPadding: CGFloat = 10
        let labelAndDoneButtonPadding: CGFloat = 10

        
        NSLayoutConstraint.activate([
            
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: labelLeadingPadding),
            label.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor, constant: labelTopPadding),
            
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: labelLeadingPadding),
            textField.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: textFieldTopPadding),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -textFieldBottomPadding),
            textField.heightAnchor.constraint(equalToConstant: 25),
            
            doneButton.topAnchor.constraint(equalTo: textField.topAnchor),
            doneButton.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            doneButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: labelAndDoneButtonPadding),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -doneTrailingPadding),
            doneButton.widthAnchor.constraint(equalToConstant: 50)

        ])
    }
    
    func makeFirstResponser(){
        textField.becomeFirstResponder()
    }
    
    @objc func doneButtonTapped() {
        delegate?.doneTapped(withText: textField.text ?? "")
        self.textField.resignFirstResponder()
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


