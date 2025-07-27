//
//  KeyboardStateManager.swift
//  AIGirlFriend
//
//  Created by Rakhi on 19/07/23.
//

import Foundation
import UIKit

final class KeyboardStateManager{
    
    static let shared = KeyboardStateManager()
    
    var isVisible = false
    var keyboardHeight: CGFloat = 0
    var observeKeyboardHeight: ((CGFloat) -> Void)?
    
    private init(){}
    
    func start(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleShow(_ notification: Notification){
        isVisible = true
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            observeKeyboardHeight?(keyboardHeight)
        }
    }
    
    @objc func handleHide(){
        isVisible = false
        observeKeyboardHeight?(0)
    }
    
    func stop(){
        NotificationCenter.default.removeObserver(self)
    }
    
}

/// Created by Rakhi
/*********************************************************************************
 
 Use :-
 
 >>> To start listening keyboard state :-
 KeyboardStateManager.shared.start()
 
 >>> To stop listening keyboard state :-
 KeyboardStateManager.shared.stop()
 
 >>> To check whether keyboard is visible or not :-
 let isVisibleKeyboard = KeyboardStateManager.shared.isVisible
 
 >>> To get height of showing keyboard :-
 let keyboardHeight = KeyboardStateManager.shared.keyboardHeight
 
 >>> To observe the keyboard height :-
 KeyboardStateManager.shared.observeKeyboardHeight = { keyboardHeight in
 UIView.animate(withDuration: 0.3) {
 self.writeMessageViewBottomConstraint.constant = keyboardHeight
 self.view.layoutIfNeeded()
 }
 }
 
 ***********************************************************************************************************************************/
