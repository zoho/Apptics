//
//  AnonymChatView.swift
//  AppticsFeedbackKitSwift
//
//  Created by jai-13322 on 12/05/23.
//

import UIKit


class AnonymChatView: UIView,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBttn:UIButton!
    @IBOutlet weak var backIconBttn:UIButton!
    @IBOutlet weak var chatTableView:UITableView!
    @IBOutlet weak var textfiledHeightConst:NSLayoutConstraint!
    @IBOutlet weak var poweredByAppticsLabel:UILabel!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textCountLabel:UILabel!
    @IBOutlet weak var sendBttn:UIButton!
    
    var placeholder = "Type your message here..."
    
    @IBOutlet weak var replyTextField:UITextView!
    
    var data:[[String: Any]]?
    
    var selectedindex = NSIndexPath()
    var selectedIndex = -1
    var iscollasped = false
    
    
    var contentArray = ["Lorem ipsum dolor sit Suspen disse consectetur id nulla amet.Lorem ipsum dolor sit Suspen disse consectetur.  ","Lorem ipsum sit Suspen disse  id nulla amet.Lorem ipsum dolor sit Suspen disse consectetur.  ", "Suspendisse id nulla dolor sit dolor sit nec urna consectetur id  nulla lacinia Fusce dolor sit Lorem ipsum dolor.", "Fusce facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum Lorem ipsum Suspendisse id nulla dolor ac.","SuspendisseFusce et con sew"]
    
    
    let json: [String: Any] = [
        "data": [
            [
                "title": "Anonymous",
                "message": "Fusce facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum Lorem ipsum Suspendisse id nulla dolor ac.Lorem ipsum dolor sit Suspen disse consectetur id nulla amet.Lorem ipsum dolor sit Suspen disse consecteturFusce facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum Lorem ipsum Suspendisse id nulla dolor ac.Lorem ipsum dolor sit Suspen disse consectetur id nulla amet.Lorem ipsum dolor sit Suspen disse consectetur.Fusce facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum Lorem ipsum Suspendisse id nulla dolor ac.Lorem ipsum dolor sit Suspen disse consectetur id nulla amet.Lorem ipsum dolor sit Suspen disse consecteturFusce Last facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum Lorem ipsum Suspendisse id nulla dolor ac.Lorem ipsum dolor sit Suspen disse consectetur id nulla amet.Lorem ipsum dolor sit Suspen disse consectetur con Last Suspen disse consectetur con Lorem ipsum dolor sit Suspen disse consectetur id nulla amet.Lorem ipsum dolor sit Suspen disse consectetur.Fusce facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum Lorem ipsum Suspendisse id nulla dolor ac.Lorem ipsum dolor sit Suspen disse consectetur id nulla amet.Lorem ipsum dolor sit Suspen disse consecteturFusce facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum  facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum Lorem ipsum Suspendisse id nulla dolor ac.Lorem ipsum dolor sit Suspen disse consectetur issss Last",
                "attachments": [
                    "attachment1.jpg",
                    "attachment2.png"
                ]
            ],
            [
                "title": "Developer Reply",
                "message": "Fusce facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum Lorem ipsum Suspendisse id nulla dolor ac.Lorem ipsum dolor sit Suspen disse consectetur id nulla amet.Lorem ipsum dolor sit Suspen disse consecteturFusce facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum  facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum Lorem ipsum Suspendisse id nulla dolor ac.Lorem ipsum dolor sit Suspen disse consectetur id nulla amet.Lorem ipsum dolor sit Suspen disse consectetur con Fusce facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum Lorem ipsum Suspendisse id nulla dolor ac.Lorem ipsum dolor sit Suspen disse consectetur id nulla amet.Lorem ipsum dolor sit Suspen disse consecteturFusce facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum Last",
                "attachments": [
                ]
            ],
            [
                "title": "Anonymous ",
                "message": "Reply facilisis Suspendisse id nulla commodo ex, et consequat neque rutrum Suspendisse id nulla commodo ex, et consequat neque rutrum Lorem ipsum Suspendisse id nulla ",
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
        let view = bundles.loadNibNamed("AnonymChatView", owner: self, options: nil)! [0] as! UIView
        view.frame = self.bounds
        addSubview(view)
        replyTextField.leftSpace()
        replyTextField.delegate = self
        replyTextField.text = placeholder
        replyTextField.textColor = .lightGray
        textFieldBottomConstraint.constant = 10
        setFontForButton(button: backIconBttn, fontName: appticsFontName, title: FontIconText.backnativeIcon, size: 25)
        setFontForButton(button: sendBttn, fontName: appticsFontName, title: FontIconText.sendArrowIcon, size: 20)        
        view.addConstraint(textFieldBottomConstraint)
        replyTextField.layer.cornerRadius = 15
        replyTextField.layer.borderWidth = 0.2
        replyTextField.layer.borderColor = UIColor.lightGray.cgColor
        sendBttn.layer.cornerRadius = 0.5 * sendBttn.bounds.size.width
        sendBttn.clipsToBounds = true
        guard let rawData = json["data"] as? [[String: Any]] else {
            return
        }
        data = rawData
        tableViewSetup()
    }

 
    
    
    
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if newText.count > 1000 {
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        var height = ceil(textView.contentSize.height)
        height = height+1
        print(height)
        if height != textfiledHeightConst.constant {
            if height < 200{
                textfiledHeightConst.constant = height
                textView.setContentOffset(CGPointZero, animated: false)
            }
        }
        
        let characterCount = textView.text.count
        textCountLabel.text = "\(characterCount)/1000"
        
    }
    
    
    
    
    
    //MARK: collectionView cell register
    func tableViewSetup(){
        let nib=UINib(nibName: "AppticsAnonymousChatTableViewCell", bundle: bundles)
        chatTableView?.register(nib, forCellReuseIdentifier: "cells")
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.rowHeight = UITableView.automaticDimension
    }
    
    //MARK: TableView delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = checkStringHeight(indexpaths: indexPath, numberlines: 0)
        if selectedIndex == indexPath.row && iscollasped == true{
            if height>300{
                return height + 250
            }
            else{
                return height + 200
            }
        }
        return  190
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView?.dequeueReusableCell(withIdentifier: "cells") as! AppticsAnonymousChatTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let item = data![indexPath.row]
        var message = ""
        if let title = item["message"] as? String {
            cell.messageLabel.text = title
            message = title
        }
        cell.statusLight.isHidden = true
        cell.attachmentButton.tag = indexPath.row
        cell.attachmentButton.addTarget(self, action:#selector(self.attachmentbttnClicked), for: .touchUpInside)
        
       
        if (indexPath.row % 2 == 0)
        {
            cell.attachmentButton.isHidden = true
            cell.badgeLabel.isHidden = true
            cell.mainView.backgroundColor = UIColor(red: 255/255, green: 229/255, blue: 231/255, alpha: 1.0)
            cell.titleLabel.text = "Anonymous"
            setFontForButton(button: cell.imageicon, fontName: appticsFontName, title: FontIconText.anonymousIcon, size: 25)
            cell.imageicon.backgroundColor = UIColor(red: 255/255, green: 202/255, blue: 206/255, alpha: 1.0)
            if selectedIndex == indexPath.row && iscollasped == true{
                cell.messageLabel.appendReadLess(after: message, trailingContent: .readless, highledcolor: UIColor(red: 255/255, green: 101/255, blue: 111/255, alpha: 1.0))
            }
            else{
                cell.messageLabel.appendReadmore(after: message, trailingContent: .readmore, highledcolor: UIColor(red: 255/255, green: 101/255, blue: 111/255, alpha: 1.0))
            }
        }
        else
        {
            cell.mainView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            cell.attachmentButton.isHidden = true
            cell.badgeLabel.isHidden = true
            cell.titleLabel.text = "Developer"
            setFontForButton(button: cell.imageicon, fontName: appticsFontName, title: FontIconText.supportIcon, size: 25)
            cell.imageicon.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
            if selectedIndex == indexPath.row && iscollasped == true{
                cell.messageLabel.appendReadLess(after: message, trailingContent: .readless, highledcolor:UIColor(red: 137/255, green: 136/255, blue: 136/255, alpha: 1.0) )
                
            }
            else{
                cell.messageLabel.appendReadmore(after: message, trailingContent: .readmore, highledcolor: UIColor(red: 137/255, green: 136/255, blue: 136/255, alpha: 1.0))
                
            }
            
        }
        
        if indexPath.row == 0 {
            cell.attachmentButton.isHidden = false
            cell.badgeLabel.isHidden = false
            setFontForButton(button: cell.logBttn, fontName: appticsFontName, title: FontIconText.celllogIcon, size: 25)
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chatTableView.deselectRow(at: indexPath, animated: true)
        if selectedIndex == indexPath.row{
            
            if self.iscollasped == false{
                self.iscollasped = true
            }
            else{
                self.iscollasped = false
            }
            
        }
        else{
            self.iscollasped = true
        }
        
        self.selectedIndex = indexPath.row
        chatTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        
        
    }
    
    
    
    //MARK: AttachmentButton CLick action
    
    @objc func attachmentbttnClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(notificationLoadAnonymChatConversation), object: self)
    }
    
    //MARK: check string length and get height
    func checkStringHeight(indexpaths:IndexPath,numberlines:Int)-> CGFloat{
        let cell = chatTableView?.dequeueReusableCell(withIdentifier: "cells") as! AppticsAnonymousChatTableViewCell
        let item = data![indexpaths.row]
        if let title = item["message"] as? String {
            cell.messageLabel.text = title
        }
        cell.messageLabel.numberOfLines = numberlines
        let height = cell.messageLabel.sizeThatFits(CGSize(width: chatTableView.bounds.width, height: .greatestFiniteMagnitude)).height
        return height
    }
    
    
    
    
    
    
}
