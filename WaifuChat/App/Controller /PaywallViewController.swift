//
//  PaywallViewController.swift
//  AIGirlFriend
//
//  Created by Rakhi on 18/09/23.
//

import UIKit
import SDWebImage
import StoreKit
import Mixpanel

class PaywallViewController: UIViewController {
    
    @IBOutlet weak var monthlyDiscountLabel: UILabel!
    @IBOutlet weak var yearlyDiscountLabel: UILabel!
    @IBOutlet weak var planSegmentControl: UISegmentedControl!
    @IBOutlet weak var planDescriptionLabel: UILabel!
    @IBOutlet weak var planImageView: UIImageView!
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var pricingView: UIView!
    @IBOutlet weak var strikeThroughPriceLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pricePerWeekLabel: UILabel!
    @IBOutlet weak var planCollectionView: UICollectionView! {
        didSet {
            planCollectionView.registerCell(type: SusbcriptionCollectionViewCell.self)
        }
    }
    var scrollTimer: Timer?
    var currentIndex = 0
    var character: Character?
    let planItems: [PlanItem] = [
        PlanItem(imageName: "background3", title: "Go Beyond Limits with Premium"),
        PlanItem(imageName: "background4", title: "Intimate messages, No Limits"),
        PlanItem(imageName: "background2", title: "Hot & Stylish Shots, Nonstop"),
        PlanItem(imageName: "background1", title: "Talk as Much as You Want")]
    let plans: [PlanDetail] = [
        PlanDetail(title: "Weekly Plan", description: "Explore Premium Fast", price: "$4.99/week", imageName: "fire"),
        PlanDetail(title: "Monthly Plan", description: "Perfect Monthly Pick", price: "$14.99/month", imageName: "fire"),
        PlanDetail(title: "Yearly Plan", description: "Save Big Yearly", price: "$99.99/year", imageName: "fire")
    ]

    var product: SKProduct?{
        didSet{
            if let product{
                strikeThroughPriceLabel.text = "\(product.priceLocale.currencySymbol ?? .init())\((product.price as Decimal)+20)"
                strikeThroughPriceLabel.strikeThrough(true)
                priceLabel.text = "\(product.priceLocale.currencySymbol ?? .init())\(product.price)"
                pricePerWeekLabel.text = "\(product.priceLocale.currencySymbol ?? .init())\(String(format: "%.2f", product.price.doubleValue/52))/week"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        updatePlanDetails(for: 2)
        Mixpanel.mainInstance().track(event: "Paywall")
        scrollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollCollectionView), userInfo: nil, repeats: true)
        planCollectionView.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let products = PublicAccess.shared.products{
//            self.product = products.first
//        }
//        else{
//            startAnimating()
//            IAPHandler.shared.fetchAvailableProducts { products in
//                PublicAccess.shared.products = products
//                self.product = products.first
//            }
//        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pricingView.layer.borderColor = UIColor.highlight.cgColor
        pricingView.layer.borderWidth = 3
        
    }
    
    @IBAction func didTapDismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapContinue(_ sender: Any) {
        guard let product else {return}
        Mixpanel.mainInstance().track(event: "Click purchase", properties: ["price": "\(product.priceLocale.currencySymbol ?? "$")\(product.price )"])
        startAnimating()
        IAPHandler.shared.purchase(product: product) { alertType, product, transaction in
            stopAnimating()
            if alertType == .purchased{
                Mixpanel.mainInstance().track(event: "Payment success", properties: ["price": "\(product?.priceLocale.currencySymbol ?? "$")\(product?.price ?? .init() )"])
                startAnimating()
                DatabaseManager.shared.updateSubscriptionStatus(isSubscribed: true) { error in
                    stopAnimating()
                    self.dismiss(animated: true)
                }
                PublicAccess.shared.showAlert(viewController: self, title: alertType.message, message: nil)
            }
            else{
                PublicAccess.shared.showAlert(viewController: self, title: alertType.message, message: nil)
            }
        }
    }
    
    @IBAction func didTapRestore(_ sender: Any) {
        startAnimating()
        IAPHandler.shared.restorePurchase()
    }
    
    @IBAction func didTapTermsAndConditions(_ sender: Any) {
        UIApplication.shared.open(Constants.termsOfUseUrl)
    }
    
    @IBAction func didTapPrivacyPolicy(_ sender: Any) {
        UIApplication.shared.open(Constants.privacyPolicyUrl)
    }
    
    
    @IBAction func planSegmentDidTapped(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
            updatePlanDetails(for: selectedIndex)
    }
    
    func initialSetup(){
        planCollectionView.isScrollEnabled = false
        dismissButton.giveShadowAndRoundCorners(shadowOffset: .zero, shadowRadius: 10, opacity: 0.1, shadowColor: .black, cornerRadius: 25)
        strikeThroughPriceLabel.strikeThrough(true)
        monthlyDiscountLabel.roundCorners()
        yearlyDiscountLabel.roundCorners()
        pricingView.addBlur(style: .systemUltraThinMaterial)

    }
    
    func updatePlanDetails(for index: Int) {
        let plan = plans[index]
        planTitleLabel.text = plan.title
        planDescriptionLabel.text = plan.description
        pricePerWeekLabel.text = plan.price
        planImageView.image = UIImage(named: plan.imageName)
    }

    
    @objc func scrollCollectionView() {
        if planItems.isEmpty { return }
        currentIndex = (currentIndex + 1) % planItems.count
        let indexPath = IndexPath(item: currentIndex, section: 0)
        planCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    deinit {
        scrollTimer?.invalidate()
    }


    
}


extension PaywallViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SusbcriptionCollectionViewCell", for: indexPath) as? SusbcriptionCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = planItems[indexPath.item]
        cell.configure(imageName: item.imageName, title: item.title)
        return cell
    }
    
    // Size for item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
