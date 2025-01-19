import SwiftUI

struct OrderDetailView: View {
    let orderId: Int
    let clientId: Int
    let orderValided: Bool
    @State private var dishes: [DishOrder] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var isFinalizing: Bool = false // État pour le bouton de finalisation
    @Environment(\.presentationMode) var presentationMode // Pour revenir en arrière

    var totalAmount: Double {
        dishes.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading order details...")
                    .padding()
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if dishes.isEmpty {
                Text("No dishes found for this order.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach($dishes) { $dish in
                        DishRow(
                            dish: $dish,
                            onQuantityChange: { updatedDish in
                                updateDish(updatedDish)
                            },
                            onUpdateQuantity: { dishId, quantity in
                                updateQuantityAPI(dishId: dishId, quantity: quantity)
                            },
                            onRemoveDish: { dishId in
                                removeDish(dishId: dishId)
                            },
                            orderValided: orderValided
                        )
                    }
                }
                
                // Affichage du total
                HStack {
                    Text("Total: ")
                        .font(.headline)
                    Spacer()
                    Text("\(totalAmount, specifier: "%.2f") $")
                        .font(.headline)
                }
                .padding()
            }

            // Bouton de finalisation
            if !orderValided {
                Button(action: finalizeOrder) {
                    if isFinalizing {
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
                .disabled(isFinalizing) // Désactiver le bouton pendant la requête
            }
        }
        .navigationTitle("Order Details")
        .onAppear {
            fetchOrderDetails()
        }
    }

    func fetchOrderDetails() {
        isLoading = true
        errorMessage = nil

        OrderService.shared.fetchOrderDetails(for: orderId) { result in
            DispatchQueue.main.async {
                isLoading = false

                switch result {
                case .success(let fetchedDishes):
                    self.dishes = fetchedDishes
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func updateDish(_ updatedDish: DishOrder) {
        if let index = dishes.firstIndex(where: { $0.id == updatedDish.id }) {
            dishes[index] = updatedDish
        }
    }

    func updateQuantityAPI(dishId: Int, quantity: Int) {
        OrderService.shared.addItemToOrder(clientId: clientId, dishId: dishId, quantity: quantity) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Successfully updated quantity for dish \(dishId).")
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    func removeDish(dishId: Int) {
        OrderService.shared.removeDishFromOrder(clientId: clientId, dishId: dishId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    dishes.removeAll { $0.id == dishId }
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    func finalizeOrder() {
        isFinalizing = true
        errorMessage = nil

        OrderService.shared.finalizeOrder(orderId: orderId) { result in
            DispatchQueue.main.async {
                isFinalizing = false

                switch result {
                case .success:
                    print("Order finalized successfully.")
                    // Retour à la vue précédente
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

// MARK: - DishRow View
struct DishRow: View {
    @Binding var dish: DishOrder
    var onQuantityChange: (DishOrder) -> Void
    var onUpdateQuantity: (Int, Int) -> Void
    var onRemoveDish: (Int) -> Void
    var orderValided: Bool // Nouvelle propriété

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: dish.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                Color.gray.frame(width: 50, height: 50)
            }
            
            VStack(alignment: .leading) {
                Text(dish.name)
                    .font(.headline)
                Text(dish.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack {
                Text("\(dish.price * Double(dish.quantity), specifier: "%.2f") $")
                    .font(.headline)
                if orderValided {
                    Text("x\(dish.quantity)")
                        .font(.subheadline)
                        .padding(.horizontal, 5)
                }
                
                if !orderValided { // Afficher uniquement si la commande n'est pas validée
                    HStack {
                        Button(action: {
                            if dish.quantity > 1 {
                                dish.quantity -= 1
                                onQuantityChange(dish)
                                onUpdateQuantity(dish.id, -1)
                            }
                        }) {
                            Image(systemName: "minus.circle")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Text("x\(dish.quantity)")
                            .font(.subheadline)
                            .padding(.horizontal, 5)
                        
                        Button(action: {
                            dish.quantity += 1
                            onQuantityChange(dish)
                            onUpdateQuantity(dish.id, +1)
                        }) {
                            Image(systemName: "plus.circle")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    
                    Button(action: {
                        onRemoveDish(dish.id)
                    }) {
                        Text("Remove")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    .padding(.top, 5)
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
        .padding(.vertical, 5)
        .contentShape(Rectangle())
    }
}
	
