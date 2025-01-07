import SwiftUI

struct AccountView: View {
    @Binding var isLoggedIn: Bool
    @Binding var clientId: Int?
    @Binding var firstName: String

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var lastName: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var extraNapkins: Bool = false
    @State private var frequentRefill: Bool = false
    @State private var isRegistering: Bool = false
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            if isRegistering {
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                    .padding()

                Toggle("Extra Napkins", isOn: $extraNapkins)

                Toggle("Frequent Refill", isOn: $frequentRefill)
            }

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button(isRegistering ? "Register" : "Log In") {
                if isRegistering {
                    registerUser()
                } else {
                    loginUser()
                }
            }
            .buttonStyle(.borderedProminent)

            Button(isRegistering ? "Already have an account? Log In" : "Don't have an account? Register") {
                isRegistering.toggle()
            }
            .foregroundColor(.blue)

            Spacer()
        }
        .padding()
        .navigationTitle(isRegistering ? "Register" : "Login")
    }

    func registerUser() {
        guard let url = URL(string: "http://\( ServerConfig.serverIP):\(ServerConfig.port)/api/auth/register") else {
            errorMessage = "Invalid server URL"
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
                if let error = error {
                    DispatchQueue.main.async {
                        errorMessage = "Error: \(error.localizedDescription)"
                    }
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    DispatchQueue.main.async {
                        errorMessage = nil
                        isRegistering = false
                    }
                } else {
                    DispatchQueue.main.async {
                        errorMessage = "Failed to register. Please try again."
                    }
                }
            }.resume()
        } catch {
            errorMessage = "Failed to encode registration data"
        }
    }

    func loginUser() {
        guard let url = URL(string: "http://\(ServerConfig.serverIP):\(ServerConfig.port)/api/auth/login") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid server URL"
            }
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
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error: \(error.localizedDescription)"
                    }
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Invalid server response"
                    }
                    return
                }

                guard httpResponse.statusCode == 200 else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Invalid email or password (Status code: \(httpResponse.statusCode))"
                    }
                    return
                }

                guard let data = data else {
                    DispatchQueue.main.async {
                        self.errorMessage = "No data received from server"
                    }
                    return
                }

                do {
                    if let responseDict = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let clientId = responseDict["id"] as? Int,
                       let firstName = responseDict["first_name"] as? String {
                        DispatchQueue.main.async {
                            self.clientId = clientId
                            self.firstName = firstName
                            self.isLoggedIn = true
                            self.errorMessage = nil
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Invalid server response format"
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse server response"
                    }
                }
            }.resume()
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to encode login data: \(error.localizedDescription)"
            }
        }
    }

}
