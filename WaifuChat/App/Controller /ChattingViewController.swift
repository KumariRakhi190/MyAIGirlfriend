//
//  ChattingViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi on 21/07/23.
//

import UIKit
import Mixpanel

class ChattingViewController: UIViewController {
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var writeViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var pictureButton: UIButton!
    
    var allowAnimatedScroll = false
    
    var character: Character?
    
    var showTypingAnimation = false{
        didSet{
            messageTableView.reloadData()
            if messages.count > 0{
                messageTableView.scrollToRow(at: .init(row: messages.count-1, section: 0), at: .bottom, animated: true)
            }
            pictureButton.isUserInteractionEnabled = !showTypingAnimation
            sendButton.isUserInteractionEnabled = !showTypingAnimation
            UIView.animate(withDuration: 0.3) {
                self.pictureButton.alpha = self.showTypingAnimation ? 0.3 : 1
                self.sendButton.alpha = self.showTypingAnimation ? 0.3 : 1
            }
        }
    }
    
    var messages = [Message](){
        didSet{
            messages.removeAll(where: {$0.isSilent})
            messageTableView.reloadData()
            if messages.count > 0{
                DispatchQueue.main.async {
                    self.messageTableView.scrollToRow(at: .init(row: self.messages.count-1, section: 0), at: .bottom, animated: self.allowAnimatedScroll)
                    self.allowAnimatedScroll = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTableView()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DatabaseManager.shared.reloadUser { _ in}
        DatabaseManager.shared.reloadPromptsFromDatabase()
        DatabaseManager.shared.fetchTokens()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomSheetView.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 10, opacity: 0.3, shadowColor: .black, cornerRadius: 25)
        messageView.layer.borderColor = UIColor.white.cgColor
        messageView.layer.borderWidth = 0.5
    }
    
    func initialSetup(){
        nameLabel.font = UIFont(name: "Inter Regular Bold", size: 20)
        messageTextField.delegate = self
        messages = CoreDataManager.shared.getMessages(characterId: character?.id ?? .init())
//        nameLabel.text = character?.name
        characterImageView.sd_setImage(with: character?.getProfilePicUrl())
        KeyboardStateManager.shared.observeKeyboardHeight = { height in
            UIView.animate(withDuration: 0.3) {
                self.writeViewBottomConstraint.constant = height + 20
                self.view.layoutIfNeeded()
                if self.messages.count > 0{
                    self.messageTableView.scrollToRow(at: .init(row: self.messages.count-1, section: 0), at: .bottom, animated: true)
                }
            }
        }
        
    }
    
    func setupTableView(){
        messageTableView.registerCell(type: MessageTableViewCell.self)
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
        
    }
    
    func clearChat(){
        CoreDataManager.shared.clearMessagesFor(characterId: self.character?.id ?? .init())
        if (1...1000 ~= self.character?.id ?? 0){
            CoreDataManager.shared.saveMessage(characterId: self.character?.id ?? .init(), message: Message(characterId: self.character?.id, message: Prompts.gptPromptToEnd, messageType: .text, messageRoleType: .system, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
        }
        else{
            CoreDataManager.shared.saveMessage(characterId: self.character?.id ?? .init(), message: Message(characterId: self.character?.id, message: ("Your personality is \(Constants.getCharacteristics(character: self.character!)), ") +  Prompts.gptPromptToEnd, messageType: .text, messageRoleType: .system, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
        }
        
        CoreDataManager.shared.saveMessage(characterId: self.character?.id ?? .init(), message: Message(characterId: self.character?.id, message: "Hello my name is \(iCloudStorage.shared.name?.capitalized ?? .init()), Who are you?", messageType: .text, messageRoleType: .me, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
        
        CoreDataManager.shared.saveMessage(characterId: self.character?.id ?? .init(), message: Message(characterId: self.character?.id, message: "I am your girlfriend \(self.character?.name ?? .init()) created by Waifu Chat.", messageType: .text, messageRoleType: .other, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
        
        CoreDataManager.shared.saveMessage(characterId: self.character?.id ?? .init(), message: Message(characterId: self.character?.id, message: "What can you do for me?", messageType: .text, messageRoleType: .me, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
        
        CoreDataManager.shared.saveMessage(characterId: self.character?.id ?? .init(), message: Message(characterId: self.character?.id, message: "You are my boyfriend and I can do everything for making our relationship stronger.", messageType: .text, messageRoleType: .other, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
        
        CoreDataManager.shared.saveMessage(characterId: self.character?.id ?? .init(), message: Message(characterId: self.character?.id, message: "Hi, my name is \(self.character?.name ?? .init())", messageType: .text, messageRoleType: .other, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init()))
        
        CoreDataManager.shared.addLastMessageToCharacter(withId: self.character?.id ?? .init(), message: "Hi, my name is \(self.character?.name ?? .init())")
        
        self.messages = CoreDataManager.shared.getMessages(characterId: self.character?.id ?? .init())
        self.messageTableView.reloadData()
    }
    
    @IBAction func didStartTypingMessage(_ sender: UITextField) {
        if let text = sender.text?.trim, !text.isEmpty{
            sendButton.isHidden = false
        }
        else{
            sendButton.isHidden = true
        }
    }
    
    @IBAction func didTapPicture(_ sender: Any) {
        let viewController = getViewController(type: AskForPhotoViewController.self)
        viewController.delegate = self
        viewController.character = character
        showPopup(viewController: viewController)
    }
    
    @IBAction func didTapOptions(_ sender: Any) {
        let viewController = getViewController(type: CharacterProfileViewController.self)
        viewController.character = character
        viewController.renameDelegate = self
        push(viewController: viewController)
        Mixpanel.mainInstance().track(event: "Open Chat Options", properties: ["premade character": !(1...1000 ~= character?.id ?? 0)])
    }
    
    @IBAction func didTapSend(_ sender: Any) {
        
        var allTodayMessages = [Message]()
        for character in CoreDataManager.shared.getCharacters(){
            allTodayMessages.append(contentsOf: CoreDataManager.shared.getMessages(characterId: character.id ?? .init()).filter({Calendar.current.isDate(Date(timeIntervalSince1970: $0.timestamp), inSameDayAs: PublicAccess.shared.currentDateTime ?? .init()) && $0.isSilent == false && $0.messageRoleType == .me}))
        }
        
        if allTodayMessages.count  >= 20 && iCloudStorage.shared.currentUser?.isSubscribed == false{
            return PublicAccess.shared.showAlertForPremium(viewController: self, title: Constants.limitReachedTitle, message: Constants.limitReachedMessage)
        }
        
        let message = Message(message: messageTextField.text, messageType: .text, messageRoleType: .me, imageUrl: nil, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init())
        Mixpanel.mainInstance().track(event: "New message")

        messages.append(message)
        
        if messages.filter({$0.messageRoleType == .me && $0.messageType == .text && $0.isSilent == false}).count.isMultiple(of: 2){
            PublicAccess.shared.presentReviewRequest(withDelay: false)
        }
        
        CoreDataManager.shared.addLastMessageToCharacter(withId: character?.id ?? .init(), message: messages.last?.message ?? .init())
        messageTextField.text?.removeAll()
        sendButton.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.showTypingAnimation = true
        })
        if message.messageType == .text{
            APIManager.shared.sendMessage(characterId: character?.id ?? .init(), message: message) { error, message in
                DispatchQueue.main.async {
                    self.showTypingAnimation = false
                    if let message{
                        self.messages.append(message)
                    }
                    else{
                        let alert = UIAlertController(title: Constants.error, message: error?.message ?? Constants.serverError, preferredStyle: .alert)
                        if error?.code == .contextLengthExceeded || error?.code == .rateLimitExceeded{
                            alert.message = Constants.exceededMessageLimit
                            alert.addAction(.init(title: Constants.restart, style: .default, handler: { _ in
                                self.clearChat()
                            }))
                        }
                        alert.addAction(.init(title: "Dismiss", style: .cancel))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func didTapBack(_ sender: Any) {
//        if navigationController?.viewControllers.first is Self{
            PublicAccess.shared.gotoTabBar()
//        }
//        else{
//            pop()
//        }
    }
    
}

extension ChattingViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10//messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell(type: MessageTableViewCell.self, indexPath: indexPath)
        if indexPath.row == 0 {
            cell.cellType = .other
        } else {
            if indexPath.row % 2 == 0 {
                cell.cellType = .me
            } else {
                cell.cellType = .system
            }
        }
//        let message = messages[indexPath.row]
//        cell.cellType = message.messageRoleType
//        cell.messageLabel.text = message.message
//        cell.messageType = message.messageType
//        cell.messageImageView.image = nil
//        cell.messageImageView.gestureRecognizers?.removeAll()
//        cell.messageImageView.sd_setImage(with: message.getMessageImageUrl(), completed: { image, error, cacheType, url in
//            cell.activityIndicator.stopAnimating()
//            if error != nil{
//                cell.messageImageView.image = .retry
//                cell.messageImageView.tag = indexPath.row
//                cell.messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapRetry)))
//            }
//            else{
//                cell.messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapViewPicture)))
//            }
//        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if showTypingAnimation{
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
            footerView.backgroundColor = .clear
            let typingView = UIImageView(frame: CGRect(x: 20, y: 0, width: 60, height: 30))
            typingView.sd_setImage(with: Bundle.main.url(forResource: "typing", withExtension: ".gif"))
            typingView.layer.borderColor = UIColor.hexStringToUIColor(hex: "#fde1e1").cgColor
            typingView.layer.borderWidth = 5
            typingView.layer.cornerRadius = typingView.bounds.height/2
            typingView.alpha = 0.5
            footerView.addSubview(typingView)
            return footerView
        }
        else{
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if showTypingAnimation{
            return 30
        }
        else{
            return 0
        }
    }
    
    @objc func didTapRetry(_ sender: UITapGestureRecognizer){
        if let row = (sender.view as? UIImageView)?.tag{
            if let photoGenerationType = messages[row].photoGenerationType{
                reGeneratePicture(for: row, photoGenerationType: photoGenerationType)
            }
        }
    }
    
    @objc func didTapViewPicture(_ sender: UITapGestureRecognizer){
        if let image = (sender.view as? UIImageView)?.image{
            let viewController = getViewController(type: ViewPictureViewController.self)
            viewController.character = character
            viewController.image = image
            push(viewController: viewController)
        }
    }
    
}

extension ChattingViewController: AskForPhotoViewControllerDelegate{
    
    func didTapClassicPhoto() {
        
        var allTodayMessages = [Message]()
        for character in CoreDataManager.shared.getCharacters(){
            allTodayMessages.append(contentsOf: CoreDataManager.shared.getMessages(characterId: character.id ?? .init()).filter({Calendar.current.isDate(Date(timeIntervalSince1970: $0.timestamp), inSameDayAs: PublicAccess.shared.currentDateTime ?? .init()) && $0.isSilent == false && $0.photoGenerationType == .classic}))
        }
        
        if allTodayMessages.count >= 2 && iCloudStorage.shared.currentUser?.isSubscribed == false{
            PublicAccess.shared.showAlertForPremium(viewController: self, title: Constants.limitReachedTitle, message: Constants.limitReachedSelfie)
        }
        else{
            generatePicture(photoGenerationType: .classic)
            Mixpanel.mainInstance().track(event: "Request picture", properties: ["type": "casual"])
            
        }
    
    }
    
    func didTapNSFWPhoto() {
        if CoreDataManager.shared.getMessages(characterId: character?.id ?? .init()).filter({Calendar.current.isDate(Date(timeIntervalSince1970: $0.timestamp), inSameDayAs: PublicAccess.shared.currentDateTime ?? .init()) && $0.isSilent == false && $0.photoGenerationType == .nsfw}).count >= 0 && iCloudStorage.shared.currentUser?.isSubscribed == false{
            let viewController = getViewController(type: PaywallViewController.self)
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
        else{
            generatePicture(photoGenerationType: .nsfw)
            Mixpanel.mainInstance().track(event: "Request picture", properties: ["type": "NSFW"])
        }
    }
    
    func generatePicture(photoGenerationType: PhotoGenerationType){
        let message = Message(message: photoGenerationType == .nsfw ? Constants.youAskForNSFWSelfie : Constants.youAskForClassicSelfie, messageType: .text, messageRoleType: .system, imageUrl: nil, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init())
        messages.append(message)
        CoreDataManager.shared.saveMessage(characterId: character?.id ?? .init(), message: message)
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.showTypingAnimation = true
        })
        AIManager.shared.generateCharacter(character: character, photoGenerationType: photoGenerationType) { imageUrl in
            DispatchQueue.main.async {
                self.showTypingAnimation = false
                let message = Message(message: photoGenerationType == .classic ? Constants.classicPhoto : Constants.nsfwPhoto, messageType: .image, messageRoleType: .other, imageUrl: imageUrl, photoGenerationType: photoGenerationType, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init())
                self.messages.append(message)
                CoreDataManager.shared.saveMessage(characterId: self.character?.id ?? .init(), message: message)
                CoreDataManager.shared.addLastMessageToCharacter(withId: self.character?.id ?? .init(), message: self.messages.last?.message ?? .init())
            }
        }
    }
    
    func reGeneratePicture(for row: Int, photoGenerationType: PhotoGenerationType){
        if let cell = messageTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? MessageTableViewCell{
            cell.activityIndicator.startAnimating()
            cell.messageImageView.image = nil
            cell.messageImageView.gestureRecognizers?.removeAll()
            AIManager.shared.generateCharacter(character: character, photoGenerationType: photoGenerationType) { imageUrl in
                DispatchQueue.main.async {
                    cell.messageImageView.sd_setImage(with: imageUrl, completed: { image, error, cacheType, url in
                        cell.activityIndicator.stopAnimating()
                        if error != nil{
                            cell.messageImageView.image = .retry
                            cell.messageImageView.tag = row
                            cell.messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapRetry)))
                        }
                        else{
                            CoreDataManager.shared.updateMessageImageUrl(messageTimestamp: self.messages[row].timestamp, newUrl: imageUrl!)
                            self.messages[row].imageUrl = imageUrl
                            cell.messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapViewPicture)))
                        }
                    })
                }
            }
        }
    }
}

extension ChattingViewController: RenameDelegate{
    func didRename(newName: String) {
        nameLabel.text = newName
    }
}

extension ChattingViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !showTypingAnimation && sendButton.isHidden == false{
            didTapSend(0)
        }
        return true
    }
    
}
