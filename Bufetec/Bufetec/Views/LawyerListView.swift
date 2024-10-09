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

                // Scrollable list of lawyers
                ScrollView {
                    VStack(spacing: 32) {
                        // Loop through users (lawyers) and render each one
                        ForEach(viewModel.users, id: \.id) { user in
                            lawyerRow(for: user)  // Refactored to a separate function for readability
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

    // Function to render each lawyer row
    @ViewBuilder
    func lawyerRow(for user: UserModel) -> some View {
        NavigationLink(destination: LawyerAvailabilityView(lawyer: user)) {
            HStack(spacing: 20) {
                // Lawyer's profile image
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))  // Thicker white border
                    .shadow(color: Color.blue.opacity(0.3), radius: 6)

                // Lawyer's name and specialty
                VStack(alignment: .leading, spacing: 5) {
                    Text(user.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#003366"))

                    Text(user.especiality)
                        .font(.subheadline)
                        .foregroundColor(Color.blue.opacity(0.8))
                }

                Spacer()
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.gray.opacity(0.4), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.6), lineWidth: 1.5)
            )
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    LawyerListView()
}
