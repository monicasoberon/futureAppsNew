//
//  CaseRowView.swift
//  Bufetec
//
//  Created by Jorge on 19/09/24.
//

import SwiftUI

struct CaseRowView: View {
    var legalCase: LegalCase
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(legalCase.caseName)
                    .font(.headline)
                    .bold()
                
                Text("N°: \(legalCase.caseID)")
                    .font(.caption)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            // Status Button
            Circle()
                .frame(width: 30, height: 30)
                .font(.body)
                .padding(3)
                .foregroundColor(statusColor(for: legalCase.status))
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 4)
    }
    
    // Function to get status color
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "abierto":
            return Color.green
        case "en progreso":
            return Color.yellow
        case "cerrado":
            return Color.red
        default:
            return Color.gray
        }
    }
}

#Preview {
    CaseRowView(legalCase: LegalCase.defaultValue)
}
