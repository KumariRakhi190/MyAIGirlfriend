//
//  IAPHandler.swift
//  AIGirlFriend
//
//  Created by Rakhi on 24/07/23.
//

import UIKit
import StoreKit

enum IAPHandlerAlertType {
    case setProductIds
    case disabled
    case restored
    case purchased
    
    var message: String{
        switch self {
            case .setProductIds: return "Product ids not set, call setProductIds method!"
            case .disabled: return "Purchases are disabled in your device!"
            case .restored: return "You've successfully restored your purchase!"
            case .purchased: return "You've successfully bought this purchase!"
        }
    }
}


class IAPHandler: NSObject {
    
    //MARK:- Shared Object
    //MARK:-
    static let shared = IAPHandler()
    private override init() { }
    
    //MARK:- Properties
    //MARK:- Private
    fileprivate var productIds = [Constants.purchaseProductId]
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var fetchProductComplition: (([SKProduct])->Void)?
    
    fileprivate var productToPurchase: SKProduct?
    fileprivate var purchaseProductComplition: ((IAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)?
    
    //MARK:- Public
    var isLogEnabled: Bool = true
    
    //MARK:- Methods
    //MARK:- Public
    
    //Set Product Ids
    func setProductIds(ids: [String]) {
        self.productIds = ids
    }
    
    //MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchase(product: SKProduct, complition: @escaping ((IAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)) {
        
        self.purchaseProductComplition = complition
        self.productToPurchase = product
        
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            log("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
        }
        else {
            complition(IAPHandlerAlertType.disabled, nil, nil)
        }
    }
    
    // RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(complition: @escaping (([SKProduct])->Void)){
        
        self.fetchProductComplition = complition
        // Put here your IAP Products ID's
        if self.productIds.isEmpty {
            log(IAPHandlerAlertType.setProductIds.message)
            fatalError(IAPHandlerAlertType.setProductIds.message)
        }
        else {
            productsRequest = SKProductsRequest(productIdentifiers: Set(self.productIds))
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
    
    //MARK:- Private
    fileprivate func log <T> (_ object: T) {
        if isLogEnabled {
            NSLog("\(object)")
        }
    }
}

//MARK:- Product Request Delegate and Payment Transaction Methods
//MARK:-
extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate{
    
    // REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        stopAnimating()
        if (response.products.count > 0) {
            if let complition = self.fetchProductComplition {
                complition(response.products)
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if let complition = self.purchaseProductComplition {
            complition(IAPHandlerAlertType.restored, nil, nil)
        }
    }
    
    // IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    case .purchased:
                        log("Product purchase done")
                        stopAnimating()
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                        if let complition = self.purchaseProductComplition {
                            complition(IAPHandlerAlertType.purchased, self.productToPurchase, trans)
                        }
                        break
                        
                    case .failed:
                        log("Product purchase failed")
                        stopAnimating()
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                        break
                        
                    case .restored:
                        stopAnimating()
                        log("Product restored")
                        DatabaseManager.shared.updateSubscriptionStatus(isSubscribed: true) { error in
                            PublicAccess.shared.topViewController?.dismiss(animated: true)
                        }
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                        break
                        
                    default:
                        break
                }}}
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        stopAnimating()
    }
    
    func refreshReceipt(){
        let request = SKReceiptRefreshRequest(receiptProperties: nil)
        request.delegate = self
        request.start()
    }
    
    func refreshSubscription(){
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
           FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                let receiptString = receiptData.base64EncodedString(options: [])
                let params = ["receipt-data": receiptString ,"password" : Constants.secretKey, "exclude-old-transactions" : true] as [String : Any]
                verifyReceiptOnAppStore(params)
            }
            catch {
                print("Couldn't read receipt data with error: " + error.localizedDescription)
                
            }
        }
    }
    
    func verifyReceiptOnAppStore(_ parameters : [String : Any]) {
        let storeURL = URL(string: "https://buy.itunes.apple.com/verifyReceipt")
        var request = URLRequest(url: storeURL!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = "POST"
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let jsonDict = try? JSONSerialization.jsonObject(with: data ?? .init()) as? [String: Any]{
                if jsonDict["status"] as? Int64 == 21007{
                    print("Not on Store , It will be SandBox")
                    self.verifyReceiptOnSandBox(parameters)
                }
                else{
                    self.handleSubscriptionExpiry(jsonDict: jsonDict)
                }
            }
        }.resume()
    }
    
    func verifyReceiptOnSandBox(_ parameters : [String : Any],isFromPurchase:Bool? = false) {
        let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = "POST"
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let jsonDict = try? JSONSerialization.jsonObject(with: data ?? .init()) as? [String: Any]{
                self.handleSubscriptionExpiry(jsonDict: jsonDict)
            }
        }.resume()
        
    }
    
    func handleSubscriptionExpiry(jsonDict: [String: Any]){
        if let latestReceipt = (jsonDict["latest_receipt_info"] as? [[String : Any]])?.first{
            if let expiryTimestamp = Double(latestReceipt["expires_date_ms"] as? String ?? .init()){
                let expiryDate = Date(timeIntervalSince1970: expiryTimestamp/1000)
                if PublicAccess.shared.currentUtcDateTime ?? Date() > expiryDate{
                    DatabaseManager.shared.updateSubscriptionStatus(isSubscribed: false, completion: { error in})
                }
                else{
                    DatabaseManager.shared.updateSubscriptionStatus(isSubscribed: true, completion: { error in})
                }
            }
        }
    }
}
