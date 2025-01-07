import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn: Bool = false
    @State private var clientId: Int? = nil
    @State private var firstName: String = ""

    var body: some View {
        if isLoggedIn {
            MainAppView(clientId: clientId ?? 0, firstName: firstName)
        } else {
            AccountView(isLoggedIn: $isLoggedIn, clientId: $clientId, firstName: $firstName)
        }
    }
}

struct MainAppView: View {
    let clientId: Int
    let firstName: String

    var body: some View {
        TabView {
            HomeView(firstName: firstName)
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }

            OrderView(clientId: clientId)
                .tabItem {
                    Label("Order", systemImage: "cart")
                }

            Text("Account Settings")
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
