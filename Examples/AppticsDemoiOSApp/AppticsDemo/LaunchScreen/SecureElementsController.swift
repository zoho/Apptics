////
////  SecureViewController.swift
////  AppticsDemo
////
////  Created by Saravanan S on 21/08/23.
////
//
//import Foundation
//import UIKit
//import AppticsPrivacyProtector
//
//class SecureElementsController: UIViewController {
//    
//    @objc var ap_screen_name: String = "Secure container screen"
//    
//    let sImageView = APSecureImageView()
//    let rImageView = UIImageView()
//    
//    let sSecureLabel = APSecureLabel()
//    let rSecureLabel = UILabel()
//    
//    let sSecureButton = APSecureButton()
//    let rSecureButton = UIButton()
//    
//    let sSecureTextView = APSecureTextView()
//    let rSecureTextView = UITextView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.view.addSubview(sImageView)
//        self.view.addSubview(rImageView)
//        
//        self.view.addSubview(sSecureLabel)
//        self.view.addSubview(rSecureLabel)
//        
//        self.view.addSubview(sSecureButton)
//        self.view.addSubview(rSecureButton)
//        
//        self.view.addSubview(sSecureTextView)
//        self.view.addSubview(rSecureTextView)
//                
//        self.view.backgroundColor=(UIScreen.main.traitCollection.userInterfaceStyle == .dark) ? .black : .white
//        
//        sImageView.image = UIImage(systemName: "eye.slash.circle")!
//        sImageView.contentMode = .scaleAspectFit
//        
//        rImageView.image = UIImage(systemName: "eye.square")
//        rImageView.contentMode = .scaleAspectFit
//        
//        sSecureLabel.text = "Private Information"
//        let customLabel = sSecureLabel.label
//        customLabel.textColor = .white
//        customLabel.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0)
//        customLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        customLabel.textAlignment = .center
//        customLabel.layer.cornerRadius = 10
//        customLabel.layer.masksToBounds = true
//        customLabel.layer.shadowColor = UIColor.black.cgColor
//        customLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
//        customLabel.layer.shadowRadius = 5
//        customLabel.layer.shadowOpacity = 0.3
//                
//        rSecureLabel.text = "Non-sensitive label"
//        rSecureLabel.textColor = .white
//        rSecureLabel.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0)
//        rSecureLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        rSecureLabel.textAlignment = .center
//        rSecureLabel.layer.cornerRadius = 10
//        rSecureLabel.layer.masksToBounds = true
//        rSecureLabel.layer.shadowColor = UIColor.black.cgColor
//        rSecureLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
//        rSecureLabel.layer.shadowRadius = 5
//        rSecureLabel.layer.shadowOpacity = 0.3
//        
//        sSecureButton.button.setTitle("Secure Button", for: .normal)
//        sSecureButton.button.setTitleColor(.white, for: .normal)
//        sSecureButton.button.backgroundColor = .systemBlue
//        sSecureButton.button.layer.cornerRadius = 10
//        sSecureButton.button.layer.shadowColor = UIColor.black.cgColor
//        sSecureButton.button.layer.shadowOffset = CGSize(width: 0, height: 2)
//        sSecureButton.button.layer.shadowRadius = 5
//        sSecureButton.button.layer.shadowOpacity = 0.3
//        sSecureButton.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//        sSecureButton.button.addTarget(self, action: #selector(sSecureButtonAction), for: .touchUpInside)
//        
//        rSecureButton.setTitle("Normal Button", for: .normal)
//        rSecureButton.setTitleColor(.white, for: .normal)
//        rSecureButton.backgroundColor = .systemBlue
//        rSecureButton.layer.cornerRadius = 10
//        rSecureButton.layer.shadowColor = UIColor.black.cgColor
//        rSecureButton.layer.shadowOffset = CGSize(width: 0, height: 2)
//        rSecureButton.layer.shadowRadius = 5
//        rSecureButton.layer.shadowOpacity = 0.3
//        rSecureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//        rSecureButton.addTarget(self, action: #selector(sSecureButtonAction), for: .touchUpInside)
//                
//        sSecureTextView.text = "Confidential Information"
//        let customTextView = sSecureTextView.textView
//        customTextView.textColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
//        customTextView.backgroundColor = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 1.0)
//        customTextView.font = UIFont.systemFont(ofSize: 18)
//        customTextView.isEditable = true
//        customTextView.layer.cornerRadius = 10
//        customTextView.layer.shadowColor = UIColor.black.cgColor
//        customTextView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        customTextView.layer.shadowRadius = 5
//        customTextView.layer.shadowOpacity = 0.3
//        
//        rSecureTextView.text = "Non-sensitive Data"
//        rSecureTextView.textColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
//        rSecureTextView.backgroundColor = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 1.0)
//        rSecureTextView.font = UIFont.systemFont(ofSize: 18)
//        rSecureTextView.isEditable = true
//        rSecureTextView.layer.cornerRadius = 10
//        rSecureTextView.layer.shadowColor = UIColor.black.cgColor
//        rSecureTextView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        rSecureTextView.layer.shadowRadius = 5
//        rSecureTextView.layer.shadowOpacity = 0.3
//        
//        let spacing: CGFloat = 70 // Adjust the spacing between elements as needed
//
//        // Constraints for sImageView
//        sImageView.translatesAutoresizingMaskIntoConstraints = false
//        sImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -60).isActive = true
//        sImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing).isActive = true
//        sImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        sImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//                
//        // Constraints for rImageView
//        rImageView.translatesAutoresizingMaskIntoConstraints = false
//        rImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60).isActive = true
//        rImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing).isActive = true
//        rImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        rImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//         
//        // Constraints for sSecureLabel
//        sSecureLabel.translatesAutoresizingMaskIntoConstraints = false
//        sSecureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -90).isActive = true
//        sSecureLabel.topAnchor.constraint(equalTo: sImageView.bottomAnchor, constant: spacing).isActive = true
//        sSecureLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
//        sSecureLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        // Constraints for rSecureLabel
//        rSecureLabel.translatesAutoresizingMaskIntoConstraints = false
//        rSecureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 90).isActive = true
//        rSecureLabel.topAnchor.constraint(equalTo: rImageView.bottomAnchor, constant: spacing).isActive = true
//        rSecureLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
//        rSecureLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        // Constraints for sSecureButton
//        sSecureButton.translatesAutoresizingMaskIntoConstraints = false
//        sSecureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80).isActive = true
//        sSecureButton.topAnchor.constraint(equalTo: sSecureLabel.bottomAnchor, constant: spacing).isActive = true
//        sSecureButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        sSecureButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        // Constraints for rSecureButton
//        rSecureButton.translatesAutoresizingMaskIntoConstraints = false
//        rSecureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80).isActive = true
//        rSecureButton.topAnchor.constraint(equalTo: rSecureLabel.bottomAnchor, constant: spacing).isActive = true
//        rSecureButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        rSecureButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        // Constraints for sSecureTextView
//        sSecureTextView.translatesAutoresizingMaskIntoConstraints = false
//        sSecureTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80).isActive = true
//        sSecureTextView.topAnchor.constraint(equalTo: sSecureButton.bottomAnchor, constant: spacing).isActive = true
//        sSecureTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        sSecureTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
//        // Constraints for rSecureTextView
//        rSecureTextView.translatesAutoresizingMaskIntoConstraints = false
//        rSecureTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80).isActive = true
//        rSecureTextView.topAnchor.constraint(equalTo: rSecureButton.bottomAnchor, constant: spacing).isActive = true
//        rSecureTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        rSecureTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
//    }
//    
//    @objc func sSecureButtonAction(){
//        print("Button tapped")
//    }
//}
