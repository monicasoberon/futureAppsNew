import SwiftUI
import FirebaseAuth

struct NavigationMenu: View {
    @ObservedObject var user: UserModel
    @Binding var isShowing: Bool
    @Binding var selectedTab: SideMenuOptionModel
    @Binding var showLogoutAlert: Bool

    @State private var selectedOption: SideMenuOptionModel? = .homeView
    @State private var showProfileView = false
    @StateObject private var viewModel = SideMenuProfileViewModel()

    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }

                HStack {
                    VStack(alignment: .leading, spacing: 32) {
                        Button(action: {
                            withAnimation {
                                isShowing = false
                            }
                            showProfileView = true
                        }) {
                            SideMenuHeaderView()
                        }
                        .buttonStyle(PlainButtonStyle())

                        VStack {
                            ForEach(filteredOptions()) { option in
                                Button(action: {
                                    onOptionTapped(option)
                                }, label: {
                                    SideMenuRowView(option: option, selectedOption: $selectedOption)
                                })
                            }
                        }

                        Spacer()

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
        .fullScreenCover(isPresented: $showProfileView) {
            ProfileView()
        }
        .onAppear {
            if let email = Auth.auth().currentUser?.email {
                viewModel.fetchUserProfile(email: email)
            }
        }
        .onChange(of: selectedTab) { newTab in
            selectedOption = newTab
        }
    }

    private func onOptionTapped(_ option: SideMenuOptionModel) {
        withAnimation {
            selectedOption = option
            selectedTab = option
            isShowing = false
        }
    }

    private func filteredOptions() -> [SideMenuOptionModel] {
        let allOptions = SideMenuOptionModel.allCases.filter { $0 != .signOut }
        if let userType = viewModel.profile?.type {
            if userType == "cliente" {
                return allOptions.filter { $0.isForClient }
            } else if userType == "abogado" {
                return allOptions.filter { $0.isForLawyer }
            }
        }
        return allOptions
    }
}
