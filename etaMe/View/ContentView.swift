import SwiftUI

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()

    var body: some View {
        if appViewModel.isLoggedIn {
            MainAppView(appViewModel: appViewModel)
        } else {
            LoginView(loginViewModel: LoginViewModel(onLoginSuccess: { clientId, firstName in
                appViewModel.isLoggedIn = true
                appViewModel.clientId = clientId
                appViewModel.firstName = firstName
            }))
        }
    }
}

struct MainAppView: View {
    @ObservedObject var appViewModel: AppViewModel

    var body: some View {
        TabView {
            HomeView(homeViewModel: HomeViewModel(), appViewModel: appViewModel )
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }

            OrderView(orderViewModel: OrderViewModel(), appViewModel: appViewModel )
                .tabItem {
                    Label("Order", systemImage: "cart")
                }

            AccountView(appViewModel: appViewModel)
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
