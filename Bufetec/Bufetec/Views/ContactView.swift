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
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Contactar")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#003366"))
                
                Spacer().frame(height: 20)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Name")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#333333"))
                    
                    TextField("Your Name", text: $user.name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
                        .foregroundColor(Color(hex: "#757575"))
                }
                .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Email")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#333333"))
                    
                    TextField("Email", text: $user.email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
                        .foregroundColor(Color(hex: "#757575"))
                }
                .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Message")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#333333"))
                    
                    TextEditor(text: $message)
                        .padding()
                        .frame(height: 150)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
                        .foregroundColor(Color(hex: "#757575"))
                }
                .padding(.horizontal, 20)
                
                Button(action: {
                    // Perform the send action and set isSent to true
                    sendMessage()
                }) {
                    Text("Send")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .shadow(color: Color(hex: "#003366").opacity(0.3), radius: 5, x: 0, y: 5)
                }
                .padding(.horizontal, 20)
                .alert(isPresented: $isSent) {
                    Alert(
                        title: Text("Message Sent"),
                        message: Text("Thank you for contacting us!"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment: .leading, spacing: 20) {
                    Link(destination: URL(string: "tel:528183284344")!) {
                        ContactInfoView(iconName: "phone.fill", contactDetail: "+52 (81) 8328 4344")
                    }
                    ContactInfoView(iconName: "envelope.fill", contactDetail: "contact@bufetec.com")
                    ContactInfoView(iconName: "mappin.and.ellipse", contactDetail: "Edificio Pabellón Tec, segundo piso, oficina PT-138-24")
                }
                .padding(.horizontal, 20)
            }
            .onAppear {
                user.fetchAuthenticatedUser()
            }
            
            Spacer()
        }
    }

    // Function to handle send action and show alert
    private func sendMessage() {
        // Add any necessary logic to send the message here.
        // Example: Network request, save data, etc.
        
        // After sending the message, show the alert
        isSent = true
    }
}

#Preview {
    ContactView(user: UserModel.defaultValue)
}
