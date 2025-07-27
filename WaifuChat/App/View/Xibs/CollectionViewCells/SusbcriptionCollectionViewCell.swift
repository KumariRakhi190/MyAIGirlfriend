//
//  SusbcriptionCollectionViewCell.swift
//  AIGirlFriend
//
//  Created by Rakhi Kumari on 19/07/25.
//

import UIKit

class SusbcriptionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(imageName: String, title: String) {
        imageView.image = UIImage(named: imageName)
        titleLabel.text = title
    }


}
