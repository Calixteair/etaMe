import SwiftUI

class OrderViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchOrders(for clientId: Int) {
        isLoading = true
        errorMessage = nil

        OrderService.shared.fetchOrders(for: clientId) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let fetchedOrders):
                    // Trier les commandes : "en cours" en premier
                    self.orders = fetchedOrders.sorted { $0.status == "en cours" && $1.status != "en cours" }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
