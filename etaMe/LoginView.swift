import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var clientId: Int?
    @Binding var firstName: String
    
    @State private var email: String = "email1@mail.com"
    @State private var password: String = "mdp"
    @State private var lastName: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var extraNapkins: Bool = false
    @State private var frequentRefill: Bool = false
    @State private var isRegistering: Bool = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
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
                        DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                            .foregroundColor(.white)
                            .padding(.horizontal)
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
                .background(Color.white.opacity(0.2))
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
                            dateOfBirth: dateOfBirth,
                            extraNapkins: extraNapkins,
                            frequentRefill: frequentRefill
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
                        .background(Color.white)
                        .foregroundColor(.blue)
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
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocapitalization(.none)
                    .foregroundColor(.black)
            } else {
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocapitalization(.none)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
	
