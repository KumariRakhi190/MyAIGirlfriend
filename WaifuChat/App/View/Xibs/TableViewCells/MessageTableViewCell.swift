//
//  MessageTableViewCell.swift
//  AIGirlFriend
//
//  Created by Rakhi on 21/07/23.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var messageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var messageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var messageViewCenterHorizontallyConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var cellType: MessageRoleType?{
        didSet{
            setupCellType()
        }
    }
    
    var photoGenerationType: PhotoGenerationType?
    
    var messageType: MessageType?{
        didSet{
            setupMessageType()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupMessageType(){
        switch messageType {
            case .image:
                messageImageView.isHidden = false
                messageLabel.text?.removeAll()
                activityIndicator.startAnimating()
            case .text:
                messageImageView.isHidden = true
                activityIndicator.stopAnimating()
            default: break
        }
    }
    
    func setupCellType() {
        // First deactivate all constraints to reset
        messageViewLeadingConstraint.isActive = false
        messageViewTrailingConstraint.isActive = false
        messageViewCenterHorizontallyConstraint.isActive = false

        switch cellType ?? .me {
        case .me:
            // Align to right side
            messageViewTrailingConstraint.isActive = true
            messageView.backgroundColor = UIColor(named: "myMessage")
            messageLabel.textColor = .black
            messageView.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], radius: 20)

        case .other:
            // Align to left side
            messageViewLeadingConstraint.isActive = true
            messageView.backgroundColor = .black.withAlphaComponent(0.8)
            messageView.backgroundColor = UIColor(named: "systemMessage")
            messageLabel.textColor = .black
            messageView.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: 20)

        case .system:
            // Align to left side (centerHorizontally is misleading, change to leading)
            messageViewLeadingConstraint.isActive = true
            messageView.backgroundColor = UIColor(named: "systemMessage")
            messageLabel.textColor = .black
            messageView.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: 20)
        }
    }
    
}
