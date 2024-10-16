import SwiftUI
import FirebaseAuth


struct MainPageView: View {
    @StateObject private var user = UserModel()
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var tesisViewModel = TesisModelViewModel() 
    
    @State private var showMenu = false
    @State private var showProfile = false
    @State private var selectedMenuOption: SideMenuOptionModel = .homeView
    @State private var showLoginView = false
    @State private var showLogoutAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                switch selectedMenuOption {
                case .homeView:
                    HomePageView(viewModel: userViewModel, tesisViewModel: tesisViewModel, selectedMenuOption: $selectedMenuOption)
                case .lawyersView:
                    UserListView()
                case .appointmentView:
                    LawyerListView()
                case .citasView:
                    CitasView()
                case .casesView:
                    CaseListView()
                case .tesisView:
                    TesisView()
                case .precedentesView:
                    PrecedentesView()
                case .faqView:
                    FaqListView()
                case .contactView:
                    ContactView(user: user)
                case .signOut:
                    Color.clear
                }
                
                // Navigation menu for side options
                NavigationMenu(
                    user: user,
                    isShowing: $showMenu,
                    selectedTab: $selectedMenuOption,
                    showLogoutAlert: $showLogoutAlert
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showMenu.toggle()
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "#FFFFFF"))
                            .opacity(0.8)
                    }
                }
            }
            .toolbarBackground(Color(hex: "#0164d2"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Log Out"),
                    message: Text("Are you sure you want to log out?"),
                    primaryButton: .destructive(Text("Log Out")) {
                        logOut()
                    },
                    secondaryButton: .cancel()
                )
            }
            .fullScreenCover(isPresented: $showLoginView) {
                LoginView()
            }
        }
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            showLoginView = true
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
}


// Preview
struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}
