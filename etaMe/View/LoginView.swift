import SwiftUI
struct LoginView: View {
    @ObservedObject var loginViewModel: LoginViewModel

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: loginViewModel.isRegistering ? [.purple, .blue] : [.blue, .purple]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text(loginViewModel.isRegistering ? "Create Account" : "Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)

                Text(loginViewModel.isRegistering ? "Join us and enjoy exclusive features!" : "Login to continue")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 20)

                VStack(spacing: 16) {
                    if loginViewModel.isRegistering {
                        CustomTextField(icon: "person", placeholder: "First Name", text: $loginViewModel.firstName)
                        CustomTextField(icon: "person.fill", placeholder: "Last Name", text: $loginViewModel.lastName)
                        HStack {
                            Text("Date of Birth").foregroundColor(.white)
                            Spacer()
                            DatePicker("Date of Birth", selection: $loginViewModel.dateOfBirth, displayedComponents: .date)
                                .labelsHidden()
                                .foregroundColor(.white)
                        }
                    }

                    CustomTextField(icon: "envelope", placeholder: "Email", text: $loginViewModel.email)
                    CustomTextField(icon: "lock", placeholder: "Password", text: $loginViewModel.password, isSecure: true)

                    if let errorMessage = loginViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
                .padding(.horizontal, 20)

                Button(action: {
                    if loginViewModel.isRegistering {
                        loginViewModel.register()
                    } else {
                        loginViewModel.login()
                    }
                }) {
                    Text(loginViewModel.isRegistering ? "Register" : "Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .padding(.horizontal, 20)

                Button(action: {
                    withAnimation {
                        loginViewModel.isRegistering.toggle()
                    }
                }) {
                    Text(loginViewModel.isRegistering ? "Already have an account? Log In" : "Don't have an account? Register")
                        .font(.footnote)
                        .foregroundColor(.white)
                }
                .padding(.top, 10)

                Spacer()
            }
        }
    }
}


struct CustomTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    @Environment(\.colorScheme) var colorScheme // Permet de détecter le mode (clair ou sombre)
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocapitalization(.none)
                    .foregroundColor(colorScheme == .dark ? .white : .black) // Texte adapté au mode
            } else {
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocapitalization(.none)
                    .foregroundColor(colorScheme == .dark ? .white : .black) // Texte adapté au mode
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color.black.opacity(0.9) : Color.white.opacity(0.9)) // Fond adapté au mode
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
	
