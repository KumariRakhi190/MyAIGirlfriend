//
//  CustomGradientView.swift
//  AIGirlFriend
//
//  Created by Rakhi on 20/07/23.
//


import UIKit

@IBDesignable
class CustomGradientView: UIView {
    
    @IBInspectable var gradientStartColor: UIColor = .white {
        didSet {
            setupGradient()
        }
    }
    
    @IBInspectable var gradientEndColor: UIColor = .black {
        didSet {
            setupGradient()
        }
    }
    
    @IBInspectable var gradientStartPoint: CGPoint = CGPoint(x: 0.5, y: 0.0) {
        didSet {
            setupGradient()
        }
    }
    
    @IBInspectable var gradientEndPoint: CGPoint = CGPoint(x: 0.5, y: 1.0) {
        didSet {
            setupGradient()
        }
    }
    
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
    
    private func setupGradient() {
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        gradientLayer.startPoint = gradientStartPoint
        gradientLayer.endPoint = gradientEndPoint
    }
}
