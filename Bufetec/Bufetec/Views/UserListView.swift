//
//  UserListView.swift
//  Bufetec
//
//  Created by Monica Soberon on 9/26/24.
//


import SwiftUI

struct UserListView: View {
    @State private var users: [UserModel] = [
        UserModel.defaultValue,  // Datos simulados
        // Aquí puedes agregar más usuarios si lo deseas
    ]
    
    var body: some View {
        NavigationView {
            List(users, id: \.id) { user in
                NavigationLink(destination: LawyerDetailView(user: user)
                    .navigationBarBackButtonHidden(true)) {
                    // Changed to LawyerDetailView
                    
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        Text(user.especiality)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Lista de Abogados")
        }
    }
}
