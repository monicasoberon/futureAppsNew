import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        VStack {
            // Botón de cerrar para volver al menú
            HStack {
                Button(action: {
                    dismiss() // Cierra la ProfileView
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                .padding()
                
                Spacer()
            }
            
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let profile = viewModel.profile {
                // Cargar imagen de perfil con AsyncImage
                AsyncImage(url: URL(string: profile.photo)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 240, height: 240)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 240, height: 240)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .padding(20)
                    case .failure:
                        Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 240, height: 240)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Form {
                    Section(header: Text("Personal Information")) {
                        Text("Name: \(profile.name)")
                        Text("Email: \(profile.email)")
                        
                        if profile.type == "abogado" {
                            TextField("Speciality", text: binding(for: \.especiality))
                            TextEditor(text: binding(for: \.description))
                                .frame(height: 100)
                        } else {
                            if let speciality = profile.especiality {
                                Text("Speciality: \(speciality)")
                            }
                            if let description = profile.description {
                                Text("Description: \(description)")
                            }
                        }
                    }
                }
                
                if profile.type == "abogado" {
                    Button(action: {
                        viewModel.saveChanges()
                    }) {
                        if viewModel.isSaving {
                            ProgressView()
                        } else {
                            Text("Save")
                        }
                    }
                    .padding()
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                Text("No user profile available")
            }
        }
        .navigationTitle("User Details")
        .onAppear {
            if let user = Auth.auth().currentUser, let email = user.email {
                viewModel.fetchUserProfile(email: email)
            } else {
                viewModel.errorMessage = "User is not authenticated"
                print("User is not authenticated")
            }
        }
    }
    
    // Helper function to create a binding for optional properties
    private func binding(for keyPath: ReferenceWritableKeyPath<ProfileModel, String?>) -> Binding<String> {
        Binding(
            get: { viewModel.profile?[keyPath: keyPath] ?? "" },
            set: { viewModel.profile?[keyPath: keyPath] = $0 }
        )
    }
}
