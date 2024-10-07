//
//  SideMenuHeaderView.swift
//  Bufetec
//
//  Created by Jorge on 03/10/24.
//

import SwiftUI

struct SideMenuHeaderView: View {
    
    @ObservedObject var user: UserModel
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("\(user.name) - \(user.especiality)")
                    .font(.headline)
                
                Text(user.email)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    SideMenuHeaderView(user: UserModel.defaultValue)
}
