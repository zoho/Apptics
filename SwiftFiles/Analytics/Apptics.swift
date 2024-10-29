//
//  Apptics.swift
//
//  Created by Saravanan S on 12/01/18.
//  Copyright © 2018 zoho. All rights reserved.
//

import Foundation
import SwiftUI
import Apptics
import AppticsScreenTracker

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


#if TARGET_OS_IOS
@available(iOS 13.0, macOS 10.15, tvOS 13.0, visionOS 1.0, watchOS 6.0,*)
struct ScreenTrackingModifier: ViewModifier {
    let screenName: String

    func body(content: Content) -> some View {
        content
            .onAppear {
                // Track screen view when the view appears
                APScreentracker.trackViewEnter(screenName)
                
            }
            .onDisappear {
                // Track screen disappearance if needed
                APScreentracker.trackViewExit(screenName)
                print("\(screenName) disappeared")
            }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, visionOS 1.0, watchOS 6.0,*)
extension View {
    public func trackScreen(_ screenName: String) -> some View {
        self.modifier(ScreenTrackingModifier(screenName: screenName))
    }
}
#endif
