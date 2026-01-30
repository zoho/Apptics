//
//  AppticsFeedbackViewController.swift
//  AppticsFeedback
//
//  Created by jai-13322 on 11/01/24.


import Cocoa
import AppticsFeedbackKit

class AppticsFeedbackViewController: NSViewController,NSTextViewDelegate, NSTableViewDelegate,NSTableViewDataSource {
    
    var progressIndicator: NSProgressIndicator!
    var feedback_Types:ZBFeedbackType?
    @IBOutlet weak var mainbox_View: NSBox!
    @IBOutlet weak var subbox_View:NSView!
    @IBOutlet var customtextView:NSTextView!
    @IBOutlet weak var FeedBackType: NSPopUpButton!
    @IBOutlet weak var anonymMailID: NSPopUpButton!
    @IBOutlet weak var attachmentBttn:NSButton!
    @IBOutlet weak var textFieldHeightConstraint: NSLayoutConstraint! // Height constraint of the text field
    @IBOutlet weak var textViewScroller: NSScrollView!
    var attachments: [Attachment] = []
    @IBOutlet weak var endline:NSBox!
    @IBOutlet weak var headerone:NSTextField!
    @IBOutlet weak var headertwo:NSTextField!
    @IBOutlet weak var fromLabel:NSTextField!
    @IBOutlet weak var aboutLabel:NSTextField!

    @IBOutlet weak var systomLogstext:NSTextField!
    @IBOutlet weak var diagnoInfotext:NSTextField!
    @IBOutlet weak var logsBoxView: NSBox!
    @IBOutlet weak var CollectionViewBoxHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var sendButton: NSButton!
    @IBOutlet weak var cancelbutton:NSButton!
    
    var feedbackType:String = ""
    var supportType:String = ""
    var selectedURLs = Set<String>()
    var sendbuttontag:Int = 0
    var attachLog:Bool = true
    var attachDiagnoInfo:Bool = true
    @IBOutlet weak var messageIconButton:RoundedButton!
    var imageArray:NSArray?
    var nsImages = [NSImage]()
    @IBOutlet weak var systemLogsBttn:NSButton!
    @IBOutlet weak var diagnosticInfoBttn:NSButton!
    @IBOutlet weak var systemlogsCheckmarkBttn:NSButton!
    @IBOutlet weak var diagnosticInfoCheckMarkBttn:NSButton!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppticsFeedback_Swift.sharedInstance.pageTitle
        self.view.backgroundColor = NSColor.clear
        customtextView.font = NSFont.systemFont(ofSize: 14)

        self.mainbox_View.backgroundColor = NSColor.init(red: 231/250, green: 231/250, blue: 230/250, alpha: 1.0)
        
        self.subbox_View.backgroundColor = NSColor.init(red: 231/250, green: 231/250, blue: 230/250, alpha: 1.0)
        
        self.customtextView.wantsLayer = true
        self.customtextView.layer?.cornerRadius = 5.0
        self.mainbox_View.layer?.cornerRadius = 15.0
        self.mainbox_View.layer?.borderWidth = 2.0
        self.mainbox_View.layer?.borderColor = NSColor.clear.cgColor
        
        bttnColorChange(buttonname: sendButton, bgColor: NSColor.init(red: 29/250, green: 116/250, blue: 255/250, alpha: 1.0).cgColor, cornerradius: 5.0, button_tintColor: .white)
        
        bttnColorChange(buttonname: cancelbutton, bgColor: NSColor.white.cgColor, cornerradius: 5.0, button_tintColor: NSColor.init(red: 29/250, green: 29/250, blue: 29/250, alpha: 1.0))
        //pass actual identity mail address
        anonymMailID.addItem(withTitle: FeedbackKitMacOS.listener().emailAddress)
        anonymMailID.addItem(withTitle: FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.label.title.anonymous")!)
        FeedBackType.addItem(withTitle: FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.navbar.title.feedback")!)
        FeedBackType.addItem(withTitle: FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.navbar.title.reportbug")!)
        setPlaceholderString(String:             FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.textview.placeholder")!)
        feedbackType = "Feed"
        supportType = FeedbackKitMacOS.listener().emailAddress
        logsButtonhide(systembttnHide: false, diagnsoticBttnHide: false)
        endline.isHidden = true
        fromLabel.stringValue = FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.bug.alert.from")!
        aboutLabel.stringValue = FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.bug.alert.about")!
        sendButton.stringValue = FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.navbar.button.title.send")!
        cancelbutton.stringValue = FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.privacy.consent.cancel")!
        
        diagnoInfotext.stringValue =  FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.accessory.title.diagnosticinfo")!
        systomLogstext.stringValue =  FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.accessory.title.systemlogs")!
        
        headertwo.stringValue = FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.bug.alert.macheader")!
        
        headerone.stringValue = FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.bug.alert.write")!
        
        systemlogsCheckmarkBttn.state = .on
        diagnosticInfoCheckMarkBttn.state = .on
        messageIconButton.cornerRadius = 10.0
        CollectionViewBoxHeightConstant.constant = 0
        if let scrollView = collectionView.enclosingScrollView {
            scrollView.verticalScrollElasticity = .none
            scrollView.horizontalScrollElasticity = .none
            
        }
               
        if #available(macOS 10.11, *) {
            guard let layout = collectionView.collectionViewLayout as? NSCollectionViewFlowLayout else {
                return
            }
            layout.scrollDirection = .horizontal
            layout.itemSize = NSSize(width: 130, height: 100)
            _ = NSCollectionView(frame: .zero)

        }
        
      
        
    
        view.addObserver(self, forKeyPath: "effectiveAppearance", options: [.new, .initial], context: nil)
        
        if #available(macOS 10.14, *) {
            checkTheme()
        }
        
       

    }
    

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "effectiveAppearance" {
            if #available(macOS 10.14, *) {
                checkTheme()
            }
        }
    }
    
    @available(macOS 10.14, *)
    func checkTheme() {
        if view.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {
            print("Theme changed: Dark Mode")
            self.mainbox_View.backgroundColor =  NSColor.init(red: 31/250, green: 31/250, blue: 30/250, alpha: 1.0)
            self.subbox_View.backgroundColor = NSColor.init(red: 31/250, green: 31/250, blue: 30/250, alpha: 1.0)
            messageIconButton.backgroundColor =  NSColor.white

        } else {
            print("Theme changed: Light Mode")
            self.mainbox_View.backgroundColor = NSColor.init(red: 231/250, green: 231/250, blue: 230/250, alpha: 1.0)
            
            self.subbox_View.backgroundColor = NSColor.init(red: 231/250, green: 231/250, blue: 230/250, alpha: 1.0)
        }
    }
    
    
    
    deinit {
        view.removeObserver(self, forKeyPath: "effectiveAppearance")

    }
 

  
    
    
    
    

//MARK: change bttn colors
    
   func bttnColorChange(buttonname:NSButton,bgColor:CGColor,
                     cornerradius:CGFloat,
                     button_tintColor:NSColor){
        buttonname.wantsLayer = true
        buttonname.layer?.backgroundColor = bgColor
        buttonname.layer?.cornerRadius = cornerradius
        if #available(macOS 10.14, *) {
        buttonname.contentTintColor = button_tintColor
        } else {
        }
    }
    
    
    
    
    
    
    func logsButtonhide(systembttnHide:Bool,diagnsoticBttnHide:Bool){
        systemLogsBttn.isHidden = systembttnHide
        diagnosticInfoBttn.isHidden = diagnsoticBttnHide
    }
    
    
    
    //MARK: delegate and datasource
    
    func delegateDatasource(){
        customtextView.delegate = self
        textViewScroller.hasVerticalScroller = true
        textViewScroller.hasHorizontalScroller = true
        textViewScroller.autohidesScrollers = true
    }
    
    
    
    //MARK: NSTextview delegate
    func textDidChange(_ notification: Notification) {
        //updateTextViewHeight()
    }
    
    func updateTextViewHeight() {
        let layoutManager = customtextView.layoutManager!
        let textContainer = customtextView.textContainer!
        layoutManager.ensureLayout(for: textContainer)
        let usedRect = layoutManager.usedRect(for: textContainer)
        if usedRect.height > 150{
            increaseTextViewHeight(by: 230)
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.5
                self.view.layoutSubtreeIfNeeded()
            }
        }
        else{
            increaseTextViewHeight(by: 150)
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.5
                self.view.layoutSubtreeIfNeeded()
            }
        }
    }
    
    //MARK: set height for textview
    func increaseTextViewHeight(by height: CGFloat) {
        textFieldHeightConstraint.constant += height
    }
    
    //MARK: inital placeholder text for Textview
    func setPlaceholderString(String:String){
        let attributes: [NSAttributedString.Key: Any] =
        [.foregroundColor: NSColor.secondaryLabelColor]
        customtextView.setValue(NSAttributedString(string: String, attributes: attributes),forKey: "placeholderAttributedString")
    }
    
    
    
    
    //MARK: add attachments
    @IBAction func attachImageAction(_ sender: NSButton) {
        openDocumentPicker()
    }
    
    
    //MARK: check feedback type
    @IBAction func FeedbackTypeAction(_ sender: NSPopUpButton) {
        print("FeedBackType PopUp:", FeedBackType.titleOfSelectedItem ?? "")
        feedbackType = FeedBackType.titleOfSelectedItem ?? ""

        if FeedBackType.titleOfSelectedItem  == "Report bug"{
            setPlaceholderString(String: FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.bug.textview.placeholder")!)
        }
        else{
            setPlaceholderString(String:             FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.textview.placeholder")!)
        }
        
        
        
    }
    
    
    //MARK: check mail address or anonymous
    
    @IBAction func mailIDSelectAction(_ sender: NSPopUpButton) {
        print("Mail id action:",anonymMailID.titleOfSelectedItem ?? "")
        supportType = anonymMailID.titleOfSelectedItem ?? ""
        if anonymMailID.titleOfSelectedItem == FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.label.title.anonymous")!{
            ShowAlertMessage(message: FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.bug.alert.anonymalert")!, messageTitle: FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.label.title.anonymous")!)
        }
    }
    
    
    //MARK: method to shoe alert
    func ShowAlertMessage(message:String,messageTitle:String) -> Void {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = messageTitle
            alert.informativeText = message
            alert.beginSheetModal(for: self.view.window!) { (response) in
                if self.sendbuttontag == 1{
                 self.closeWindow()
                }
            }
        }
    }
    
    
    
    
    
    func openDocumentPicker() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = true
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["png", "jpeg", "jpg", "HEIC", "JPEG"]
        openPanel.beginSheetModal(for: view.window!) { response in
            if response == .OK {
                var newAttachments: [Attachment] = []
                var newSelectedURLs: Set<String> = []

                let urls = openPanel.urls
                for url in urls {
                    let urlString = url.absoluteString
                    // Check if URL is already present
                    if self.selectedURLs.contains(urlString) {
                        continue
                    }
                    let attachment = Attachment(imageIcon: urlString)
                    newAttachments.append(attachment)
                    newSelectedURLs.insert(urlString)
                    // Check if adding these new attachments would exceed the limit
                    if self.attachments.count + newAttachments.count > 10 {
                        self.alertImageExceeds()
                        return
                    }
                }
                self.attachments.append(contentsOf: newAttachments)
                self.selectedURLs.formUnion(newSelectedURLs)
                self.attachmentBttn.title = FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.attachments.title")! + "(\(self.attachments.count))"
                DispatchQueue.main.async {
                    if #available(macOS 10.11, *) {
                        self.CollectionViewBoxHeightConstant.constant = 100
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    
    
    
//MARK: system logs check for attach log or not
    @IBAction func systemLogsCheckMarkAction(_ sender: NSButton) {
        if systemlogsCheckmarkBttn.state == .on{
            systemLogsBttn.isHidden = false
            attachLog = true
        }
        else{
            systemLogsBttn.isHidden = true
            attachLog = false
        }
        
    }
    
    
    
//MARK: convert url to Image
    func nsImage(from url: URL) -> NSImage? {
        if let data = try? Data(contentsOf: url) {
            return NSImage(data: data)
        }
        return nil
    }
    
    
//MARK: progress indicator for loader
    func loaderView(){
        progressIndicator = NSProgressIndicator()
        progressIndicator.isHidden = false
        progressIndicator.style = .spinning
        progressIndicator.isIndeterminate = true
        if #available(macOS 11.0, *) {
            progressIndicator.controlSize = .large
        }
        progressIndicator.sizeToFit()
        progressIndicator.frame.origin = CGPoint(x: (view.frame.width - progressIndicator.frame.width) / 2, y: (view.frame.height - progressIndicator.frame.height) / 2)
        
        view.addSubview(progressIndicator)
        progressIndicator.startAnimation(nil)
    }
    
    
//MARK: attach diag info or not

    @IBAction func diagnosticInfoCheckMarkAction(_ sender: NSButton) {
                
        if diagnosticInfoCheckMarkBttn.state == .on{
            diagnosticInfoBttn.isHidden = false
            attachDiagnoInfo = true
        }
        else{
            diagnosticInfoBttn.isHidden = true
            attachDiagnoInfo = false
        }
        
    }
    
    //MARK: convert json to string
    func stringify(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
            options = JSONSerialization.WritingOptions.prettyPrinted
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: options)
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                return string
            }
        } catch {
            print(error)
        }
        
        return ""
    }
    //MARK: open diag info in the file view

    @IBAction func openDiagnosticInfo(_ sender:NSButton)
    
    {
        let finalString = stringify(json: FeedbackKitMacOS.listener().feedbackDiagosticInfo.jsonify())
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("DiagnosticInfo.txt")
        do {
            try (finalString as AnyObject).write(to: fileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)
            NSWorkspace.shared.open(fileURL)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
//MARK: open system logs directory
    @IBAction func openSystemLogs(_ sender:NSButton){
        print("logs dir ---> ",APLog.getInstance().logsDirectory)
        openFirstFile(in: APLog.getInstance().logsDirectory)
    }
    
    //MARK: open first file in logs
    func openFirstFile(in directory: String) {
        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(atPath: directory)
            guard !files.isEmpty, let firstFileName = files.first else {
//                ShowAlertMessage(message: "No log file present", messageTitle: "")
                return
            }
            let firstFileURL = URL(fileURLWithPath: directory).appendingPathComponent(firstFileName).relativePath
            let workspace = NSWorkspace.shared
            workspace.openFile(firstFileURL, withApplication: "TextEdit")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    
    //MARK: Alert for image cross more than 10 files
    func alertImageExceeds(){
        let alert = NSAlert()
        alert.messageText = "Maximum limit reached"
        alert.informativeText = "You can attach only up to 10 images."
        alert.beginSheetModal(for: self.view.window!) { (response) in
        }
    }

    
//MARK: delete urls from the attachemnts table
    @objc func checkBoxAction(button: NSButton) {
        
        guard button.tag < attachments.count else {
            return
        }
        let removedAttachment = attachments.remove(at: button.tag)
        if let urlString = removedAttachment.imageIcon {
            selectedURLs.remove(urlString)
        }
        if #available(macOS 10.11, *) {
            self.collectionView.reloadData()
        }
        if attachments.isEmpty {
            self.attachmentBttn.title = FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.attachments.title")!
            DispatchQueue.main.async {
                self.CollectionViewBoxHeightConstant.constant = 0
            }

        } else {
            self.attachmentBttn.title = FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.attachments.title")! + " (\(attachments.count))"
        }
    }
    
    
    
    
    //MARK: Open image file in preview
    
    func openFile(atPath path: String) {
        let workspace = NSWorkspace.shared
        if FileManager.default.fileExists(atPath: path) {
            workspace.openFile(path)
        } else {
            print("File not found at path: \(path)")
        }
        
    }
    
    
    //MARK:  image tap in the cell
    
    @objc func imageTapAction(sender:NSButton){
        
        if let filePath = attachments[sender.tag].imageIcon{
            if let imagelocation = filePath.replacingOccurrences(of: "file://", with: "").removingPercentEncoding{
                openFile(atPath: imagelocation)
            }
        }
        
    }
    
    
    @IBAction func cancelPressed(_ sender:NSButton){
        self.closeWindow()
    }
    
    
//MARK: button send data to server
    @IBAction func sendPressed(_ sender: NSButton){
        
        loaderView()
        for images in attachments{
            if let url = URL(string: images.imageIcon!), let image = nsImage(from: url) {
                nsImages.append(image)
            }
        }
        if feedbackType == "Feed"{
            feedback_Types = .feedbackOnly
        }
        else if feedbackType == "report"{
            feedback_Types = .report
        }
        else{
            feedback_Types = .feedbackOnly
        }

        print("nsImages",nsImages.count)
        print("nsImages",nsImages)
        print("send clicked",self.customtextView.string)
        print("feedbackType",feedbackType)
        print("supportType",supportType)
        print("attachemnts",attachments.count)
        print("feedback macos diagnostic info",FeedbackKitMacOS.listener().diagnoInfo)
        print("feedback macos diagnostic info",FeedbackKitMacOS.listener().feedbackDiagosticInfo.jsonify())
       
        
        if self.customtextView.string == ""{
            customtextView.shake()
            self.closeLoader()
            return
        }
       
        let _tag: NSString = FKCustomHandlerManager.setFeedbackTag() as NSString? ?? ""
        sendbuttontag = 1
        ZABugNetworkManager.shared().sendFeedback(self.customtextView.string,
                                                  withImages: nsImages,
                                                  screenName: "feedback screen",
                                                  email: supportType,
                                                  attachLog: attachLog,
                                                  attachDignoInfo: attachDiagnoInfo,
                                                  actionType: .settings,
                                                  feedbackType: feedback_Types!,
                                                  tag: _tag as String) { status in
            
            self.closeLoader()
            FKCustomHandlerManager.sendFeedbackEndWithSuccess()
            self.ShowAlertMessage(message: FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.success.alert.description")!, messageTitle: "")
            
        } onFailure: { status in
            self.sendbuttontag = 0
            FKCustomHandlerManager.sendFeedbackEndWithFailure()
            self.ShowAlertMessage(message: FeedbackKitMacOS.getLocalizableString(forKey: "zanalytics.feedback.failed.alert.description")!, messageTitle: "")
            self.closeLoader()

        }
        
        
    }
    
    //MARK: close feedback window

    func closeWindow(){
        DispatchQueue.main.async {
            self.dismiss(nil)
        }
    }
    
//MARK: close loader view

    
    func closeLoader(){
        DispatchQueue.main.async {
            self.progressIndicator.stopAnimation(self)
            self.progressIndicator.isHidden = true
        }
    }
    
   
    
    
    
}







extension AppticsFeedbackViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {
 

    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return attachments.count

    }
    
    @available(macOS 10.11, *)
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionCell"), for: indexPath)
        
        let attachment = attachments[indexPath.item]

        guard let collectionViewItem = item as? CollectionCell else { return item }
        
        if let imagepath = attachment.imageIcon {
            print(imagepath)
            if let imagelocation = imagepath.replacingOccurrences(of: "file://", with: "").removingPercentEncoding{
                collectionViewItem.deleteBttn?.tag = indexPath.item
                collectionViewItem.attachmentImage.wantsLayer = true
                collectionViewItem.attachmentImage.layer?.backgroundColor = NSColor.white.cgColor
                collectionViewItem.attachmentImage.layer?.cornerRadius = 10.0
                let image = NSImage(byReferencingFile: imagelocation)
                collectionViewItem.attachmentImage?.image = image
                
                collectionViewItem.deleteBttn?.action = #selector(AppticsFeedbackViewController.checkBoxAction)
                
            }
        }
        collectionViewItem.view.wantsLayer = true
        collectionViewItem.view.layer?.backgroundColor = NSColor.clear.cgColor
        
        return item
    }

    
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        for indexPath in indexPaths {
            let item = indexPath.item
            print("Selected row at: \(item)")
            if let filePath = attachments[item].imageIcon{
                if let imagelocation = filePath.replacingOccurrences(of: "file://", with: "").removingPercentEncoding{
                    openFile(atPath: imagelocation)
                }
            }
        }
    }
}









