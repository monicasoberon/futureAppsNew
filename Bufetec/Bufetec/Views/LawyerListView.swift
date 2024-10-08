//
//  LawyerList.swift
//  Bufetec
//
//  Created by Monica Soberon on 10/8/24.
//

import SwiftUI

struct LawyerListView: View {
    @StateObject var viewModel = UserViewModel()  // Use your existing ViewModel

    var body: some View {
        ZStack {
            // Background Gradient from light blue to white
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Stylized Title
                Text("Selecciona un Abogado")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(hex: "#003366"))
                    .padding(.top, 70)

                ScrollView {
                    VStack(spacing: 32) {
                        ForEach(viewModel.users, id: \.id) { user in
                            NavigationLink(destination: LawyerAvailabilityView(user: user)) {  // Navigate to availability view
                                HStack(spacing: 20) {
                                    // Lawyer's image with a subtle shadow
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)  // Slightly smaller image
                                        .foregroundColor(.gray)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))  // Thicker white border
                                        .shadow(color: Color.blue.opacity(0.3), radius: 6)  // Adjusted shadow

                                    VStack(alignment: .leading, spacing: 5) {
                                        // Lawyer's name in a professional look
                                        Text(user.name)
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(hex: "#003366"))

                                        // Lawyer's specialty
                                        Text(user.especiality)
                                            .font(.subheadline)
                                            .foregroundColor(Color.blue.opacity(0.8))
                                    }

                                    Spacer()
                                }
                                .padding(20)
                                .background(Color.white)  // White background for contrast
                                .cornerRadius(12)  // Slightly less rounded corners for a sleek look
                                .shadow(color: Color.gray.opacity(0.4), radius: 8, x: 0, y: 4)  // Subtle shadow for depth
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue.opacity(0.6), lineWidth: 1.5)  // Subtle blue border
                                )
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 16)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.fetchUsers()  // Fetch lawyers (users)
        }
    }
}

#Preview {
    LawyerListView()
}

