//
//  NavigationMenuView.swift
//  Bufetec
//
//  Created by Jorge on 03/10/24.
//

import SwiftUI
import FirebaseAuth

struct NavigationMenu: View {
    
    @ObservedObject var user: UserModel
    
    @Binding var isShowing: Bool
    @Binding var selectedTab: SideMenuOptionModel
    @State private var selectedOption: SideMenuOptionModel? = .homeView
    
    @State private var showLogin = false
    @State private var showLogoutAlert = false
    
    
    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowing.toggle()
                        }
                    }
                
                HStack {
                    VStack(alignment: .leading, spacing: 32) {
                        SideMenuHeaderView(user: user)
                        
                        VStack {
                            // Display all options except Sign Out
                            ForEach(SideMenuOptionModel.allCases.filter { $0 != .signOut }) { option in
                                Button(action: {
                                    onOptionTapped(option)
                                }, label: {
                                    SideMenuRowView(option: option, selectedOption: $selectedOption)
                                })
                            }
                        }
                        
                        Spacer()
                        
                        // Sign Out button at the bottom
                        Button(action: {
                            showLogoutAlert = true
                        }, label: {
                            HStack {
                                Image(systemName: SideMenuOptionModel.signOut.systemImageName)
                                    .foregroundColor(.red)
                                
                                Text(SideMenuOptionModel.signOut.title)
                                    .foregroundColor(.red)
                            }
                        })
                    }
                    .padding()
                    .frame(width: 285, alignment: .leading)
                    .background(.white)
                    
                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView() // Show LoginView if user logs out
        }
        // Alert to confirm sign-ou
    }
    
    private func onOptionTapped(_ option: SideMenuOptionModel) {
        withAnimation {
            selectedOption = option
            selectedTab = option
            isShowing = false
        }
    }
    
    // Function to log out the user
    private func logOut() {
        do {
            try Auth.auth().signOut()
            selectedTab = .homeView // Reset to the home view after logout
            showLogin = true // Show the login screen
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

#Preview {
    NavigationMenu(user: UserModel.defaultValue, isShowing: .constant(true), selectedTab: .constant(.homeView))
}
