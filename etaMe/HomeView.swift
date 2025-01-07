import SwiftUI

struct HomeView: View {
    let firstName: String
    @State private var dishes: [Dish] = []

    var body: some View {
           NavigationView {
               VStack(spacing: 0) {
                   // En-tête personnalisé
                   VStack {
                       Text("Welcome, \(firstName)!")
                           .font(.system(size: 28, weight: .bold))
                           .foregroundColor(.white)
                           .padding(.top, 60)
                       
                       Text("Discover delicious meals curated for you")
                           .font(.system(size: 16))
                           .foregroundColor(.white.opacity(0.8))
                           .padding(.bottom, 20)
                   }
                   .frame(maxWidth: .infinity)
                   .background(
                       LinearGradient(
                           gradient: Gradient(colors: [.blue, .purple]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing
                       )
                   )
                   .cornerRadius(20)
                   .padding(.horizontal)
                   
                   // Liste des plats
                   List(dishes) { dish in
                       NavigationLink(destination: DishDetailView(dish: dish)) {
                           HStack(alignment: .center, spacing: 16) {
                               // Image du plat
                               AsyncImage(url: URL(string: dish.URLimage)) { image in
                                   image
                                       .resizable()
                                       .aspectRatio(contentMode: .fill)
                                       .frame(width: 80, height: 80)
                                       .clipShape(RoundedRectangle(cornerRadius: 10))
                               } placeholder: {
                                   Color.gray.opacity(0.3)
                                       .frame(width: 80, height: 80)
                                       .clipShape(RoundedRectangle(cornerRadius: 10))
                               }
                               
                               // Détails du plat
                               VStack(alignment: .leading, spacing: 6) {
                                   Text(dish.name)
                                       .font(.headline)
                                       .foregroundColor(.primary)
                                   
                                   Text(dish.description)
                                       .font(.subheadline)
                                       .foregroundColor(.secondary)
                                       .lineLimit(2)
                                   
                                   HStack {
                                       Text("\(dish.calories) kcal")
                                           .font(.caption)
                                           .foregroundColor(.green)
                                       
                                       Spacer()
                                       
                                       Text("$\(dish.price, specifier: "%.2f")")
                                           .font(.headline)
                                           .foregroundColor(.blue)
                                   }
                               }
                           }
                           .padding(8)
                       }
                       .listRowSeparator(.hidden)
                   }
                   .listStyle(.plain)
                   .navigationTitle("🍽️ Our Menu")
                   .onAppear {
                       fetchDishes()
                   }
               }
               .background(Color(.systemGroupedBackground))
           }
       }

    func fetchDishes() {
        guard let url = URL(string: "http://\( ServerConfig.serverIP):\(ServerConfig.port)/api/dishes") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedDishes = try JSONDecoder().decode([Dish].self, from: data)
                    DispatchQueue.main.async {
                        self.dishes = decodedDishes
                    }
                } catch {
                    print("Error decoding: \(error)")
                }
            }
        }.resume()
    }
}
