//
//  CaseListView.swift
//  Bufetec
//
//  Created by Jorge on 17/09/24.
//

import SwiftUI

struct CaseListView: View {
    @State private var cases: [LegalCase] = LegalCase.sampleCases
    @State private var isVisible: [Bool] = [] // Array to track each item's visibility
    
    var body: some View {
        NavigationView {
            List(cases.indices, id: \.self) { index in
                let legalCase = cases[index]
                NavigationLink(
                    destination: CaseDetailView(legalCase: legalCase)
                        .navigationBarBackButtonHidden(true) // Hide extra back button
                ) {
                    CaseRowView(legalCase: legalCase)
                        .opacity(isVisible.indices.contains(index) && isVisible[index] ? 1 : 0) // Control visibility
                        .offset(y: isVisible.indices.contains(index) && isVisible[index] ? 0 : 20) // Apply offset animation
                        .animation(.easeOut(duration: 1.5).delay(Double(index) * 0.3), value: isVisible)
                        .onAppear {
                            if index < isVisible.count {
                                withAnimation {
                                    isVisible[index] = true
                                }
                            }
                        }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .onAppear {
                // Initialize isVisible array based on the number of cases
                isVisible = Array(repeating: false, count: cases.count)
            }
            .navigationTitle("Mis Casos")
        }
    }
}

#Preview {
    CaseListView()
}
