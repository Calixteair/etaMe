import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn: Bool = false
    @State private var clientId: Int? = nil
    @State private var firstName: String = ""

    var body: some View {
        if isLoggedIn {
            MainAppView(isLoggedIn: $isLoggedIn, clientId: $clientId, firstName: $firstName)
        } else {
            LoginView(isLoggedIn: $isLoggedIn, clientId: $clientId, firstName: $firstName)
        }
    }
}
	

struct MainAppView: View {
    @Binding var isLoggedIn: Bool
    @Binding var clientId: Int?
    @Binding var firstName: String

    var body: some View {
        TabView {
            HomeView(firstName: firstName, idClient: clientId ?? 0)
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }

            OrderView(clientId: clientId ?? 0)
                .tabItem {
                    Label("Order", systemImage: "cart")
                }

            AccountView(isLoggedIn: $isLoggedIn, clientId: $clientId, firstName: $firstName)
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }	
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
