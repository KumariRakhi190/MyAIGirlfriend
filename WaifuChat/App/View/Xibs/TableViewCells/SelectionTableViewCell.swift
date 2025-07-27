//
//  SelectionTableViewCell.swift
//  AIGirlFriend
//
//  Created by Rakhi on 20/07/23.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var optionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
