//
//  PlayerTimeIndicatorView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 31/10/23.
//

import UIKit

protocol PlayerTimeIndicatorViewProtocol: UIView{
    func updateTime(to: String)
}


class PlayerTimeIndicatorView: UIView, PlayerTimeIndicatorViewProtocol{
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            timeLabel.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        return timeLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            timeLabel.topAnchor.constraint(equalTo: topAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateTime(to text: String){
        timeLabel.text = text
    }
}
