import Foundation

class ProfileViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var dateOfBirth: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    let clientId: Int
    let appViewModel: AppViewModel

    init(clientId: Int, appViewModel: AppViewModel) {
        self.clientId = clientId
        self.appViewModel = appViewModel
    }

    func loadUserData() {
        isLoading = true
        errorMessage = nil

        ProfileService.fetchUserProfile(clientId: clientId) { [weak self] success, profile, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if success, let profile = profile {
                    self?.firstName = profile.firstName
                    self?.lastName = profile.lastName
                    self?.email = profile.email
                    self?.password = profile.password
                    self?.dateOfBirth = profile.dateOfBirth
                    self?.appViewModel.firstName = profile.firstName
                } else {
                    self?.errorMessage = error ?? "Failed to load profile"
                }
            }
        }
    }

    func logOut() {
        appViewModel.logOut()
    }
}
