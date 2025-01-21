import SwiftUI
struct OrderDetailView: View {
    @ObservedObject var orderDetailviewModel: OrderDetailViewModel
    @ObservedObject var appViewModel: AppViewModel

    let orderId: Int
    let orderValided: Bool
    @Environment(\.presentationMode) var presentationMode

    var totalAmount: Double {
        orderDetailviewModel.dishes.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    var body: some View {
        VStack {
            if orderDetailviewModel.isLoading {
                ProgressView("Loading order details...")
                    .padding()
            } else if let errorMessage = orderDetailviewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if orderDetailviewModel.dishes.isEmpty {
                Text("No dishes found for this order.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach($orderDetailviewModel.dishes) { $dish in
                        DishRow(
                            viewModel: DishRowViewModel(
                            dish: dish,
                                onQuantityChange: { updatedDish in
                                    orderDetailviewModel.dishes = orderDetailviewModel.dishes.map {
                                        $0.id == updatedDish.id ? updatedDish : $0
                                    }
                                },
                                onUpdateQuantity: { dishId, quantity in
                                    orderDetailviewModel.updateQuantityAPI(clientId: appViewModel.clientId, dishId: dishId, quantity: quantity)
                                },
                                onRemoveDish: { dishId in
                                    orderDetailviewModel.removeDish(clientId: appViewModel.clientId, dishId: dishId)
                                })
                            ,
                            orderValided: orderValided
                        )
                    }
                }

                HStack {
                    Text("Total: ")
                        .font(.headline)
                    Spacer()
                    Text("\(totalAmount, specifier: "%.2f") $")
                        .font(.headline)
                }
                .padding()
            }

            if !orderValided {
                Button(action: {
                    orderDetailviewModel.finalizeOrder(orderId: orderId) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    if orderDetailviewModel.isFinalizing {
                        ProgressView()
                            .padding()
                    } else {
                        Text("Finalize Order")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .disabled(orderDetailviewModel.isFinalizing)
            }
        }
        .navigationTitle("Order Details")
        .onAppear {
            orderDetailviewModel.fetchOrderDetails(orderId: orderId)
        }
    }
}

