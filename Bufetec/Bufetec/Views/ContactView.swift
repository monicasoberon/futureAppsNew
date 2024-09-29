//
//  ContactView.swift
//  Bufetec
//
//  Created by Jorge on 28/09/24.
//

import SwiftUI

struct ContactView: View {
    @ObservedObject var user: UserModel
    
    @State var message: String = ""
    
    @State private var isSent: Bool = false

    var body: some View {
        VStack {
            // Title
            Text("Contactar")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#003366"))
                .padding(.top, 20)
            
            Spacer().frame(height: 20)
            
            // Name Input
            VStack(alignment: .leading, spacing: 5) { // Ensure alignment is set to leading
                Text("Name")
                    .font(.headline)
                
                TextField("Your Name", text: $user.name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
            }
            .padding(.horizontal, 20)
            
            // Email Input
            VStack(alignment: .leading, spacing: 5) {
                Text("Email")
                    .font(.headline)
                
                TextField("Email", text: $user.email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
            }
            .padding(.horizontal, 20)
            
            // Message Input
            VStack(alignment: .leading, spacing: 5) {
                Text("Message")
                    .font(.headline)
                
                TextEditor(text: $message)
                    .padding()
                    .frame(height: 150)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
            }
            .padding(.horizontal, 20)
            
            // Send Button
            Button(action: {
                // Action for sending message
                isSent = true
            }) {
                Text("Send")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#4A90E2"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(color: Color(hex: "#003366").opacity(0.3), radius: 5, x: 0, y: 5)
            }
            .padding(.horizontal, 20)
            .alert(isPresented: $isSent) {
                Alert(title: Text("Message Sent"), message: Text("Thank you for contacting us!"), dismissButton: .default(Text("OK")))
            }
            
            Spacer().frame(height: 30)
            
            // Contact Information Section
            HStack(spacing: 20) {
                ContactInfoView(iconName: "phone.fill", contactDetail: "+1 (234) 567-890")
                ContactInfoView(iconName: "envelope.fill", contactDetail: "contact@bufetec.com")
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(Color(hex: "#F0F4FF"))
    }
}

#Preview {
    ContactView(user: UserModel.defaultValue)
}
