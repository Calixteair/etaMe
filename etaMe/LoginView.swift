import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var clientId: Int?
    @Binding var firstName: String
    
    @State private var email: String = "email1@mail.com"
    @State private var password: String = "mdp"
    @State private var lastName: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var isRegistering: Bool = false
    @State private var errorMessage: String? = nil
    
    @Environment(\.colorScheme) var colorScheme // Détecte le mode clair ou sombre
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: colorScheme == .dark ? [Color.black, Color.gray] : [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text(isRegistering ? "Create Account" : "Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Text(isRegistering ? "Join us and enjoy exclusive features!" : "Login to continue")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 20)
                
                VStack(spacing: 16) {
                    if isRegistering {
                        CustomTextField(icon: "person", placeholder: "First Name", text: $firstName)
                        CustomTextField(icon: "person.fill", placeholder: "Last Name", text: $lastName)
                        HStack{
                            Text("Date of Birth").foregroundStyle(Color.white)
                            Spacer()
                            DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                                .labelsHidden() // Cache le label pour un style minimal
                                .datePickerStyle(.compact)
                                .colorInvert() // Force l'inversion des couleurs pour un texte blanc
                                .foregroundColor(.white) // Assure que la police est blanche
                                .padding()
                                .cornerRadius(8)
                        }
                    }
                    
                    CustomTextField(icon: "envelope", placeholder: "Email", text: $email, isSecure: false)
                    CustomTextField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding()
                .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.white.opacity(0.2))
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding(.horizontal, 20)
                
                Button(action: {
                    if isRegistering {
                        AuthService.registerUser(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            password: password,
                            dateOfBirth: dateOfBirth
                        ) { success, error in
                            if success {
                                isRegistering = false
                                errorMessage = nil
                            } else {
                                errorMessage = error
                            }
                        }
                    } else {
                        AuthService.loginUser(
                            email: email,
                            password: password
                        ) { success, clientIdValue, firstNameValue, error in
                            if success {
                                clientId = clientIdValue
                                firstName = firstNameValue ?? ""
                                isLoggedIn = true
                                errorMessage = nil
                            } else {
                                errorMessage = error
                            }
                        }
                    }
                }) {
                    Text(isRegistering ? "Register" : "Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(colorScheme == .dark ? Color.white.opacity(0.8) : Color.white)
                        .foregroundColor(colorScheme == .dark ? .black : .blue)
                        .font(.headline)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .padding(.horizontal, 20)
                
                Button(action: {
                    withAnimation {
                        isRegistering.toggle()
                    }
                }) {
                    Text(isRegistering ? "Already have an account? Log In" : "Don't have an account? Register")
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
	
