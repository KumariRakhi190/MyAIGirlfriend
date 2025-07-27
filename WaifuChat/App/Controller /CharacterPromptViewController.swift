//
//  CharacterPromptViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi on 19/07/23.
//

import UIKit
import Mixpanel

class CharacterPromptViewController: UIViewController {
    
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    
    var isOnboarding = true
    
    var characters: [Character]?{
        didSet{
            characters?.insert(.init(), at: 0)
            charactersCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimating()
        DatabaseManager.shared.reloadPromptsFromDatabase()
        DatabaseManager.shared.fetchTokens()
        DatabaseManager.shared.getCharacters { characters in
            self.characters = characters
        }
    }
    
    func setupCollectionView(){
        charactersCollectionView.registerCell(type: CharacterCollectionViewCell.self)
        charactersCollectionView.registerCell(type: CreateCustomGirlfriendCollectionViewCell.self)
        charactersCollectionView.delegate = self
        charactersCollectionView.dataSource = self
        charactersCollectionView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        if isOnboarding{
//            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterNameViewController")
//            let navigationViewController = UINavigationController(rootViewController: viewController)
//            navigationViewController.isNavigationBarHidden = true
//            let window = PublicAccess.shared.window
//            window?.rootViewController = navigationViewController
//            window?.makeKeyAndVisible()
//            UIView.transition(with: window ?? .init(), duration: 0.2, options: .transitionCrossDissolve, animations: nil)
            
            self.navigationController?.popViewController(animated: true)
        }
        else{
            pop()
        }
    }
    
}

extension CharacterPromptViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters?.count ?? .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{
            let cell = collectionView.getCell(type: CreateCustomGirlfriendCollectionViewCell.self, indexPath: indexPath)
            return cell
        }
        let cell = collectionView.getCell(type: CharacterCollectionViewCell.self, indexPath: indexPath)
        let character = characters?[indexPath.item]
        cell.characterNameLabel.text = character?.name
        cell.characterImageView.sd_setImage(with: character?.getProfilePicUrl()) { _, _, _, _ in
            cell.activityIndicator.stopAnimating()
        }
        if cell.characterImageView.image == nil{
            cell.activityIndicator.startAnimating()
        }
        else{
            cell.activityIndicator.stopAnimating()
        }
        if CoreDataManager.shared.getCharacters().contains(where: {$0.id == character?.id}){
            cell.contentView.alpha = 0.5
        }
        else{
            cell.contentView.alpha = 1
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return .init(width: collectionView.bounds.width/2-10, height: collectionView.bounds.height/2.1)
        }
        else{
            return .init(width: collectionView.bounds.width/2-10, height: collectionView.bounds.height/2.7)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if CoreDataManager.shared.getCharacters().contains(where: {$0.id == characters?[indexPath.item].id}){
            return
        }
        else if indexPath.item == 0{
            if iCloudStorage.shared.currentUser?.isSubscribed == false && CoreDataManager.shared.getCharacters().filter({!(1...1000 ~= $0.id ?? 0)}).count > 0{
                let viewController = getViewController(type: PaywallViewController.self)
                viewController.modalPresentationStyle = .fullScreen
                PublicAccess.shared.topViewController?.present(viewController, animated: true)
            }
            else{
                Mixpanel.mainInstance().track(event: "Create character", properties: ["onboarding": CoreDataManager.shared.getCharacters().count == 0])
                let viewController = self.getViewController(type: EnterNameViewController.self)
                viewController.nameControllerFor = .her
                self.push(viewController: viewController)
            }
        }
        else{
            Mixpanel.mainInstance().track(event: "New chat", properties: ["onboarding": CoreDataManager.shared.getCharacters().count == 0, "premade character": true])

            let character = characters?[indexPath.item]
            
            CoreDataManager.shared.saveMessage(characterId: character?.id ?? .init(), message: Message(characterId: character?.id, message: Prompts.gptPromptToEnd, messageType: .text, messageRoleType: .system, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
            
            CoreDataManager.shared.saveMessage(characterId: character?.id ?? .init(), message: Message(characterId: character?.id, message: "Hello my name is \(iCloudStorage.shared.name?.capitalized ?? .init()), Who are you?", messageType: .text, messageRoleType: .me, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
            
            CoreDataManager.shared.saveMessage(characterId: character?.id ?? .init(), message: Message(characterId: character?.id, message: "I am your girlfriend \(character?.name ?? .init()) created by Waifu Chat.", messageType: .text, messageRoleType: .other, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
            
            CoreDataManager.shared.saveMessage(characterId: character?.id ?? .init(), message: Message(characterId: character?.id, message: "What can you do for me?", messageType: .text, messageRoleType: .me, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
            
            CoreDataManager.shared.saveMessage(characterId: character?.id ?? .init(), message: Message(characterId: character?.id, message: "You are my boyfriend and I can do everything for making our relationship stronger.", messageType: .text, messageRoleType: .other, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
            
            CoreDataManager.shared.saveMessage(characterId: character?.id ?? .init(), message: Message(characterId: character?.id, message: "Hi, my name is \(character?.name ?? .init())", messageType: .text, messageRoleType: .other, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init()))
            
            PublicAccess.shared.gotoTabBar(intoChat: true, character: characters?[indexPath.item])
            CoreDataManager.shared.addCharacter(character: characters![indexPath.item])
            
            CoreDataManager.shared.addLastMessageToCharacter(withId: character?.id ?? .init(), message: "Hi, my name is \(character?.name ?? .init())")
            
        }
    }
    
}
