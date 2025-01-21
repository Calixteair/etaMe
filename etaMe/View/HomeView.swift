import SwiftUI
struct HomeView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var appViewModel: AppViewModel


    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack {
                    Text("Hey, \(appViewModel.firstName)!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 20)

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

                // List of Dishes
                List(homeViewModel.dishes) { dish in
                    NavigationLink(destination: DishDetailView(dish: dish, idClient: appViewModel.clientId)) {
                        HStack(alignment: .center, spacing: 16) {
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
                .navigationTitle("Our Menu")
                .onAppear {
                    homeViewModel.fetchDishes()
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}
