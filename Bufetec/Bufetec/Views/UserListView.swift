import SwiftUI

struct UserListView: View {
    @State private var users: [UserModel] = [
        UserModel.defaultValue,  // Simulated data
        // You can add more users if necessary
    ]
    
    var body: some View {
        ZStack {
            // Background Gradient with light blue and white
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // Makes sure gradient covers the whole screen
            
            VStack {
                // Title with professional styling
                Text("Lista de Abogados")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(hex: "#003366"))
                    .padding(.top, 30)
                
                ScrollView {
                    VStack(spacing: 32) {  // Increased spacing for a more spacious look
                        ForEach(users, id: \.id) { user in
                            NavigationLink(destination: LawyerDetailView(user: user)) {
                                HStack(spacing: 20) {  // Adjust spacing for a clean, professional look
                                    // Lawyer's image with reduced shadow
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 90, height: 90)  // Increased size for better emphasis
                                        .foregroundColor(.gray)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 1)) // Blue border
                                        .shadow(color: Color.blue.opacity(0.3), radius:4) // Reduced shadow opacity and radius

                                    VStack(alignment: .leading, spacing: 5) {
                                        // Lawyer's Name with a bold professional look (no gradient)
                                        Text(user.name)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(hex: "#003366")) // Plain blue, no gradient
                                        
                                        // Lawyer's Specialty
                                        Text(user.especiality)
                                            .font(.subheadline)
                                            .foregroundColor(Color.blue.opacity(0.7))  // Professional muted blue
                                    }

                                    Spacer()
                                }
                                .padding(20)  // More padding for larger touch target
                                .background(Color.white)  // Professional white background for contrast
                                .cornerRadius(15)  // More rounded corners for a polished look
                                .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.blue.opacity(0.5), lineWidth: 2)  // Slight border for emphasis
                                )
                                .scaleEffect(1.02)  // Slightly larger scale for emphasis
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 16)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    UserListView()
}
