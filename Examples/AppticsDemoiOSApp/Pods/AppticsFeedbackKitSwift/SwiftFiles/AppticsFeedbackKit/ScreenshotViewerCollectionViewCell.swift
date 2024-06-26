//
//  ScreenshotViewerCollectionViewCell.swift
//  MyFramework
//
//  Created by jai-13322 on 25/07/22.
//

import UIKit
@objcMembers
//class ScreenshotViewerCollectionViewCell: UICollectionViewCell {
//    public let imageview = UIImageView()
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        commonInit()
//    }
//    func commonInit(){
//        imageview.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addSubview(imageview)
//        let data = ["image":imageview]
//        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[image]-0-|", options: [], metrics: nil, views: data))
//        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[image]-0-|", options: [], metrics: nil, views: data))
//    }
//}




class ScreenShotEditCollectionViewCell: UICollectionViewCell {

    let imageview: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageview)
        imageview.clipsToBounds = false
        imageview.backgroundColor = .clear
        if TargetDevice.currentDevice == .iPhone {
            imageview.contentMode = .scaleAspectFit
        }
        else{
            imageview.contentMode = .scaleToFill
        }
        NSLayoutConstraint.activate([
            imageview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            imageview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    func configure(with image: UIImage) {
        imageview.image = image
   }

    
}
