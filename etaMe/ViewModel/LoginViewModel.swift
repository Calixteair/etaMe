import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = "email1@mail.com"
    @Published var password: String = "mdp"
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var isRegistering: Bool = false
    @Published var errorMessage: String? = nil

    // Callback pour signaler un succès de connexion
    var onLoginSuccess: ((Int, String) -> Void)?

    init(onLoginSuccess: ((Int, String) -> Void)? = nil) {
        self.onLoginSuccess = onLoginSuccess
    }

    func login() {
        AuthService.loginUser(email: email, password: password) { success, clientIdValue, firstNameValue, error in
            if success {
                self.errorMessage = nil
                if let clientId = clientIdValue, let firstName = firstNameValue {
                    self.onLoginSuccess?(clientId, firstName)
                }
            } else {
                self.errorMessage = error
            }
        }
    }

    func register() {
        AuthService.registerUser(firstName: firstName, lastName: lastName, email: email, password: password, dateOfBirth: dateOfBirth) { success, error in
            if success {
                self.isRegistering = false
                self.errorMessage = nil
            } else {
                self.errorMessage = error
            }
        }
    }
}
