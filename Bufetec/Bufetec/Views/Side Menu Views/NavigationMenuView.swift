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
    @Binding var showLogoutAlert: Bool // Binding for the logout alert
    
    @State private var selectedOption: SideMenuOptionModel? = .homeView

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
                            showLogoutAlert = true // Trigger logout alert
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
    }
    
    private func onOptionTapped(_ option: SideMenuOptionModel) {
        withAnimation {
            selectedOption = option
            selectedTab = option
            isShowing = false
        }
    }
}



#Preview {
    @State var isShowingMenu = true
    @State var selectedTab = SideMenuOptionModel.homeView
    @State var showLogoutAlert = false // Add this state for preview

    return NavigationMenu(
        user: UserModel.defaultValue,
        isShowing: $isShowingMenu,
        selectedTab: $selectedTab,
        showLogoutAlert: $showLogoutAlert // Pass this binding
    )
}
