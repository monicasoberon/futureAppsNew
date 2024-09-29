//
//  ContactInfoView.swift
//  Bufetec
//
//  Created by Jorge on 28/09/24.
//

import SwiftUI

struct ContactInfoView: View {
    var iconName: String
    var contactDetail: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(Color(hex: "#4A90E2"))
                .padding(10)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
            
            Text(contactDetail)
                .foregroundColor(Color.black)
        }
    }
}


#Preview {
    ContactInfoView(iconName: "phone.fill", contactDetail: "+1 (234) 567-890")
}
