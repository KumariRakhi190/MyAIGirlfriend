//
//  UICollectionViewExtension.swift
//  AIGirlFriend
//
//  Created by Rakhi on 20/07/23.
//

import UIKit

extension UICollectionView{
    
    /*
     
     MARK: Created by Rakhi
     
     NOTE:- Always put the reuse identifier same of the class name of table view cell.
     
     MARK: Uses:-
     >>For registering the cell:-
     rentersCollectionView.registerCell(type: RenterCollectionViewCell.self)
     
     >>For getting cell
     let cell = collectionView.getCell(type: RenterCollectionViewCell.self, indexPath: indexPath)
     return cell
     
     */
    
    func registerCell(type: UICollectionViewCell.Type){
        self.register(UINib(nibName: String(describing: type), bundle: nil), forCellWithReuseIdentifier: String(describing: type))
    }
    
    func getCell<T:UICollectionViewCell>(type: T.Type, indexPath: IndexPath) -> T{
        return dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath) as! T
    }
    
}
