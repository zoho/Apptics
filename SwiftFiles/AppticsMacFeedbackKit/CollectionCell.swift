//
//  CollectionCell.swift
//  AppticsFeedback
//
//  Created by jai-13322 on 05/06/24.
//

import Cocoa

class CollectionCell: NSCollectionViewItem {
    
    
    @IBOutlet public weak var attachmentImage: NSImageView!
       
    @IBOutlet public weak var deleteBttn: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false

    }
    

   
    
}
