//
//  CharacterProfileViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi on 21/07/23.
//

import UIKit

class CharacterProfileViewController: UIViewController {
    
    @IBOutlet weak var sheetView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutTextField: UITextView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var noMediaLabel: UILabel!
    @IBOutlet weak var personalityLabel: UILabel!
    @IBOutlet weak var eyeColourLabel: UILabel!
    @IBOutlet weak var hairColorLabel: UILabel!
    @IBOutlet weak var ethinicityLabel: UILabel!
    
    var messages = [Message](){
        didSet{
            messages = messages.filter({$0.messageType == .image}).reversed()
            galleryCollectionView.reloadData()
            noMediaLabel.isHidden = messages.count > 0
        }
    }
    
    var character: Character?
    
    var renameDelegate: RenameDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        initialSetup()
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messages = CoreDataManager.shared.getMessages(characterId: character?.id ?? .init())
    }
    
//    @IBAction func didTapChangeName(_ sender: Any) {
//        if !(1...1000 ~= character?.id ?? 0){
//            let alert = UIAlertController(title: Constants.changeName, message: nil, preferredStyle: .alert)
//            alert.addAction(.init(title: Constants.cancel, style: .cancel))
//            alert.addTextField { textField in
//                textField.text = self.character?.name
//            }
//            alert.addAction(.init(title: Constants.done, style: .default, handler: { _ in
//                CoreDataManager.shared.renameCharacter(withId: self.character?.id ?? .init(), to: String(alert.textFields?.first?.text?.prefix(35) ?? .init()))
//                CoreDataManager.shared.saveMessage(characterId: self.character?.id ?? .init(), message: Message(characterId: self.character?.id, message: "Your name has been changed from \(self.character?.name ?? .init()) to \(String(alert.textFields?.first?.text?.prefix(35) ?? .init()))", messageType: .text, messageRoleType: .system, timestamp: PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init(), isSilent: true))
//                self.character?.name = String(alert.textFields?.first?.text?.prefix(35) ?? .init())
//                self.nameLabel.text = self.character?.name
//                self.aboutTextField.text = self.character?.characteristics
//                self.ethinicityLabel.text = self.character?.ethnicity
//                self.eyeColourLabel.text = self.character?.eyesColor
//                self.hairColorLabel.text = self.character?.hairColor
//                self.personalityLabel.text = self.character?.characteristics
//                self.renameDelegate?.didRename(newName: self.character?.name ?? .init())
//            }))
//            present(alert, animated: true)
//        }
//        
//    }
    
    @IBAction func didTapBack(_ sender: Any) {
        pop()
    }
    
    func initialSetup(){
        profileImageView.sd_setImage(with: character?.getProfilePicUrl())
        self.nameLabel.text = self.character?.name
        self.aboutTextField.text = self.character?.characteristics
        self.ethinicityLabel.text = self.character?.ethnicity
        self.eyeColourLabel.text = self.character?.eyesColor
        self.hairColorLabel.text = self.character?.hairColor
        self.personalityLabel.text = self.character?.characteristics
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapViewPicture)))
        nameLabel.font = UIFont(name: "Inter Regular Bold", size: 20)
    }
    
    func setupCollectionView(){
        galleryCollectionView.registerCell(type: ImageCollectionViewCell.self)
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        galleryCollectionView.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}

extension CharacterProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5//messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.getCell(type: ImageCollectionViewCell.self, indexPath: indexPath)
        cell.attachedImageView.image = UIImage(named: "girl1")
//        if let imageUrl = messages[indexPath.row].getMessageImageUrl(){
//            cell.attachedImageView.sd_setImage(with: imageUrl) { _, _, _, _ in
                cell.activityIndicator.stopAnimating()
//            }
//        }
        cell.attachedImageView.gestureRecognizers?.removeAll()
        cell.attachedImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapViewPicture)))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.width/2.8, height: collectionView.bounds.height)
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

protocol RenameDelegate: AnyObject{
    func didRename(newName: String)
}
