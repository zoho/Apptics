//
//  BorderStyleTableViewCell.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 01/11/23.
//

import UIKit

class BorderStyleTableViewCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .label
        return label
    }()

    
    // Required initializer (not used in this example)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Initializer for the custom cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    private func configure(){
        contentView.addSubview(titleLabel)
        
        let topPadding: CGFloat = 4
        let bottomPadding: CGFloat = 4
        let leadingPadding: CGFloat = 13
        let trailingPadding: CGFloat = 13
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -trailingPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -bottomPadding)
        ])
    }
    
    func configureWith(text: String, isSelected: Bool){
        titleLabel.text = text

        if isSelected{
            contentView.backgroundColor = AnnotationEditorViewColors.borderStyleCellContentSelectionBGColor
        }else{
            contentView.backgroundColor = AnnotationEditorViewColors.borderStyleCellContentViewBGColor
        }
    }

}
