//
//  MainPageView.swift
//  Bufetec
//
//  Created by Jorge on 03/10/24.
//

import SwiftUI
import FirebaseAuth

struct MainPageView: View {
    
    @StateObject private var user = UserModel()
    
    @State private var showMenu = false
    @State private var showProfile = false
    @State private var selectedMenuOption: SideMenuOptionModel = .homeView
    @State private var showLoginView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Conditionally show different views based on the selectedMenuOption
                switch selectedMenuOption {
                case .homeView:
                    HomePageView(userModel: user)
                case .appointmentView:
                    CreateEventView()
                case .lawyersView:
                    UserListView()
                case .newsView:
                    NovedadesLegales()
                case .casesView:
                    CaseListView()
                case .faqView:
                    FaqListView()
                case .contactView:
                    ContactView(user: user)
                    
                case .signOut:
                    // Log out and show the login view
                    Color.white // Blank view to avoid crashing due to missing case
                    .onAppear {
                        logOut()
                    }
                }
                
                // Your navigation menu
                NavigationMenu(user: user, isShowing: $showMenu, selectedTab: $selectedMenuOption)
            }
            .navigationTitle(selectedMenuOption.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showMenu.toggle()
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.blue)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showProfile.toggle()
                    }) {
                        Image(systemName: "person.crop.circle")
                    }
                }
            }
            .toolbarBackground(Color.pink, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)

            // NavigationLink to ProfileView triggered by the state variable
            NavigationLink(destination: ProfileView(user: user), isActive: $showProfile) {
                EmptyView()
            }

            // Full screen login view if the user logs out
            .fullScreenCover(isPresented: $showLoginView) {
                LoginView()
            }
        }
    }
    
    // Function to log out the user
    private func logOut() {
        do {
            try Auth.auth().signOut()
            showLoginView = true // Show login view when user logs out
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

#Preview {
    MainPageView()
}
