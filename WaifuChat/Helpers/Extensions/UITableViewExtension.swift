//
//  UITableViewExtension.swift
//  AIGirlFriend
//
//  Created by Rakhi on 20/07/23.
//

import UIKit

extension UITableView{
    
    /*
     
     MARK: Created by Rakhi
     
     NOTE:- Always put the reuse identifier same of the class name of table view cell.
     
     MARK: Uses:-
     >>For registering the cell:-
     chatTableView.registerCell(type: ChatTableViewCell.self)
     
     >>For getting cell
     let cell = tableView.getCell(type: ChatTableViewCell.self, indexPath: indexPath)
     return cell
     
     */
    
    
    func registerCell(type: UITableViewCell.Type){
        self.register(UINib(nibName: String(describing: type), bundle: nil), forCellReuseIdentifier: String(describing: type))
    }
    
    func getCell<T:UITableViewCell>(type: T.Type, indexPath: IndexPath) -> T{
        return dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as! T
    }
    
}
