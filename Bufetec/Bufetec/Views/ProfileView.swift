//
//  ProfileView.swift
//  Bufetec
//
//  Created by Jorge on 25/09/24.
//

import SwiftUI
import FirebaseAuth


struct ProfileView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var user: UserModel
    
    @State private var showLogin = false
    @State private var showLogoutAlert = false // State to control alert visibility
    
    var body: some View {
        VStack {
            // Circular Image at the top
            Image(user.photo)
                .resizable()
                .scaledToFill()
                .frame(width: 240, height: 240)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                .padding(20)
            
            Form {
                // Name Section
                Section(header: Text("Personal Information")) {
                    if user.type == "abogado" {
                        TextField("Name", text: $user.name)
                        TextField("Email", text: $user.email)
                        TextField("Speciality", text: $user.especiality)
                    } else {
                        Text("Name: \(user.name)")
                        Text("Email: \(user.email)")
                        Text("Speciality: \(user.especiality)")
                    }
                }
                
                // Description Section
                Section(header: Text("Description")) {
                    if user.type == "abogado" {
                        TextEditor(text: $user.description)
                            .frame(height: 100)
                    } else {
                        Text(user.description)
                    }
                }
                
                // Cases Section
                Section(header: Text("Case IDs")) {
                    if user.type == "abogado" {
                        ForEach($user.caseID, id: \.self) { $caseID in
                            TextField("Case ID", text: $caseID)
                        }
                        Button(action: addNewCaseID) {
                            Text("Add Case ID")
                        }
                    } else {
                        ForEach(user.caseID, id: \.self) { caseID in
                            Text(caseID)
                        }
                    }
                }
            }
        }
        .navigationTitle("User Details")
        .toolbar {
            if user.type == "abogado" {
                Button(action: saveChanges) {
                    Text("Save")
                }
            }
        }
        .navigationBarItems(trailing:
                                Button(action: {
            showLogoutAlert = true
        }) {
            Image(systemName: "rectangle.portrait.and.arrow.forward")
                .foregroundColor(Color(hex: "#003366"))
        }
        )
        
        // If user logs out, show the login view
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
        }
        // Alert to confirm sign-out
        .alert(isPresented: $showLogoutAlert) {
            Alert(
                title: Text("Cerrar sesión"),
                message: Text("¿Estás seguro de que quieres cerrar sesión?"),
                primaryButton: .destructive(Text("Cerrar sesión")) {
                    logOut() // Proceed with logging out
                },
                secondaryButton: .cancel(Text("Cancelar"))
            )
        }
    }
    
    // Function to log out the user
    private func logOut() {
        do {
            try Auth.auth().signOut()
            // Redirect to login view after signing out
            showLogin = true
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // Function to add a new case ID to the list
    private func addNewCaseID() {
        user.caseID.append("New Case ID")
    }
    
    // Function to save changes (implementation can vary based on your app's backend or local storage)
    private func saveChanges() {
        print("Changes saved for user: \(user.name)")
        dismiss()
    }
}

// Preview for the UserDetailView
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: UserModel.defaultValue)
    }
}
