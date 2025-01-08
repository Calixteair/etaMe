import Foundation

class OrderService {
    static let shared = OrderService()
    private let baseURL = "http://\(ServerConfig.serverIP):\(ServerConfig.port)/api/orders"
    
    // Récupérer la commande en cours pour un client
    func fetchOrder(for clientId: Int, completion: @escaping (Result<Order, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(clientId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let order = try JSONDecoder().decode(Order.self, from: data)
                completion(.success(order))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Ajouter un article
    func addItem(clientId: Int, dishId: Int, quantity: Int, pricePerDish: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/addItem") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "idClient": clientId,
            "idDish": dishId,
            "quantity": quantity,
            "pricePerDish": pricePerDish
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }.resume()
    }
    
    // Ajuster ou supprimer un article
    func adjustItem(clientId: Int, dishId: Int, quantity: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/adjustItem") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "idClient": clientId,
            "idDish": dishId,
            "quantity": quantity
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }.resume()
    }
    
    // Finaliser une commande
    func finalizeOrder(orderId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/finalize") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "idOrder": orderId
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }.resume()
    }
}
