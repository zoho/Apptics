//
//  QuartzKit.swift
//
//
//  Created by Jaffer Sheriff U on 24/05/24.
//

import UIKit

public protocol QuartzKitDelegate{
    var subDomain: String { get }
    var department: String { get }
    var workspace: String { get }
    var shouldRecordNetworkLogs: Bool { get }
    var theme: QuartzTheme? { get }
}

public extension QuartzKitDelegate {
    var theme: QuartzTheme? {
        return nil
        /*
        Sample Usage Of Theme
        let primaryColorLight = UIColor(red: 41.0/255.0, green: 91.0/255.0, blue: 249.0/255.0, alpha: 1)
        let colorOnPrimaryLight = UIColor.white
        
        let primaryColorDark = UIColor(red: 70.0/255.0, green: 103.0/255.0, blue: 241.0/255.0, alpha: 1)
        let colorOnPrimaryDark = UIColor.black
        
        let switchOnTintColorLight = UIColor.blue
        let switchOnTintColorDark = UIColor.red
        
        let colorSchemeLight = QuartzColorScheme(primaryColor: primaryColorLight, switchOnTintColor: switchOnTintColorLight, colorOnPrimary: colorOnPrimaryLight)
        let colorSchemeDark = QuartzColorScheme(primaryColor: primaryColorDark, switchOnTintColor: switchOnTintColorDark, colorOnPrimary: colorOnPrimaryDark)
        
        return QuartzTheme(colorScheme: colorSchemeLight, darkColorScheme: colorSchemeDark, uiMode: .systemDefault)
         */
    }
}

public class QuartzKit{
    public static var shared: QuartzKit!
    
    var delegate: QuartzKitDelegate
    
    public var subDomain: String{
        let toReturn = delegate.subDomain
        lastUsedSubdomain = toReturn
        return toReturn
    }
    
    public var department: String{
        delegate.department
    }
    
    public var workspace: String{
        delegate.workspace
    }
    
    public var shouldRecordNetworkLogs: Bool{
        delegate.shouldRecordNetworkLogs
    }
    
    public var primaryColor : UIColor? {
        guard let theme = delegate.theme else {return nil}
        return UIColor.dynamicColor(light: theme.colorScheme.primaryThemeColor, dark: theme.darkColorScheme.primaryThemeColor)
    }
    
    public var switchOnTintColor : UIColor? {
        guard let theme = delegate.theme else {return nil}
        return UIColor.dynamicColor(light: theme.colorScheme.switchOnTintColor, dark: theme.darkColorScheme.switchOnTintColor)
    }
    
    public var colorOnPrimaryColor : UIColor? {
        guard let theme = delegate.theme else {return nil}
        return UIColor.dynamicColor(light: theme.colorScheme.txtColorOnPrimaryColorBG, dark: theme.darkColorScheme.txtColorOnPrimaryColorBG)
    }
    
    public var primaryLightColor : UIColor? {
        guard let theme = delegate.theme else {return nil}
        return UIColor.dynamicColor(light: theme.colorScheme.primaryLightColor, dark: theme.darkColorScheme.primaryLightColor)
    }
    
    public var uiMode: UIUserInterfaceStyle {
        guard let theme = delegate.theme else {return .unspecified}
        switch theme.uiMode {
        case .light:
            return .light
        case .dark:
            return .dark
        case .systemDefault:
            return .unspecified
        }
    }
    
    public private(set) var lastUsedSubdomain: String = ""
    
    
    init(delegate: QuartzKitDelegate) {
        self.delegate = delegate
    }
    
    
    public static func configure(delegate: QuartzKitDelegate) {
        shared = QuartzKit(delegate: delegate)
        shared.cleanUpVideoAndAudioSavedFiles()
        shared.removeAllObserverFromSelf()
        NotificationCenter.default.addObserver(shared, selector: #selector(screeenRecordingStateChanged(_:)), name: UIScreen.capturedDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(shared, selector: #selector(applicationWillTerminate(notification:)), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    private func removeAllObserverFromSelf(){
        NotificationCenter.default.removeObserver(self)
    }
    
    /*  For handling devices's screen recording started when app's screen recording in progress case */
    @objc private func screeenRecordingStateChanged(_ sender: Notification){
        
        let isScreenCaptured = UIScreen.main.isCaptured
        let isScreenRecordedByRPKit = ScreenRecorder.isScreenRecording()
        
        let isQuartzStartedRecording = UserDefaults.standard.object(forKey: ScreenRecorder.isScreenRecordingStartedByQuartz) as? Bool ?? false
        let state = UIApplication.shared.applicationState
//        print("Screen recording state changed. isScreenCaptured: \(isScreenCaptured), isScreenRecordedByRPKit: \(isScreenRecordedByRPKit), isQuartzStartedRecording: \(isQuartzStartedRecording), app state: \(state as? UIApplication.State)")
            switch state {
            case .active:
                if !isScreenCaptured, isQuartzStartedRecording, isScreenRecordedByRPKit{ // Quartz Recording interrupted by system recording while app is in forground
                    QuartzRecordingTimeNotifier.shared.osScreenRecordingStartedWhileQuartzRecordingInprogress()
                }
            case .background:
                if isScreenCaptured, isQuartzStartedRecording{ // Quartz Recording In progress with app in minimized background state & system screen recording started
                    QuartzRecordingTimeNotifier.shared.osScreenRecordingStartedWhileQuartzRecordingInprogress()
                }
            default: break
            }
    }
    
    private func stopQuartzRecordingIfInProgress(){
        if let isRecordingStartedByQuartz = UserDefaults.standard.object(forKey: ScreenRecorder.isScreenRecordingStartedByQuartz) as? Bool, isRecordingStartedByQuartz{
            QuartzRecordingTimeNotifier.shared.osScreenRecordingStartedWhileQuartzRecordingInprogress()
        }
    }
    
    @objc func applicationWillTerminate(notification: Notification) {
        stopQuartzRecordingIfInProgress()
    }
    
    func cleanUpVideoAndAudioSavedFiles(){
        AudioRecorder.deleteAllRecordings()
        clearVideoScreenRecordedFile()
    }
    
    private func clearVideoScreenRecordedFile() {
        clearOldScreenRecordedVideoFiles()
        do {
            let tmpDirURL = FileManager.default.temporaryDirectory
            let quartzDirUrl = tmpDirURL.appendingPathComponent(ScreenRecorder.directoryName)
            let fileUrl = quartzDirUrl.appendingPathComponent(ScreenRecorder.annotatedVideoName)
            if FileManager.default.fileExists(atPath: fileUrl.path){
                try FileManager.default.removeItem(atPath: fileUrl.path)
            }
        } catch {
            print("Error removing the saved video file : \(error.localizedDescription)")
        }
    }
    
    private func clearOldScreenRecordedVideoFiles(){
        do {
            let fManager = FileManager.default
            let tmpDirectory = try fManager.contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                if let videoFileName = path.components(separatedBy: "/").last{
                    if videoFileName.hasSuffix(".mov"), videoFileName.components(separatedBy: "-").count == 5{ // Removes old videos which are not cleaned up by os
                        try fManager.removeItem(atPath: path)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    deinit {
        self.removeAllObserverFromSelf()
    }
}


public struct QuartzTheme{
    let colorScheme: QuartzColorScheme
    let darkColorScheme: QuartzColorScheme
    let uiMode: QuartzUIMode
}

public struct QuartzColorScheme{
    let primaryThemeColor: UIColor
    let switchOnTintColor: UIColor
    let txtColorOnPrimaryColorBG: UIColor
    var primaryLightColor: UIColor{
        primaryThemeColor.withAlphaComponent(0.2)
    }
}

public enum QuartzUIMode{
    case light, dark, systemDefault;
}

extension UIColor {
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return light }
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
}
