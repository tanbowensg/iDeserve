/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void
public typealias PurchaseCompletionHandler = (_ success: Bool) -> Void


extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

open class IAPHelper: NSObject {
    private let productIdentifiers: Set<ProductIdentifier>
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    private var purchaseCompletionHandler: PurchaseCompletionHandler?
    private var products: [SKProduct] = []
    
    public init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds
        for productIdentifier in productIds {
            //      if productIdentifier.hasPrefix(IAPS.consumablesPrefix) {
            //        let amountPurchased = UserDefaults.standard.integer(forKey: productIdentifier)
            //        if amountPurchased != 0 {
            //          print("Remaining purchased amount: \(productIdentifier)")
            //        }
            //      } else {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            } else {
                print("Not purchased: \(productIdentifier)")
            }
            //      }
            //    }
        }
        super.init()
        SKPaymentQueue.default().add(self)
    }
}

// MARK: - StoreKit API

extension IAPHelper {
    public func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        if let request = productsRequest {
            request.delegate = self
            request.start()
        }
    }
    
    public func buyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func requestProductsAndBuy(productIdentifier: String, completionHandler: @escaping PurchaseCompletionHandler) {
        self.requestProducts { [self] success, products in
            guard success, let products = products else {
                return completionHandler(false)
            }
            
            let results = products.filter { product -> Bool in
                print(product)
                if product.productIdentifier == productIdentifier {
                    return true
                }
                return false
            }
            
            if let product = results.first {
                purchaseCompletionHandler = completionHandler
                
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(payment)
            } else {
                completionHandler(false)
            }
        }
    }
    
    public func buyProduct(productIdentifier: String, completionHandler: @escaping PurchaseCompletionHandler) {
        print("Buying \(productIdentifier)...")
        
        let results = products.filter { product -> Bool in
            if product.productIdentifier == productIdentifier {
                return true
            }
            return false
        }
        
        if let product = results.first {
            purchaseCompletionHandler = completionHandler
            
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    //  public func receiptContains(_ productIdentifier: String) -> Bool {
    //    let receipt = Receipt()
    //
    //    let purchased = receipt.inAppReceipts.filter { iapReceipt -> Bool in
    //      return iapReceipt.productIdentifier == productIdentifier
    //    }
    //
    //    return !purchased.isEmpty
    //  }
    //
    //  public func checkSubscriptionExpiry(_ productIdentifier: String) -> Bool {
    //    let receipt = Receipt()
    //
    //    let purchased = receipt.inAppReceipts.filter { iapReceipt -> Bool in
    //      return iapReceipt.productIdentifier == productIdentifier
    //    }
    //
    //    if let expiryDate = purchased.first?.subscriptionExpirationDate {
    //      print(expiryDate.description)
    //
    //      let expiryTimestamp: Double = expiryDate.timeIntervalSince1970
    //      let timestamp: Double = Date().timeIntervalSince1970
    //
    //      if timestamp >= expiryTimestamp {
    //        purchasedProductIdentifiers.remove(productIdentifier)
    //        UserDefaults.standard.removeObject(forKey: productIdentifier)
    //        return true
    //      } else {
    //        return false
    //      }
    //    }
    //    return true
    //  }
}

// MARK: - Helpers

extension IAPHelper {
    static func priceFor(_ product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate, SKRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        self.products = products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for prod in products {
            print("Found product: \(prod.productIdentifier) \(prod.localizedTitle) \(prod.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction)
            case .failed:
                fail(transaction)
            case .restored:
                restore(transaction)
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    public func paymentQueue(
        _ queue: SKPaymentQueue,
        didRevokeEntitlementsForProductIdentifiers productIdentifiers: [String]
    ) {
        for identifier in productIdentifiers {
            purchasedProductIdentifiers.remove(identifier)
            UserDefaults.standard.removeObject(forKey: identifier)
            deliverPurchaseNotificationFor(identifier: identifier)
        }
    }
    
    private func complete(_ transaction: SKPaymentTransaction) {
        print("complete...")
        persistPurchase(identifier: transaction.payment.productIdentifier)
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(_ transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        persistPurchase(identifier: productIdentifier)
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(_ transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?,
           let localizedDescription = transaction.error?.localizedDescription,
           transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        SKPaymentQueue.default().finishTransaction(transaction)
        purchaseCompletionHandler?(false)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
        }
        purchaseCompletionHandler?(true)
    }
    
    private func persistPurchase(identifier: String?) {
        guard let identifier = identifier else { return }
        
        purchasedProductIdentifiers.insert(identifier)
        
        //    if !identifier.hasPrefix(IAPS.consumablesPrefix) {
        UserDefaults.standard.set(true, forKey: identifier)
        //    } else {
        //      if let amount = Int(identifier.split(separator: ".").last ?? "") {
        //        let remainingAmount = UserDefaults.standard.integer(forKey: IAPS.consumablesPrefix)
        //        UserDefaults.standard.set(remainingAmount + amount, forKey: IAPS.consumablesPrefix)
        //      }
        //    }
    }
}
