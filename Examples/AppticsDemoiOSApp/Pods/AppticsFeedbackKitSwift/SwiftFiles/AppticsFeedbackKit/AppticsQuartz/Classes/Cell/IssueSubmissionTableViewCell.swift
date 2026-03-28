//
//  IssueSubmissionTableViewCell.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 22/11/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import UIKit

protocol IssueSubmissionTableViewCell: UITableViewCell{
    var vm: IssueSumissionCellVM? {get set}
    func configure(withModel model: IssueSumissionCellVM)
    func showEmptyContentErrorMessage(_ str: String)
}

extension IssueSubmissionTableViewCell{
    func getMandatoryText(forDisplayTxt displayTxt: String) -> NSAttributedString{
        let attributedText = NSMutableAttributedString(string: displayTxt)
        attributedText.append(NSAttributedString(string: " *", attributes: [
            .foregroundColor: UIColor.red
        ]))
        return attributedText
    }
    
    func showEmptyContentErrorMessage(_ str: String){
        
    }
}
