//
//  ViewController.swift
//  AppticsDemo
//
//  Created by Saravanan S on 26/11/21.
//
 
import Foundation
import AppKit
import AppticsEventTracker

class NewViewController : NSViewController{
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @objc @IBAction func crash(sender : Any){
        Apptics.crash()
    }
    
    @objc @IBAction func apitracker(sender : Any){
        let configuration = URLSession.shared.configuration
    
        APAPIManager.enable(for: configuration)
    
        let url = URL(string: "https://www.google.com/maps/")
        let session = URLSession.init(configuration: configuration)
        //For almofire
//            let manager = Alamofire.SessionManager(configuration: configuration)
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) in
          // your code here
            print(data)
        })
    
        task.resume()
    }
    
    @objc @IBAction func remoteConfig(_ sender: Any) {
  
      APRemoteConfig.shared().fetch { (status) in
          print("\(status.rawValue)")
          if (status == .statusSuccess || status == .statusUpToDate){
              APRemoteConfig.shared().activateFetched()
          }
          print(APRemoteConfig.shared()["feedback_module"]?.stringValue)
          print(APRemoteConfig.shared().configValue(forKey: "secondary_color")?.stringValue )
      }
      
    }
    
    @objc @IBAction func trackEvent(_ sender: Any) {
        APEvent.trackEvent(AP_EVENT_APP_LAUNCHING, withGroupName: AP_GROUP_APP_LIFE_CYCLE)
    }
}
