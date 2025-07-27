//
//  EnterNameViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi on 19/07/23.
//

import UIKit
import Mixpanel

class EnterNameViewController: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var continueButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var nameDescriptionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var nameControllerFor = NameControllerFor.me
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    func initialSetup(){
        if nameControllerFor == .her{
            nameTitleLabel.text = Constants.whatsHerName
            nameDescriptionLabel.text = Constants.howWouldLikeToNameYourGirlfriend
            nameTextField.placeholder = Constants.typeHerName
            backButton.isHidden = false
        } else {
            nameTitleLabel.text = Constants.whatsUserName
            nameDescriptionLabel.text = Constants.whichNameShouldIRemember
            nameTextField.placeholder = Constants.typeUserName
            backButton.isHidden = true
        }
        handleKeyboard()
    }
    
    func handleKeyboard(){
        KeyboardStateManager.shared.observeKeyboardHeight = { height in
            UIView.animate(withDuration: 0.3) {
                self.continueButtonBottomConstraint.constant = height + 10
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func didChangeEditing(_ sender: UITextField) {
        if let text = sender.text?.trim, !text.isEmpty{
            continueButton.isUserInteractionEnabled = true
            continueButton.alpha = 1
        }
        else{
            continueButton.isUserInteractionEnabled = false
            continueButton.alpha = 0.3
        }
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        pop()
    }
    
    @IBAction func didTapContinue(_ sender: Any) {
        let viewController = getViewController(type: InterestViewController.self)
        push(viewController: viewController)
//        DatabaseManager.shared.reloadPromptsFromDatabase()
//        DatabaseManager.shared.fetchTokens()
//        if nameControllerFor == .her{
//            let viewController = getViewController(type: SelectionViewController.self)
//            viewController.name = String(nameTextField.text?.prefix(35) ?? .init())
//            viewController.selectionControllerFor = .ethnicity
//            push(viewController: viewController)
//        } else{
//            Mixpanel.mainInstance().track(event: "Onboarding - name")
//            iCloudStorage.shared.name = String(nameTextField.text?.prefix(35) ?? .init()).trim
//            if iCloudStorage.shared.currentUser != nil{
////                DatabaseManager.shared.changeName(newName: iCloudStorage.shared.name ?? .init()) { error in
////                    PublicAccess.shared.gotoCharacterPrompt()
////                }
//                let viewController = getViewController(type: InterestViewController.self)
//                push(viewController: viewController)
//            } else{
//                let user = User(name: String(nameTextField.text?.prefix(35) ?? .init()).trim, deviceId: UIDevice.current.identifierForVendor?.uuidString, isSubscribed: false)
//                DatabaseManager.shared.addUser(user: user)
//                PublicAccess.shared.gotoCharacterPrompt()
//            }
//        }
    }
    
}
