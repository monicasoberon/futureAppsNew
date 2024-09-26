import SwiftUI

struct LawyerDetailView: View {
    var user: UserModel

    @State private var showDetail = false  // State variable to toggle detail view
    
    var body: some View {
        ZStack {
            // Gradient Background for an appealing look
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 20) {
                
                // Adjusted Profile Picture Position
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: showDetail ? 240 : 280, height: showDetail ? 240 : 280) // Start large, shrink when details are shown
                            .shadow(color: Color.blue.opacity(0.4), radius: 20, x: 0, y: 10)
                        
                        Image("default_picture")
                            .resizable()
                            .scaledToFill()
                            .frame(width: showDetail ? 220 : 260, height: showDetail ? 220 : 260) // Start large, shrink when details are shown
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .opacity(1) // Picture always visible
                            .scaleEffect(showDetail ? 1 : 1.1) // Slight scaling effect for emphasis
                    }
                    Spacer()
                }
                .padding(.top, 10) // Adjusted the padding to move the profile picture higher up
                
                // Animated User Information in a rounded card with a transition
                if showDetail {
                    HStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Información del Abogado")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .padding(.bottom, 5)
                            
                            // Lawyer's Name
                            Text(user.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .shadow(color: .blue.opacity(0.2), radius: 2, x: 0, y: 2)

                            // Email with Icon
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.blue)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            // Specialization with Icon
                            HStack {
                                Image(systemName: "briefcase.fill")
                                    .foregroundColor(.blue)
                                Text("Especialidad: \(user.especiality)")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                            
                            // Description with a Bold Label
                            Text("Descripción:")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(user.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 5)
                        }
                        .padding(25)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue.opacity(0.4), lineWidth: 2)
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))  // Move in from bottom and fade in
                        .animation(.easeInOut(duration: 0.6), value: showDetail) // Animate the card
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .navigationTitle("Detalles del Abogado")
        // Automatically trigger the animation after 5 seconds when the view appears
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.spring()) {
                    showDetail = true
                }
            }
        }
    }
}

#Preview {
    LawyerDetailView(user: UserModel.defaultValue)
}
