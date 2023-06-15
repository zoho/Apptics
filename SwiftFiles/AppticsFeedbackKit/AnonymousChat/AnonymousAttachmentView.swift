//
//  AnonymousAttachmentView.swift
//  AppticsFeedbackKitSwift
//
//  Created by jai-13322 on 16/05/23.
//

import UIKit

class AnonymousAttachmentView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
 
    
    
    @IBOutlet weak var hideBttn:UIButton!
    @IBOutlet weak var attachmentCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    let DEVICE_SIZE = UIApplication.shared.keyWindow?.rootViewController?.view.convert(UIScreen.main.bounds, from: nil).size
    let cellwidth = (3 / 4) * UIScreen.main.bounds.width
    let spacing = (1 / 8) * UIScreen.main.bounds.width
    let cellspacing = (1 / 16) * UIScreen.main.bounds.width
    let cellheight =  UIScreen.main.bounds.width * 1.50

    
    var fileArray = [URL]()
    var filesCount = 0
    var fileindexpath = IndexPath()
    var filesIndexvalue = 0

    

    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func commoninit(){
        let bundles = bundles
        let view = bundles.loadNibNamed("AnonymousAttachmentView", owner: self, options: nil)! [0] as! UIView
        view.frame = self.bounds
        addSubview(view)
        collectionViewSetup()
        getallImages()
    }

    //MARK: collection view nib setup
        
        func collectionViewSetup(){
            let nib=UINib(nibName: "ScreenshotViewerCollectionViewCell", bundle: bundles)
            attachmentCollectionView?.register(nib, forCellWithReuseIdentifier: "cell")
            attachmentCollectionView.delegate = self
            attachmentCollectionView.dataSource = self
            attachmentCollectionView.isPagingEnabled = false
            pageView.isUserInteractionEnabled = false
            layoutCells()
            
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
        attachmentCollectionView.reloadData()
    }
    
    
    
    
    //MARK: collectionViewLayout setting

        func layoutCells() {
            let layout = PaginginationCVLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: self.spacing, bottom: 0, right: self.spacing)
            layout.minimumLineSpacing = 0
            if TargetDevice.currentDevice == .iPhone {
                layout.itemSize = .init(width: cellwidth, height: cellheight)
            }
            else{
                layout.itemSize = .init(width: cellwidth, height: UIScreen.main.bounds.width * 1.1)
            }
            layout.scrollDirection = .horizontal
            attachmentCollectionView!.collectionViewLayout = layout
            
        }
        
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = attachmentCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ScreenshotViewerCollectionViewCell
        let image = UIImage(contentsOfFile: fileArray[indexPath.row].path)
        DispatchQueue.main.async {
            cell.imageview.image = image
        }
        cell.imageview.clipsToBounds = false
        cell.backgroundColor = .clear
        cell.imageview.backgroundColor = .clear
        cell.imageview.contentMode = .scaleAspectFit
        return cell
    }
    
//MARK: scroll delegates
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let point = getpageIndex()
            guard let indexPath = attachmentCollectionView.indexPathForItem(at: point) else { return }
            pageView.currentPage = indexPath.row

        }
    
    //MARK: get visibile index
    func getpageIndex() ->CGPoint {
        var visibleRect = CGRect()
        visibleRect.origin = attachmentCollectionView.contentOffset
        visibleRect.size = attachmentCollectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return visiblePoint
    }
    
    
    
    
}





