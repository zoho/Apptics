//
//  QuartzColorConstants.swift
//  QuartzKit
//
//  Created by Jaffer Sheriff Usman on 14/07/25.
//

import UIKit

extension UIColor {
    static func quartzColor(_ light: UIColor, _ dark: UIColor) -> UIColor {
        return UIColor(dynamicProvider: { return $0.userInterfaceStyle == .dark ? dark : light})
    }
    
    static func color(r: Int,g: Int, b: Int, a: CGFloat = 1) -> UIColor{
        guard r <= 255, r >= 0, g <= 255, g >= 0, b <= 255, b >= 0, a >= 0 , a <= 1 else {
            return UIColor.white
        }
        return UIColor(red: CGFloat(r)/255.0 , green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
    }
    
}

