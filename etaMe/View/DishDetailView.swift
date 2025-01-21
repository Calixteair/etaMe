import SwiftUI

struct DishDetailView: View {
    @StateObject private var viewModel: DishDetailViewModel

    init(dish: Dish, idClient: Int) {
        _viewModel = StateObject(wrappedValue: DishDetailViewModel(clientId: idClient, dish: dish))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Image du plat
                AsyncImage(url: URL(string: viewModel.dish.URLimage)) { image in
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

                Text(viewModel.dish.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(viewModel.dish.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                HStack(spacing: 20) {
                    NutritionInfo(title: "Calories", value: "\(viewModel.dish.calories)")
                    NutritionInfo(title: "Proteins", value: "\(viewModel.dish.proteins)g")
                    NutritionInfo(title: "Carbs", value: "\(viewModel.dish.carbs)g")
                }
                .padding(.horizontal)

                Text("$\(viewModel.dish.price, specifier: "%.2f")")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.top)

                HStack {
                    Text("Quantity:")
                        .font(.headline)
                    Stepper("\(viewModel.quantity)", value: $viewModel.quantity, in: 1...99)
                        .frame(maxWidth: 150)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)

                Button(action: viewModel.addToOrder) {
                    if viewModel.isAdding {
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
                .disabled(viewModel.isAdding)
                .padding(.horizontal)

                if let feedbackMessage = viewModel.feedbackMessage {
                    Text(feedbackMessage)
                        .font(.callout)
                        .foregroundColor(feedbackMessage.contains("successfully") ? .green : .red)
                        .padding(.top)
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.dish.name)
        .navigationBarTitleDisplayMode(.inline)
    }

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
}
