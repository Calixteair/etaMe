import Foundation

class DishDetailViewModel: ObservableObject {
    @Published var quantity: Int = 1
    @Published var isAdding: Bool = false
    @Published var feedbackMessage: String?
    @Published var isAdded: Bool = false


     let clientId: Int
     let dish: Dish

    init(clientId: Int, dish: Dish) {
        self.clientId = clientId
        self.dish = dish
    }

    func addToOrder() {
        isAdding = true
        feedbackMessage = nil

        OrderService.shared.addItemToOrder(clientId: clientId, dishId: dish.id, quantity: quantity) { result in
            DispatchQueue.main.async {
                self.isAdding = false
                self.isAdded = true
                switch result {
                case .success:
                    self.feedbackMessage = "Dish successfully added to your order!"
                case .failure(let error):
                    self.feedbackMessage = "Failed to add dish: \(error.localizedDescription)"
                }
            }
        }
    }
}
