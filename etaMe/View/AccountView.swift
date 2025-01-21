import SwiftUI

struct AccountView: View {
    @ObservedObject var appViewModel: AppViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome, \(appViewModel.firstName)")
                    .font(.largeTitle)
                    .padding()

          
                Text("Client ID: \(appViewModel.clientId)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                
                Spacer()

                Button(action: {
                    appViewModel.logOut()
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
