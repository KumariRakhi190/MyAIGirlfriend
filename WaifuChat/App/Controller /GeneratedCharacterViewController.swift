//
//  GeneratedCharacterViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi on 20/07/23.
//

import UIKit
import StoreKit
import Mixpanel

class GeneratedCharacterViewController: UIViewController {
    
    @IBOutlet weak var regenerateButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageView.roundCorners(corners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 25)
    }
    
    func initialSetup(){
        startAnimating(status: Constants.loadingCharacter)
        characterImageView.image = UIImage(named: "girl1")
//        characterImageView.sd_setImage(with: character?.getProfilePicUrl()) { _, _, _, _ in
            stopAnimating()
            self.buttonsStackView.isHidden = false
            self.messageView.isHidden = false
            PublicAccess.shared.presentReviewRequest()
//        }
        messageLabel.text = Constants.hiMyNameIs(name: character?.name ?? .init())
        let imageAttachment = NSTextAttachment()
        imageAttachment.bounds = CGRect(x: 0, y: -2, width: 17, height: 17)
        imageAttachment.image = .reload
       // let attributedString = NSMutableAttributedString(string: regenerateButton.title(for: .normal) ?? .init())
//        attributedString.append(NSAttributedString(attachment: imageAttachment))
//        regenerateButton.setAttributedTitle(attributedString, for: .normal)
        chatButton.setTitle(Constants.chatWith(name: character?.name ?? .init()), for: .normal)
    }
    
    @IBAction func didTapRegenerate(_ sender: Any) {
        if let imageUrl = character?.imageUrl{
            CoreDataManager.shared.deleteImage(at: imageUrl)
        }
        pop()
        Mixpanel.mainInstance().track(event: "Regenerated character", properties: ["onboarding": CoreDataManager.shared.getCharacters().count == 0])

    }
    
    @IBAction func didTapChat(_ sender: Any) {
        if let nextViewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "ChattingViewController") as? ChattingViewController {
//            nextViewcontroller.character = character
            self.navigationController?.pushViewController(nextViewcontroller, animated: true)
        }
//        Mixpanel.mainInstance().track(event: "New chat", properties: ["onboarding": CoreDataManager.shared.getCharacters().count == 0, "premade character": false])
//
//        CoreDataManager.shared.saveMessage(characterId: character?.id ?? .init(), message: Message(characterId: character?.id, message: ("Your personality is \(Constants.getCharacteristics(character: character!)), ") +  Prompts.gptPromptToEnd, messageType: .text, messageRoleType: .system, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
//        
//        CoreDataManager.shared.saveMessage(characterId: character?.id ?? .init(), message: Message(characterId: character?.id, message: "Hello my name is \(iCloudStorage.shared.name?.capitalized ?? .init()), Who are you?", messageType: .text, messageRoleType: .me, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
//        
//        CoreDataManager.shared.saveMessage(characterId: character?.id ?? .init(), message: Message(characterId: character?.id, message: "I am your girlfriend \(character?.name ?? .init()) created by Waifu Chat.", messageType: .text, messageRoleType: .other, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
//        
//        CoreDataManager.shared.saveMessage(characterId: character?.id ?? .init(), message: Message(characterId: character?.id, message: "What can you do for me?", messageType: .text, messageRoleType: .me, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
//        
//        CoreDataManager.shared.saveMessage(characterId: character?.id ?? .init(), message: Message(characterId: character?.id, message: "You are my boyfriend and I can do everything for making our relationship stronger.", messageType: .text, messageRoleType: .other, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
//        
//        CoreDataManager.shared.saveMessage(characterId: character?.id ?? .init(), message: Message(characterId: character?.id, message: "Hi, my name is \(character?.name ?? .init())", messageType: .text, messageRoleType: .other, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init()))
//        
//        PublicAccess.shared.gotoTabBar(intoChat: true, character: character)
//        CoreDataManager.shared.addCharacter(character: character!)
//        
//        CoreDataManager.shared.addLastMessageToCharacter(withId: character?.id ?? .init(), message: "Hi, my name is \(character?.name ?? .init())")
//        
//        if iCloudStorage.shared.currentUser?.isSubscribed == false{
//            let viewController = getViewController(type: PaywallViewController.self)
//            viewController.character = character
//            viewController.modalPresentationStyle = .fullScreen
//            PublicAccess.shared.topViewController?.present(viewController, animated: true)
//        }
//        
    }
    
}
