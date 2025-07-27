//
//  SettingsViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi on 24/07/23.
//

import UIKit
import MessageUI
import StoreKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var bannerBottomLabel: UILabel!
    @IBOutlet weak var bannerTopLabel: UILabel!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var profileTitleLabel: UILabel!
    @IBOutlet weak var settingTableView: UITableView! {
        didSet {
            settingTableView.registerCell(type: SettingsTableViewCell.self)
            settingTableView.registerCell(type: SettingHeaderTableViewCell.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.sectionHeaderTopPadding = 0
        DatabaseManager.shared.changeName(newName: iCloudStorage.shared.name ?? .init()) { _ in}
        profileTitleLabel.font = UIFont(name: "Fredoka Light Bold", size: 25)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.settingArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = Bundle.main.loadNibNamed("SettingHeaderTableViewCell", owner: self, options: nil)?.first as? SettingHeaderTableViewCell else {
                return nil
            }
        let headerSection = Constants.settingArray[section].heading
            headerView.titleLabel.text = headerSection
            return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = Constants.settingArray[section].detail.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        let details = Constants.settingArray[indexPath.section].detail[indexPath.row]
        cell.usernameLabel.isHidden = indexPath.section != 0
        cell.configData(data: details)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            // Only one row for nickname change
            if indexPath.row == 0 {
                Helper.shared.updateNickname(in: Helper.shared.getTopViewController() ?? UIViewController()) { _ in }
            }
            return
        }

        // Handle other settings (section 1+)
        switch indexPath.row {
        case 0:
            // Privacy Policy
            Helper.shared.getTopViewController()?.navigationController?.pushViewController(
                WebViewViewController(url: URLs.privacyPolicy, title: "Privacy Policy"),
                animated: true
            )
        case 1:
            // Terms of Use
            Helper.shared.getTopViewController()?.navigationController?.pushViewController(
                WebViewViewController(url: URLs.termsOfUse, title: "Terms of Use"),
                animated: true
            )
        case 2:
            // Feedback Email
            EmailViewController.shared = EmailViewController()
            EmailViewController.shared?.sendEmail(subject: "Feedback")
        case 3:
            // Support Email
            EmailViewController.shared = EmailViewController()
            EmailViewController.shared?.sendEmail(subject: "Support")
        case 4:
            // Rate on App Store
            UIApplication.shared.open(URLs.rateOnAppStore)
        case 5:
            // Open Website
            UIApplication.shared.open(URLs.website)
        default:
            break
        }
    }

    
}
