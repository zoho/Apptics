//
//  TableViewCell.swift
//  Pods
//
//  Created by Prakash R on 04/08/20.
//

import UIKit


protocol PromotedAppViewCellDelegate {
    
    func appInstallBtnPressed(_ appScheme:String, _ crossPromoId:Int , _ identifier : String)
    
}


@objcMembers
@objc public class PromotedAppViewCell: UITableViewCell {

    @IBOutlet var imgIconn: CustomImageView!
    @IBOutlet var lblAppName: UILabel!
    @IBOutlet var lblCaption: UILabel!
    @IBOutlet var vwSuperView: UIView!
    @IBOutlet var appStatusButton: UIButton!
    
    
    var data : promotedDatasource?
    var delegate : PromotedAppViewCellDelegate?
    var bundle : Bundle!
    var appInstallStatus : Bool = false
    var crossPromoTheme : CrossPromoTheme!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
     
        appStatusButton.titleLabel?.textAlignment = .center
        if let size = appStatusButton.titleLabel?.font.pointSize {
            appStatusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: size)
        }
        appStatusButton.layer.cornerRadius = 15
        
    }
    
    func loadData() {
        
        lblAppName.text = data?.appName
        lblCaption.text = data?.caption
        if let status = data?.appInstallStatus {
            appInstallStatus = status
        }
        
        appStatusButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        if appInstallStatus == true {
            appStatusButton.setTitle(NSLocalizedString("zanalytics.crosspromotion.open", tableName: "CrossPromo", bundle: self.bundle, value: "", comment: "More apps from us"), for: .normal)
        } else {
            appStatusButton.setTitle(NSLocalizedString("zanalytics.crosspromotion.get", tableName: "CrossPromo", bundle: self.bundle, value: "", comment: "Get"), for: .normal)
        }
                            
        if let uri = URL(string: data?.imageUrl ?? "") {
            
             imgIconn.downloadImageFrom(url: uri)
            imgIconn.layer.cornerRadius = 16
        }
        self.applyTheme()
    }
    
    
    @IBAction func appInstallPressed(_ sender: UIButton) {
                
        if let str = data?.appscheme {
            if let id = data?.crossPromoAppId, let identifier = data?.appIdentifier {
            self.delegate?.appInstallBtnPressed(str,id,identifier)
            }
        }
    }    
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    func applyTheme() {
        if let bgcolor = crossPromoTheme.cellBGColor {
            self.vwSuperView.backgroundColor = bgcolor
        }else{
            if let bgcolor = crossPromoTheme.viewBGColor {
                self.vwSuperView.backgroundColor = bgcolor
            }
        }
        
        if let textColor = crossPromoTheme.cellTextColor {
            self.lblAppName.textColor = textColor
            self.lblCaption.textColor = textColor
            
        }
        
        if let btnTextColor = crossPromoTheme.buttonTextColor {
            self.appStatusButton.setTitleColor(btnTextColor, for: UIControl.State.normal)
        }
        
        if let btnColor = crossPromoTheme.buttonBGColor {
            self.appStatusButton.backgroundColor = btnColor
        }else{
            if UIColor.isDarkThemeOn(){
                self.appStatusButton.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.09, alpha: 1.00)
            } else {
                self.appStatusButton.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00)
            }
        }
        
        if let font = crossPromoTheme.cellTextFont {
            self.lblAppName.font = font
        }
        if let captionfont = crossPromoTheme.cellCaptionFont {
            self.lblCaption.font = captionfont
        }
    }
}



class CustomImageView: UIImageView {

    let imageCache = NSCache<NSString, AnyObject>()

    var imageURLString: String?

    func downloadImageFrom(url: URL) {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    self.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                    self.image = imageToCache
                }
            }.resume()
        }
    }
}
