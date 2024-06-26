//
//  SecureListViewController.swift
//  AppticsDemo
//
//  Created by Saravanan S on 13/06/24.
//

import Foundation
import UIKit
import AppticsPrivacyProtector

class SecureListViewController: UITableViewController {
    @objc var ap_screen_name: String = "Secure List Screen"
    
    override func viewDidLoad() {
        
        /*
        let customView = UIView()
        
        // Create and configure the label
        let label = UILabel()
        label.text = "Screen is secured"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false

        // Create and configure the image view
        let imageView = UIImageView()
        let image = UIImage(systemName: "eye.slash.fill")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews to the blur view
        customView.addSubview(label)
        customView.addSubview(imageView)

        // Define and activate layout constraints
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: customView.centerYAnchor, constant: -30),
            imageView.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        APPrivacyShield.shared().contentView = customView
        */
        
        APWindowShield.shared().enableScreenRecordingMonitoring()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        APWindowShield.shared().enableScreenRecordingMonitoring()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        APWindowShield.shared().disableScreenRecordingMonitoring()
    }
    
}

extension SecureListViewController {
    
    static let listCellIdentifier = "SecureListCell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SecureTableList.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.listCellIdentifier, for: indexPath) as? SecureListCell else {
            fatalError("Unable to dequeue ReminderCell")
        }
        let list = SecureTableList.data[indexPath.row]
        
        cell.titleLabel.text = list.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = SecureTableList.data[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch list.type {
            
        case .secureElements:
            guard let navController = self.navigationController else {
                print("Navigation controller is nil")
                return
            }
            print(navController)
            let crashListController = SecureElementsController()
            self.navigationController?.pushViewController(crashListController, animated: true)
            break
        case .secureViews:
            guard let navController = self.navigationController else {
                print("Navigation controller is nil")
                return
            }
            print(navController)
            let crashListController = SecureViewController()
            self.navigationController?.pushViewController(crashListController, animated: true)
            break
        case .secureWindow:
            
            break
        }
    }
}
    
class SecureListCell: UITableViewCell {
    typealias DoneButtonAction = () -> Void

    @IBOutlet var titleLabel: UILabel!

    var doneButtonAction: DoneButtonAction?
    
    @IBAction func doneButtonTriggered(_ sender: UIButton) {
        doneButtonAction?()
    }
}
