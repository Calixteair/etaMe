import SwiftUI
struct AccountView: View {
    @Binding var isLoggedIn: Bool
    @Binding var clientId: Int?
    @Binding var firstName: String

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome, \(firstName)")
                    .font(.largeTitle)
                    .padding()

                Text("Client ID: \(clientId ?? 0)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()

                Button(action: {
                    // Déconnexion de l'utilisateur
                    isLoggedIn = false
                    clientId = nil
                    firstName = ""
                }) {
                    Text("Log Out")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationTitle("Account")
        }
    }
}

	
