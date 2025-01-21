import Foundation
struct ProfileService {

    static var baseURL = ServerConfig().getBaseUrl()

    // MARK: - Fetch User Profile
    static func fetchUserProfile(
        clientId: Int,
        onCompletion: @escaping (_ success: Bool, _ profile: UserProfile?, _ errorMessage: String?) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/api/auth/\(clientId)") else {
            onCompletion(false, nil, "Invalid server URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    onCompletion(false, nil, "Network error: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    onCompletion(false, nil, "Failed to fetch profile. Please try again.")
                    return
                }

                guard let data = data else {
                    onCompletion(false, nil, "No data received from server")
                    return
                }

                do {
                    let profile = try JSONDecoder().decode(UserProfile.self, from: data)
                    onCompletion(true, profile, nil)
                } catch {
                    onCompletion(false, nil, "Failed to parse server response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    // MARK: - Update User Profile
    static func updateUserProfile(
        profile: UserProfile,
        onCompletion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/api/auth/update/\(profile.idClient)") else {
            onCompletion(false, "Invalid server URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(profile)
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        onCompletion(false, "Network error: \(error.localizedDescription)")
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        onCompletion(false, "Failed to update profile. Please try again.")
                        return
                    }

                    onCompletion(true, nil)
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                onCompletion(false, "Failed to encode profile data: \(error.localizedDescription)")
            }
        }
    }
}
