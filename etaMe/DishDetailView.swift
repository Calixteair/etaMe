import SwiftUI
struct DishDetailView: View {
    var dish: Dish
    
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
                .font(.largeTitle)
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
            .padding(.horizontal)
            
            Text("$\(dish.price, specifier: "%.2f")")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Spacer()
        }
        .padding()
        .navigationTitle(dish.name)
    }
}
