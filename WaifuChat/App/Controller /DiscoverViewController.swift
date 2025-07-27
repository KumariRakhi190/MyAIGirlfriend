//
//  DiscoverViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi Kumari on 26/07/25.
//

import UIKit
import Mixpanel

class DiscoverViewController: UIViewController {

    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var bannerBottomLabel: UILabel!
    @IBOutlet weak var bannerTopLabel: UILabel!
    @IBOutlet weak var bannerView: UIView!
    
    var characters: [Character]?{
        didSet{
            characters?.insert(.init(), at: 0)
            charactersCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        DatabaseManager.shared.reloadUser { error in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.bannerView.isHidden = iCloudStorage.shared.currentUser?.isSubscribed == true
                    self.bannerBottomLabel.isHidden = iCloudStorage.shared.currentUser?.isSubscribed == true
                    self.bannerTopLabel.isHidden = iCloudStorage.shared.currentUser?.isSubscribed == true
                    self.separatorLabel.isHidden = iCloudStorage.shared.currentUser?.isSubscribed == true
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimating()
//        DatabaseManager.shared.reloadPromptsFromDatabase()
//        DatabaseManager.shared.fetchTokens()
//        DatabaseManager.shared.getCharacters { characters in
//            self.characters = characters
//        }
    }
    
    func setupCollectionView(){
        charactersCollectionView.registerCell(type: CharacterCollectionViewCell.self)
        charactersCollectionView.registerCell(type: CreateCustomGirlfriendCollectionViewCell.self)
        charactersCollectionView.delegate = self
        charactersCollectionView.dataSource = self
        charactersCollectionView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
    }

}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10//characters?.count ?? .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.getCell(type: CharacterCollectionViewCell.self, indexPath: indexPath)
//        let character = characters?[indexPath.item]
//        cell.characterNameLabel.text = character?.name
//        cell.characterImageView.sd_setImage(with: character?.getProfilePicUrl()) { _, _, _, _ in
//            cell.activityIndicator.stopAnimating()
//        }
//        if cell.characterImageView.image == nil{
//            cell.activityIndicator.startAnimating()
//        }
//        else{
            cell.activityIndicator.stopAnimating()
//        }
//        if CoreDataManager.shared.getCharacters().contains(where: {$0.id == character?.id}){
//            cell.contentView.alpha = 0.5
//        }
//        else{
//            cell.contentView.alpha = 1
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/2-10
        if UIDevice.current.userInterfaceIdiom == .pad{
            return .init(width: width, height: width*1.2)
        }
        else{
//            return .init(width: collectionView.bounds.width/2-10, height: collectionView.bounds.height/2.7)
            return .init(width: width, height: width*1.3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let nextViewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "ChattingViewController") as? ChattingViewController {
//            nextViewcontroller.character = character
            self.navigationController?.pushViewController(nextViewcontroller, animated: true)
        }
    }
    
}
