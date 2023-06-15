//
//  AppticsAnonymousChatTableViewCell.swift
//  AppticsFeedbackKitSwift
//
//  Created by jai-13322 on 15/05/23.
//

import UIKit

class AppticsAnonymousChatTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView:CardViews!
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var imageicon:UIButton!
    @IBOutlet weak var badgeLabel:UILabel!
    @IBOutlet weak var attachmentButton:UIButton!
    @IBOutlet weak var logBttn:UIButton!
    @IBOutlet weak var statusLight:UILabel!

    @IBOutlet weak var readMoreBttn:UIButton!
    
    @IBOutlet weak var contentMainView: UIView!
    
    var isExpanded = false


    override func awakeFromNib() {
        super.awakeFromNib()
        badgeLabel.layer.masksToBounds = true

        if UIDevice.current.userInterfaceIdiom == .phone {
         badgeLabel.layer.cornerRadius = 9
        }
        setFontForButton(button: attachmentButton, fontName: appticsFontName, title: FontIconText.attachmentIcon, size: 25)
        imageicon.layer.masksToBounds = true
        imageicon.layer.borderColor = UIColor.clear.cgColor
        imageicon.layer.borderWidth = 0.25
        imageicon.layer.cornerRadius = 20

        statusLight.layer.cornerRadius = 0.5 * statusLight.bounds.size.width
        statusLight.clipsToBounds = true

        
        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
