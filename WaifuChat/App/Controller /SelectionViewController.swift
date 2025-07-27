//
//  SelectionViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi on 20/07/23.
//

import UIKit

class SelectionViewController: UIViewController {
    
    @IBOutlet weak var selectTitleLabel: UILabel!
    @IBOutlet weak var selectionTableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    
    var character = Character()
    
    var name: String?
    var selectionControllerFor: selectionControllerFor?
    var optionsForSelection: [String]?
    var selectedOptionIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialSetup()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let tableViewHeight = self.selectionTableView.frame.height
        let contentHeight = self.selectionTableView.contentSize.height
        
        let centeringInset = (tableViewHeight - contentHeight) / 2.0
        let topInset = max(centeringInset, 0)
        
        self.selectionTableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0.0, right: 0)
    }
    
    func initialSetup(){
        DatabaseManager.shared.reloadPromptsFromDatabase()
        DatabaseManager.shared.fetchTokens()
        character.name = name
        character.id = PublicAccess.shared.currentDateTime?.timeIntervalSince1970 ?? .init()
        switch selectionControllerFor {
            case .ethnicity:
                selectTitleLabel.text = Constants.selectEthnicity
                optionsForSelection = Constants.ethnicityTitle
            case .eyesColor:
                selectTitleLabel.text = Constants.selectEyeColor
                optionsForSelection = Constants.eyeColorTitles
            case .hairColor:
                selectTitleLabel.text = Constants.selectHairColor
                optionsForSelection = Constants.hairColorTitles
            case .traits:
                selectTitleLabel.text = Constants.selectNameCharacterTraits(name: name ?? .init())
                optionsForSelection = Constants.characterTraits
            default:
                break
        }
    }
    
    func setupTableView(){
        selectionTableView.registerCell(type: SelectionTableViewCell.self)
        selectionTableView.dataSource = self
        selectionTableView.delegate = self
    }
    
    @IBAction func didTapContinue(_ sender: Any) {
        if let nextPurposeForSelection = selectionControllerFor?.next{
            let viewController = getViewController(type: SelectionViewController.self)
            viewController.selectionControllerFor = nextPurposeForSelection
            viewController.name = name
            viewController.character = character
            push(viewController: viewController)
        }
        else{
            let viewController = getViewController(type: GeneratingViewController.self)
            viewController.character = character
            push(viewController: viewController)
        }
        
    }
    
    @IBAction func didTapBack(_ sender: Any){
        pop()
    }
    
}

extension SelectionViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsForSelection?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell(type: SelectionTableViewCell.self, indexPath: indexPath)
        cell.optionButton.setTitle(optionsForSelection?[indexPath.row], for: .normal)
        if indexPath.row == selectedOptionIndex{
            cell.optionButton.backgroundColor = .white
            cell.optionButton.setTitleColor(.black, for: .normal)
        }
        else{
            cell.optionButton.backgroundColor = .white.withAlphaComponent(0.1)
            cell.optionButton.setTitleColor(.white, for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOptionIndex = indexPath.row
        selectionTableView.reloadData()
        continueButton.isUserInteractionEnabled = true
        continueButton.alpha = 1
        
        let optionForSelection = optionsForSelection?[indexPath.row]
        switch selectionControllerFor {
            case .ethnicity:
                character.ethnicity = optionForSelection
            case .eyesColor:
                character.eyesColor = optionForSelection
            case .hairColor:
                character.hairColor = optionForSelection
            case .traits:
                character.traits = optionForSelection
            default:
                break
        }
        
    }
    
}
