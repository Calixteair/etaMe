import SwiftUI

struct ProfileView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var dateOfBirth: String = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }

                HStack {
                    Image(systemName: "person.crop.circle")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    Text("Personal Information")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding(.bottom, 10)

                VStack(alignment: .leading, spacing: 15) {
                    Text("First Name: \(firstName)")
                    Text("Last Name: \(lastName)")
                    Text("Email: \(email)")
                    Text("Date of Birth: \(dateOfBirth)")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

                NavigationLink(destination: EditProfileView(appViewModel: appViewModel, firstName: $firstName, lastName: $lastName, email: $email, password: $password, dateOfBirth: $dateOfBirth, errorMessage: $errorMessage)) {
                    Text("Edit Profile")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                Button(action: appViewModel.logOut) {
                    Text("Log Out")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            .padding()
            .onAppear(perform: loadUserData)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func loadUserData() {
        ProfileService.fetchUserProfile(clientId: appViewModel.clientId) { success, profile, error in
            if success, let profile = profile {
                DispatchQueue.main.async {
                    self.firstName = profile.firstName
                    self.lastName = profile.lastName
                    self.email = profile.email
                    self.password = profile.password
                    self.dateOfBirth = profile.dateOfBirth
                    appViewModel.firstName = profile.firstName
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = error ?? "Failed to load profile"
                }
            }
        }
    }
}
