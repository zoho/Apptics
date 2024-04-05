//
//  ScreenShotView.swift
//  MyFramework
//
//  Created by jai-13322 on 25/07/22.
//

import UIKit
import AppticsFeedbackKit

@available(iOS 11.0, *)
public class ScreenShotView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var doneBttn:UIButton!
    @IBOutlet weak var hideBttn: UIButton!
    @IBOutlet weak var deleteBttn:UIButton!
    @IBOutlet weak var pageNumberLabel:UILabel!
    @IBOutlet weak var screenshotCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var cardView:CardViews!
    var floatingscrollController: FloatScreenshotEditor?
    @IBOutlet weak var clobttnTopConst:NSLayoutConstraint!
    @IBOutlet weak var doneBttnTopConst:NSLayoutConstraint!
    let DEVICE_SIZE = UIApplication.shared.keyWindow?.rootViewController?.view.convert(UIScreen.main.bounds, from: nil).size
    @IBOutlet weak var noDataBttn:UIButton!
    var fileArray = [URL]()
    var filesCount = 0
    var fileindexpath = IndexPath()
    var filesIndexvalue = 0
    var mainView = UIView()
    let cellwidth = (3 / 4) * UIScreen.main.bounds.width
    let spacing = (1 / 8) * UIScreen.main.bounds.width
    let cellspacing = (1 / 16) * UIScreen.main.bounds.width
    let cellheight =  UIScreen.main.bounds.width * 1.40

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
        
    func commoninit(color:UIColor,frame:CGRect){
        mainView = bundles.loadNibNamed("ScreenShotView", owner: self, options: nil)! [0] as! UIView
        mainView.frame = frame
        mainView.backgroundColor = color
        addSubview(mainView)
        setBlurTheme()
        setFontForButton(button: deleteBttn, fontName: appticsFontName, title: FontIconText.deleteIcon, size: appFontsize)
        if UIDevice.current.userInterfaceIdiom == .phone {
            appFontsize = 30.0
        }
        else{
            appFontsize = 40.0
        }
        collectionViewSetup()
        getallImages()
        fileindexpath = [0,0]
        noDataBttn.isHidden = true
        deleteBttn.isHidden = false
        deleteBttn.addTarget(self, action:#selector(self.deletebuttonClicked), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(self.screenshotsLoad), name:Notification.Name(notificationScreenreloadKey) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.imageReloadreportBug), name:Notification.Name(notificationImageReloadfromReportBug) , object: nil)
        self.pageNumberLabel.text = "\(1)/\(self.fileArray.count)"
        if DEVICE_SIZE!.height < 670{
            clobttnTopConst.constant = 20
            doneBttnTopConst.constant = 20
        }
                
    }
    
    
//MARK: blur theme for view
    
    func setBlurTheme(){
        if FeedbackTheme.sharedInstance.setTransparencySettingsEnabled  == false{
            mainView.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.mainView.bounds
            mainView.addSubview(blurEffectView)
            mainView.sendSubviewToBack(blurEffectView)
            blurEffectView.layer.cornerRadius = 10
            blurEffectView.layer.masksToBounds = true
            blurEffectView.layer.borderWidth = 2
            blurEffectView.layer.borderColor = UIColor.clear.cgColor
        } else {
            mainView.backgroundColor = FeedbackTheme.sharedInstance.ViewColor
        }
    }
    
//MARK: observer for screenshots & index load
        
    @objc  func imageReloadreportBug(_ notification: Notification) {
        guard let indexRow = notification.userInfo?["indexValue"] as? Int else { return }
        getallImages(index: indexRow)
    }
    
//MARK: observer for screenshots & index load
    
    @objc func screenshotsLoad() {
        getallImages(index:FeedbackTheme.sharedInstance.index_Value)
        let indexPath = IndexPath(item: self.filesIndexvalue, section: 0)
        guard let cell = self.screenshotCollectionView.cellForItem(at: indexPath) as? ScreenshotViewerCollectionViewCell else {
            return
        }
        if TargetDevice.currentDevice == .iPhone {
            self.setHideandShowBttns(status: true)
            cell.transform = cell.transform.scaledBy(x:1.15, y: 1.15)
            UIView.animate(withDuration: 0.20) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.010) {
                    UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseInOut],animations: {
                            cell.transform = .identity
                        }, completion: { success in
                        })
                    }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.setHideandShowBttns(status: false)
                self.deleteBttn.layer.add(FadeInAdnimation(), forKey: "fadeIn")
                self.pageView.layer.add(FadeInAdnimation(), forKey: "fadeIn")
                self.pageNumberLabel.layer.add(FadeInAdnimation(), forKey: "fadeIn")
                self.doneBttn.layer.add(FadeInAdnimation(), forKey: "fadeIn")
                self.hideBttn.layer.add(FadeInAdnimation(), forKey: "fadeIn")
            }
        }
    }

    
//MARK: show and hide button status
    func setHideandShowBttns(status:Bool){
        self.deleteBttn.isHidden = status
        self.pageView.isHidden = status
        self.pageNumberLabel.isHidden = status
        self.doneBttn.isHidden = status
        self.hideBttn.isHidden = status
    }
    
//MARK: collection view nib setup
    
    func collectionViewSetup(){
        let nib=UINib(nibName: "ScreenshotViewerCollectionViewCell", bundle: bundles)
        screenshotCollectionView?.register(nib, forCellWithReuseIdentifier: "cell")
        screenshotCollectionView.delegate = self
        screenshotCollectionView.dataSource = self
        screenshotCollectionView.isPagingEnabled = false
        pageView.isUserInteractionEnabled = false
        layoutCells()
    }
//MARK: collectionViewLayout setting

    func layoutCells() {
        let layout = PaginginationCVLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: self.spacing, bottom: 0, right: self.spacing)
        layout.minimumLineSpacing = 10
        if TargetDevice.currentDevice == .iPhone {
            layout.itemSize = .init(width: cellwidth, height: cellheight)
        }
        else{
            layout.itemSize = .init(width: cellwidth, height: UIScreen.main.bounds.width * 1.1)
        }
        layout.scrollDirection = .horizontal
        screenshotCollectionView!.collectionViewLayout = layout
        
    }
    
//MARK: Delete Button action
    @objc func deletebuttonClicked(_ sender: UIButton) {
        if fileArray.isEmpty == false{
            let visibleRect = CGRect(origin: screenshotCollectionView.contentOffset, size: screenshotCollectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            let visibleIndexPath = screenshotCollectionView.indexPathForItem(at: visiblePoint)
            let filename = fileArray[visibleIndexPath!.row]
            fileArray.remove(at: visibleIndexPath!.row)
            pageView.numberOfPages = fileArray.count
            if filesIndexvalue == 1{
                pageView.currentPage = 0
            }
            else{
                pageView.currentPage = visibleIndexPath!.row - 1
            }
            do{
                try FileManager.default.removeItem(atPath: filename.path)
            }
            catch{}
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                let indexPath = IndexPath(item: visibleIndexPath!.row, section: 0)
                guard let cell = self.screenshotCollectionView.cellForItem(at: indexPath) else {
                    return
                }
                let animation = CAKeyframeAnimation(keyPath: "transform.scale")
                animation.values = [0.80,0.40,0.15]
                animation.duration = 0.5
                animation.repeatCount = 0
                cell.layer.add(animation, forKey: nil)
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseOut,.curveEaseInOut], animations: {
                    self.screenshotCollectionView.deleteItems(at: [indexPath])
                }, completion: { success in
                })
            }
            
            pageView.currentPage = filesIndexvalue
            self.pageNumberLabel.text = "\(filesIndexvalue + 1)/\(self.fileArray.count)"
        }
        if fileArray.count == 0{
            noDataBttn.isHidden = false
            self.pageNumberLabel.text = ""
            self.deleteBttn.isHidden = true
        }
    }
    
    //MARK: get visibile index
    func getpageIndex() ->CGPoint {
        var visibleRect = CGRect()
        visibleRect.origin = screenshotCollectionView.contentOffset
        visibleRect.size = screenshotCollectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return visiblePoint
    }
    
    
//MARK: scroll delegates
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = getpageIndex()
        guard let indexPath = screenshotCollectionView.indexPathForItem(at: point) else { return }
        pageView.currentPage = indexPath.row
        fileindexpath = indexPath
        filesIndexvalue = indexPath.row
        self.pageNumberLabel.text = "\(indexPath.row + 1)/\(self.fileArray.count)"
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let point = getpageIndex()
        guard let indexPath = screenshotCollectionView.indexPathForItem(at: point) else { return }
        fileindexpath = indexPath
        filesIndexvalue = indexPath.row
    }
    
    //MARK: get all images from cache folder
    public func getallImages(index:Int = 0){
        fileArray.removeAll()
        let docsDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.path
        let dirEnum = FileManager.default.enumerator(atPath: docsDir)
        while let file = dirEnum?.nextObject() as? String {
            if file.hasPrefix("Appticssdk") == true{
                let fileUrl = URL(fileURLWithPath: docsDir.appending("/\(file)"))
                filesCount = (filesCount + 1)
                fileArray.append(fileUrl)
            }
        }
        pageView.numberOfPages = fileArray.count
        pageView.currentPage = index
        screenshotCollectionView.reloadData()
        scrollToIndex(index: index)
    }
    
    
    //MARK: collectionview delegates & datasource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = screenshotCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ScreenshotViewerCollectionViewCell
        let image = UIImage(contentsOfFile: fileArray[indexPath.row].path)
        DispatchQueue.main.async {
            cell.imageview.image = image
        }
        deleteBttn.tag = indexPath.row
        cell.imageview.clipsToBounds = false
        cell.backgroundColor = .clear
        cell.imageview.backgroundColor = .clear
        if TargetDevice.currentDevice == .iPhone {
            cell.imageview.contentMode = .scaleAspectFit
        }
        else{
            cell.imageview.contentMode = .scaleToFill
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        FeedbackTheme.sharedInstance.imageLocation = fileArray[indexPath.row]
        FeedbackTheme.sharedInstance.index_Value = indexPath.row
        FeedbackTheme.sharedInstance.isfromClass = ""
        floatingscrollController = FloatScreenshotEditor()
    }
//MARK: scroll to mentioned index
    
    func scrollToIndex(index:Int) {
        screenshotCollectionView.layoutIfNeeded()
        screenshotCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(notificationScreenreloadKey), object: nil)
        
    }
    
    
    
}








