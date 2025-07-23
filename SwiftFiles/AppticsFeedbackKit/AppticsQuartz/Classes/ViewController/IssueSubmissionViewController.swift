//
//  IssueSubmissionViewController.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 18/11/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
import ReplayKit
import Photos

struct IssueSubmissionViewStringsProvider{
    static let emailDisplayName = QuartzKitStrings.localized("issuesubmissionform.label.emaildisplay")
    static let emailPlaceHolder = QuartzKitStrings.localized("issuesubmissionform.label.emailplaceholder")
    
    static let videoDisplayName = QuartzKitStrings.localized("issuesubmissionform.label.screenrecordingsummary")
    
    static let subjectDisplayName = QuartzKitStrings.localized("issuesubmissionform.label.subjectdisplayname")
    static let subjectPlaceHolder = QuartzKitStrings.localized("issuesubmissionform.label.subjectplaceholder")
    
    static let addToExisingTicket = QuartzKitStrings.localized("issuesubmissionform.label.addtoexistingticket")
    
    static let ticketIDDisplayName = QuartzKitStrings.localized("issuesubmissionform.label.existingticketid")
    static let ticketIDPlaceHolder = QuartzKitStrings.localized("issuesubmissionform.label.enterticketidtolink")
    
    static let descriptionDisplayName = QuartzKitStrings.localized("issuesubmissionform.label.issuedescription")
    static let descriptionPlaceHolder = QuartzKitStrings.localized("issuesubmissionform.label.issuemoredetails")
    
    static let fileAttachment = QuartzKitStrings.localized("issuesubmissionscreen.label.attachfiles")
    
    static let issueSubmissionVCNavTitle = QuartzKitStrings.localized("issuesubmissionform.label.submityourissue")
    static let navBarLeftCancelButtonTitle = QuartzKitStrings.localized("general.label.cancel")
    
    static let errorOccurred = QuartzKitStrings.localized("general.label.erroroccured")
    static let done = QuartzKitStrings.localized("general.label.done")
    static let ok = QuartzKitStrings.localized("general.label.ok")
    
    static let videoUploadFailed = QuartzKitStrings.localized("issuesubmissionform.alert.videouploadfailed")
    
    static let successMessageTitle = QuartzKitStrings.localized("issuesubmissionform.alert.thanksmessagetitle")
    static let successMessageBody = QuartzKitStrings.localized("issuesubmissionform.alert.thanksmessagebody")
    
    static let editDetailsUploadFailed = QuartzKitStrings.localized("issuesubmissionform.alert.videoeditdetailuploadfailure")
    
    static let emptySubjectErrorMsg = QuartzKitStrings.localized("issuesubmissionform.label.entersubject")
    static let emptyEmailErrorMsg = QuartzKitStrings.localized("issuesubmissionform.label.enteremail")
    static let emptyTicketErrorMsg = QuartzKitStrings.localized("issuesubmissionform.label.enterexistingticketid")
    
    static let choosePhotos = QuartzKitStrings.localized("issuesubmissionform.label.choosephoto")
    static let chooseFiles = QuartzKitStrings.localized("issuesubmissionform.label.browse")
    static let cancel = QuartzKitStrings.localized("general.label.cancel")
    
    static let iPhonePhotoPermissionDeniedMessage = QuartzKitStrings.localized("issuesubmissionform.alert.accestophotodisabledgotosetting")
    static let iPadPhotoPermissionDeniedTitle = QuartzKitStrings.localized("issuesubmissionform.alert.accestophotodisabledipad")
    static let iPadPhotoPermissionDeniedMessage = QuartzKitStrings.localized("issuesubmissionform.alert.accestophotodisabledmessageipad")
    static let settingActionTitle = QuartzKitStrings.localized("general.label.settings")
    static let cancelActionTitle = QuartzKitStrings.localized("general.label.cancel")
    
    static let submittingText = QuartzKitStrings.localized("issuesubmissionform.alert.submitting")
}

enum IssueSumissionCellValue{
    case value(String)
}

protocol IssueSumissionCellVMDelgate: AnyObject {
    func playTapped()
    func newRecordingTapped()
    func editRecordingTapped()
    func switchChanged(to: Bool)
    
    func fileAttachmentTapped()
    func removeAttachedFile(at: URL)
    func refreshAfterRemovingError()
}


protocol IssueSumissionCellVM{
    var view: IssueSubmissionTableViewCell? {get set}
    var delegate: IssueSumissionCellVMDelgate? {get set}
    var rowModel: IssueSubmissionRowModel {get}
    var reuseID: String {get}
    var value: IssueSumissionCellValue? {get set}
    func refreshAfterRemovingError()
}

extension IssueSumissionCellVM{
    mutating func setValue(_ value: IssueSumissionCellValue){
        self.value = value
    }
    
    func refreshAfterRemovingError(){
        
    }
}

class EmailAddressVM: IssueSumissionCellVM{
    weak var view: IssueSubmissionTableViewCell? = nil
    weak var delegate: IssueSumissionCellVMDelgate? = nil
    let rowModel = IssueSubmissionRowModel(type: .email, displayName: IssueSubmissionViewStringsProvider.emailDisplayName, placeHolder: IssueSubmissionViewStringsProvider.emailPlaceHolder, isMandatory: true)
    let reuseID: String = IssueSubmissionSingleLineTableViewCell.resuseID
    var value: IssueSumissionCellValue?
    
    init(emailValue: String? = nil) {
        self.view = nil
        self.delegate = nil
        if let email = emailValue{
            self.value = .value(email)
        }
    }
    
    func showEmptyEmailErrorMessage(){
        view?.showEmptyContentErrorMessage(IssueSubmissionViewStringsProvider.emptyEmailErrorMsg)
    }
    
    func refreshAfterRemovingError(){
        delegate?.refreshAfterRemovingError()
    }
}

class VideoVM: IssueSumissionCellVM{
    weak var view: IssueSubmissionTableViewCell? = nil
    weak var delegate: IssueSumissionCellVMDelgate? = nil
    
    private let imageGenerator = ThumbnailGenerator()
    let rowModel = IssueSubmissionRowModel(type: .video, displayName: IssueSubmissionViewStringsProvider.videoDisplayName, placeHolder: "", isMandatory: false)
    let reuseID: String = IssueSubmissionVideoFileTableViewCell.resuseID
    var value: IssueSumissionCellValue?
    var thumbnailImage: UIImage?
    
    func playTapped(){
        delegate?.playTapped()
    }
    
    func editTapped(){
        delegate?.editRecordingTapped()
    }
    
    func newRecordingTapped(){
        delegate?.newRecordingTapped()
    }
}

class TicketVM: IssueSumissionCellVM{
    weak var view: IssueSubmissionTableViewCell? = nil
    weak var delegate: IssueSumissionCellVMDelgate? = nil
    let rowModel = IssueSubmissionRowModel(type: .ticketId, displayName: IssueSubmissionViewStringsProvider.ticketIDDisplayName, placeHolder: IssueSubmissionViewStringsProvider.ticketIDPlaceHolder, isMandatory: true)
    let reuseID: String = IssueSubmissionSingleLineTableViewCell.resuseID
    var value: IssueSumissionCellValue?
    
    func showEmptyTicketErrorMessage(){
        view?.showEmptyContentErrorMessage(IssueSubmissionViewStringsProvider.emptyTicketErrorMsg)
    }
}

class SubjectVM: IssueSumissionCellVM{
    weak var view: IssueSubmissionTableViewCell? = nil
    weak var delegate: IssueSumissionCellVMDelgate? = nil
    let rowModel = IssueSubmissionRowModel(type: .subject, displayName: IssueSubmissionViewStringsProvider.subjectDisplayName, placeHolder: IssueSubmissionViewStringsProvider.subjectPlaceHolder, isMandatory: true)
    let reuseID: String = IssueSubmissionSingleLineTableViewCell.resuseID
    var value: IssueSumissionCellValue?
    
    func showEmptySubjectErrorMessage(){
        view?.showEmptyContentErrorMessage(IssueSubmissionViewStringsProvider.emptySubjectErrorMsg)
    }
    
    func refreshAfterRemovingError(){
        delegate?.refreshAfterRemovingError()
    }
}

class AddToExistingTicketVM: IssueSumissionCellVM{
    weak var view: IssueSubmissionTableViewCell? = nil
    weak var delegate: IssueSumissionCellVMDelgate? = nil
    let rowModel = IssueSubmissionRowModel(type: .addToExistingTicket, displayName: IssueSubmissionViewStringsProvider.addToExisingTicket, placeHolder: "", isMandatory: false)
    let reuseID: String = IssueSubmissionAddingToExistingTicketTableViewCell.resuseID
    var value: IssueSumissionCellValue?
    
    func switchChanged(to value: Bool){
        delegate?.switchChanged(to: value)
    }
    
    
}

class DescriptionVM: IssueSumissionCellVM{
    weak var view: IssueSubmissionTableViewCell? = nil
    weak var delegate: IssueSumissionCellVMDelgate? = nil
    let rowModel = IssueSubmissionRowModel(type: .description, displayName: IssueSubmissionViewStringsProvider.descriptionDisplayName, placeHolder: IssueSubmissionViewStringsProvider.descriptionPlaceHolder , isMandatory: false)
    let reuseID: String = IssueSubmissionSingleLineTableViewCell.resuseID
    var value: IssueSumissionCellValue?
}

class FileAttachmentVM: IssueSumissionCellVM{
    weak var view: IssueSubmissionTableViewCell? = nil
    weak var delegate: IssueSumissionCellVMDelgate? = nil
    let rowModel = IssueSubmissionRowModel(type: .fileAttachment, displayName: IssueSubmissionViewStringsProvider.fileAttachment, placeHolder: "", isMandatory: false)
    let reuseID: String = IssueSubmissionFileAttachementTableViewCell.resuseID
    var value: IssueSumissionCellValue?
    
    func attachFileClicked(){
        delegate?.fileAttachmentTapped()
    }
    
    func removeAttachedFile(at: URL){
        delegate?.removeAttachedFile(at: at)
    }
}

public protocol IssueSubmissionViewModelDelegate: AnyObject{
    func showDataLossAlertAndDismissIfPrompted()
    func newRecordingTapped()
    func dismissIssueSubmissionVC()
}

public enum UploadFailureError: Error{
    case videoUploadFailed
    case annotatedJsonUploadFailed
    case formSubmissingFailed
}

public protocol AnnotationUploadCompletionDelegate: AnyObject{
    func uploadCompleted(withQuartzUrl: String)
    func uploadFailed(with: UploadFailureError)
}


protocol IssueSubmissionViewDelegate: AnyObject{
    func pushAnnotation(annotationVC : UIViewController)
    func cancelTappedinAnnotationVC()
    func doneTappedinAnnotationVC()
    
    func refreshTableView()
    func presentFileAttachmentContoller()
    
    func showEditDetailsFailedAlert()
    func showVideoUploadFailedAlert()
    
    func showSuccessAlert()
    
    func showLoader()
    func hideLoader()
}


public class IssueSubmissionViewModel{
    var cellViewModels: [IssueSumissionCellVM] = []
    var userEmailAddress: String? = nil
    
    enum APIStatus{
        case nothingIsSent
        case videoSent
        case annotatedDetailsSent
    }
    
    private var apiDataStatus: APIStatus = .nothingIsSent
    
    private var formData = IssueSubmissionFormData()
    
    private var attachedFiles: [(String, Data)] = []
    private let thumnailGenerator: VideoThumbnailGenerationProtocol = ThumbnailGenerator()
    
    public weak var delegate: IssueSubmissionViewModelDelegate? = nil
    
    public weak var uploadCompletionDelegate: AnnotationUploadCompletionDelegate? = nil
    weak var view: IssueSubmissionViewDelegate? = nil
    
    private var annotationVC: AnnotatorViewController? = nil
    private var annotatorViewModel: AnnotatorViewModelProtocol? = nil

    private var subjectOrTicketVM: IssueSumissionCellVM? = nil
    private var attachFileVM: IssueSumissionCellVM? = nil
    
    private var ticketVM = TicketVM()
    private var subjectVM = SubjectVM()
    private var emailVM : EmailAddressVM? = nil
    
    public init?(userMailAddress: String? = nil, delgate: IssueSubmissionViewModelDelegate?) {
        self.userEmailAddress = userMailAddress
        self.delegate = delgate
        formData.email = userMailAddress ?? ""
        
        let emailVM = EmailAddressVM.init(emailValue: userMailAddress)
        let videoVM = VideoVM()
        let addToExistingTicket = AddToExistingTicketVM()
        let ticketVM = subjectVM
        subjectVM.delegate = self
        emailVM.delegate = self
        let descriptionVM = DescriptionVM()
        let fileAttachementVM = FileAttachmentVM()

        self.emailVM = emailVM
        self.subjectOrTicketVM = ticketVM
        self.attachFileVM = fileAttachementVM
        
        videoVM.delegate = self
        addToExistingTicket.delegate = self
        fileAttachementVM.delegate = self
        
        cellViewModels.append(emailVM)
        cellViewModels.append(videoVM)
//        cellViewModels.append(addToExistingTicket)
        cellViewModels.append(ticketVM)
        cellViewModels.append(descriptionVM)
        cellViewModels.append(fileAttachementVM)
        
        guard let videoUrlStr = UserDefaults.standard.object(forKey: ScreenRecorder.recordedVideoURLKey) as? String else {return nil}
        let videoURL = URL(fileURLWithPath: videoUrlStr)
        let asset = AVAsset(url: videoURL)
        self.thumnailGenerator.generateThumbnail(for: asset, at: CMTime(seconds: 0.1, preferredTimescale: 50)) {image in
            videoVM.thumbnailImage = image
        }
    }
    
    public init?(delgate: AnnotationUploadCompletionDelegate?) {
        self.uploadCompletionDelegate = delgate
    }
    
    public func update(userMailAddress: String, subject: String, description: String){
        formData.email = userMailAddress
        formData.subject = subject
        formData.description = description
    }
    
    func maxAllowedSize() -> Int{
        3 * 1024 * 1024
    }
    
    func getViewModel(for indexPath: IndexPath) -> IssueSumissionCellVM{
        cellViewModels[indexPath.row]
    }
    
    public func getScreenRecordedVideoThumbnail(at time: CMTime, completion: @escaping (UIImage?) -> Void){
        guard let videoUrlStr = UserDefaults.standard.object(forKey: ScreenRecorder.recordedVideoURLKey) as? String else {
            completion(nil)
            return
        }
        let videoURL = URL(fileURLWithPath: videoUrlStr)
        let asset = AVAsset(url: videoURL)
        
        let snapShotTime = (asset.duration >= time) ? time : CMTime(seconds: 0.1, preferredTimescale: 50)
        self.thumnailGenerator.generateThumbnail(for: asset, at: snapShotTime) {image in
            completion(image)
            return
        }
    }
}



extension IssueSubmissionViewModel: FooterViewModel{
    
    public func submitAnnotatedVideoWithData(){        
        Task {
            await sendDataToServerBasedOnState(isFromCustomUICase: true)
        }
    }
    
    private func sendDataToServerBasedOnState(isFromCustomUICase: Bool = false) async {
        
        switch apiDataStatus{
        case .nothingIsSent:
            guard let videoUrlStr = UserDefaults.standard.object(forKey: ScreenRecorder.recordedVideoURLKey) as? String else {return}
            let videoURL = URL(fileURLWithPath: videoUrlStr)
            let isVideoUploaded = await QuartzDataManager.shared.sendVideo(url: videoURL)
            if !isVideoUploaded{
                DispatchQueue.main.async {
                    if isFromCustomUICase{
                        self.uploadCompletionDelegate?.uploadFailed(with: .videoUploadFailed)
                    }else{
                        self.view?.hideLoader()
                        self.view?.showVideoUploadFailedAlert()
                    }
                }
                return
            }
            apiDataStatus = .videoSent
            await sendDataToServerBasedOnState(isFromCustomUICase: isFromCustomUICase)
            
        case .videoSent:
        
            var annotationDetails: VideoSendEditDetailsInfo
            if let annotatorViewModel = self.annotatorViewModel {
                annotationDetails = annotatorViewModel.getAllAnnotationData()
            }else{
                guard let videoUrlStr = UserDefaults.standard.object(forKey: ScreenRecorder.recordedVideoURLKey) as? String else {return}
                let videoURL = URL(fileURLWithPath: videoUrlStr)
                let asset = AVAsset(url: videoURL)
                let duration = asset.duration
                annotationDetails = VideoSendEditDetailsInfo(isVideoTrimmed: false,
                                                             startTime: CMTime.zero,
                                                             endTime: duration,
                                                             addedShape: [:],
                                                             audios: [])
            }
            
            annotationDetails.isAudioRecorded = false
            if RPScreenRecorder.shared().isAvailable {
                if RPScreenRecorder.shared().isMicrophoneEnabled {
                    annotationDetails.isAudioRecorded = true
                }
            }
            let isEditDetailsUploaded = await QuartzDataManager.shared.sendEditInfo(videoInfo: annotationDetails)
            if !isEditDetailsUploaded{
                DispatchQueue.main.async {
                    if isFromCustomUICase{
                        self.uploadCompletionDelegate?.uploadFailed(with: .annotatedJsonUploadFailed)
                    }else{
                        self.view?.hideLoader()
                        self.view?.showVideoUploadFailedAlert()
                    }
                }
                return
            }
            apiDataStatus = .annotatedDetailsSent
            await sendDataToServerBasedOnState(isFromCustomUICase: isFromCustomUICase)
            
        case .annotatedDetailsSent:
            let videoInfo = getVideoSendEditDetailsInfo()
            let submittedResponse = await QuartzDataManager.shared.submitRecording(recordingInfo: videoInfo)
            if let submittedResponse = submittedResponse{ // Submit is Successful
                DispatchQueue.main.async {
                    QuartzKit.shared.cleanUpVideoAndAudioSavedFiles()
                    if isFromCustomUICase{
                        self.uploadCompletionDelegate?.uploadCompleted(withQuartzUrl: submittedResponse.feedbackLink)
                    }else{
                        self.view?.hideLoader()
                        self.view?.showSuccessAlert()
                    }
                }
            }else{ // Submit Failed
                DispatchQueue.main.async {
                    if isFromCustomUICase{
                        self.uploadCompletionDelegate?.uploadFailed(with: .formSubmissingFailed)
                    }else{
                        self.view?.hideLoader()
                        self.view?.showVideoUploadFailedAlert()
                    }
                }
            }
        }
    }
    
    private func getVideoSendEditDetailsInfo() -> SubmitRecordingDetail{
        let deviceName = UIDevice.current.name
        let os = UIDevice.current.systemName
        let osVersion = UIDevice.current.systemVersion
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let width = Int(UIScreen.main.bounds.size.width)
        let height = Int(UIScreen.main.bounds.size.height)
        
        let files = formData.files.map { (path, fileData) in
            let fileName = path.components(separatedBy: "/").last ?? ""
            return (fileName, fileData)
        }
        let videoInfo = SubmitRecordingDetail(deviceName: deviceName,
                                              os: os,
                                              osVersion: osVersion,
                                              appVersion: appVersion,
                                              deviceWidth: width,
                                              deviceHeight: height,
                                              subject: formData.subject,
                                              description: formData.description,
                                              email: formData.email,
                                              networkSpeed: "",
                                              ticketNumber: formData.ticket,
                                              files: files)
        return videoInfo
    }
    
    func submitPressed() {
        view?.showLoader()
    
        for cellVm in cellViewModels{
            if let cellVm = cellVm as? EmailAddressVM{
                if let val = cellVm.value{
                    switch val{
                    case .value(let enteredString):
                        formData.email = enteredString
                        continue
                    }
                }
            }
            if let cellVm = cellVm as? SubjectVM{
                if let val = cellVm.value{
                    switch val{
                    case .value(let enteredString):
                        formData.subject = enteredString
                        continue
                    }
                }
            }
            if let cellVm = cellVm as? DescriptionVM{
                if let val = cellVm.value{
                    switch val{
                    case .value(let enteredString):
                        formData.description = enteredString
                        continue
                    }
                }
            }
        }
        
        if let val = ticketVM.value{
            switch val{
            case .value(let enteredString):
                formData.ticket = enteredString
            }
        }
        formData.files = attachedFiles
        if formData.addToExistingTicket{
            if formData.ticket.isEmpty{
                // show enter ticket value error
                view?.hideLoader()
                ticketVM.showEmptyTicketErrorMessage()
                view?.refreshTableView()
                return
            }
        }else{
            if formData.email.isEmpty{
                // show enter email value error
                view?.hideLoader()
                emailVM?.showEmptyEmailErrorMessage()
                view?.refreshTableView()
                return
            }
            
            if formData.subject.isEmpty{
                // show enter subject value error
                view?.hideLoader()
                subjectVM.showEmptySubjectErrorMessage()
                view?.refreshTableView()
                return
            }
            
        }
        
        Task {
            await sendDataToServerBasedOnState()
        }
    }
}

extension IssueSubmissionViewModel: IssueSumissionCellVMDelgate{
    func refreshAfterRemovingError() {
        view?.refreshTableView() 
    }
    
    func fileAttachmentTapped() {
        view?.presentFileAttachmentContoller()
    }
    
    private func getAnnotationViewControllerAndViewModel(withNavDelegate navDelegate: NavigationProtocol? = nil) -> (UIViewController, AnnotatorViewModelProtocol) {
        guard let vc = annotationVC, let vm = annotatorViewModel else {
            guard let videoUrlStr = UserDefaults.standard.object(forKey: ScreenRecorder.recordedVideoURLKey) as? String else {
                fatalError("Video URL Not found")
            }
            let videoURL = URL(fileURLWithPath: videoUrlStr)
            let viewModel = AnnotatorViewModel(videoFileUrl: videoURL)
            viewModel.navigationDelegate = navDelegate ?? self
            
            let vc = AnnotatorViewController(viewModel: viewModel)
            vc.hidesBottomBarWhenPushed = true
            
            self.annotatorViewModel = viewModel
            self.annotationVC = vc
            
            return (vc, viewModel)
        }
        return (vc, vm)
    }
    
    func newRecordingTapped() {
        delegate?.newRecordingTapped()
    }
    
    func backButtonTapped() {
        delegate?.showDataLossAlertAndDismissIfPrompted()
    }
    
    func dismissIssueSubmissionVC() {
        delegate?.dismissIssueSubmissionVC()
    }
    
    public func flushOldRecording(){
        self.annotationVC = nil
        self.annotatorViewModel = nil
    }
    
    public func getAnnotationEditingViewController(isVideoPlayBackMode: Bool, withNavDelegate navDelegate: NavigationProtocol?) -> UIViewController{
        let (vc, vm)  = getAnnotationViewControllerAndViewModel(withNavDelegate: navDelegate)
        vm.isVideoPlayBackMode = isVideoPlayBackMode
        return vc
    }
    
    func editRecordingTapped() {
        let (vc, vm)  = getAnnotationViewControllerAndViewModel()
        vm.isVideoPlayBackMode = false
        view?.pushAnnotation(annotationVC: vc)
    }
    
    func playTapped() {
        let (viewController, viewModel) = getAnnotationViewControllerAndViewModel()
        viewModel.isVideoPlayBackMode = true
        view?.pushAnnotation(annotationVC: viewController)
    }
    
    func switchChanged(to value: Bool) {
        guard let subjectOrTicketVM = subjectOrTicketVM else {return}
        guard let view = subjectOrTicketVM.view as? IssueSubmissionSingleLineTableViewCell else {return}
        if value{
            view.vm = ticketVM
        }else{
            view.vm = subjectVM
        }
        formData.addToExistingTicket = value
    }
    
    func showFileSizeExceededMessage(){
        guard let attachFileVM = attachFileVM else {return}
        guard let cell = attachFileVM.view as? IssueSubmissionFileAttachementTableViewCell else {return}
        cell.shouldShowFileSizeExceededLabel = true //Shows error message UI
        view?.refreshTableView() // Refreshes Table view to accomdata extra label
    }
    
    func showFile(at url: URL, data: Data){
        guard let attachFileVM = attachFileVM else {return}
        guard let cell = attachFileVM.view as? IssueSubmissionFileAttachementTableViewCell else {return}
        cell.shouldShowFileSizeExceededLabel = false //Shows error message UI
        
        let byteCount = data.count
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useKB]
        bcf.countStyle = .file
        let sizeStr = bcf.string(fromByteCount: Int64(byteCount))
    
        cell.showFile(at: url, withSize: sizeStr)
        attachedFiles.append((url.absoluteString, data))
        if attachedFiles.count == 5{
            cell.hideAttachFileButton()
        }
        
        view?.refreshTableView() // Refreshes Table view to accomdata extra label
    }
    
    func removeAttachedFile(at url: URL){
        guard let attachFileVM = attachFileVM else {return}
        guard let cell = attachFileVM.view as? IssueSubmissionFileAttachementTableViewCell else {return}
        cell.shouldShowFileSizeExceededLabel = false //Shows error message UI

        let removedFileUrlAbsStr = url.absoluteString
        let indexToRemove = attachedFiles.firstIndex { (absStr,_) in
            absStr == removedFileUrlAbsStr
        }
        if let indexToRemove = indexToRemove{
            attachedFiles.remove(at: indexToRemove)
        }
        
        if attachedFiles.count < 5{
            cell.showAttachFileButton()
        }
        
        view?.refreshTableView() // Refreshes Table view to accomdata extra label
    }
    
}


extension IssueSubmissionViewModel: NavigationProtocol{
    public func doneAction() {
        view?.doneTappedinAnnotationVC()
    }
    
    public func cancelAction() {
//        self.annotationVC = nil
//        self.annotatorViewModel = nil
        view?.cancelTappedinAnnotationVC()
    }
}


public class IssueSubmissionViewController: UITableViewController, UINavigationControllerDelegate{
    
    let viewModel: IssueSubmissionViewModel
    private var previousInterfaceStyle: UIUserInterfaceStyle?

    
    public init(viewModel: IssueSubmissionViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.view = self
    }
    
    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.isUserInteractionEnabled = true
        return loadingView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        hideKeyboard()
        configureNavigationBarUI()
        configureApplicationTerminationNotification()
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
    
    private func configure(){
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        title = IssueSubmissionViewStringsProvider.issueSubmissionVCNavTitle
        let footer = IssueSubmissionTableFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 70))
        footer.configure(viewModel: viewModel)
        tableView.tableFooterView = footer
        
        self.tableView.register(IssueSubmissionSingleLineTableViewCell.self, forCellReuseIdentifier: IssueSubmissionSingleLineTableViewCell.resuseID)
        self.tableView.register(IssueSubmissionVideoFileTableViewCell.self, forCellReuseIdentifier: IssueSubmissionVideoFileTableViewCell.resuseID)
        self.tableView.register(IssueSubmissionDescriptionTableViewCell.self, forCellReuseIdentifier: IssueSubmissionDescriptionTableViewCell.resuseID)
        self.tableView.register(IssueSubmissionAddingToExistingTicketTableViewCell.self, forCellReuseIdentifier: IssueSubmissionAddingToExistingTicketTableViewCell.resuseID)
        self.tableView.register(IssueSubmissionFileAttachementTableViewCell.self, forCellReuseIdentifier: IssueSubmissionFileAttachementTableViewCell.resuseID)
    }
    
    private func configureNavigationBarUI(){
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: IssueSubmissionViewStringsProvider.navBarLeftCancelButtonTitle, style: .done, target: self, action: #selector(backPressed))
        navigationItem.leftBarButtonItem?.tintColor = QuartzKit.shared.primaryColor
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = IssueRecordingViewColors.issueSubmissionNavBarBg
            appearance.titleTextAttributes = [.foregroundColor: IssueRecordingViewColors.issueSubmissionNavBarTextColor]
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
            navigationItem.compactAppearance = appearance // For iPhone small navigation bar in landscape.
        }
    }
    
    @objc func backPressed() {
        viewModel.backButtonTapped()
    }
    
    func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func configureApplicationTerminationNotification(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(applicationWillTerminate(notification:)),
            name: UIApplication.willTerminateNotification,
            object: nil)
    }
    
    
    @objc func applicationWillTerminate(notification: Notification) {
        QuartzKit.shared.cleanUpVideoAndAudioSavedFiles()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
        QuartzKit.shared.cleanUpVideoAndAudioSavedFiles()
    }
    
    private lazy var imagePicker : UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .pageSheet
        return picker
    }()
}

extension IssueSubmissionViewController: UIDocumentPickerDelegate {

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        let isAccessing = selectedFileURL.startAccessingSecurityScopedResource()

        if let data = try? Data.init(contentsOf: selectedFileURL) {
            if data.count > viewModel.maxAllowedSize() {
                viewModel.showFileSizeExceededMessage()
            }else{
                viewModel.showFile(at: selectedFileURL, data: data)
            }
        }else{
            let action = UIAlertAction.init(title: IssueSubmissionViewStringsProvider.done, style: .default, handler: nil)
            showAlert(message: IssueSubmissionViewStringsProvider.errorOccurred, actions: action)
        }
        
        if isAccessing {
            selectedFileURL.stopAccessingSecurityScopedResource()
        }
    }
    private func showAlert(title: String? = nil, message: String, actions: UIAlertAction...){
        let alertController = UIAlertController(title: title, message: message , preferredStyle: .alert)
        actions.forEach { action in
            alertController.addAction(action)
        }
        self.present(alertController, animated: true)
    }

}

extension IssueSubmissionViewController: IssueSubmissionViewDelegate{
    
    func showLoader(){
        let parentView: UIView
        if let window = UIApplication.shared.windows.first{
            parentView = window
        }else{
            parentView = self.view
        }
        parentView.addSubview(loadingView)
        parentView.bringSubviewsToFront(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: parentView.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ])
        loadingView.startLoading()
    }
    
    func hideLoader(){
        loadingView.removeFromSuperview()
    }
    
    func showSuccessAlert(){
        let action = UIAlertAction.init(title: IssueSubmissionViewStringsProvider.ok, style: .default) { _ in
            self.viewModel.dismissIssueSubmissionVC()
        }
        showAlert(title: IssueSubmissionViewStringsProvider.successMessageTitle, message: IssueSubmissionViewStringsProvider.successMessageBody, actions: action)
    }
    
    func showVideoUploadFailedAlert(){
        let action = UIAlertAction.init(title: IssueSubmissionViewStringsProvider.done, style: .default, handler: nil)
        showAlert(message: IssueSubmissionViewStringsProvider.videoUploadFailed, actions: action)
    }
    
    func showEditDetailsFailedAlert(){
        let action = UIAlertAction.init(title: IssueSubmissionViewStringsProvider.done, style: .default, handler: nil)
        showAlert(message: IssueSubmissionViewStringsProvider.editDetailsUploadFailed, actions: action)
    }
    
    func refreshTableView() {
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func presentFileAttachmentContoller(){
        let typeOfFileChoosingActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: iPad ? .alert: .actionSheet)
        let chosePhotoAction = UIAlertAction(title: IssueSubmissionViewStringsProvider.choosePhotos , style: .default){_ in
            self.choosePhotos()
        }
        let choseFilesAction = UIAlertAction(title: IssueSubmissionViewStringsProvider.chooseFiles, style: .default){_ in
            self.chooseFiles()
        }
        
        let cancelAction = UIAlertAction(title: IssueSubmissionViewStringsProvider.cancel, style: .cancel)
        
        typeOfFileChoosingActionSheet.addAction(chosePhotoAction)
        typeOfFileChoosingActionSheet.addAction(choseFilesAction)
        typeOfFileChoosingActionSheet.addAction(cancelAction)
        present(typeOfFileChoosingActionSheet, animated: true)
    }
    
    private func choosePhotos(){
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            presentImagePicker()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.presentImagePicker()
                    } else {
                        self.showDeniedAlert()
                    }
                }
            }
        case .restricted:
            showDeniedAlert()
        case .denied:
            showDeniedAlert()
        default:
            self.presentImagePicker()
        }
    }
    
    private func presentImagePicker(){
        if let popOverController = imagePicker.popoverPresentationController {
            popOverController.sourceRect = CGRect(x: (self.view.bounds.midX) , y: (self.view.bounds.midY), width: 0, height: 0)
            popOverController.sourceView = self.view
        }
        present(imagePicker, animated: true)
    }
    
    private func showDeniedAlert(){
        let iPhoneMessage = IssueSubmissionViewStringsProvider.iPhonePhotoPermissionDeniedMessage
        let iPadTitle = IssueSubmissionViewStringsProvider.iPadPhotoPermissionDeniedTitle
        let iPadMessage = IssueSubmissionViewStringsProvider.iPadPhotoPermissionDeniedMessage
        
        let settingsAction = UIAlertAction(title: IssueSubmissionViewStringsProvider.settingActionTitle, style: .default){_ in
            openApplicationSetting()
        }
        let cancelAction = UIAlertAction(title: IssueSubmissionViewStringsProvider.cancelActionTitle, style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title:  iPad ? iPadTitle: nil, message: iPad ? iPadMessage: iPhoneMessage , preferredStyle: iPad ? .alert: .actionSheet)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    private func chooseFiles(){
        if #available(iOS 14.0, *) {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .image, .text])
            documentPicker.delegate = self
            present(documentPicker, animated: true, completion: nil)
        }
        else {
            // Fallback on earlier versions
        }
    }
    
    func pushAnnotation(annotationVC: UIViewController) {
        self.navigationController?.pushViewController(annotationVC, animated: true)
    }
    
    func cancelTappedinAnnotationVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func doneTappedinAnnotationVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension IssueSubmissionViewController{
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = viewModel.getViewModel(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: vm.reuseID, for: indexPath) as! IssueSubmissionTableViewCell
        cell.configure(withModel: vm)
        return cell
    }
}

extension IssueSubmissionViewController : UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        var image : UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = originalImage
        }
        if let image = image, let compressedImageData = image.compress(sizeLimit: viewModel.maxAllowedSize()) {
            if compressedImageData.count > viewModel.maxAllowedSize() {
                viewModel.showFileSizeExceededMessage()
                return
            }else{
                if let imgURL = info[UIImagePickerController.InfoKey.imageURL] as? URL{
                    viewModel.showFile(at: imgURL, data: compressedImageData)
                    return
                }
            }
        }
        let action = UIAlertAction.init(title: IssueSubmissionViewStringsProvider.done, style: .default, handler: nil)
        showAlert(message: IssueSubmissionViewStringsProvider.errorOccurred, actions: action)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}



struct IssueSubmissionFormData{
    var email: String = ""
    var subject: String = ""
    var ticket: String = ""
    var addToExistingTicket: Bool = false
    var description: String = ""
    var files: [(String, Data)] = []
}


extension UIImage{
    func compress(sizeLimit: Int) -> Data? {
        let image = self
        var compression : CGFloat = 1
        let minCompression : CGFloat = 0.1
        
        if var imageData = image.jpegData(compressionQuality: compression) {
            while imageData.count > sizeLimit && compression >= minCompression {
                compression = compression - 0.1
                if let data = image.jpegData(compressionQuality: compression) {
                    imageData = data
                }
            }
            if imageData.count > sizeLimit {
                return nil
            }
            return imageData
        }
        return nil
    }
}
