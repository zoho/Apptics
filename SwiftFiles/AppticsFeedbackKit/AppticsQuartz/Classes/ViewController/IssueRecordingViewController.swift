//
//  IssueRecordingViewController.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 17/11/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import UIKit
import ReplayKit

fileprivate struct IssueRecordingVCStringProvider{
    static let navTitle = QuartzKitStrings.localized("issuerecordscreen.label.recordissue")
    static let closeButtonTitle = QuartzKitStrings.localized("issuerecordscreen.label.close")
    static let recordingFailureGenericAlertText = QuartzKitStrings.localized("issuerecordscreen.label.failedtoinitiate")
    static let recordingFailureDueToMultiwindowAlertText = QuartzKitStrings.localized("issuerecordscreen.label.failuremultiwindow")
    static let recordingFailureDueToNoInternetAlertText = QuartzKitStrings.localized("issuerecordscreen.label.nointerneterror")
    static let recordingFailureAlertOKText = QuartzKitStrings.localized("issuerecordscreen.label.ok")
}


public class IssueRecordingViewController: UIViewController{
    public var shouldShowCloseInNavBar: Bool = false
    private var previousInterfaceStyle: UIUserInterfaceStyle?
    
    public weak var delegate: ScreenRecordingStoppingDelegate? = nil
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        //        containerView.backgroundColor = .yellow
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    public var issueRecordingImg: UIImage?
    public var helpDocUrlStr: String?
    
    private lazy var issueRecordingView: IssueRecordingView = {
        let issueRecordingView = IssueRecordingView(withIssueRecordingImg: issueRecordingImg, helpDocRefUrlStr: helpDocUrlStr )
        issueRecordingView.delegate = self
        //        issueRecordingView.backgroundColor = .orange
        issueRecordingView.translatesAutoresizingMaskIntoConstraints = false
        return issueRecordingView
    }()
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = IssueRecordingViewColors.issueRecordingViewBG
        title = IssueRecordingVCStringProvider.navTitle
        
        configure()
        configureNavigationBarUI()
        removeNotificationObserver()
        
        NotificationCenter.default.addObserver(self, selector: #selector(screenRecordingStopped(sender:)), name: QuartzRecordingTimeNotifier.shared.screenRecordingStoppingNotification , object: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if previousInterfaceStyle == nil {
            previousInterfaceStyle = navigationController?.overrideUserInterfaceStyle
        }

        let forcedMode = QuartzKit.shared.uiMode
        overrideUserInterfaceStyle = forcedMode
        navigationController?.overrideUserInterfaceStyle = forcedMode
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent {
            if let original = previousInterfaceStyle {
                navigationController?.overrideUserInterfaceStyle = original
            }
        }
    }
    
    private func configureNavigationBarUI(){
        navigationItem.largeTitleDisplayMode = .never
        
        if shouldShowCloseInNavBar{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: IssueRecordingVCStringProvider.closeButtonTitle, style: .done, target: self, action: #selector(backPressed))
        }else{
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.named("navigationBack"), style: .done, target: self,  action: #selector(backPressed))
        }
        navigationController?.navigationBar.tintColor = QuartzKit.shared.primaryColor
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = IssueRecordingViewColors.issueRecordingNavBarBg
            appearance.titleTextAttributes = [.foregroundColor: IssueRecordingViewColors.issueRecordingNavBarTextColor]
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
            navigationItem.compactAppearance = appearance // For iPhone small navigation bar in landscape.
        }
    }
        
    private func configure(){
        let leadingPaddingOfScrollView: CGFloat = 10
        let trailingPaddingOfScrollView: CGFloat = 10
        let topPaddingOfScrollView: CGFloat = 10
        let bottomPaddingOfScrollView: CGFloat = 10
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingPaddingOfScrollView),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -trailingPaddingOfScrollView),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPaddingOfScrollView),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomPaddingOfScrollView)
        ])
        
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        containerView.addSubview(issueRecordingView)
        NSLayoutConstraint.activate([
            issueRecordingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            issueRecordingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            issueRecordingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            issueRecordingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    @objc func screenRecordingStopped(sender: Notification) {
        backPressed()
    }
    
    @objc private func backPressed(){
        if isModal{
            dismiss(animated: true)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func removeNotificationObserver(){
        NotificationCenter.default.removeObserver(self)
    }
    
//    public override var preferredStatusBarStyle: UIStatusBarStyle {
//        if #available(iOS 13.0, *) {
//            return .darkContent
//        } else {
//            return .lightContent
//        }
//    }
    
    deinit{
        removeNotificationObserver()
    }
}

extension IssueRecordingViewController:  IssueRecordingViewDelegate{
    
    func showDataCollectionMessage(){
            let dataConsentVC = DataCollectionAlertingViewController()
            dataConsentVC.modalPresentationStyle = .custom
            dataConsentVC.transitioningDelegate = self
            self.present(dataConsentVC, animated: true)
    }
    
    func startRecording(){
        ScreenRecorder.shared().startScreenRecording { result in
            self.enableTheDisabledStartRecordingButton()
            switch result {
            case .success(_):
                if let window = UIApplication.shared.windows.first{
                    let notifier = QuartzRecordingTimeNotifier.shared
                    notifier.delegate = self.delegate
                    notifier.configure(inWindow: window)
                }
                self.recordingStarted()
                self.backPressed()
            case .failure(let failure):
                self.handleRecordingInitiationError(failure)
            }
        }
    }
    
    func endRecording() {
        if isModal{
            dismiss(animated: false) {
                QuartzRecordingTimeNotifier.shared.stopClicked()
            }
        }else{
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                QuartzRecordingTimeNotifier.shared.stopClicked()
            }
            self.navigationController?.popViewController(animated: false)
            CATransaction.commit()
        }
    }
    
    private func recordingStarted(){
        delegate?.screenRecordingStartedByQuartz()
//        NetworkInterceptor.enableNetworkInterception()
    }
    
    func notConnectedToInternet() {
        showNoInternetConnectionAlert()
    }
}


extension IssueRecordingViewController: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
extension IssueRecordingViewController{
    
    private func handleRecordingInitiationError(_ error: Error) {
        // Try to cast the Error to NSError to access the code
        if let nsError = error as NSError?, let errorCode = RPRecordingErrorCode(rawValue: nsError.code) {
            switch errorCode {
            case .userDeclined: // Do nothing when user denied the permission to screen recording since when clicked again on start recording button the os will show alert asking for the permission
                break
            case .contentResize:
                showRecordingFailedDueToMultiWindowError()
            default:
                showRecordingFailedGenericError()
            }
        } else {
            print("An error occurred: \(error.localizedDescription)")
        }
    }
    
    
    private func enableTheDisabledStartRecordingButton(){
        issueRecordingView.startRecordingButton(shouldEnable: true)
    }
    
    
    private func showRecordingFailedGenericError(){
        showAlert(with: nil, message: IssueRecordingVCStringProvider.recordingFailureGenericAlertText)
    }
    
    private func showRecordingFailedDueToMultiWindowError(){
        showAlert(with: nil, message: IssueRecordingVCStringProvider.recordingFailureDueToMultiwindowAlertText)
    }
    
    private func showNoInternetConnectionAlert(){
        showAlert(with: nil, message: IssueRecordingVCStringProvider.recordingFailureDueToNoInternetAlertText)
    }
    
    func showAlert(with title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: IssueRecordingVCStringProvider.recordingFailureAlertOKText, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

class PresentationController: UIPresentationController {
    
    let blurView: UIView!
    var dimmingViewColor: UIColor = UIColor.black.withAlphaComponent(0.4)
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        blurView = UIView()
        blurView.backgroundColor = dimmingViewColor
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurView.isUserInteractionEnabled = true
        self.blurView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0,
                               y: self.containerView!.frame.height * 0.5),
               size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
                            0.5))
    }
    
    override func presentationTransitionWillBegin() {
        self.blurView.alpha = 0
        self.containerView?.addSubview(blurView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurView.alpha = 1
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.roundCorners([.topLeft, .topRight], radius: 12)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurView.frame = containerView!.bounds
    }
    
    @objc func dismissController(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}

extension UIView {
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      layer.mask = mask
  }
}


struct IssueRecordingViewColors{
    static let issueRecordingViewBG = QuartzRGBColor.issueRecordingViewBGColor
    static let issueRecordingNavBarBg = QuartzRGBColor.issueRecordingNavBarBGColor
    static let issueRecordingNavBarTextColor = UIColor.label
    static let quicklyRecordIssueLabelTextColor = QuartzRGBColor.quicklyRecordIssueLabelColor
    static let iAgreeLabelColor = QuartzRGBColor.iAgreeLabelColor
    static let viewDetailsLabelColor = QuartzRGBColor.viewDetailsLabel
    
    static let startRecordingButtonEnabledTxtColor = QuartzRGBColor.startRecEnabledTxtColor
    static let startRecordingButtonDisabledTxtColor = QuartzRGBColor.startRecDisabledTxtColor
    
    static let startRecordingButtonEnabledBgColor = QuartzRGBColor.startRecEnabledBGColor
    static let startRecordingButtonDisabledBgColor = QuartzRGBColor.startRecDisabledBGColor
    
    static let quickTipsTitleTextColor = QuartzRGBColor.quickTipsTitleTextColor
    static let quickTipsViewBGColor = QuartzRGBColor.quickTipsViewBgColor
    static let quickTipsTextColor = QuartzRGBColor.quickTipsTextColor
    
    static let dataConsentTextColor = QuartzRGBColor.dataConsentTextColor
    static let dataConsentViewBGColor = QuartzRGBColor.dataConsentViewBGColor
    
    static let issueSubmissionNavBarBg = QuartzRGBColor.issueSubmissionNavBarBg
    static let issueSubmissionNavBarTextColor = UIColor.label
}

enum QuartzRGBColor{
    static let issueRecordingViewBGColor = UIColor.quartzColor(
        UIColor.color(r: 255, g: 255, b: 255, a: 1),
        UIColor.color(r: 19, g: 19, b: 19, a: 1)
    )
    static let issueRecordingNavBarBGColor = UIColor.quartzColor(
        UIColor.color(r: 255, g: 255, b: 255, a: 1),
        UIColor.color(r: 41, g: 41, b: 41, a: 1)
    )
    static let quicklyRecordIssueLabelColor = UIColor.quartzColor(
        UIColor.color(r: 0, g: 0, b: 0, a: 0.7),
        UIColor.color(r: 255, g: 255, b: 255, a: 0.7)
    )
    static let iAgreeLabelColor = UIColor.quartzColor(
        UIColor.label,
        UIColor.color(r: 255, g: 255, b: 255, a: 1)
    )
    static let viewDetailsLabel = UIColor.quartzColor(
        UIColor.color(r: 105, g: 125, b: 247, a: 1),
        UIColor.color(r: 105, g: 125, b: 247, a: 1)
    )
    static let startRecEnabledTxtColor = UIColor.quartzColor(
        UIColor.color(r: 255, g: 255, b: 255, a: 1),
        UIColor.color(r: 255, g: 255, b: 255, a: 1)
    )
    static let startRecDisabledTxtColor = UIColor.quartzColor(
        UIColor.color(r: 116, g: 121, b: 138, a: 1),
        UIColor.color(r: 230, g: 224, b: 233, a: 1)
    )
    static let startRecEnabledBGColor = UIColor.quartzColor(
        UIColor.color(r: 105, g: 125, b: 247, a: 1),
        UIColor.color(r: 105, g: 125, b: 247, a: 1)
    )
    static let startRecDisabledBGColor = UIColor.quartzColor(
        UIColor.color(r: 226, g: 227, b: 233, a: 1),
        UIColor.color(r: 230, g: 224, b: 233, a: 0.12)
    )
    
    
    static let quickTipsTitleTextColor = UIColor.quartzColor(
        UIColor.color(r: 31, g: 32, b: 35, a: 0.7),
        UIColor.color(r: 255, g: 255, b: 255, a: 0.7)
    )
    static let quickTipsViewBgColor = UIColor.quartzColor(
        UIColor.color(r: 237, g: 240, b: 248, a: 1),
        UIColor.color(r: 28, g: 28, b: 29, a: 1)
    )
    static let quickTipsTextColor = UIColor.quartzColor(
        UIColor.color(r: 31, g: 32, b: 35, a: 0.7),
        UIColor.color(r: 255, g: 255, b: 255, a: 0.7)
    )
    static let dataConsentTextColor = UIColor.quartzColor(
        UIColor.color(r: 0, g: 0, b: 0, a: 0.7),
        UIColor.color(r: 255, g: 255, b: 255, a: 0.7)
    )
    static let dataConsentViewBGColor = UIColor.quartzColor(
        UIColor.color(r: 255, g: 255, b: 255, a: 1),
        UIColor.color(r: 28, g: 28, b: 29, a: 1)
    )
    static let issueSubmissionNavBarBg = UIColor.quartzColor(
        UIColor.color(r: 255, g: 255, b: 255, a: 1),
        UIColor.color(r: 41, g: 41, b: 41, a: 1)
    )
    
    
    static let annotationControlViewButtionColor = UIColor.quartzColor(
        UIColor.color(r: 76, g: 76, b: 77, a: 1),
        UIColor.color(r: 202, g: 202, b: 202, a: 1)
    )
    static let thumbanilContainerBGColor = UIColor.quartzColor(
        UIColor.color(r: 244, g: 245, b: 246, a: 1),
        UIColor.color(r: 23, g: 22, b: 23, a: 1)
    )
    static let shapeBlockViewBGColor = UIColor.quartzColor(
        UIColor.color(r: 208, g: 216, b: 248, a: 1),
        UIColor.color(r: 33, g: 39, b: 94, a: 1)
    )
    static let shapeIndicatorViewBGColor = UIColor.quartzColor(
        UIColor.color(r: 48, g: 48, b: 50, a: 1),
        UIColor.color(r: 255, g: 255, b: 255, a: 1)
    )
    static let audioRowViewBGColor = UIColor.quartzColor(
        UIColor.color(r: 228, g: 231, b: 246, a: 1),
        UIColor.color(r: 25, g: 29, b: 53, a: 1)
    )
    static let recordedVideoAudioTrackBGColor = UIColor.quartzColor(
        UIColor.color(r: 208, g: 216, b: 248, a: 1),
        UIColor.color(r: 33, g: 39, b: 94, a: 1)
    )
    static let recordedAudioBlockViewBG = UIColor.quartzColor(
        UIColor.color(r: 169, g: 239, b: 203, a: 1),
        UIColor.color(r: 123, g: 182, b: 152, a: 1)
    )
    static let handlerViewCenterLineColor = UIColor.quartzColor(
        UIColor.color(r: 255, g: 255, b: 255, a: 1),
        UIColor.color(r: 0, g: 0, b: 0, a: 1)
    )
    static let selectionBorderColor = UIColor.quartzColor(
        UIColor.color(r: 42, g: 42, b: 44, a: 1),
        UIColor.color(r: 250, g: 199, b: 44, a: 1)
    )
    static let toolBarIconsColor = UIColor.quartzColor(
        UIColor.color(r: 91, g: 91, b: 91, a: 1),
        UIColor.color(r: 202, g: 202, b: 202, a: 1)
    )
    static let toolBarTextColor = UIColor.quartzColor(
        UIColor.color(r: 91, g: 91, b: 91, a: 1),
        UIColor.color(r: 202, g: 202, b: 202, a: 1)
    )
    static let bottomToolBarColor = UIColor.quartzColor(
        UIColor.color(r: 255, g: 255, b: 255, a: 1),
        UIColor.color(r: 19, g: 19, b: 20, a: 1)
    )
    static let shapeColorPickerBGColor = UIColor.quartzColor(
        UIColor.color(r: 255, g: 255, b: 255, a: 1),
        UIColor.color(r: 42, g: 41, b: 43, a: 1)
    )
    static let borderStyleCellContentViewBGColor = UIColor.quartzColor(
        UIColor.color(r: 255, g: 255, b: 255, a: 1),
        UIColor.color(r: 42, g: 41, b: 43, a: 1)
    )
    static let borderStyleCellContentSelectionBGColor = UIColor.quartzColor(
        UIColor.color(r: 228, g: 231, b: 246, a: 1),
        UIColor.color(r: 33, g: 39, b: 94, a: 1)
    )
    static let strokeWidthLabelTxtColor = UIColor.quartzColor(
        UIColor.color(r: 102, g: 102, b: 102, a: 1),
        UIColor.color(r: 220, g: 220, b: 220, a: 1)
    )
    static let recordAudioIconColor = UIColor.quartzColor(
        UIColor.color(r: 255, g: 255, b: 255, a: 1),
        UIColor.color(r: 255, g: 255, b: 255, a: 1)
    )
    static let textMaskingViewBGColor = UIColor.quartzColor(
        UIColor.color(r: 255, g: 255, b: 255, a: 0.6),
        UIColor.color(r: 0, g: 0, b: 0, a: 0.6)
    )
    
    
    static let screenRecordingStoppingViewBGColor = UIColor.quartzColor(
        UIColor.color(r: 246, g: 246, b: 246, a: 0.9),
        UIColor.color(r: 40, g: 40, b: 40, a: 0.9)
    )
    static let screenRecordingStoppingViewBorderColor = UIColor.quartzColor(
        UIColor.color(r: 0, g: 0, b: 0, a: 0.12),
        UIColor.color(r: 255, g: 255, b: 255, a: 0.12)
    )
    static let screenRecordingStoppingViewTextColor = UIColor.quartzColor(
        UIColor.color(r: 62, g: 62, b: 62, a: 1),
        UIColor.color(r: 200, g: 200, b: 200, a: 1)
    )
    
    
    static let loaderBoxColor = UIColor.quartzColor(
        UIColor.color(r: 255, g: 255, b: 255, a: 1),
        UIColor.color(r: 39, g: 39, b: 40, a: 1)
    )
    static let loadingCircleUnfilledColor = UIColor.quartzColor(
        UIColor.color(r: 194, g: 194, b: 194, a: 1),
        UIColor.color(r: 56, g: 56, b: 58, a: 1)
    )
    static let submittingTextColor = UIColor.quartzColor(
        UIColor.color(r: 1, g: 1, b: 1, a: 1),
        UIColor.color(r: 255, g: 255, b: 255, a: 1)
    )
}

enum QuartzColor: String{
    case issueRecordingViewBGColor = "issueRecordingViewBg"
    case issueRecordingNavBarBGColor = "issueRecordingViewNavBarBg"
    case quicklyRecordIssueLabelColor = "quicklyRecordIssueLabelColor"
    case iAgreeLabelColor = "iAgreeLabel"
    case viewDetailsLabel = "viewDetailsLabel"
    case startRecEnabledTxtColor = "startRecordingButtonEnabledText"
    case startRecDisabledTxtColor = "startRecordingButtonDisabledText"
    case startRecEnabledBGColor = "startRecordingButtonEnabledBG"
    case startRecDisabledBGColor = "startRecordingButtonDisabledBG"
    
    case quickTipsTitleTextColor = "quickTipsLabelTextColor"
    case quickTipsViewBgColor = "quickTipsViewBGColor"
    case quickTipsTextColor = "tipTextColor"
    case dataConsentTextColor = "dataConsentTextColor"
    case dataConsentViewBGColor = "dataConsentViewBG"
    case issueSubmissionNavBarBg = "issueSubmissionNavBarBg"
    
    case annotationControlViewButtionColor = "controlViewButtonColor"
    case thumbanilContainerBGColor = "thumbnailScrollContainerViewBG"
    case shapeBlockViewBGColor = "shapeBlockViewBGColor"
    case shapeIndicatorViewBGColor = "shapeIndicatorViewBGColor"
    case audioRowViewBGColor = "audioRowViewBGColor"
    case recordedVideoAudioTrackBGColor = "audioTrackOfScreenRecordedVideo"
    case recordedAudioBlockViewBG = "recordedAudioBlockViewBG"
    case handlerViewCenterLineColor = "handlerViewCenterLineColor"
    case selectionBorderColor = "selectionBorderNewColor"
    case toolBarIconsColor = "toolBarIconsColor"
    case toolBarTextColor = "toolBarTextColor"
    case bottomToolBarColor = "bottomToolBarColor"
    case shapeColorPickerBGColor = "shapeColorPickerBGColor"
    case borderStyleCellContentViewBGColor = "borderStyleCellContentViewBGColor"
    case borderStyleCellContentSelectionBGColor = "borderStyleCellContentSelectionBGColor"
    case strokeWidthLabelTxtColor = "strokeWidthLabelTxtColor"
    case recordAudioIconColor = "recordAudioIconColor"
    case textMaskingViewBGColor = "textMaskViewColor"
    
    case screenRecordingStoppingViewBGColor = "screenRecordingStoppingViewBGColor"
    case screenRecordingStoppingViewBorderColor = "screenRecordingStoppingViewBorderColor"
    case screenRecordingStoppingViewTextColor = "screenRecordingStoppingViewTextColor"
    
    case loaderBoxColor = "loaderBoxColor"
    case loadingCircleUnfilledColor = "loadingCircleUnfilledColor"
    case submittingTextColor = "submittingTextColor"
}


extension QuartzColor
{
    @available(iOS 11.0, *)
    var color : UIColor?
    {
        #if SWIFT_PACKAGE
                return  UIColor.init(named: self.rawValue, in: .module, compatibleWith: nil)
        #else
                return UIColor.init(named: self.rawValue, in: Bundle(for: TimeHandler.self), compatibleWith: nil)
        #endif
    }
}


extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}

