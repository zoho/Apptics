//
//  AppticsQuartz.swift
//  AppticsQuartz
//APIConstants
//  Created by jai-13322 on 15/04/25.
//
import Foundation
import AppticsFeedbackKit
import Apptics


extension FeedbackKit: ScreenRecordingStoppingDelegate{
    
    public func osScreenRecordingStartedWhileQuartzRecordingInProgress() {
        print("osScreenRecordingStartedWhileQuartzRecordingInProgress")
    }
    
    public func stopScreenRecording(isRecordingFailed: Bool){
        
    stopRecording(isRecordingFailed: isRecordingFailed) {
        print("stopRecording__Called")
        _ = ScreenRecordEditViewController()
    }
        FeedbackKit.listener().closeQuartz_Window = "stopped"
    }
    
    public func screenRecordingStartedByQuartz() {
        NotificationCenter.default.post(name: Notification.Name("Apptics_ScreenRecord_Started"), object: nil)
    }
    
    
    
    
    private func stopRecording(isRecordingFailed: Bool, completion: (() -> Void)? = nil) {
        ScreenRecorder.shared().stopScreenRecording{ isSuccess in
        guard !isRecordingFailed else {
                completion?()
                return
            }
            if isSuccess{
                print("isSuccess to Save clip")
            }else{
                print("Failed to Save clip")
            }
            completion?()
        }
    }
}


















//extension UIApplication {
//    func topMostViewController(base: UIViewController? = {
//        if #available(iOS 15.0, *) {
//        return UIApplication.shared.connectedScenes
//            .compactMap { $0 as? UIWindowScene }
//            .flatMap { $0.windows }
//            .first(where: { $0.isKeyWindow })?.rootViewController
//    } else {
//        return UIApplication.shared.windows
//            .first(where: { $0.isKeyWindow })?.rootViewController
//    }
//    }()) -> UIViewController? {
//        
//        if let nav = base as? UINavigationController {
//            return topMostViewController(base: nav.visibleViewController)
//        }
//        
//        if let tab = base as? UITabBarController,
//           let selected = tab.selectedViewController {
//            return topMostViewController(base: selected)
//        }
//        
//        if let presented = base?.presentedViewController {
//            return topMostViewController(base: presented)
//        }
//        
//        return base
//    }
//}





extension UIApplication {
    func topMostViewController(base: UIViewController? = {
        if #available(iOS 15.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })?.rootViewController
        } else {
            return UIApplication.shared.windows
                .first(where: { $0.isKeyWindow })?.rootViewController
        }
    }()) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController,
            let selected = tab.selectedViewController {
            return topMostViewController(base: selected)
        }
        
        if let presented = base?.presentedViewController {
            return topMostViewController(base: presented)
        }
        
        if let topController = base, topController.children.count > 0 {
            return topMostViewController(base: topController.children.last)
        }
        
        return base
    }
}

