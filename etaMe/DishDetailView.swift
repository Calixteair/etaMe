import SwiftUI

struct DishDetailView: View {
    var dish: Dish
    var idClient: Int
    @State private var quantity: Int = 1
    @State private var isAdding: Bool = false
    @State private var feedbackMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Image du plat
                AsyncImage(url: URL(string: dish.URLimage)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 10)
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            ProgressView()
                        )
                }
                .padding(.horizontal)

                // Nom du plat
                Text(dish.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                // Description
                Text(dish.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                // Informations nutritionnelles
                HStack(spacing: 20) {
                    NutritionInfo(title: "Calories", value: "\(dish.calories)")
                    NutritionInfo(title: "Proteins", value: "\(dish.proteins)g")
                    NutritionInfo(title: "Carbs", value: "\(dish.carbs)g")
                }
                .padding(.horizontal)

                // Prix
                Text("$\(dish.price, specifier: "%.2f")")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.top)

                // Sélection de la quantité
                HStack {
                    Text("Quantity:")
                        .font(.headline)
                    Stepper("\(quantity)", value: $quantity, in: 1...99)
                        .frame(maxWidth: 150)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)

                // Bouton Ajouter au panier
                Button(action: addToOrder) {
                    if isAdding {
                        ProgressView()
                    } else {
                        Text("Add to Order")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                }
                .disabled(isAdding)
                .padding(.horizontal)

                // Message de feedback
                if let feedbackMessage = feedbackMessage {
                    Text(feedbackMessage)
                        .font(.callout)
                        .foregroundColor(feedbackMessage.contains("successfully") ? .green : .red)
                        .padding(.top)
                }
            }
            .padding()
        }
        .navigationTitle(dish.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // Vue personnalisée pour les infos nutritionnelles
    private func NutritionInfo(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
        }
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
