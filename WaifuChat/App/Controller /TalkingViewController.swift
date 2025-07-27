//
//  TalkingViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi Kumari on 19/07/25.
//

import UIKit

class TalkingViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var talkingWayCollectionView: UICollectionView! {
        didSet {
            talkingWayCollectionView.registerCell(type: InterestCollectionViewCell.self)
        }
    }
    let talkingStyles = ["💖 Sweet", "😉 Flirty", "🔥 Bold", "🌹 Romantic", "🎭 Playful", "😍 Caring", "😜 Cheeky"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupContinueButton()
    }

    private func setupCollectionView() {
        talkingWayCollectionView.collectionViewLayout = createCenteredLayout()
        talkingWayCollectionView.allowsMultipleSelection = true
    }

    private func setupContinueButton() {
        continueButton.isUserInteractionEnabled = false
        continueButton.alpha = 0.5
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueDidTapped(_ sender: Any) {
//        let viewController = getViewController(type: CharacterPromptViewController.self)
//        viewController.isOnboarding = true
//        push(viewController: viewController)
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController")
        let navigationViewController = UINavigationController(rootViewController: viewController)
        navigationViewController.isNavigationBarHidden = true
        PublicAccess.shared.window?.rootViewController = navigationViewController
        PublicAccess.shared.window?.makeKeyAndVisible()
    }
    
//    private func getSelectedInterests() -> [String] {
//        guard let indexPaths = talkingWayCollectionView.indexPathsForSelectedItems else { return [] }
//        return indexPaths.compactMap { $0.item < talkingStyles.count ? talkingStyles[$0.item] : nil }
//    }

    private func updateContinueButtonState() {
        let selectedCount = talkingWayCollectionView.indexPathsForSelectedItems?.count ?? 0
        continueButton.isUserInteractionEnabled = selectedCount > 0
        continueButton.alpha = selectedCount > 0 ? 1.0 : 0.3
    }

}

// MARK: - UICollectionView DataSource & Delegate
extension TalkingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return talkingStyles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < talkingStyles.count else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCollectionViewCell", for: indexPath) as! InterestCollectionViewCell
        cell.titleLabel.text = talkingStyles[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < talkingStyles.count else { return }
        (collectionView.cellForItem(at: indexPath) as? InterestCollectionViewCell)?.setSelected(true)
        updateContinueButtonState()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard indexPath.item < talkingStyles.count else { return }
        (collectionView.cellForItem(at: indexPath) as? InterestCollectionViewCell)?.setSelected(false)
        updateContinueButtonState()
    }
}

// MARK: - Modern Centered Compositional Layout
extension TalkingViewController {
    private func createCenteredLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }

            // Dynamic item width calculation
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(80),
                heightDimension: .absolute(40)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(10)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.orthogonalScrollingBehavior = .none
            section.interGroupSpacing = 10
            section.contentInsetsReference = .automatic

            // Center alignment
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

            return section
        }
    }
}
