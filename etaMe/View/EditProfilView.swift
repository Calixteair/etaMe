import SwiftUI

struct EditProfileView: View {
    @ObservedObject var appViewModel: AppViewModel
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var password: String
    @Binding var dateOfBirth: String
    @Binding var errorMessage: String?
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedDate = Date()

    var body: some View {
        VStack(spacing: 20) {
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            VStack(alignment: .leading) {
                Text("Date of Birth")
                    .font(.headline)

                DatePicker(
                    "Select Date of Birth",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(CompactDatePickerStyle()) // Style compact
            }

            HStack(spacing: 20) {
                Button(action: saveChanges) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Convertir la date de naissance (String) en Date
            if let dob = convertStringToDate(dateOfBirth) {
                selectedDate = dob
            }
        }
    }

    private func saveChanges() {
        // Mettre à jour le champ dateOfBirth avec la nouvelle date au format String
        dateOfBirth = convertDateToString(selectedDate)

        let updatedProfile = UserProfile(
            idClient: appViewModel.clientId,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            dateOfBirth: dateOfBirth
        )

        ProfileService.updateUserProfile(profile: updatedProfile) { success, error in
            DispatchQueue.main.async {
                if success {
                    errorMessage = nil
                    presentationMode.wrappedValue.dismiss()
                } else {
                    errorMessage = error ?? "Failed to update profile"
                }
            }
        }
    }

    // Convertir une chaîne de caractères en Date
    private func convertStringToDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }

    // Convertir une Date en chaîne de caractères
    private func convertDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
