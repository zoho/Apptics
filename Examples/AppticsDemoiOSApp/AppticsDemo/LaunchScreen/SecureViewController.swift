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
//class SecureViewController: UIViewController {
//    
//    @objc var ap_screen_name: String = "Secure container screen"
//    
//    let bodyContainer = UIView()
//    
//    lazy var screenshotPreventView = APSecureView(contentView: bodyContainer)
//    
//    let rImageView = UIImageView()
//        
//    let rSecureLabel = UILabel()
//        
//    let rSecureButton = UIButton()
//        
//    let rSecureTextView = UITextView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//                
//        screenshotPreventView.isUserInteractionEnabled = true;
//        view.addSubview(screenshotPreventView)
//        screenshotPreventView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            screenshotPreventView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            screenshotPreventView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            screenshotPreventView.topAnchor.constraint(equalTo: view.topAnchor),
//            screenshotPreventView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//        
//        bodyContainer.addSubview(rImageView)
//        
//        bodyContainer.addSubview(rSecureLabel)
//        
//        bodyContainer.addSubview(rSecureButton)
//        
//        bodyContainer.addSubview(rSecureTextView)
//                
//        view.backgroundColor=(UIScreen.main.traitCollection.userInterfaceStyle == .dark) ? .black : .white
//        bodyContainer.backgroundColor=(UIScreen.main.traitCollection.userInterfaceStyle == .dark) ? .black : .white
//                        
//        
//        rImageView.image = UIImage(systemName: "person.circle.fill")
//        rImageView.contentMode = .scaleAspectFit
//
//        rSecureLabel.text = "Home address"
//        rSecureLabel.textColor = .white
//        rSecureLabel.backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 0.7, alpha: 1.0)
//        rSecureLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        rSecureLabel.textAlignment = .center
//        rSecureLabel.layer.cornerRadius = 10
//        rSecureLabel.layer.masksToBounds = true
//        rSecureLabel.layer.shadowColor = UIColor.black.cgColor
//        rSecureLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
//        rSecureLabel.layer.shadowRadius = 5
//        rSecureLabel.layer.shadowOpacity = 0.3
//                
//        rSecureButton.setTitle("Bank details", for: .normal)
//        rSecureButton.setTitleColor(.white, for: .normal)
//        rSecureButton.backgroundColor = UIColor(red: 0.0, green: 0.2, blue: 0.4, alpha: 1.0)
//        rSecureButton.layer.cornerRadius = 10
//        rSecureButton.layer.shadowColor = UIColor.black.cgColor
//        rSecureButton.layer.shadowOffset = CGSize(width: 0, height: 2)
//        rSecureButton.layer.shadowRadius = 5
//        rSecureButton.layer.shadowOpacity = 0.3
//        rSecureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//        rSecureButton.addTarget(self, action: #selector(sSecureButtonAction), for: .touchUpInside)
//        
//        rSecureTextView.text = "Health information"
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
//        // Constraints for rImageView
//        rImageView.translatesAutoresizingMaskIntoConstraints = false
//        rImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//        rImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing).isActive = true
//        rImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        rImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//              
//        // Constraints for rSecureLabel
//        rSecureLabel.translatesAutoresizingMaskIntoConstraints = false
//        rSecureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//        rSecureLabel.topAnchor.constraint(equalTo: rImageView.bottomAnchor, constant: spacing).isActive = true
//        rSecureLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
//        rSecureLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
//       
//        // Constraints for rSecureButton
//        rSecureButton.translatesAutoresizingMaskIntoConstraints = false
//        rSecureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//        rSecureButton.topAnchor.constraint(equalTo: rSecureLabel.bottomAnchor, constant: spacing).isActive = true
//        rSecureButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        rSecureButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        
//        // Constraints for rSecureTextView
//        rSecureTextView.translatesAutoresizingMaskIntoConstraints = false
//        rSecureTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
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
