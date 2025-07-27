//
//  CreateViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi Kumari on 26/07/25.
//

import UIKit

class CreateViewController: UIViewController {
    
    @IBOutlet weak var ethinicityCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hairCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eyeCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var personalityCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var continueButtonOutlet: UIButton!
    @IBOutlet weak var ethinicityCollectionView: UICollectionView! {
        didSet {
            ethinicityCollectionView.register(UINib(nibName: "InterestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InterestCollectionViewCell")
        }
    }
    @IBOutlet weak var hairCollectionView: UICollectionView! {
        didSet {
            hairCollectionView.register(UINib(nibName: "InterestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InterestCollectionViewCell")
        }
    }
    @IBOutlet weak var eyeCollectionView: UICollectionView! {
        didSet {
            eyeCollectionView.register(UINib(nibName: "InterestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InterestCollectionViewCell")
        }
    }
    @IBOutlet weak var personalityCollectionView: UICollectionView! {
        didSet {
            personalityCollectionView.register(UINib(nibName: "InterestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InterestCollectionViewCell")
        }
    }
    
    var onDismiss: (() -> Void)? // Add this property

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        setupContinueButton()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.ethinicityCollectionViewHeightConstraint.constant = self.ethinicityCollectionView.contentSize.height
            self.hairCollectionViewHeightConstraint.constant = self.hairCollectionView.contentSize.height
            //self.eyeCollectionViewHeightConstraint.constant = self.eyeCollectionView.contentSize.height
            self.personalityCollectionViewHeightConstraint.constant = self.personalityCollectionView.contentSize.height
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed {
            onDismiss?()
        }
    }
    
    @IBAction func continueDidTapped(_ sender: Any) {
        let viewController = self.getViewController(type: GeneratedCharacterViewController.self)
//        viewController.character = self.character
        self.push(viewController: viewController)
    }
    
    @IBAction func backDidTappedTapped(_ sender: UIButton) {
        self.onDismiss?()
        self.navigationController?.popViewController(animated: true)
    }

    private func setupCollectionViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)

        [ethinicityCollectionView, hairCollectionView, eyeCollectionView, personalityCollectionView].forEach {
            $0?.collectionViewLayout = layout
            $0?.allowsMultipleSelection = false  // ✅ Allow only single selection
            $0?.isScrollEnabled = false
        }
    }
    
    private func setupContinueButton() {
        continueButtonOutlet.isUserInteractionEnabled = false
        continueButtonOutlet.alpha = 0.3
    }
    
    private func updateContinueButtonState() {
        let ethnicitySelected = !(ethinicityCollectionView.indexPathsForSelectedItems?.isEmpty ?? true)
        let hairSelected = !(hairCollectionView.indexPathsForSelectedItems?.isEmpty ?? true)
        let eyeSelected = !(eyeCollectionView.indexPathsForSelectedItems?.isEmpty ?? true)
        let personalitySelected = !(personalityCollectionView.indexPathsForSelectedItems?.isEmpty ?? true)
        
        let allSelected = ethnicitySelected && hairSelected && eyeSelected && personalitySelected
        continueButtonOutlet.isUserInteractionEnabled = allSelected
        continueButtonOutlet.alpha = allSelected ? 1.0 : 0.3
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension CreateViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case ethinicityCollectionView:
            return Constants.ethnicityTitle.count
        case hairCollectionView:
            return Constants.hairColorTitles.count
        case eyeCollectionView:
            return Constants.eyeColorTitles.count
        case personalityCollectionView:
            return Constants.characterTraits.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCollectionViewCell", for: indexPath) as! InterestCollectionViewCell
        
        switch collectionView {
        case ethinicityCollectionView:
            cell.titleLabel.text = Constants.ethnicityTitle[indexPath.item]
        case hairCollectionView:
            cell.titleLabel.text = Constants.hairColorTitles[indexPath.item]
        case eyeCollectionView:
            cell.titleLabel.text = Constants.eyeColorTitles[indexPath.item]
        case personalityCollectionView:
            cell.titleLabel.text = Constants.characterTraits[indexPath.item]
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
            for selectedIndexPath in selectedIndexPaths where selectedIndexPath != indexPath {
                collectionView.deselectItem(at: selectedIndexPath, animated: false)
                (collectionView.cellForItem(at: selectedIndexPath) as? InterestCollectionViewCell)?.setSelected(false)
            }
        }
        (collectionView.cellForItem(at: indexPath) as? InterestCollectionViewCell)?.setSelected(true)
        updateContinueButtonState()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? InterestCollectionViewCell)?.setSelected(false)
        updateContinueButtonState()
    }
    
    // MARK: - Dynamic cell sizing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var text = ""
        switch collectionView {
        case ethinicityCollectionView:
            text = Constants.ethnicityTitle[indexPath.item]
        case hairCollectionView:
            text = Constants.hairColorTitles[indexPath.item]
        case eyeCollectionView:
            text = Constants.eyeColorTitles[indexPath.item]
        case personalityCollectionView:
            text = Constants.characterTraits[indexPath.item]
        default:
            break
        }

        let font = UIFont.systemFont(ofSize: 16)
        let padding: CGFloat = 38 // For left + right inside the cell
        
        let size = (text as NSString).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 40),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        
        return CGSize(width: ceil(size.width + padding), height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }

}
