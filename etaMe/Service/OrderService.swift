import Foundation

// MARK: - API Error
enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case failedRequest(String)
    case decodingError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from the server"
        case .failedRequest(let message):
            return "Failed request: \(message)"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        }
    }
}

// MARK: - OrderService
class OrderService {
    var baseURL = ServerConfig().getBaseUrl()

    static let shared = OrderService()
    private init() {}
    
    
    
    
    
    func fetchOrders(for clientId: Int, completion: @escaping (Result<[Order], APIError>) -> Void) {
        let clientIdString = String(clientId)
        
        guard let url = URL(string: "\(baseURL)/api/orders/client/\(clientIdString)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.failedRequest(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
          
            do {
                let orders = try JSONDecoder().decode([Order].self, from: data)
                completion(.success(orders))
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }
        
        task.resume()
    }
    
    
    
    // MARK: - Fetch Order Details
    func fetchOrderDetails(for orderId: Int, completion: @escaping (Result<[DishOrder], APIError>) -> Void) {
        let orderIdString = String(orderId)
        
        guard let url = URL(string: "\(baseURL)/api/orders/\(orderIdString)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.failedRequest(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
        
            do {
                let dishes = try JSONDecoder().decode([DishOrder].self, from: data)
                completion(.success(dishes))
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }
        
        task.resume()
    }
    
    // MARK: - Add Item to Order
    func addItemToOrder(clientId: Int, dishId: Int, quantity: Int, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/orders/addItem") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "idClient": clientId,
            "idDish": dishId,
            "quantity": quantity
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            completion(.failure(.decodingError("Failed to encode JSON payload")))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.failedRequest(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.failedRequest("Server returned an error.")))
                return
            }
            
            completion(.success(()))
        }
        
        task.resume()
    }
    
    
    // MARK: - Remove Dish from Order
    func removeDishFromOrder(clientId: Int, dishId: Int, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/orders/remove") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "idClient": clientId,
            "idDish": dishId
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            completion(.failure(.decodingError("Failed to encode JSON payload")))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.failedRequest(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.failedRequest("Server returned an error.")))
                return
            }
            
            completion(.success(()))
        }
        
        task.resume()
    }
    
    
    // MARK: - Finalize Order
    func finalizeOrder(orderId: Int, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/orders/finalize/\(orderId)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.failedRequest(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.failedRequest("Server returned an error.")))
                return
            }
            
            completion(.success(()))
        }
        
        task.resume()
    }





}
