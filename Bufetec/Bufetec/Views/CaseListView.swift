//
//  CaseListView.swift
//  Bufetec
//
//  Created by Jorge on 17/09/24.
//

import SwiftUI

struct CaseListView: View {
    @State private var cases: [LegalCase] = [
        LegalCase(caseID: "caso_001", clientID: "c001", lawyerAssigned: "a001", status: "en progreso", caseDetails: "Caso de robo de identidad", files: ["documento_prueba.pdf"]),
        LegalCase(caseID: "caso_002", clientID: "c002", lawyerAssigned: "a002", status: "abierto", caseDetails: "Caso de fraude financiero", files: ["reporte_inicial.pdf"]),
        LegalCase(caseID: "caso_003", clientID: "c003", lawyerAssigned: "a003", status: "cerrado", caseDetails: "Caso de disputa de contrato", files: ["contrato_disputado.pdf"])
    ]
    
    var body: some View {
        NavigationView {
            List(cases) { legalCase in
                NavigationLink(destination: CaseDetailView(legalCase: legalCase)
                    .navigationBarBackButtonHidden(true) // Hide extra back button
                ) {
                    CaseRowView(legalCase: legalCase)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationTitle("Mis Casos")
        }
    }
}


#Preview {
    CaseListView()
}
