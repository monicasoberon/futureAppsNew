//
//  HomePage.swift
//  Bufetec
//
//  Created by Luis Gzz on 24/09/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct HomePageView: View {
    // Definimos el layout de la cuadrícula
    var userEmail: String?
    var firstName: String?
    var lastName: String?

    @State private var showProfileView = false
    
    @ObservedObject var userModel: UserModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("Welcome, \(firstName ?? "User") \(lastName ?? "")!")
                    Text("Email: \(userEmail ?? "No email")")
                }
            }
        }
//        .background(Color(hex: "#F0F4FF")) // Fondo claro con azul suave
//        .navigationBarTitleDisplayMode(.large) // Estilo del título
//
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                Text("Bufetec")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(Color(hex: "#003366")) // Color azul oscuro para el título
//            }
//        }
    }
}


// Vista previa
#Preview {
    HomePageView(userModel: UserModel.defaultValue)
}
