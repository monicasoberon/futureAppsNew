//
//  HomeView.swift
//  Bufetec
//
//  Created by Alumno on 18/09/24.
//
import SwiftUI
import Firebase
import FirebaseAuth

struct HomeView: View {
    
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
    @State private var userEmail: String? = Auth.auth().currentUser?.email
//    @State private var userEmail: String?
    @State private var userFirstName: String?
    @State private var userLastName: String?
    var body: some View {
        NavigationView {
            VStack {
                if userLoggedIn {
                    // Navigate to HomePage if the user is logged in
                    HomePageView(userEmail: userEmail, firstName: userFirstName, lastName: userLastName)
                } else {
                    // Stay on the Login page if the user isn't logged in
                    LoginView()
                }
            }
            .onAppear {
                // Listen for changes in authentication state
                Auth.auth().addStateDidChangeListener { auth, user in
                    userLoggedIn = (user != nil)
                    if let user = user {
                        // Retrieve user information
                        userEmail = user.email
                        // For Google users, you may want to retrieve additional info from your authentication flow
                        userFirstName = user.displayName?.components(separatedBy: " ").first
                        userLastName = user.displayName?.components(separatedBy: " ").dropFirst().joined(separator: " ") // Gets last name
                    }

                }
            }
        }
    }
}

#Preview {
    HomeView()
}
