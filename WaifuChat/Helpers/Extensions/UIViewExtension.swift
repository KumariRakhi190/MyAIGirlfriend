//
//  UIViewExtension.swift
//  AIGirlFriend
//
//  Created by Rakhi on 20/07/23.
//

import UIKit

extension UIView {
    func roundCorners(corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    func giveShadowAndRoundCorners(shadowOffset: CGSize , shadowRadius : Int , opacity : Float , shadowColor : UIColor , cornerRadius :
                                   CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        DispatchQueue.main.async {
            self.layer.shadowPath =  UIBezierPath(roundedRect: self.bounds,cornerRadius: self.layer.cornerRadius).cgPath
        }
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = CGFloat(shadowRadius)
        self.layer.shadowOffset = shadowOffset
        self.layer.masksToBounds = false
    }
    
    
}

extension UIView {
    func addBlur(style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}

//extension UIView{
//    
//    func addDefaultShadow(){
//        layer.shadowColor = UIColor.main.cgColor
//        layer.shadowOffset = .zero
//        layer.shadowRadius = 3
//        layer.shadowOpacity = 0.2
//        layer.masksToBounds = false
//    }
//    
//    func animateScaleForever(scale: CGFloat = 1.2, duration: TimeInterval = 0.6) {
//           layer.removeAnimation(forKey: "pulse")
//           let animation = CABasicAnimation(keyPath: "transform.scale")
//           animation.fromValue = 1.0
//           animation.toValue = scale
//           animation.duration = duration
//           animation.autoreverses = true
//           animation.repeatCount = .infinity
//           animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//           layer.add(animation, forKey: "pulse")
//       }
//    
//}
