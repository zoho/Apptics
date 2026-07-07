//
//  AppShieldViewController.swift
//  AppShield
//
//  Created by Asif on 15/05/24.
//

import Foundation
import UIKit

public class AppShieldViewController: UIViewController{

    var theme:AppShieldTheme?
    var lockSwitch = UISwitch()
    var shieldTableView:UITableView!
    var persistedTheme:AppShieldTheme?
    var titleLabel:UILabel!
    var header:UIView!
    var delayTime = ["controller.immedietly".getLocalizedString(),"controller.after".getLocalizedString() + " 1 " + "controller.minute".getLocalizedString(),"15".getTimeStringForDeay(),"30".getTimeStringForDeay(),"controller.after".getLocalizedString() + " 1 " + "controller.hour".getLocalizedString()]
    var section = [""]
    var label:UILabel!
    override public func viewDidLoad() {
        super.viewDidLoad()

        shieldTableView = UITableView()
        shieldTableView.frame = self.view.frame
        shieldTableView.separatorStyle = .none
        self.view.addSubview(shieldTableView)
        shieldTableView.delegate = self
        shieldTableView.dataSource = self
        shieldTableView.tableHeaderView = getHeaderView()
        self.shieldTableView.backgroundColor = theme?.viewBgColor()
        lockSwitch.thumbTintColor = theme?.lockSwitchThumbTint()
        lockSwitch.onTintColor = theme?.lockSwitchOnTint()
        lockSwitch.tintColor = theme?.lockSwitchTint()


    }


    public override func viewDidAppear(_ animated: Bool) {




    }
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //self.setTheme(persistedTheme!)
        updateTheme()
    }
    public override func viewWillAppear(_ animated: Bool) {
        if AppticsLock.shared.isAuthenticatorEnabled{
            lockSwitch.setOn(true, animated: false)
            showList()
        }
        else{
            lockSwitch.setOn(false, animated: false)
            removeList()
        }
    }
    public func updateTheme(){
        if let _ = label{
        header.backgroundColor = theme?.viewBgColor()
        titleLabel.textColor = theme?.textColor()
        lockSwitch.thumbTintColor = theme?.lockSwitchThumbTint()
        lockSwitch.onTintColor = theme?.lockSwitchOnTint()
        lockSwitch.tintColor = theme?.lockSwitchTint()
        self.label.textColor = theme?.textColor()
        self.shieldTableView.backgroundColor = theme?.viewBgColor()
        self.shieldTableView.reloadData()
        }

    }
    func getHeaderView()-> UIView{
        header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        header.backgroundColor = theme?.viewBgColor()

        lockSwitch.addTarget(self, action: #selector(switchAction(sender:)), for: .valueChanged)
        titleLabel = UILabel()
        header.addSubview(lockSwitch)
        lockSwitch.translatesAutoresizingMaskIntoConstraints = false
        lockSwitch.trailingAnchor.constraint(equalTo: header.trailingAnchor,constant: -20).isActive = true
        lockSwitch.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        header.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor,constant: 20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        let type = Authenticator.isTouchID() ? "Touch" : "Face"
        titleLabel.text = "\(type) ID/ Passcode"
        titleLabel.textColor = theme?.textColor()
        titleLabel.font = theme?.titleFont()
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 17)

        return header

    }
    @objc func switchAction(sender: UISwitch) {

        //defer{shieldTableView}
        if !AppticsLock.shared.toggleAuthenticator(sender.isOn, completionBlock:{ result in

            if !result {
                DispatchQueue.main.async {
                    AuthenticatorKeychain().save(asString: "true")

                    self.lockSwitch.setOn(true, animated: true)
                    self.viewWillAppear(true)
                }

            }
            else{
                 UserDefaults.standard.set(0, forKey:"delayTime")
            }


        }) {
            sender.isOn = false

            let alert = UIAlertController(title: "Set up ID in iPhone Settings to turn ON ", message: "", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                self.lockSwitch.setOn(false, animated: true)
            }))

            self.present(alert, animated:true, completion:nil)
        }

        if sender.isOn{
            self.showList()
        }
        else{
            self.removeList()
        }
        self.shieldTableView.reloadData()
    }

    private func removeList(){
        self.delayTime.removeAll()
                   self.section.removeAll()
                   let transition = CATransition()
                   transition.type = CATransitionType.fade
                   transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                   transition.fillMode = CAMediaTimingFillMode.forwards
                   transition.duration = 0.5
                   transition.subtype = CATransitionSubtype.fromTop
                   self.shieldTableView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
                   // Update your data source here
                   self.shieldTableView.reloadData()
    }
    private func showList(){
        delayTime = ["controller.immedietly".getLocalizedString(),"controller.after".getLocalizedString() + " 1 " + "controller.minute".getLocalizedString(),"15".getTimeStringForDeay(),"30".getTimeStringForDeay(),"controller.after".getLocalizedString() + " 1 " + "controller.hour".getLocalizedString()]
        section = [""]
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.fillMode = CAMediaTimingFillMode.forwards
        transition.duration = 0.5
        transition.subtype = CATransitionSubtype.fromTop
        self.shieldTableView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
        // Update your data source here
        self.shieldTableView.reloadData()
    }
    public func setTheme(_ userTheme:AppShieldTheme){
        theme = userTheme

    }


    private func getTimeFromString(_ str:String)->Double{
        switch str {
        case let x where x.contains("1 "+"controller.minute".getLocalizedString()):
            return 60
        case let x where x.contains(" 5"):
            return 300
        case let x where x.contains("15"):
            return 900
        case let x where x.contains("30"):
            return 1800
        case let x where x.contains("controller.hour".getLocalizedString()):
            return 3600
        default:
            return 0
        }

    }
    func getIndexPathForTime(time:Double)->Int{
        switch time {
            case 60:
            return 1
            case 900:
            return 2
            case 1800:
            return 3
            case 3600:
            return 4

        default:
            return 0
        }
    }

}


extension AppShieldViewController:UITableViewDelegate,UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delayTime.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = delayTime[indexPath.row]
        cell.backgroundColor = theme?.viewBgColor()
        cell.textLabel?.font = theme?.elementFont()
        cell.textLabel?.textColor = theme?.textColor()
        let delay = UserDefaults.standard.object(forKey: "delayTime") as? Double
        if let del = delay{
            let row  = getIndexPathForTime(time: del)

            if lockSwitch.isOn{
                if indexPath.row == row{
                    cell.accessoryType = .checkmark
                    cell.tintColor = theme?.tickMarkColor()
                    shieldTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
                    shieldTableView.delegate?.tableView!(shieldTableView, didSelectRowAt: indexPath)
                    AppticsLock.shared.updateDelayTime(del)
                }
            }
        }
        else{
            if indexPath.row == 0{
                cell.accessoryType = .checkmark
                cell.tintColor = theme?.tickMarkColor()
                shieldTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
                shieldTableView.delegate?.tableView!(shieldTableView, didSelectRowAt: indexPath)
            }
        }
        return cell
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {


        return 60
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        

        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        cell?.tintColor = theme?.tickMarkColor()
        AppticsLock.shared.updateDelayTime(getTimeFromString(cell?.textLabel!.text ?? "Im"))
       // print(getTimeFromString(cell?.textLabel!.text ?? "empty"))

    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 100))
        headerView.backgroundColor = theme?.sectionHeaderColor()
        label = UILabel()
        label.frame = CGRect.init(x: 20, y: 0, width: headerView.frame.width - 30, height: headerView.frame.height-10)
        label.numberOfLines = 2
        label.font = theme?.elementFont()
        let type = Authenticator.isTouchID() ? "Touch ID" : "Face ID"
        label.text = String(format:  "controller.lockAfter".getLocalizedString(), type)

        label.textColor =  theme?.textColor()

        headerView.addSubview(label)

        return headerView



    }


}

extension UITableView {
    func reloadData(with animation: UITableView.RowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)

    }

}



public protocol AppShieldTheme {
    
    func viewBgColor() -> UIColor
    func lockSwitchTint() -> UIColor
    func lockSwitchThumbTint() -> UIColor
    func lockSwitchOnTint() -> UIColor
    func elementFont() -> UIFont
    func textColor() -> UIColor
    func tickMarkColor() -> UIColor
    func sectionHeaderColor() -> UIColor
    func titleFont() -> UIFont
    func initialTitleFont() -> UIFont
    func initialDetailFont()-> UIFont
    func authenticationScreenColor()->UIColor?
    func authenticationScreenTextColor()->UIColor?
}
public protocol Localized{
    ///"%@ has been locked"
    func yourAppHasLocked()-> String
    ///"Tap any where to authenticate"
    func appShieldNeedsAuthentication()-> String
    ///"Set up %@ ID in iPhone Settings to use "
    func appShieldSetup()->String
    ///"Settings"
    func appShielSetting()->String

// Localisation keys and value
//    "app.haslocked" = "%@ has been locked";
//    "app.authenticate.authenticate" = "Tap any where to authenticate";
//    "app.authenticate.setup" = "Set up %@ ID in iPhone Settings to use ";
//    "app.settings" = "Settings";


}
public extension Localized{
    ///"%@ has been locked"
    func yourAppHasLocked()-> String{
        return  "app.haslocked".getStringFromBundle()
    }
    ///"Tap any where to authenticate"
    func AppShieldNeedsAuthentication()-> String{
        "app.authenticate.authenticate".getStringFromBundle()

    }
    ///"Set up %@ ID in iPhone Settings to use "
    func AppShieldSetup()->String{
        "app.authenticate.setup".getStringFromBundle()

    }
    ///"Settings"
    func appShielSetting()->String{
        "app.settings".getStringFromBundle()

    }
}

public extension AppShieldTheme{
    /// Only for Applications using view controller style of app lock.
    func viewBgColor() -> UIColor{
        .white
    }
    func lockSwitchTint() -> UIColor{
        .white
    }

    func lockSwitchThumbTint() -> UIColor{
        .yellow
    }
    func lockSwitchOnTint() -> UIColor{
        .blue
    }
    func elementFont() -> UIFont{
        UIFont.systemFont(ofSize: 13)
    }
    func textColor() -> UIColor{
        .black
    }

    func titleFont() -> UIFont{
        UIFont.boldSystemFont(ofSize: 15)
    }
    func tickMarkColor()-> UIColor{

        .black
    }
    

    func sectionHeaderColor() -> UIColor{
        return .clear
    }


    // Applications using default style of app lock.

    ///Sets title font for the initial lock controller "App has been locked"
    func initialTitleFont() -> UIFont{
         UIFont.boldSystemFont(ofSize: 17)
    }
    ///Sets detail font for the initial lock controller "Tap anywhere to authenticate"
    func initialDetailFont()-> UIFont{
         UIFont.systemFont(ofSize: 13)
    }
    
    func authenticationScreenColor()->UIColor? {
        return nil
    }
    func authenticationScreenTextColor()->UIColor? {
        return nil
    }

}
public protocol AppShieldStrings {
    func reasonString()-> String
}
public extension AppShieldStrings{
    func reasonString()->String{
        Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    }
}


