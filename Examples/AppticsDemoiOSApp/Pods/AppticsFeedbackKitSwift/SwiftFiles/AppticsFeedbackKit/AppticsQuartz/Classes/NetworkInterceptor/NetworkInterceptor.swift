//
//  NetworkInterceptor.swift
//  Creator
//
//  Created by Ganesh Arora on 23/08/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import Foundation

private let swizzling: (AnyClass, Selector, Selector) -> () = { forClass, originalSelector, swizzledSelector in
    guard let originalMethod = class_getInstanceMethod(forClass, originalSelector),
          let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector) else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}

struct NetworkLogKeys{
    static let requestUrl = "requestUrl"
    static let method = "method"
    static let statusCode = "statusCode"
    
}

extension URLSession {

    var shouldWriteInterceptedLogsToFile: Bool{
        false
    }
    
    static func sessionInterception(_ shouldEnable: Bool){
        let originalSelector = #selector((dataTask(with:completionHandler:)) as (URLSession) -> (URLRequest, @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask)
        let swizzledSelector = #selector(swizzledDataTask(with: completionHandler:))
        if shouldEnable{
            swizzling(URLSession.self, originalSelector, swizzledSelector)
        }else{
            swizzling(URLSession.self, swizzledSelector, originalSelector)
        }
    }
    
    @objc func swizzledDataTask(with request: URLRequest,
                                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        var requestCopy = request
        
        let attributes = NetworkInterceptor.maskedRequestAttribtes
        
        for attribute in attributes {
            switch attribute{
            case .httpHeader(let key):
                guard var allHTTPHeaderFields = requestCopy.allHTTPHeaderFields else {break}
                if allHTTPHeaderFields[key] != nil{
                    allHTTPHeaderFields.removeValue(forKey: key)
                    requestCopy.allHTTPHeaderFields?[key] = "***** Masked ******"
                }
            }
        }
        
        
        var mutableRequest = request
        mutableRequest.httpShouldHandleCookies = true
        
        if let recID = APIKeySaver.shared.getKeyFor(type: .recordingID), let clientStartTime = APIKeySaver.shared.getKeyFor(type: .startTime){
            let curTime = QuartzDataManager.currentTimeInMilliSeconds()
            let startTime = "\(curTime)"
            
            let timeOriginOfRequest =  curTime - ( Int(clientStartTime) ?? 0 )
            let workspaceKey = APIKeySaver.shared.getKeyFor(type: .workSpaceID) ?? ""
            let serverLogMetrics = "Quartz-RecordingIdentifier;dur=0;desc=" + workspaceKey + "_" + recID + "_" + startTime + ";Quartz-RequestIdentifier;dur=0;desc=" + "\(timeOriginOfRequest)" + "_" + generateAPIUniqueIdentifier() + ";"

            mutableRequest.addValue(serverLogMetrics, forHTTPHeaderField: "Server-Timing")
        }
        
        if shouldWriteInterceptedLogsToFile {
            var networkLogDict: [String: String] = [:]
                        
            if let url = requestCopy.url{
                networkLogDict[NetworkLogKeys.requestUrl] = url.absoluteString
            }
            
            if let httpMethod = requestCopy.httpMethod{
                networkLogDict[NetworkLogKeys.method] = httpMethod
            }
            
            // Wrap the original completionHandler
            let wrappedCompletionHandler: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
                // Handle the response
                if let httpResponse = response as? HTTPURLResponse {
                                        
                    networkLogDict[NetworkLogKeys.statusCode] = httpResponse.statusCode.description
                    
                    let strToWrite = networkLogDict.map { $0.0 + "=" + $0.1 }.joined(separator: ";")
                    if let data = strToWrite.data(using: .utf8) {
                        NetworkInterceptor.shared.logData(data: data)
                    }
                }
                completionHandler(data, response, error)
            }
            // Call the original implementation
            return swizzledDataTask(with: mutableRequest, completionHandler: wrappedCompletionHandler)
        }else{
            return swizzledDataTask(with: mutableRequest, completionHandler: completionHandler)
        }
    }
    
    private func generateAPIUniqueIdentifier() -> String {
        var randomNumber = ""
        for _ in 1...15 {
            let digit = Int.random(in: 0...9)
            randomNumber += "\(digit)"
        }
        return randomNumber
    }
}



enum RequestAttribute{
    case httpHeader(key: String)
}

public class NetworkInterceptor{
    static let logsFileName = "networkLogs.txt"
    
    private let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(NetworkInterceptor.logsFileName)
    private var fileHandle: FileHandle?
    static var maskedRequestAttribtes: [RequestAttribute] = [.httpHeader(key: "Authorization")]

    static let shared = NetworkInterceptor()
    
    private init() {
        do {
            // Open the file handle for appending
            if !FileManager.default.fileExists(atPath: fileURL.path){
                FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil) // Recreate the file
                print("File Doesn't Exits")
            }else{
                print("File Exits")
            }
            fileHandle = try FileHandle(forWritingTo: fileURL)
        }catch{
            print("Error creating file handle \(error)")
        }
    }
    
    public func flushFileData(){
        do {
            try FileManager.default.removeItem(at: NetworkInterceptor.shared.fileURL) // Remove the file
            FileManager.default.createFile(atPath: NetworkInterceptor.shared.fileURL.path, contents: nil, attributes: nil) // Recreate the file
            print("File content cleared successfully.")
            
            fileHandle = try FileHandle(forWritingTo: NetworkInterceptor.shared.fileURL)
        } catch {
            print("Error clearing file content: \(error)")
        }
    }
    
    
    
    static func dontPrint(attribute: RequestAttribute){
        maskedRequestAttribtes.append(attribute)
    }
    
    func closeFile(){
        fileHandle?.closeFile()
    }
    
    public func logData(data: Data){
        fileHandle?.seekToEndOfFile()
        fileHandle?.write(data)
    }
    
    deinit {
        closeFile()
    }
}
