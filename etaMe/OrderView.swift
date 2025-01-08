import SwiftUI

struct OrderView: View {
    let clientId: Int
    @State private var orders: [Order] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading orders...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if orders.isEmpty {
                    Text("No orders found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(orders) { order in
                        OrderRow(order: order)
                    }
                }
            }
            .navigationTitle("Orders")
            .onAppear {
                fetchOrders()
            }
        }
    }
    
    func fetchOrders() {
        isLoading = true
        errorMessage = nil
        
        OrderService.shared.fetchOrders(for: clientId) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let fetchedOrders):
                    self.orders = fetchedOrders
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

// MARK: - OrderRow View
struct OrderRow: View {
    let order: Order
    
    var body: some View {
        NavigationLink(destination: OrderDetailView(orderId: order.id)) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Order ID: \(order.id)")
                        .font(.headline)
                    Text("Quantity: \(order.quantity)")
                        .font(.subheadline)
                }
                Spacer()
                Text(String(format: "$%.2f", order.totalPrice))
                    .font(.headline)
            }
            .padding(.vertical, 5)
        }
    }
}


// MARK: - Preview
struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            OrderView(clientId: 1)
                .tabItem {
                    Label("Order", systemImage: "cart")
                }
        }
    }
}
