//
//  UIViewControllerExtension.swift
//  AIGirlFriend
//
//  Created by Rakhi on 19/07/23.
//

import UIKit

extension UIViewController{
    
    //MARK: Created by Rakhi
    func push(viewController: UIViewController?, animated: Bool = true){
        if let viewController{
            self.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
    
    func pop(animated: Bool = true){
        self.navigationController?.popViewController(animated: animated)
    }
    
    func getViewController<T:UIViewController>(type: T.Type) -> T{
        return storyboard?.instantiateViewController(withIdentifier: String(describing: type)) as! T
    }
    
    func showPopup(viewController: UIViewController?, animated: Bool = true){
        if let viewController{
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: animated)
        }
        
    }
    
}


/*
 
 MARK: Created by Rakhi
 
 NOTE:- Always put the reuse identifier same of the class name of view controller.
 
 MARK: Use:-
 let viewController = GetViewController(storyboard: .homeTab, type: HomeViewController.self)
 
 */


