//
//  HomePage.swift
//  Bufetec
//
//  Created by Luis Gzz on 24/09/24.
//

import SwiftUI

struct HomePageView: View {
    @ObservedObject var lawyerviewModel: UserViewModel
    @Binding var selectedMenuOption: SideMenuOptionModel

    @State private var searchQuery = ""
    @State private var legalNews = [
        "New Business Law Regulations",
        "Recent Family Law Updates",
        "Civil Rights Legal Changes"
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Hero Section
                Image("bufetec_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Justicia al Alcance de Todos")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#003366"))
                        .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)

                    HStack(spacing: 15) {
                        Button(action: {
                            selectedMenuOption = .lawyersView
                        }) {
                            Text("Buscar Abogado")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }

                        Button(action: {
                            selectedMenuOption = .appointmentView
                        }) {
                            Text("Generar Cita")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }

                        Button(action: {
                            selectedMenuOption = .tesisView
                        }) {
                            Text("Ver Tesis")
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 5)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

                // Featured Lawyers
                VStack(alignment: .leading, spacing: 15) {
                    Text("Abogados")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#003366"))
                        .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)

                    ForEach(lawyerviewModel.users.prefix(3), id: \.id) { user in
                        LawyerCardView(name: user.name, especialty: user.especiality
                        )
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

                // Legal News Feed
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tesis Recientes")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#003366"))
                        .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(legalNews, id: \.self) { news in
                                NewsCardView(title: news)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

                // Contact and Support
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Necesitas Ayuda?")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#003366"))
                            .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)

                        Button("Contactar Soporte") {
                            selectedMenuOption = .contactView
                        }
                        .font(.system(size: 13.5))
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)

                        Text("Dudas?")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#003366"))
                            .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)

                        Button("FAQ") {
                            selectedMenuOption = .faqView
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            lawyerviewModel.fetchUsers() // Ensure users are fetched
        }
    }
}

// MARK: - Reusable Components

struct LawyerCardView: View {
    var name: String
    var especialty: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(name), \(especialty)")
                    .font(.subheadline).bold()
            }
            Spacer()
            Button("View Profile") {
                // Navigation action
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
        }
    }
}

struct NewsCardView: View {
    var title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .bold()
            Text("Click to read more")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}


// Vista previa
#Preview {
    HomePageView(lawyerviewModel: UserViewModel(), selectedMenuOption: .constant(.homeView))
}
