//
//  AskForPhotoViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi on 21/07/23.
//

import UIKit

class AskForPhotoViewController: UIViewController {
    
    @IBOutlet weak var sheetView: UIView!
    @IBOutlet weak var classicSelfieView: UIView!
    @IBOutlet weak var nsfwSelfieView: UIView!
    @IBOutlet weak var naturalImaeView: UIImageView!
    @IBOutlet weak var classicImageView: UIImageView!
    
    weak var delegate: AskForPhotoViewControllerDelegate?
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        classicSelfieView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didtapClassicPhoto)))
        nsfwSelfieView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapNSFWPhoto)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DatabaseManager.shared.reloadPromptsFromDatabase()
        DatabaseManager.shared.fetchTokens()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sheetView.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 15, opacity: 0.3, shadowColor: .white, cornerRadius: 35)
        classicSelfieView.layer.borderColor = UIColor.white.cgColor
        classicSelfieView.layer.borderWidth = 1.0
        nsfwSelfieView.layer.borderColor = UIColor.white.cgColor
        nsfwSelfieView.layer.borderWidth = 1.0
        classicImageView.roundCorners(corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 0)
        naturalImaeView.roundCorners(corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 10)


    }
    
    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func didtapClassicPhoto(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true) {
            self.delegate?.didTapClassicPhoto()
        }
    }
    
    @objc func didTapNSFWPhoto(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true) {
            self.delegate?.didTapNSFWPhoto()
        }
    }
    
    @IBAction func didTapOutside(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

protocol AskForPhotoViewControllerDelegate: AnyObject{
    func didTapClassicPhoto()
    func didTapNSFWPhoto()
}
