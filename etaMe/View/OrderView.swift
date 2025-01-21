import SwiftUI

struct OrderView: View {
    @ObservedObject var orderViewModel: OrderViewModel
    @ObservedObject var appViewModel: AppViewModel

    var body: some View {
        NavigationView {
            VStack {
                if orderViewModel.isLoading {
                    ProgressView("Loading orders...")
                        .padding()
                        .foregroundColor(.accentColor)
                } else if let errorMessage = orderViewModel.errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else if orderViewModel.orders.isEmpty {
                    VStack {
                        Image(systemName: "cart.badge.minus")
                            .font(.largeTitle)
                        Text("No orders found.")
                            .padding()
                    }
                } else {
                    List(orderViewModel.orders) { order in
                        OrderRow(order: order, appViewModel: appViewModel)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("🛒 Orders")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                orderViewModel.fetchOrders(for: appViewModel.clientId)
            }
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        }
    }
}

