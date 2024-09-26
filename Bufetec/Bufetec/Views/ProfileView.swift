//
//  ProfileView.swift
//  Bufetec
//
//  Created by Jorge on 25/09/24.
//

import SwiftUI

struct UserDetailView: View {
    @State private var user: UserModel
    
    init(user: UserModel) {
        _user = State(initialValue: user)
    }
    
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
    }
    
    // Function to add a new case ID to the list
    private func addNewCaseID() {
        user.caseID.append("New Case ID")
    }
    
    // Function to save changes (implementation can vary based on your app's backend or local storage)
    private func saveChanges() {
        print("Changes saved for user: \(user.name)")
    }
}

// Preview for the UserDetailView
struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(user: UserModel.defaultValue)
    }
}
