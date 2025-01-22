import SwiftUI
struct EditProfileView: View {
    @StateObject private var viewModel: EditProfileViewModel
    @Environment(\.presentationMode) var presentationMode

    init(appViewModel: AppViewModel, firstName: String, lastName: String, email: String, password: String, dateOfBirth: String) {
        _viewModel = StateObject(
            wrappedValue: EditProfileViewModel(
                clientId: appViewModel.clientId,
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                dateOfBirth: dateOfBirth
            )
        )
    }

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                            Text("First Name")
                                .font(.headline)
                            TextField("Enter your first name", text: $viewModel.firstName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Last Name")
                                .font(.headline)
                            TextField("Enter your last name", text: $viewModel.lastName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.headline)
                            TextField("Enter your email", text: $viewModel.email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.emailAddress)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.headline)
                            SecureField("Enter your password", text: $viewModel.password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                DatePicker(
                    "Date of Birth",
                    selection: $viewModel.selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(CompactDatePickerStyle())
            

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }

            HStack(spacing: 20) {
                Button(action: {
                    viewModel.saveChanges { success in
                        if success {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }


            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
