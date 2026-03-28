//
//  DefaultShapeAttributesProvider.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 25/10/23.
//

import UIKit

protocol DefaultShapeAttributesProviderProtocol{
    var defaultLineThickness: Int { get }
    var colors: [UIColor] { get }
    var removeImageSystemName: String { get }
    var resizeImageSystemName: String { get }
    var copyImageSystemName: String { get }
    var fontSize: CGFloat { get }
    func getSizeFor(shape: AddedShape) -> CGSize
}

struct DefaultShapeAttributesProvider: DefaultShapeAttributesProviderProtocol{
    var fontSize: CGFloat {
        30
    }
    
    var colors: [UIColor] {
        let c1 = UIColor(red: 255.0/255.0, green: 1.0/255.0, blue: 0.0/255.0, alpha: 1)
        let c2 = UIColor(red: 255.0/255.0, green: 19.0/255.0, blue: 147.0/255.0, alpha: 1)
        let c3 = UIColor(red: 236.0/255.0, green: 151.0/255.0, blue: 55.0/255.0, alpha: 1)
        let c4 = UIColor(red: 244.0/255.0, green: 195.0/255.0, blue: 67.0/255.0, alpha: 1)
        let c5 = UIColor(red: 103.0/255.0, green: 219.0/255.0, blue: 110.0/255.0, alpha: 1)
        let c6 = UIColor(red: 128.0/255.0, green: 44.0/255.0, blue: 204.0/255.0, alpha: 1)
        let c7 = UIColor(red: 130.0/255.0, green: 73.0/255.0, blue: 33.0/255.0, alpha: 1)
        let c8 = UIColor(red: 55.0/255.0, green: 113.0/255.0, blue: 230.0/255.0, alpha: 1)
        let c9 = UIColor.white
        let c10 = UIColor.black
        
        return [c1,c2,c3,c4,c5,c6,c7,c8,c9,c10]
    }
    let defaultLineThickness: Int = 3
    
    let removeImageSystemName = "multiply.circle.fill"
    let resizeImageSystemName = "arrow.up.left.and.arrow.down.right"
    let copyImageSystemName = "doc.on.doc"

    
    func getSizeFor(shape: AddedShape) -> CGSize {
        switch shape.type{
        case .circle:
            return CGSize(width: 100, height: 100)
        case .rectangle:
            return CGSize(width: 100, height: 100)
        case .arrow:
            return CGSize(width: 100, height: 20)
        case .blur:
            return CGSize(width: 100, height: 100)
        case .block:
            return CGSize(width: 100, height: 100)
        case .text:
            return CGSize(width: 29, height: 50)
        }
    }
}

