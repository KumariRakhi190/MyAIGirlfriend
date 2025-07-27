//
//  GradientBackgroundView.swift
//  AIGirlFriend
//
//  Created by Rakhi Kumari on 17/07/25.
//

import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable var applyFixedGradient: Bool {
        get { return layer.sublayers?.contains(where: { $0 is CAGradientLayer }) ?? false }
        set {
            if newValue {
                addFixedGradient()
            } else {
                removeFixedGradient()
            }
        }
    }
    
    private func addFixedGradient() {
        removeFixedGradient() // Avoid duplicates
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "FixedGradientLayer"
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemPink.cgColor
        ]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5) // Left center
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)   // Right center

        gradientLayer.cornerRadius = layer.cornerRadius
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        // ✅ Update frame when layout changes
        DispatchQueue.main.async {
            self.observeFrameChanges(for: gradientLayer)
        }
    }
    
    private func removeFixedGradient() {
        layer.sublayers?.removeAll(where: { $0.name == "FixedGradientLayer" })
    }
    
    private func observeFrameChanges(for gradientLayer: CAGradientLayer) {
        // Use Auto Layout observer
        self.addObserver(self, forKeyPath: "bounds", options: [.new, .old], context: nil)
        
        // Observe bounds changes
        gradientLayer.frame = self.bounds
    }
    
    // ✅ Observe bounds changes (like layoutSubviews)
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds" {
            layer.sublayers?.filter({ $0.name == "FixedGradientLayer" }).forEach { $0.frame = self.bounds }
        }
    }
}
