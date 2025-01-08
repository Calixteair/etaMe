import SwiftUI

struct OrderDetailView: View {
    let orderId: Int
    @State private var dishes: [DishOrder] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
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
                List(dishes) { dish in
                    DishRow(dish: dish)
                }
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
}

// MARK: - DishRow View
struct DishRow: View {
    let dish: DishOrder
    
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
                Text("x\(dish.quantity)")
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 5)
    }
}
