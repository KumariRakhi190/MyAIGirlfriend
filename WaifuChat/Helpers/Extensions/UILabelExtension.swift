//
//  UILabelExtension.swift
//  AIGirlFriend
//
//  Created by Rakhi on 18/09/23.
//

import Foundation
import UIKit


extension UILabel {
    
    func strikeThrough(_ isStrikeThrough:Bool) {
        if isStrikeThrough {
            if let lblText = self.text {
                let attributeString =  NSMutableAttributedString(string: lblText)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
                self.attributedText = attributeString
            }
        } else {
            if let attributedStringText = self.attributedText {
                let txt = attributedStringText.string
                self.attributedText = nil
                self.text = txt
                return
            }
        }
    }

        func roundCorners(_ radius: CGFloat? = nil) {
            self.layer.cornerRadius = radius ?? self.frame.height / 2
            self.layer.masksToBounds = true
        }
    

}
