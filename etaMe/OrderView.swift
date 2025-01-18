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
                        .foregroundColor(.accentColor)
                } else if let errorMessage = errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else if orders.isEmpty {
                    VStack {
                        Image(systemName: "cart.badge.minus")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No orders found.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                } else {
                    List(orders) { order in
                        OrderRow(order: order, clientId: clientId)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("🛒 Orders")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                fetchOrders()
            }
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
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
                    // Trier les commandes : "en cours" en premier
                    self.orders = fetchedOrders.sorted { $0.status == "en cours" && $1.status != "en cours" }
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
    let clientId: Int

    var body: some View {
        NavigationLink(destination: OrderDetailView(orderId: order.id, clientId: clientId,orderValided: order.status == "validée")) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Order ID: \(order.id)")
                        .font(.headline)
                    Text("Quantity: \(order.quantity)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack {
                        Text("Status:")
                            .font(.subheadline)
                        Text(order.status)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(statusColor(for: order.status))
                            .padding(4)
                            .background(statusColor(for: order.status).opacity(0.2))
                            .cornerRadius(5)
                    }
                }
                Spacer()
                VStack {
                    Text(String(format: "$%.2f", order.totalPrice))
                        .font(.headline)
                    	
                }
            }
            .padding(.vertical, 8)
        }
    }

    func statusColor(for status: String) -> Color {
        switch status {
        case "validée":
            return .green
        case "en cours":
            return .orange
        default:
            return .gray
        }
    }
}

// MARK: - Preview
struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            OrderView(clientId: 1)
                .tabItem {
                    Label("Orders", systemImage: "cart.fill")
                }
        }
    }
}
