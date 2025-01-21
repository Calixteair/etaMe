import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var dishes: [Dish] = []

    func fetchDishes() {
        let baseURL = ServerConfig().getBaseUrl()
        guard let url = URL(string: "\(baseURL)/api/dishes") else { return }

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


