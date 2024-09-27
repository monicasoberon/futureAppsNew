import Foundation

class LegalCase: Identifiable, Codable, Equatable {
    var id: String
    var caseID: String
    var caseName: String
    var clientID: String
    var lawyerAssigned: String
    var status: String
    var caseDetails: String
    var files: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case caseID = "id"
        case caseName = "nombre"
        case clientID = "cliente_id"
        case lawyerAssigned = "abogado_asignado"
        case status = "estado"
        case caseDetails = "detalles"
        case files = "archivos"
    }
    
    init(caseID: String, caseName: String, clientID: String, lawyerAssigned: String, status: String, caseDetails: String, files: [String]) {
        self.id = UUID().uuidString
        self.caseID = caseID
        self.caseName = caseName
        self.clientID = clientID
        self.lawyerAssigned = lawyerAssigned
        self.status = status
        self.caseDetails = caseDetails
        self.files = files
    }
    
    // Conformidad a Equatable
    static func == (lhs: LegalCase, rhs: LegalCase) -> Bool {
        return lhs.id == rhs.id
    }
}

extension LegalCase {
    static var defaultValue: LegalCase = LegalCase(
        caseID: "caso_001",
        caseName: "Caso 1",
        clientID: "c001",
        lawyerAssigned: "a001",
        status: "en progreso",
        caseDetails: "Caso de robo de identidad",
        files: ["documento_prueba.pdf"]
    )
    
    // Extension to provide multiple default cases
    static var sampleCases: [LegalCase] = [
        LegalCase(
            caseID: "caso_01",
            caseName: "Caso de Robo de Identidad",
            clientID: "c001",
            lawyerAssigned: "a001",
            status: "abierto",
            caseDetails: "Caso relacionado con robo de identidad y fraude.",
            files: ["documento_prueba.pdf"]
        ),
        LegalCase(
            caseID: "caso_02",
            caseName: "Divorcio Contencioso",
            clientID: "c001",
            lawyerAssigned: "a002",
            status: "cerrado",
            caseDetails: "Divorcio con disputa sobre la custodia de los hijos.",
            files: ["acuerdo_divorcio.pdf"]
        ),
        LegalCase(
            caseID: "caso_03",
            caseName: "Disputa de Propiedad",
            clientID: "c002",
            lawyerAssigned: "a001",
            status: "en progreso",
            caseDetails: "Disputa legal sobre la propiedad de un inmueble.",
            files: ["escritura.pdf", "pruebas_fotograficas.jpg"]
        )
    ]
}
