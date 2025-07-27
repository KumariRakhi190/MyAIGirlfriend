//
//  UIImageExtension.swift
//  AIGirlFriend
//
//  Created by Rakhi on 20/07/23.
//

import UIKit

extension UIImage{
    static let reload = UIImage(named: "reload")!
    static let retry = UIImage(named: "retry")!
    
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
