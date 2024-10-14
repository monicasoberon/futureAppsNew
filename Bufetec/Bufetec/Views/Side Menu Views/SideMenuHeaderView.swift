import SwiftUI
import FirebaseAuth

struct SideMenuHeaderView: View {
    @StateObject private var viewModel = SideMenuProfileViewModel()

    var body: some View {
        HStack {
            if let profile = viewModel.profile {
                AsyncImage(url: URL(string: profile.photo)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 48, height: 48)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 48, height: 48)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(profile.name)
                        .font(.headline)
                    
                    Text(profile.email)
                        .font(.subheadline)
                }
            } else if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                Text("No user data available")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            if let email = Auth.auth().currentUser?.email {
                viewModel.fetchUserProfile(email: email)
            } else {
                viewModel.errorMessage = "User is not authenticated"
            }
        }
    }
}

#Preview {
    SideMenuHeaderView()
}
