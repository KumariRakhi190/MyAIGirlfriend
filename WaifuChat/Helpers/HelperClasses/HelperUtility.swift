//
//  HelperUtility.swift
//  WaifuChat
//
//  Created by Rakhi Kumari on 26/07/25.
//

import Foundation
import UIKit
import StoreKit

final class Helper {
    
    static let shared = Helper()
    private let nicknameKey = "userNickname"
    
    // Save Nickname Locally
    private func saveNickname(_ nickname: String) {
        UserDefaults.standard.set(nickname, forKey: nicknameKey)
    }
    
    // Fetch Nickname
    func fetchNickname() -> String? {
        return UserDefaults.standard.string(forKey: nicknameKey)
    }
    
    func getTopViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .first?.rootViewController) -> UIViewController? {
            if let nav = base as? UINavigationController {
                return getTopViewController(base: nav.visibleViewController)
            } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
                return getTopViewController(base: selected)
            } else if let presented = base?.presentedViewController {
                return getTopViewController(base: presented)
            }
            return base
        }
    
    // Update Nickname
    func updateNickname(in viewController: UIViewController, completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "Update Username", message: "Enter a new username:", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "New Nickname"
            textField.text = self.fetchNickname()
        }
        
        let updateAction = UIAlertAction(title: "Update", style: .default) { _ in
            if let newNickname = alert.textFields?.first?.text, !newNickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.saveNickname(newNickname)
                completion(newNickname)
            } else {
                completion(nil)
            }
        }
        
        alert.addAction(updateAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func isDeviceJailbroken() -> Bool {
#if arch(i386) || arch(x86_64)
        return false
#else
        let fileManager = FileManager.default
        
        if (fileManager.fileExists(atPath: "/bin/bash") ||
            fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
            fileManager.fileExists(atPath: "/etc/apt") ||
            fileManager.fileExists(atPath: "/private/var/lib/apt/") ||
            fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
            fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")) {
            return true
        } else {
            return false
        }
#endif
    }
    
}
