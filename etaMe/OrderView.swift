import SwiftUI

struct OrderView: View {
    let clientId: Int
    @State private var order: Order = Order(id: nil, clientId: 0, items: [])
    @State private var isLoading = false
    @State private var errorMessage: ErrorMessage?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else {
                List {
                    ForEach(order.items) { item in
                        HStack {
                            Text("Dish ID: \(item.dish_id)")
                            Spacer()
                            Text("Quantity: \(item.quantity)")
                            Stepper("", value: Binding(
                                get: { item.quantity },
                                set: { newValue in
                                    adjustItem(dishId: item.dish_id, quantity: newValue)
                                }
                            ), in: 0...100)
                        }
                    }
                }
                
                HStack {
                    Text("Total: $\(order.total, specifier: "%.2f")")
                    Button("Finalize Order") {
                        finalizeOrder()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .onAppear(perform: loadOrder)
        .alert(item: $errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func loadOrder() {
        isLoading = true
        OrderService.shared.fetchOrder(for: clientId) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let fetchedOrder):
                    self.order = fetchedOrder
                case .failure(let error):
                    self.errorMessage = ErrorMessage(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func adjustItem(dishId: Int, quantity: Int) {
        OrderService.shared.adjustItem(clientId: clientId, dishId: dishId, quantity: quantity) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    loadOrder()
                case .failure(let error):
                    self.errorMessage = ErrorMessage(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func finalizeOrder() {
        guard let orderId = order.id else { return }
        OrderService.shared.finalizeOrder(orderId: orderId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    loadOrder()
                case .failure(let error):
                    self.errorMessage = ErrorMessage(message: error.localizedDescription)
                }
            }
        }
    }
}
