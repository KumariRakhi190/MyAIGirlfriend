//
//  GeneratingViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi on 20/07/23.
//

import UIKit

class GeneratingViewController: UIViewController {
    
    @IBOutlet weak var generatingLabel: UILabel!
    
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        generatingLabel.text = Constants.generating(name: character?.name ?? .init())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        generateCharacter()
    }
    
    func generateCharacter(){
        startAnimating()
        character?.modelId = Constants.sinkinModelIds.randomElement()
        AIManager.shared.generateCharacter(character: character) { imageUrl in
            stopAnimating()
            DispatchQueue.main.async {
                if let imageUrl{
                    self.character?.imageUrl = imageUrl
                    let viewController = self.getViewController(type: GeneratedCharacterViewController.self)
                    viewController.character = self.character
                    self.push(viewController: viewController)
                }
                else{
                    let alert = UIAlertController(title: Constants.somethingWentWrong, message: nil, preferredStyle: .alert)
                    alert.addAction(.init(title: Constants.retry, style: .default, handler: { _ in
                        self.generateCharacter()
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func didTapBack(_ sender: Any){
        pop()
    }
    
    
}
