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
    @Binding var showLogoutAlert: Bool
    
    @State private var selectedOption: SideMenuOptionModel? = .homeView
    @State private var showProfileView = false

    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        // Cierra el menú al hacer clic en el fondo
                        withAnimation {
                            isShowing = false
                        }
                    }
                
                HStack {
                    VStack(alignment: .leading, spacing: 32) {
                        // Envolver el header en un botón para mostrar ProfileView
                        Button(action: {
                            // Cierra el menú y muestra la vista de perfil
                            withAnimation {
                                isShowing = false
                            }
                            showProfileView = true
                        }) {
                            SideMenuHeaderView()
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        VStack {
                            // Mostrar todas las opciones excepto Sign Out
                            ForEach(SideMenuOptionModel.allCases.filter { $0 != .signOut }) { option in
                                Button(action: {
                                    onOptionTapped(option)
                                }, label: {
                                    SideMenuRowView(option: option, selectedOption: $selectedOption)
                                })
                            }
                        }
                        
                        Spacer()
                        
                        // Botón de Sign Out en la parte inferior
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
        // Mostrar la ProfileView cuando showProfileView es verdadero
        .fullScreenCover(isPresented: $showProfileView) {
            ProfileView()
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
    @State var showLogoutAlert = false

    return NavigationMenu(
        user: UserModel.defaultValue,
        isShowing: $isShowingMenu,
        selectedTab: $selectedTab,
        showLogoutAlert: $showLogoutAlert
    )
}
