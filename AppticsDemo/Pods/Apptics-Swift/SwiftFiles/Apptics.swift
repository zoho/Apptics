//
//  Apptics.swift
//
//  Created by Saravanan S on 12/01/18.
//  Copyright © 2018 zoho. All rights reserved.
//

import Foundation
import Apptics

extension APLog {
  
}

public func APTrackError(_ error: @autoclosure () -> NSError, file: StaticString = #file, line: UInt = #line, function: StaticString = #function){
    let currentFile = file.withUTF8Buffer {
        String(decoding: $0, as: UTF8.self)
    }
    let key = "\((currentFile as NSString).lastPathComponent)_\(function)_\(line)_error"
    Analytics.getInstance().trackError(error(), withKey: key)
}

public func APTrackException(_ exception: @autoclosure () -> NSException, file: StaticString = #file, line: UInt = #line, function: StaticString = #function){
    let currentFile = file.withUTF8Buffer {
        String(decoding: $0, as: UTF8.self)
    }
    let key = "\((currentFile as NSString).lastPathComponent)_\(function)_\(line)_error"
    Analytics.getInstance().trackException(exception(), withKey: key)
}

public func APLogVerbose(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line, function: StaticString = #function){
  APLog.getInstance().zlsExtension(String(describing: file), lineNumber: Int32(line), functionName: String(describing: function), symbol: "🟣", type: "verbose", format: message())
}

public func APLogDebug(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line, function: StaticString = #function){
  APLog.getInstance().zlsExtension(String(describing: file), lineNumber: Int32(line), functionName: String(describing: function), symbol: "🟢", type: "debug", format: message())
}

public func APLogInfo(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line, function: StaticString = #function){
  APLog.getInstance().zlsExtension(String(describing: file), lineNumber: Int32(line), functionName: String(describing: function), symbol: "🔵", type: "info", format: message())
}

public func APLogWarn(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line, function: StaticString = #function){
  APLog.getInstance().zlsExtension(String(describing: file), lineNumber: Int32(line), functionName: String(describing: function), symbol: "⚠️", type: "warning", format: message())
}

public func APLogError(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line, function: StaticString = #function){
  APLog.getInstance().zlsExtension(String(describing: file), lineNumber: Int32(line), functionName: String(describing: function), symbol: "🔴", type: "error", format: message())
}

