import Foundation

class EditProfileViewModel: ObservableObject {
    @Published var firstName: String
    @Published var lastName: String
    @Published var email: String
    @Published var password: String
    @Published var dateOfBirth: String
    @Published var errorMessage: String?
    @Published var selectedDate: Date

    private let clientId: Int

    init(clientId: Int, firstName: String, lastName: String, email: String, password: String, dateOfBirth: String) {
        self.clientId = clientId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.dateOfBirth = dateOfBirth
        self.selectedDate = Self.convertStringToDate(dateOfBirth) ?? Date()
    }

    func saveChanges(completion: @escaping (Bool) -> Void) {
        dateOfBirth = Self.convertDateToString(selectedDate)

        let updatedProfile = UserProfile(
            idClient: clientId,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            dateOfBirth: dateOfBirth
        )

        ProfileService.updateUserProfile(profile: updatedProfile) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.errorMessage = nil
                    completion(true)
                } else {
                    self.errorMessage = error ?? "Failed to update profile"
                    completion(false)
                }
            }
        }
    }

    private static func convertStringToDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }

    private static func convertDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
