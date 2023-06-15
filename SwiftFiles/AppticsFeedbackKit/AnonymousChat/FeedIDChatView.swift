//
//  FeedIDChatView.swift
//  AppticsFeedbackKitSwift
//
//  Created by jai-13322 on 29/05/23.
//

import UIKit

@available(iOS 11.0, *)
class FeedIDChatView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBttn:UIButton!
    @IBOutlet weak var backIconBttn:UIButton!
    @IBOutlet weak var feedIDTableView:UITableView!
    var data:[[String: Any]]?
    
    
    let json: [String: Any] = [
        "data": [
            [
                "title": "ID #2141221587680",
                "message": "Fusce facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum Lorem ipsum Suspendisse id nulla dolor ac.Lorem ipsum dolor sit Suspen disse consectetur Suspen disse consecteturFusce facilisis Suspendisse id nulla commodo ex,id ",
                "attachments": [
                    "attachment1.jpg",
                    "attachment2.png"
                ]
            ],
            [
                "title": "ID #2141221587681",
                "message": "Fusce facilisis  Suspendisse id nulla commodo ex, et consequat neque rutrum  facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum Lorem ipsum Suspendisse id nulla dolor ac.Lorem ipsum dolor sit Suspen disse consectetur id nulla Last",
                "attachments": [
                ]
            ],
            [
                "title": "ID #2141221587682 ",
                "message": "Reply facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum Lorem ipsum Suspendisse id nulla dolor ac Reply.Suspendisse id nulla dolor sit dolor sit nec urna consectetur id",
                "attachments": [
                    "attachment1.jpg"
                ]
            ]
        ]
    ]
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func commoninit(){
        let bundles = bundles
        let view = bundles.loadNibNamed("FeedIDChatView", owner: self, options: nil)! [0] as! UIView
        view.frame = self.bounds
        addSubview(view)
        setFontForButton(button: backIconBttn, fontName: appticsFontName, title: FontIconText.backnativeIcon, size: 25)
        guard let rawData = json["data"] as? [[String: Any]] else {
            return
        }
        data = rawData
        tableViewSetup()
    }
    
    //MARK: collectionView cell register
    func tableViewSetup(){
        let nib=UINib(nibName: "AppticsAnonymousChatTableViewCell", bundle: bundles)
        feedIDTableView?.register(nib, forCellReuseIdentifier: "cells")
        feedIDTableView.delegate = self
        feedIDTableView.dataSource = self
        feedIDTableView.rowHeight = UITableView.automaticDimension
    }
    
    //MARK: TableView delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  200
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedIDTableView?.dequeueReusableCell(withIdentifier: "cells") as! AppticsAnonymousChatTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let item = data![indexPath.row]
        if let title = item["message"] as? String {
            cell.messageLabel.text = title
            cell.messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping

        }
        cell.attachmentButton.tag = indexPath.row
        cell.mainView.backgroundColor = UIColor(red: 255/255, green: 229/255, blue: 231/255, alpha: 1.0)
        cell.attachmentButton.isHidden = false
        cell.badgeLabel.isHidden = false
        
        if let feedID = item["title"] as? String {
            cell.titleLabel.text = feedID
        }
        setFontForButton(button: cell.logBttn, fontName: appticsFontName, title: FontIconText.cellArrowIcon, size: 25)
        cell.logBttn.setTitleColor(UIColor(red: 255/255, green: 70/255, blue: 82/255, alpha: 1.0), for: .normal)
        cell.logBttn.isUserInteractionEnabled = false
        setFontForButton(button: cell.imageicon, fontName: appticsFontName, title: FontIconText.anonymousIcon, size: 25)
        cell.imageicon.backgroundColor = UIColor(red: 255/255, green: 202/255, blue: 206/255, alpha: 1.0)
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = AnonymChatViewController()

    }
    
    
    
}
