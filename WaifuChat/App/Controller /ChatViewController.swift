//
//  ChatViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi on 24/07/23.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var bannerBottomLabel: UILabel!
    @IBOutlet weak var bannerTopLabel: UILabel!
    @IBOutlet weak var girlImageViewAtBanner: UIImageView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var bannerButton: UIButton!
    @IBOutlet weak var chatTitleLabel: UILabel!
    
    var characters = [Character](){
        didSet{
            chatTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        chatTitleLabel.font = UIFont(name: "Fredoka Light Bold", size: 25)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.characters = CoreDataManager.shared.getCharacters()
        
//        DatabaseManager.shared.reloadUser { error in
//            DispatchQueue.main.async {
//                UIView.animate(withDuration: 0.3) {
//                    self.bannerView.isHidden = iCloudStorage.shared.currentUser?.isSubscribed == true
//                    self.bannerBottomLabel.isHidden = iCloudStorage.shared.currentUser?.isSubscribed == true
//                    self.bannerTopLabel.isHidden = iCloudStorage.shared.currentUser?.isSubscribed == true
//                    self.separatorLabel.isHidden = iCloudStorage.shared.currentUser?.isSubscribed == true
//                }
//            }
//        }
        
//        CoreDataManager.shared.getCharacters().forEach { character in
//            if let hours = Calendar.current.dateComponents([.hour], from: Date(timeIntervalSince1970: CoreDataManager.shared.getMessages(characterId: character.id ?? .init()).first?.timestamp ?? .init()), to: PublicAccess.shared.currentDateTime ?? .init()).hour, hours >= 48 && iCloudStorage.shared.currentUser?.isSubscribed == false{
//                CoreDataManager.shared.clearMessagesFor(characterId: character.id ?? .init())
//                if (1...1000 ~= character.id ?? 0){
//                    CoreDataManager.shared.saveMessage(characterId: character.id ?? .init(), message: Message(characterId: character.id, message: Prompts.gptPromptToEnd, messageType: .text, messageRoleType: .system, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
//                }
//                else{
//                    CoreDataManager.shared.saveMessage(characterId: character.id ?? .init(), message: Message(characterId: character.id, message: ("Your personality is \(Constants.getCharacteristics(character: character)), ") +  Prompts.gptPromptToEnd, messageType: .text, messageRoleType: .system, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
//                }
//                CoreDataManager.shared.saveMessage(characterId: character.id ?? .init(), message: Message(characterId: character.id, message: "Hello my name is \(iCloudStorage.shared.name?.capitalized ?? .init()), Who are you?", messageType: .text, messageRoleType: .me, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
//                
//                CoreDataManager.shared.saveMessage(characterId: character.id ?? .init(), message: Message(characterId: character.id, message: "I am your girlfriend \(character.name ?? .init()) created by Waifu Chat.", messageType: .text, messageRoleType: .other, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
//                
//                CoreDataManager.shared.saveMessage(characterId: character.id ?? .init(), message: Message(characterId: character.id, message: "What can you do for me?", messageType: .text, messageRoleType: .me, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
//                
//                CoreDataManager.shared.saveMessage(characterId: character.id ?? .init(), message: Message(characterId: character.id, message: "You are my boyfriend and I can do everything for making our relationship stronger.", messageType: .text, messageRoleType: .other, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
//                
//                CoreDataManager.shared.saveMessage(characterId: character.id ?? .init(), message: Message(characterId: character.id, message: "Hi, my name is \(character.name ?? .init())", messageType: .text, messageRoleType: .other, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init()))
//                
//                CoreDataManager.shared.addLastMessageToCharacter(withId: character.id ?? .init(), message: "Hi, my name is \(character.name ?? .init())")
//            }
//        }
    }
    
    func setupTableView(){
        chatTableView.registerCell(type: ChatTableViewCell.self)
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    @IBAction func didTapPaywall(_ sender: Any) {
        let viewController = getViewController(type: PaywallViewController.self)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10//characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell(type: ChatTableViewCell.self, indexPath: indexPath)
//        let character = characters[indexPath.row]
//        cell.nameLabel.text = character.name
//        cell.messageLabel.text = character.lastMessage
//        cell.characterImageView.sd_setImage(with: character.getProfilePicUrl())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = getViewController(type: ChattingViewController.self)
//        viewController.character = characters[indexPath.row]
        push(viewController: viewController)
    }
    
    
}
