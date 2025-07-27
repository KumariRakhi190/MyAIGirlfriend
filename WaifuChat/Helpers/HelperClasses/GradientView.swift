//
//  GradientView.swift
//  AIGirlFriend
//
//  Created by Rakhi on 19/07/23.
//

import UIKit

class GradientView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradient()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupGradient()
    }
    
//    private func setupGradient() {
//        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
//        
//        // Dark theme gradient (black to light dark)
//        gradientLayer.colors = [
//            UIColor.black.cgColor,
//            UIColor.highlight.cgColor
//        ]
//        
//        // Vertical gradient direction
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
//    }
    
    private func setupGradient() {
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }

        // Gradient colors
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.black.cgColor,
//            UIColor.gradientStartColor.cgColor
            UIColor(named: "AccentColor")?.cgColor
             // #781D56
//            UIColor(red: 220/255, green: 80/255, blue: 110/255, alpha: 1).cgColor
//,   // Soft Pink (#FF6384)
//                UIColor(red: 120/255, green: 29/255, blue: 86/255, alpha: 1).cgColor
            
        ]

        // Black from 0 to 55%, highlight from 55% to 100%
        gradientLayer.locations = [0.0, 0.05, 1.0]

        // Vertical gradient
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }


}
