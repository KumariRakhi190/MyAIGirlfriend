//
//  InterestCollectionViewCell.swift
//  AIGirlFriend
//
//  Created by Rakhi Kumari on 19/07/25.
//

import UIKit

// MARK: - Custom Cell
class InterestCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 20
        mainView.layer.masksToBounds = true
    }

    func setSelected(_ selected: Bool) {
//        mainView.layer.borderWidth = selected ? 2 : 0
//        mainView.layer.borderColor = selected ? UIColor.systemPink.cgColor : UIColor.clear.cgColor
        mainView.layer.backgroundColor = selected ? UIColor.highlight.cgColor : UIColor.darkGray.cgColor
        
    }
}
