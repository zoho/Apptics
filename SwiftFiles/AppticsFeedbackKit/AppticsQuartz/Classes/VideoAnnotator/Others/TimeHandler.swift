//
//  TimeHandler.swift
//  QuatzApp
//
//  Created by Jaffer Sheriff U on 25/10/23.
//

import CoreMedia
import UIKit

protocol TimeHandlerProtocol{
    func getShapeStartAndEndTimeWithInLimit(withCurTime curTime: CMTime, totalDuration: CMTime) -> (CMTime, CMTime)
}

class TimeHandler: TimeHandlerProtocol{
    
    let addedShapeDisplayingDurationTimeFactor: Double = 10 / 100 // shape added for initial duration of 10% of total video time
    
    func getShapeStartAndEndTimeWithInLimit(withCurTime curTime: CMTime, totalDuration: CMTime) -> (CMTime, CMTime) {
        let timeAdditionValue = CMTimeGetSeconds(totalDuration) * addedShapeDisplayingDurationTimeFactor
        let timeToAdd = CMTimeMakeWithSeconds(timeAdditionValue, preferredTimescale: totalDuration.timescale)
        let resultTime = CMTimeAdd(curTime,timeToAdd)
        if resultTime >= totalDuration{
            let startTime = CMTimeSubtract(totalDuration, timeToAdd)
            return (startTime, totalDuration)
        }else{
            return (curTime, resultTime)
        }
    }
}

extension UIView{
    
    func addSubviews(_ views: UIView...){
        views.forEach {addSubview($0)}
    }
    
    func bringSubviewsToFront(_ views: UIView...){
        views.forEach { bringSubviewToFront($0) }
    }
    
    func fillSuperView(with inset: UIEdgeInsets = UIEdgeInsets.zero)
    {
        if let superview = self.superview
        {
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superview.topAnchor, constant: inset.top),
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset.left),
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset.bottom),
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -inset.right)
                ])
        }
    }
    
}

extension UIFont {
    
    func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
        let modifiedDescriptor = descriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        
        if let modifiedDescriptor = modifiedDescriptor {
            return UIFont(descriptor: modifiedDescriptor, size: pointSize)
        }else{
            return UIFont(descriptor: descriptor, size: 0)
        }
    }
    
    func boldItalic() -> UIFont {
        return withTraits(traits: .traitBold, .traitItalic)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}

extension UIImage {
    static func named(_ name: String, bundle: Bundle? = nil) -> UIImage? {
        guard !name.isEmpty else {
            return nil
        }
        #if SWIFT_PACKAGE
                return UIImage(named: name, in: .module, compatibleWith: nil)
        #else
                return UIImage(named: name, in: Bundle(for: TimeHandler.self), compatibleWith: nil)
        #endif
    }
}


extension CMTime {
    var roundedSeconds: TimeInterval {
        return seconds.rounded()
    }
    var hours:  Int { return Int(roundedSeconds / 3600) }
    var minute: Int { return Int(roundedSeconds.truncatingRemainder(dividingBy: 3600) / 60) }
    var second: Int { return Int(roundedSeconds.truncatingRemainder(dividingBy: 60)) }
    var positionalTime: String {
        return hours > 0 ?
            String(format: "%d:%02d:%02d",
                   hours, minute, second) :
            String(format: "%02d:%02d",
                   minute, second)
    }
}
