//
//  TabBarViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi on 21/07/23.
//

import UIKit
import StoreKit
import Mixpanel

class TabBarViewController: UIViewController {
    
    @IBOutlet weak var chatTabControl: UIControl!
    @IBOutlet weak var profileTabControl: UIControl!
    @IBOutlet weak var discoverTabControl: UIControl!
    @IBOutlet weak var createTabControl: UIControl!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
//MARK: FOR ENABLE SCROLLING BETWEEN THE TABS UNCOMMENT THESE CODES
    
//    var selectedTab: TaBarItem = .chat {
//        didSet {
//            let screenWidth = UIScreen.main.bounds.width
//            switch selectedTab {
//            case .chat:
//                chatTabControl.alpha = 1
//                discoverTabControl.alpha = 0.4
//                createTabControl.alpha = 0.4
//                profileTabControl.alpha = 0.4
//                scrollView.setContentOffset(CGPoint(x: screenWidth * 0, y: 0), animated: true)
//            case .discover:
//                chatTabControl.alpha = 0.4
//                discoverTabControl.alpha = 1
//                createTabControl.alpha = 0.4
//                profileTabControl.alpha = 0.4
//                scrollView.setContentOffset(CGPoint(x: screenWidth * 1, y: 0), animated: true)
//            case .create:
//                chatTabControl.alpha = 0.4
//                discoverTabControl.alpha = 0.4
//                createTabControl.alpha = 1
//                profileTabControl.alpha = 0.4
//                scrollView.setContentOffset(CGPoint(x: screenWidth * 2, y: 0), animated: true)
//            case .profile:
//                chatTabControl.alpha = 0.4
//                discoverTabControl.alpha = 0.4
//                createTabControl.alpha = 0.4
//                profileTabControl.alpha = 1
//                scrollView.setContentOffset(CGPoint(x: screenWidth * 3, y: 0), animated: true)
//                Mixpanel.mainInstance().track(event: "Profile")
//            }
//        }
//    }
    
//MARK: FOR DISABLE SCROLLING BETWEEN THE TABS COMMENT THESE CODES
    
    var chatVC: ChatViewController!
    var discoverVC: DiscoverViewController!
    var createVC: CreateViewController!
    var profileVC: SettingsViewController!
    var previousTab: TaBarItem = .chat
    
//MARK: FOR DISABLE SCROLLING BETWEEN THE TABS COMMENT THESE CODES
    
    var selectedTab: TaBarItem = .chat {
        didSet {
            chatTabControl.alpha = selectedTab == .chat ? 1 : 0.4
            discoverTabControl.alpha = selectedTab == .discover ? 1 : 0.4
            createTabControl.alpha = selectedTab == .create ? 1 : 0.4
            profileTabControl.alpha = selectedTab == .profile ? 1 : 0.4
            switch selectedTab {
            case .chat: showOnly(chatVC)
            case .discover: showOnly(discoverVC)
            case .create: showOnly(createVC)
            case .profile:
                showOnly(profileVC)
//                Mixpanel.mainInstance().track(event: "Profile")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        chatVC = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
        discoverVC = storyboard.instantiateViewController(withIdentifier: "DiscoverViewController") as? DiscoverViewController
        createVC = storyboard.instantiateViewController(withIdentifier: "CreateViewController") as? CreateViewController
        profileVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
        add(childVC: chatVC)
        add(childVC: discoverVC)
        add(childVC: createVC)
        add(childVC: profileVC)
        showOnly(chatVC)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tabBarView.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 10, opacity: 0.3, shadowColor: .buttonColor, cornerRadius: 0)
//        tabBarView.layer.cornerRadius = self.tabBarView.frame.height / 2
////        scrollView.delegate = self
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Remove any background color
        tabBarView.backgroundColor = .clear
        
        // Remove old blur views if any
        tabBarView.subviews.forEach {
            if $0 is UIVisualEffectView { $0.removeFromSuperview() }
        }
        
        // 1. Glass Blur Effect (iOS 17 style)
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tabBarView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = tabBarView.frame.height / 2
        blurView.layer.masksToBounds = true
        
        // 2. Vibrancy Layer (makes icons/text pop)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .fill)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.frame = blurView.bounds
        vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.contentView.addSubview(vibrancyView)
        
        // 3. Optional Glass Border
        blurView.layer.borderWidth = 0.8
        blurView.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        
        // 4. Optional Subtle Gradient Overlay (for depth)
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.white.withAlphaComponent(0.15).cgColor,
            UIColor.clear.cgColor
        ]
        gradient.frame = blurView.bounds
        gradient.cornerRadius = blurView.layer.cornerRadius
        blurView.layer.insertSublayer(gradient, at: 0)
        
        tabBarView.insertSubview(blurView, at: 0)
    }


    
    func initialSetup(){
        chatTabControl.addTarget(self, action: #selector(didChangeTab), for: .touchUpInside)
        discoverTabControl.addTarget(self, action: #selector(didChangeTab), for: .touchUpInside)
        createTabControl.addTarget(self, action: #selector(didChangeTab), for: .touchUpInside)
        profileTabControl.addTarget(self, action: #selector(didChangeTab), for: .touchUpInside)
//        PublicAccess.shared.presentReviewRequest()
    }
    
//MARK: FOR DISABLE SCROLLING BETWEEN THE TABS COMMENT THESE CODES
    
    private func showOnly(_ vcToShow: UIViewController) {
        [chatVC, discoverVC, createVC, profileVC].forEach { vc in
            vc.view.isHidden = (vc != vcToShow)
        }
    }
    
//MARK: FOR DISABLE SCROLLING BETWEEN THE TABS COMMENT THESE CODES
    
    private func add(childVC: UIViewController) {
        addChild(childVC)
        view.insertSubview(childVC.view, belowSubview: tabBarView)
        childVC.view.frame = view.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func didChangeTab(_ sender: UIControl) {
//        DatabaseManager.shared.reloadPromptsFromDatabase()
//        DatabaseManager.shared.fetchTokens()

        if sender == chatTabControl && selectedTab != .chat {
            selectedTab = .chat
        } else if sender == discoverTabControl && selectedTab != .discover {
            selectedTab = .discover
        } else if sender == createTabControl {
            // Save current tab
            previousTab = selectedTab

            // Push CreateViewController and hide tab bar
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let createVC = storyboard.instantiateViewController(withIdentifier: "CreateViewController") as? CreateViewController {
                createVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(createVC, animated: true)
            }
        } else if sender == profileTabControl && selectedTab != .profile {
            selectedTab = .profile
        }
    }
}

//MARK: FOR ENABLE SCROLLING BETWEEN THE TABS UNCOMMENT THESE CODES

//extension TabBarViewController: UIScrollViewDelegate{
//    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset.x
//        let screenWidth = UIScreen.main.bounds.width
//        let index = Int(round(offset / screenWidth))
//
//        switch index {
//        case 0:  selectedTab = .chat
//        case 1:  selectedTab = .discover
//        case 2:  selectedTab = .create
//        case 3:  selectedTab = .profile
//        default: break
//        }
//    }
//}
