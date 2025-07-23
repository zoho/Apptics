//
//  ColorPalatteCollectionView.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 03/11/23.
//

import UIKit

class ColorPalatteCollectionView: UICollectionView{
    private let sizeOfCollectionViewCell = CGSize(width: 25, height: 25)
    
    weak var collectionViewDelegate: (UICollectionViewDelegate&UICollectionViewDataSource)?
    
    init(delegate: (UICollectionViewDelegate&UICollectionViewDataSource)){
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        layout.itemSize = sizeOfCollectionViewCell
        self.collectionViewDelegate = delegate
        
        super.init(frame: .zero, collectionViewLayout: layout)
        configure()
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        self.dataSource = collectionViewDelegate
        self.delegate = collectionViewDelegate
        self.backgroundColor = AnnotationEditorViewColors.shapeColorPickerBGColor
        self.layer.cornerRadius = 5

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.25
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 1, height: 1)

        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ToolBarView.colorPalatteCollectionViewCellId)
    }
    
}
