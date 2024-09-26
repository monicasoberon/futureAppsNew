//
//  Case.swift
//  Bufetec
//
//  Created by Jorge on 17/09/24.
//

import SwiftUI

class LegalCase: Identifiable {
    var id = UUID()
    var caseID: String
    var clientID: String
    var lawyerAssigned: String
    var status: String
    var caseDetails: String
    var files: [String]
    
    // Initializer
    init(caseID: String, clientID: String, lawyerAssigned: String, status: String, caseDetails: String, files: [String]) {
        self.caseID = caseID
        self.clientID = clientID
        self.lawyerAssigned = lawyerAssigned
        self.status = status
        self.caseDetails = caseDetails
        self.files = files
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case caseID = "id"
        case clientID = "cliente_id"
        case lawyerAssigned = "abogado_asignado"
        case status = "estado"
        case caseDetails = "detalles"
        case files = "archivos"
    }
}

// Extension to provide default values
extension LegalCase {
    static var defaultValue: LegalCase = LegalCase(
        caseID: "caso_001",
        clientID: "c001",
        lawyerAssigned: "a001",
        status: "en progreso",
        caseDetails: "Caso de robo de identidad",
        files: ["documento_prueba.pdf"]
    )
}
