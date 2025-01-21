import SwiftUI

class OrderDetailViewModel: ObservableObject {
    @Published var dishes: [DishOrder] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isFinalizing: Bool = false

    func fetchOrderDetails(orderId: Int) {
        isLoading = true
        errorMessage = nil

        OrderService.shared.fetchOrderDetails(for: orderId) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let fetchedDishes):
                    self.dishes = fetchedDishes
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func updateQuantityAPI(clientId: Int, dishId: Int, quantity: Int) {
        OrderService.shared.addItemToOrder(clientId: clientId, dishId: dishId, quantity: quantity) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Successfully updated quantity for dish \(dishId).")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func removeDish(clientId: Int, dishId: Int) {
        OrderService.shared.removeDishFromOrder(clientId: clientId, dishId: dishId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.dishes.removeAll { $0.id == dishId }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func finalizeOrder(orderId: Int, completion: @escaping () -> Void) {
        isFinalizing = true
        errorMessage = nil

        OrderService.shared.finalizeOrder(orderId: orderId) { result in
            DispatchQueue.main.async {
                self.isFinalizing = false
                switch result {
                case .success:
                    print("Order finalized successfully.")
                    completion()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
