//
//  AppticsExtension.swift
//  AppticsDemo
//
//  Created by jai-13322 on 04/07/22.
//


import Foundation

var userDefaultsSuiteName = UserDefaults(suiteName: "group.zoho.app.event")
var ExtensionEventKey = "WidgetDate"

@objcMembers
class APExtensionEventList: NSObject, NSCoding {
    
    
    var groupName: String
    var start_time: NSNumber
    var end_time: NSNumber
    var event_Name: String
    var properties:String
    
    init(groupName: String,start_time:NSNumber, event_Name: String,properties:String? = nil) {
        self.groupName = groupName
        self.start_time = start_time
        self.end_time = start_time
        self.event_Name = event_Name
        self.properties = properties ?? ""
    }
    
    required init(coder aDecoder: NSCoder) {
        groupName = aDecoder.decodeObject(forKey: "groupName") as? String ?? ""
        start_time = aDecoder.decodeObject(forKey: "start_time") as? NSNumber ?? 0
        end_time = aDecoder.decodeObject(forKey: "end_time") as? NSNumber ?? 0
        event_Name = aDecoder.decodeObject(forKey: "event_Name") as? String ?? ""
        properties = aDecoder.decodeObject(forKey: "properties") as? String ?? ""
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(groupName, forKey: "groupName")
        aCoder.encode(start_time, forKey: "start_time")
        aCoder.encode(end_time, forKey: "end_time")
        aCoder.encode(event_Name, forKey: "event_Name")
        aCoder.encode(properties, forKey: "properties")
    }
    
}



class AppticsExtensionManager:NSObject{
    
    
    class func saveEvent(_ task: APExtensionEventList) {
                
        var tasks = retrievedata
        tasks.append(task)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tasks, requiringSecureCoding: false) {
            print(savedData)
            userDefaultsSuiteName!.set(savedData, forKey: ExtensionEventKey)
        }
    }
    
    class var retrievedata: [APExtensionEventList] {
        guard let taskData = userDefaultsSuiteName?.data(forKey: ExtensionEventKey) else {
            return []
        }
        do {
            return try ((NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(taskData) as? [APExtensionEventList])!)
        } catch {
            fatalError(error.localizedDescription)
        }
        
    }
    
    class func retrieveallData() -> [String] {
        var Array = [String]()
        if let data = userDefaultsSuiteName?.dictionaryRepresentation(){
            for (key, value) in data {
                if key == ExtensionEventKey{
                    if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(value as! Data) as? [APExtensionEventList] {
                        for i in decodedPeople{
                            let newV = "\(i.groupName),\(i.start_time),\(i.end_time),\(i.event_Name),\(i.properties)"
                            Array.append(newV)
                        }
                    }
                }
            }
        }
        return Array
    }
    
    
    
    class func trackEvent(groupname:String,eventName:String,property:[String : Any]){
        
        let jsonData = try! JSONSerialization.data(withJSONObject: property, options: [])
        guard let decoded = String(data: jsonData, encoding: .utf8) else {
            return
        }
        let E = APExtensionEventList(groupName: groupname, start_time: (Int64(NSDate().timeIntervalSince1970 * 1000)) as NSNumber, event_Name: eventName, properties: "\(decoded)" )
        AppticsExtensionManager.saveEvent(E)
    }
    
    
    class func trackEventWithProperty(groupname:String,eventName:String){
        
        let E = APExtensionEventList(groupName: groupname, start_time:(Int64(NSDate().timeIntervalSince1970 * 1000)) as NSNumber, event_Name: eventName)
        AppticsExtensionManager.saveEvent(E)
    }
    
    
}
