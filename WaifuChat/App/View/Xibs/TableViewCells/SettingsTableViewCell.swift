//
//  SettingsTableViewCell.swift
//  BirthdayAI
//
//  Created by Geetam Singh on 07/03/25.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        blurView.addDefaultShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configData(data: SettingModel) {
        optionLabel.text = data.title
        optionImageView.image = UIImage(systemName: data.icon)
        usernameLabel.text = iCloudStorage.shared.name
    }
    
}
