import Foundation
import SwiftUI

struct AuthService {
    
    // MARK: - Register User
    static func registerUser(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        dateOfBirth: Date,
        extraNapkins: Bool,
        frequentRefill: Bool,
        onCompletion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void
    ) {
        guard let url = URL(string: "http://\(ServerConfig.serverIP):\(ServerConfig.port)/api/auth/register") else {
            onCompletion(false, "Invalid server URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dateFormatter = ISO8601DateFormatter()
        let formattedDate = dateFormatter.string(from: dateOfBirth)
        
        let registerData: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "password": password,
            "date_of_birth": formattedDate,
            "extra_napkins": extraNapkins,
            "frequent_refill": frequentRefill
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: registerData)
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        onCompletion(false, "Network error: \(error.localizedDescription)")
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                        onCompletion(true, nil)
                    } else {
                        onCompletion(false, "Failed to register. Please try again.")
                    }
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                onCompletion(false, "Failed to encode registration data: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Login User
    static func loginUser(
        email: String,
        password: String,
        onCompletion: @escaping (_ success: Bool, _ clientId: Int?, _ firstName: String?, _ errorMessage: String?) -> Void
    ) {
        guard let url = URL(string: "http://\(ServerConfig.serverIP):\(ServerConfig.port)/api/auth/login") else {
            onCompletion(false, nil, nil, "Invalid server URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginData: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loginData)
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        onCompletion(false, nil, nil, "Network error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        onCompletion(false, nil, nil, "Invalid server response")
                        return
                    }
                    
                    guard httpResponse.statusCode == 200 else {
                        onCompletion(false, nil, nil, "Invalid email or password (Status code: \(httpResponse.statusCode))")
                        return
                    }
                    
                    guard let data = data else {
                        onCompletion(false, nil, nil, "No data received from server")
                        return
                    }
                    
                    do {
                        if let responseDict = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let clientIdValue = responseDict["id"] as? Int,
                           let firstNameValue = responseDict["first_name"] as? String {
                            onCompletion(true, clientIdValue, firstNameValue, nil)
                        } else {
                            onCompletion(false, nil, nil, "Invalid server response format")
                        }
                    } catch {
                        onCompletion(false, nil, nil, "Failed to parse server response: \(error.localizedDescription)")
                    }
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                onCompletion(false, nil, nil, "Failed to encode login data: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Logout User
    static func logoutUser(
        isLoggedIn: Binding<Bool>,
        clientId: Binding<Int?>,
        firstName: Binding<String>
    ) {
        isLoggedIn.wrappedValue = false
        clientId.wrappedValue = nil
        firstName.wrappedValue = ""
    }
    
    // MARK: - Fetch User Data
    static func fetchUserData(
        clientId: Int,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        guard let url = URL(string: "http://\(ServerConfig.serverIP):\(ServerConfig.port)/api/user/\(clientId)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -2, userInfo: nil)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(NSError(domain: "Invalid JSON format", code: -3, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
