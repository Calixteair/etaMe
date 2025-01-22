import SwiftUI
struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel

    init(appViewModel: AppViewModel) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(clientId: appViewModel.clientId, appViewModel: appViewModel))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }

                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else {
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
                        Text("First Name: \(viewModel.firstName)")
                        Text("Last Name: \(viewModel.lastName)")
                        Text("Email: \(viewModel.email)")
                        Text("Date of Birth: \(viewModel.dateOfBirth)")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                    NavigationLink(destination: EditProfileView(
                        appViewModel: viewModel.appViewModel,
                        firstName: viewModel.firstName,
                        lastName: viewModel.lastName,
                        email: viewModel.email,
                        password: viewModel.password,
                        dateOfBirth: viewModel.dateOfBirth
                    )) {
                        Text("Edit Profile")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    Button(action: viewModel.logOut) {
                        Text("Log Out")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .onAppear(perform: viewModel.loadUserData)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
