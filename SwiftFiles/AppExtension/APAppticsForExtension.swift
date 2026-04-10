//
//  AppticsExtension.swift
//  AppticsDemo
//
//  Created by jai-13322 on 04/07/22.
//


import Foundation

import WatchConnectivity

class WatchWCSessionManager: NSObject, WCSessionDelegate {
  
#if os(iOS)
   func sessionDidBecomeInactive(_ session: WCSession) {
       print("sessionDidBecomeInactive")
   }

   func sessionDidDeactivate(_ session: WCSession) {
       print("sessionDidDeactivate")
   }
#endif
    

    static let shared = WatchWCSessionManager()

    override private init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    @available(iOS 9.3, *)
    @available(watchOSApplicationExtension 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState)")
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        if session.isReachable {
            print("iPhone is reachable via WCSession")
        } else {
            print("iPhone is not reachable via WCSession")
        }
    }

    func sendMessageToiPhone(groupname:String,eventName:String,property:[String : Any]) {
        let exampleDict: [String: Any] = [
            "eventname": eventName,
            "group": groupname,
            "properties": property,
        ]
        if WCSession.default.isReachable {
            let message = ["event": exampleDict]
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                print("Error sending message to iPhone: \(error.localizedDescription)")
            }
        } else {
            print("iPhone is not reachable via WCSession")
        }
        
    }
}


@objcMembers
class APExtensionEventList: NSObject, NSCoding {
    
    var groupName: String
    var start_time: NSNumber
    var end_time: NSNumber
    var event_Name: String
    var properties:String
    var isTimed:Bool
    
    init(object:[String:Any]? = nil) {
        self.groupName = object?["groupName"] as! String
        self.start_time = object?["start_time"] as! NSNumber
        self.end_time = object?["start_time"] as! NSNumber
        self.event_Name = object?["event_Name"] as! String
        self.isTimed = object?["is_timed"] as? Bool ?? false
        self.properties = object?["properties"] as? String ?? ""
    }
    
    init(groupName: String,start_time:NSNumber, event_Name: String,properties:String? = nil) {
        self.groupName = groupName
        self.start_time = start_time
        self.end_time = start_time
        self.event_Name = event_Name
        self.properties = properties ?? ""
        self.isTimed = false
    }
    init(groupName: String,start_time:NSNumber,end_time:NSNumber, event_Name: String,isTimed:Bool,properties:String? = nil) {
        self.groupName = groupName
        self.start_time = start_time
        self.end_time = end_time
        self.event_Name = event_Name
        self.isTimed = isTimed
        self.properties = properties ?? ""
    }

    
    required init(coder aDecoder: NSCoder) {
        groupName = aDecoder.decodeObject(forKey: "groupName") as? String ?? ""
        start_time = aDecoder.decodeObject(forKey: "start_time") as? NSNumber ?? 0
        end_time = aDecoder.decodeObject(forKey: "end_time") as? NSNumber ?? 0
        event_Name = aDecoder.decodeObject(forKey: "event_Name") as? String ?? ""
        properties = aDecoder.decodeObject(forKey: "properties") as? String ?? ""
        isTimed = aDecoder.decodeObject(forKey: "is_timed") as? Bool ?? false
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(groupName, forKey: "groupName")
        aCoder.encode(start_time, forKey: "start_time")
        aCoder.encode(end_time, forKey: "end_time")
        aCoder.encode(event_Name, forKey: "event_Name")
        aCoder.encode(properties, forKey: "properties")
        aCoder.encode(isTimed, forKey: "is_timed")

    }
    
    func jsonify() -> [String:Any] {
        return ["groupName":self.groupName, "start_time":self.start_time, "end_time":self.end_time, "event_Name":self.event_Name,"is_timed":self.isTimed, "properties":self.properties]
    }
    
}




var ExtensionEventKey = "WidgetData"

var ExtensionEventKeyTimed = "TimedEventApp"




@objcMembers
@objc public class AppticsExtensionManager:NSObject{
    
    class func saveEvent(_ task: APExtensionEventList, appGroup: String) {
        
        var tasks = retrievedata(appGroup: appGroup)
        tasks.append(task.jsonify())
        if #available(iOS 11.0, *) {
            if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tasks, requiringSecureCoding: false) {
                print(savedData)
                UserDefaults(suiteName: appGroup)?.set(savedData, forKey: ExtensionEventKey)
            }
        } else {
            // Fallback on earlier versions
            let savedData = NSKeyedArchiver.archivedData(withRootObject: tasks)
            print(savedData)
            UserDefaults(suiteName: appGroup)?.set(savedData, forKey: ExtensionEventKey)
        }
    }
    
    class func retrievedata(appGroup: String) -> [[String : Any]] {
        guard let taskData =  UserDefaults(suiteName: appGroup)?.data(forKey: ExtensionEventKey) else {
            return []
        }
        do {
            return try ((NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(taskData) as? [[String : Any]])!)
        } catch {
            fatalError(error.localizedDescription)
        }
        
    }
    
    
    
    @objc public class func trackEvent(groupname:String,eventName:String,property:[String : Any],appGroup:String){
        
        let jsonData = try! JSONSerialization.data(withJSONObject: property, options: [])
        guard let decoded = String(data: jsonData, encoding: .utf8) else {
            return
        }
        let E = APExtensionEventList(groupName: groupname, start_time: (Int64(NSDate().timeIntervalSince1970 * 1000)) as NSNumber, event_Name: eventName, properties: "\(decoded)" )
        AppticsExtensionManager.saveEvent(E,appGroup: appGroup)
    }
    
    
    @objc public class func trackEvent(groupname:String,eventName:String,appGroup:String){
        
        let E = APExtensionEventList(groupName: groupname, start_time:(Int64(NSDate().timeIntervalSince1970 * 1000)) as NSNumber, event_Name: eventName)
        AppticsExtensionManager.saveEvent(E,appGroup: appGroup)
    }
    
    @objc public class func trackWatchEvent(groupname:String,eventName:String,property:[String : Any]){
        var groupname = groupname
        if groupname.isEmpty {
            groupname = "uncategorized"
        }
        _ = WatchWCSessionManager.shared
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            if WCSession.default.isReachable {
                WatchWCSessionManager.shared.sendMessageToiPhone(groupname: groupname, eventName: eventName, property: property)
            }
        }
        
    }
    
    
    
    
    
    
    
    @objc public class func startTimedEvent(groupname:String,eventName:String,property:[String : Any],appGroup:String) -> NSNumber
    {
      //Empty check for group name
        var groupname = groupname
        groupname = groupname.trimmingCharacters(in: .whitespaces)
        if groupname.isEmpty {
            groupname = "uncategorized"
        }
        let keyStartTime = NSNumber(value:NSDate().timeIntervalSince1970 * 1000)
        let jsonData = try! JSONSerialization.data(withJSONObject: property, options: [])
        if let decoded = String(data: jsonData, encoding: .utf8){
        let value: [String: Any] = [
                "groupName": groupname,
                "event_Name": eventName,
                "properties": decoded,
                "start_time": keyStartTime
            ]
            let dictionary: [NSNumber: [String: Any]] = [
                keyStartTime: value
            ]
            let timedEvent = APExtensionTimedEventList(events: dictionary)
            saveTimedEvent(timedEvent, appGroup: appGroup)
            
        }
        return keyStartTime
        
    }
    
    
    
    @objc public class func endTimedEvent(startTime:NSNumber, groupname:String,eventName:String,appGroup:String){
        
        let endTime = Int64(NSDate().timeIntervalSince1970 * 1000)
        let endtimer = NSNumber(value: endTime)
        var tasks = retrieveTimeddata(appGroup: appGroup)
        if var event = tasks[startTime] {
            event["end_time"] = endtimer
            tasks[startTime] = event
        }
         if let keyName = tasks[startTime] {
            if let eventName = keyName["event_Name"] as? String,
               let startTime = keyName["start_time"] as? NSNumber,
               let endTime = keyName["end_time"] as? NSNumber,
               let groupName = keyName["groupName"] as? String {
                let properties = keyName["properties"]
                let event = APExtensionEventList(groupName: groupName, start_time: startTime, end_time: endTime, event_Name: eventName, isTimed: true, properties: properties as? String)
                AppticsExtensionManager.saveEvent(event, appGroup: appGroup)
            }
             removeTimestamp(startTime, appGroup: appGroup)

        }
        
    }
    
    class func removeTimestamp(_ timestamp: NSNumber, appGroup: String) {
        var tasks = retrieveTimeddata(appGroup: appGroup)
        tasks.removeValue(forKey: timestamp)
        if #available(iOS 11.0, *) {
            if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tasks, requiringSecureCoding: false) {
                UserDefaults(suiteName: appGroup)?.set(savedData, forKey: ExtensionEventKeyTimed)
            }
        } else {
            let savedData = NSKeyedArchiver.archivedData(withRootObject: tasks)
            UserDefaults(suiteName: appGroup)?.set(savedData, forKey: ExtensionEventKeyTimed)
        }
    }
    
    
    class func saveTimedEvent(_ task: APExtensionTimedEventList, appGroup: String) {
        var tasks = retrieveTimeddata(appGroup: appGroup)
        for (key, value) in task.jsonify() {
            tasks[key] = value
        }
        if #available(iOS 11.0, *) {
            if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tasks, requiringSecureCoding: false) {
                print(savedData)
                UserDefaults(suiteName: appGroup)?.set(savedData, forKey: ExtensionEventKeyTimed)
            }
        } else {
            // Fallback on earlier versions
            let savedData = NSKeyedArchiver.archivedData(withRootObject: tasks)
            print(savedData)
            UserDefaults(suiteName: appGroup)?.set(savedData, forKey: ExtensionEventKeyTimed)
        }
    }
    
    class func retrieveTimeddata(appGroup: String) -> [NSNumber: [String: Any]] {
        guard let taskData = UserDefaults(suiteName: appGroup)?.data(forKey: ExtensionEventKeyTimed) else {
            return [:]
        }
        do {
            return try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(taskData) as? [NSNumber: [String: Any]]) ?? [:]
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
    
    
}

class APExtensionTimedEventList: NSObject, NSCoding {
    
    var events: [NSNumber: [String: Any]]
    
    override init() {
        self.events = [:]
    }
    
    init(events: [NSNumber: [String: Any]]? = nil) {
        self.events = events ?? [:]
    }
    
    required init(coder aDecoder: NSCoder) {
        events = aDecoder.decodeObject(forKey: "events") as? [NSNumber: [String: Any]] ?? [:]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(events, forKey: "events")
    }
    
    func addEvent(timestamp: NSNumber, groupName: String, eventName: String, startTime: NSNumber, properties: String? = nil) {
        events[timestamp] = [
            "groupName": groupName,
            "eventName": eventName,
            "start_time": startTime,
            "properties": properties ?? ""
        ]
    }
    
    func removeEvent(timestamp: NSNumber) {
        events.removeValue(forKey: timestamp)
    }
    
    func jsonify() -> [NSNumber: [String: Any]] {
        return events
    }
}


