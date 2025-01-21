import SwiftUI

// MARK: - ViewModel
class AppViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var clientId: Int = 0
    @Published var firstName: String = ""
    
    // Example methods for authentication and data handling
    func logIn(clientId: Int, firstName: String) {
        self.isLoggedIn = true
        self.clientId = clientId
        self.firstName = firstName
    }
    
    func logOut() {
        self.isLoggedIn = false
        self.clientId = 0
        self.firstName = ""
    }
}
