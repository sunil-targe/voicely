import Foundation
import RevenueCat

extension Notification.Name {
    static let purchasesCustomerInfoUpdated = Notification.Name("PurchasesCustomerInfoUpdated")
}

class PurchaseViewModel: ObservableObject {
    static let shared = PurchaseViewModel()
    
    @Published var isPremium: Bool = false
    
    private init() {
        // Listen for RevenueCat customer info updates via NotificationCenter
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(customerInfoUpdated),
            name: .purchasesCustomerInfoUpdated,
            object: nil
        )
        // Initial check
        fetchPremiumStatus()
    }
    
    func fetchPremiumStatus() {
        Purchases.shared.getCustomerInfo { [weak self] customerInfo, error in
            DispatchQueue.main.async {
                if let info = customerInfo {
                    self?.updatePremiumStatus(from: info)
                }
            }
        }
    }
    
    // Call this method after paywall is dismissed to refresh purchase status
    func refreshPurchaseStatus() {
        // Add a small delay to ensure RevenueCat has processed the purchase
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fetchPremiumStatus()
        }
    }
    
    @objc private func customerInfoUpdated(notification: Notification) {
        guard let info = notification.userInfo?["customerInfo"] as? CustomerInfo else { return }
        DispatchQueue.main.async {
            self.updatePremiumStatus(from: info)
        }
    }
    
    private func updatePremiumStatus(from customerInfo: CustomerInfo) {
        // Replace "premium" with your actual entitlement identifier if needed
        if let _ = customerInfo.entitlements.active.first(where: { $0.value.isActive }) {
            isPremium = true
        } else {
            isPremium = false
        }
    }
} 
