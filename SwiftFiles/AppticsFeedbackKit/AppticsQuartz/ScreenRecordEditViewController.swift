//
//  ScreenRecordEditViewController.swift
//  AppticsQuartz
//
//  Created by jai-13322 on 16/04/25.
//

import UIKit
import AVFoundation
import AppticsFeedbackKit


@objcMembers
public class quartzFloatingBottomWindow: UIWindow {
    public var views: UIView?
    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
        self.windowLevel = UIWindow.Level.normal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let button = views else { return false }
        let buttonPoint = convert(point, to: button)
        return button.point(inside: buttonPoint, with: event)
    }
    
}


extension ScreenRecordEditViewController: AnnotationUploadCompletionDelegate{
    
    
//MARK: video upload success and you will get quartz URL
    public func uploadCompleted(withQuartzUrl quartzUrl: String) {
        print("QuartZURL",quartzUrl)
        let DataDict:[String: String] = ["urlString": quartzUrl]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "apptics_ScreenRecord_SendQuartzURL"), object: nil, userInfo: DataDict)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ScreenRecordEditViewController.didAddObservers = false
            self.flushRecordings()
        }
    }

    
//MARK: video upload failed and you will get failure callback from quartz and dismiss current window

    public func uploadFailed(with errType: UploadFailureError) {
        
        print("uploadFailed for video Initial State")

        var dataDict: [String: Any] = [:]
        switch errType {
        case .videoUploadFailed:
            print("Handle for video upload failure & retry")
            dataDict["urlString"] = "videoUploadFailed"
        case .annotatedJsonUploadFailed:
            print("Handle for json upload failure & retry")
            dataDict["urlString"] = "annotatedJsonUploadFailed"
        case .formSubmissingFailed:
            print("Handle for form submission failure & retry")
            dataDict["urlString"] = "formSubmissingFailed"
        }
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "apptics_ScreenRecord_FailedNotification"),
            object: nil,
            userInfo: dataDict
        )
        closeFloatingWindow()
    }

    
    
    
    
    
    
    
    
}


@objc public  class ScreenRecordEditViewController: UIViewController,IssueSubmissionViewModelDelegate,NavigationProtocol {

    private static var didAddObservers = false // flag to listen addObserver call to function only once

    
    public func closeFloatingWindow() {
        if #available(iOS 13.0, *) {
            if let currentWindowScene = UIApplication.shared.connectedScenes.first as?  UIWindowScene {
                sceneAlertWindow = UIWindow(windowScene: currentWindowScene)
                sceneAlertWindow?.windowLevel = UIWindow.Level.alert + 1
                sceneAlertWindow?.rootViewController = UIViewController()
                sceneAlertWindow?.makeKeyAndVisible()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.window.isHidden = true
                        self.window.removeFromSuperview()
                        self.sceneAlertWindow.isHidden = true
                        self.sceneAlertWindow.removeFromSuperview()
                    }
            }
        }
    }
    
    
//MARK: Quartz done action
    public func doneAction() {
        print("Done actionCalled")
        getImage { image in
            if let image = image {
                print(" image is present")
            } else {
                print("Image is nil")
            }
        }
        UIApplication.shared.topMostViewController()?.navigationController!.popViewController(animated: true)
        closeFloatingWindow()
        if FeedbackKit.listener().closeQuartz_Window != "quartzClose"{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                FeedbackKit.showFeedback()
            }
        }
    }
    //MARK: Quartz cancel action

    public  func cancelAction() {
        print("Called cancelAction")
        getImage { image in
            if let image = image {
                print(" image is present")
            } else {
                print("Image is nil")
            }
        }
        UIApplication.shared.topMostViewController()?.navigationController!.popViewController(animated: true)
        closeFloatingWindow()
        if FeedbackKit.listener().closeQuartz_Window != "quartzClose"{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                FeedbackKit.showFeedback()

            }
        }

    }
    public func showDataLossAlertAndDismissIfPrompted() {
        
    }
    public func dismissIssueSubmissionVC(){
        self.dismiss(animated: true)
    }
    
    public func newRecordingTapped() {
        self.dismiss(animated: true) {
        }
    }
    
    
    
    
    public lazy var window = quartzFloatingBottomWindow()
    
    public var sceneAlertWindow: UIWindow!
    
    private lazy var issueSubmissionVm = IssueSubmissionViewModel(delgate: self)

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    public init() {
        super.init(nibName: nil, bundle: nil)
        if #available(iOS 13.0, *) {
            if window.windowScene != nil{
                setRootViewController()
            }else{
                if let currentWindowScene = UIApplication.shared.connectedScenes.first as?  UIWindowScene {
                    window.windowScene = currentWindowScene
                    window.windowLevel = UIWindow.Level.alert + 1
                    window.rootViewController = self
                    window.makeKeyAndVisible()
                }
                else{
                    setRootViewController()
                }
            }
        } else {
            setRootViewController()
        }
        
    }
    
    func setRootViewController(){
        window.windowLevel = UIWindow.Level.alert
        window.isHidden = false
        window.rootViewController = self
        window.makeKeyAndVisible()
    }
    

    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        editScreenRecording(isAnimated: false)
        print("viewDidLoad called for \(self)")
        
        if !ScreenRecordEditViewController.didAddObservers {
            ScreenRecordEditViewController.didAddObservers = true
                   NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("apptics_ScreenRecord_DataErase"), object: nil)

                   NotificationCenter.default.addObserver(self, selector: #selector(self.methodSendDataToQuartz(notification:)), name: Notification.Name("apptics_ScreenRecord_SendData"), object: nil)
               }
        
    }
    
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        flushRecordings()
        FeedbackKit.listener().flagForRecordSent = ""
        NotificationCenter.default.removeObserver(self)
        ScreenRecordEditViewController.didAddObservers = false
    }
    
    @objc func methodSendDataToQuartz(notification: Notification) {
        print("send pressed in quartz--methodSendDataToQuartz")
        NotificationCenter.default.removeObserver(self)
        self.submitFormWithAnnotatedVideo()
    }

    
    
   
    func flushRecordings(){
        issueSubmissionVm?.flushOldRecording()
        AnnotationEditViewControllerStore.shared.resetAnnotationEditViewControllerStore()
    }    
    
    
//MARK: Quartz get Image thumbnail

    public func getImage(completion: @escaping (UIImage?) -> Void) {
        guard let vm = issueSubmissionVm else {
            completion(nil)
            return
        }


        let email = FeedbackKit.listener().emailAddress
        let strmail = email.isEmpty ? "user@example.com" : email

        
        vm.update(userMailAddress: "\(strmail)",
                  subject: "",
                  description: "")

        vm.getScreenRecordedVideoThumbnail(at: CMTime(seconds: 1, preferredTimescale: 50)) { image in
            if let image = image, let data = image.pngData() {
                let filename = "Apptics_ScreenRecordedVideoThumbnail.png"
                let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
                do {
                    try data.write(to: url)
                    print("Image saved at: \(url.path)")
                } catch {
                    print("Error saving image: \(error)")
                }
            }
            completion(image)
        }
        
        
        
    }
    

//MARK: Quartz Send recordings data to server

    func submitFormWithAnnotatedVideo(){
        print("submitFormWithAnnotatedVideo is sent to server called")
         self.issueSubmissionVm?.submitAnnotatedVideoWithData()
     }
    
    
//MARK: Quartz record edit viewcontroller page
    
    private func editScreenRecording(isAnimated: Bool) {
        guard let topVC = UIApplication.shared.topMostViewController(),
              let navigationController = topVC.navigationController else {
            print("Navigation controller not found.")
            return
        }

        if let storedVC = AnnotationEditViewControllerStore.shared.editVC {
            if !navigationController.viewControllers.contains(storedVC) {
                navigationController.pushViewController(storedVC, animated: isAnimated)
            }
        } else {
            let editVC = issueSubmissionVm!.getAnnotationEditingViewController(
                isVideoPlayBackMode: false,
                withNavDelegate: self
            )
            AnnotationEditViewControllerStore.shared.editVC = editVC
            navigationController.pushViewController(editVC, animated: isAnimated)
        }
    }

    
  
}




//MARK: Singleton class to hold the Edited instance of the VC
@objcMembers
public class AnnotationEditViewControllerStore: NSObject {
    
    public static let shared = AnnotationEditViewControllerStore()
    
    public var editVC: UIViewController?
    
    private override init() {
        super.init()
    }
    
    public func resetAnnotationEditViewControllerStore() {
        editVC = nil
        print("editVC is reset to nil")
    }
}







