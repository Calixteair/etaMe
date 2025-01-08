import SwiftUI

struct DishDetailView: View {
    var dish: Dish
    var idClient:Int
    @State private var quantity: Int = 1
    @State private var isAdding: Bool = false
    @State private var feedbackMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: dish.URLimage)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } placeholder: {
                Color.gray.opacity(0.3)
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            
            Text(dish.name)
                .font(.title)
                .fontWeight(.bold)
            
            Text(dish.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            HStack {
                Text("Calories: \(dish.calories)")
                Spacer()
                Text("Proteins: \(dish.proteins)g")
                Spacer()
                Text("Carbs: \(dish.carbs)g")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            Text("$\(dish.price, specifier: "%.2f")")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            // Quantité
            HStack {
                HStack {
                                Text("Quantity:")
                                    .font(.headline)
                                
                                Text("\(quantity)")
                                    .font(.body)
                                    .frame(width: 50, alignment: .leading) // Largeur pour le nombre
                            }
                Stepper("\(quantity)", value: $quantity, in: 1...99)
                    .frame(width: 100)
            }
            if let feedbackMessage = feedbackMessage {
                Text(feedbackMessage)
                    .foregroundColor(.green)
            }
                        
            // Bouton Ajouter au panier
            Button(action: addToOrder) {
                if isAdding {
                    ProgressView()
                } else {
                    Text("Add to Order")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(isAdding)
            
            // Message de feedback
          
        }
        .padding()
        .navigationTitle(dish.name)
    }
    
    // MARK: - Ajouter au panier
    func addToOrder() {
        isAdding = true
        feedbackMessage = nil
        
        OrderService.shared.addItemToOrder(clientId: idClient, dishId: dish.id, quantity: quantity) { result in
            DispatchQueue.main.async {
                isAdding = false
                switch result {
                case .success:
                    feedbackMessage = "Dish successfully added to your order!"
                case .failure(let error):
                    feedbackMessage = "Failed to add dish: \(error.localizedDescription)"
                }
            }
        }
    }
}
