//
//  GlobalVariables.swift
//  AIGirlFriend
//
//  Created by Rakhi on 26/07/23.
//

import UIKit
import StoreKit

final class PublicAccess{
    
    static let shared = PublicAccess()
        
    var products: [SKProduct]?
    
    var currentDateTime: Date?
    var currentUtcDateTime: Date?
        
    var window: UIWindow?{
        return UIApplication.shared.windows.first?.windowScene?.windows.first
    }
    
    var topViewController: UIViewController?{
        var top = window?.rootViewController
        if let presented = top?.presentedViewController {
            top = presented
        }
        else if let nav = top as? UINavigationController {
            top = nav.visibleViewController
        }
        else if let tab = top as? UITabBarController {
            top = tab.selectedViewController
        }
        return top
    }
    
    func gotoCharacterPrompt(){
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CharacterPromptViewController")
        let navigationViewController = UINavigationController(rootViewController: viewController)
        navigationViewController.isNavigationBarHidden = true
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        UIView.transition(with: window ?? .init(), duration: 0.2, options: .transitionCrossDissolve, animations: nil)
    }
    
    func gotoTabBar(intoChat: Bool = false, character: Character? = nil){
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController")
        let navigationViewController = UINavigationController(rootViewController: viewController)
        navigationViewController.isNavigationBarHidden = true
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        if intoChat{
            let chattingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChattingViewController") as! ChattingViewController
            chattingViewController.character = character
            navigationViewController.pushViewController(chattingViewController, animated: false)
        }
        UIView.transition(with: window ?? .init(), duration: 0.2, options: .transitionCrossDissolve, animations: nil)
    }
    
    func logoutUserAndDeleteData(){
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterNameViewController")
        let navigationViewController = UINavigationController(rootViewController: viewController)
        navigationViewController.isNavigationBarHidden = true
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        UIView.transition(with: window ?? .init(), duration: 0.2, options: .transitionCrossDissolve, animations: nil)
        iCloudStorage.shared.name = nil
        iCloudStorage.shared.userDocumentId = nil
        iCloudStorage.shared.currentUser = nil
        CoreDataManager.shared.removeCharacters()
        CoreDataManager.shared.deleteAllMessages()
    }
    
    func handleNavigations(){
//        if CoreDataManager.shared.getCharacters().count != 0{
//            gotoTabBar()
//        } else if iCloudStorage.shared.name != nil{
//            gotoCharacterPrompt()
//        } else{
//            logoutUserAndDeleteData()
//        }
    }
    
    func showAlertForPremium(viewController: UIViewController, title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: Constants.continue_, style: .default, handler: { _ in
            let paywallViewController = viewController.getViewController(type: PaywallViewController.self)
            paywallViewController.modalPresentationStyle = .fullScreen
            viewController.present(paywallViewController, animated: true)
        }))
        viewController.present(alert, animated: true)
    }
    
    func showAlert(viewController: UIViewController, title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: Constants.okay, style: .cancel))
        viewController.present(alert, animated: true)
    }
    
    
    func startObservingDateFromServer() {
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//            let url = URL(string: "http://worldtimeapi.org/api/ip")
//            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
//                if let error = error {
//                    print("Error: \(error.localizedDescription)")
//                    return
//                }
//                if let data = data {
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data, options: [])
//                        
//                        if let jsonDict = json as? [String: Any],
//                           let dateTimeString = jsonDict["datetime"] as? String, let utcDateTimeString = jsonDict["utc_datetime"] as? String{
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSxxx"
//                            if let dateTime = dateFormatter.date(from: dateTimeString), let utcDateTime = dateFormatter.date(from: utcDateTimeString){
//                                self.currentDateTime = dateTime
//                                self.currentUtcDateTime = utcDateTime
////                                debugPrint(dateTime)
////                                debugPrint(utcDateTime)
//                            } else {
//                                print("Failed to convert date string.")
//                            }
//                        } else {
//                            print("Invalid JSON response.")
//                        }
//                    } catch {
//                        print("Error parsing JSON: \(error.localizedDescription)")
//                    }
//                } else {
//                    print("No data received.")
//                }
//            }
//            task.resume()
//        }
    }
    
    func presentReviewRequest(withDelay: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + (withDelay ? 1 : 0)){
            if let windowScene = UIApplication.shared.windows.first?.windowScene{
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }

    
    private init(){}
    
}
