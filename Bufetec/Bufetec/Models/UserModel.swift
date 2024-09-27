import Foundation

class UserModel: Identifiable, ObservableObject {
    var id = UUID()
    @Published var type: String
    @Published var userID: String
    @Published var name: String
    @Published var email: String
    @Published var especiality: String
    @Published var caseID: [String]
    @Published var description: String
    @Published var photo: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type = "tipo"
        case userID = "usuario_id"
        case name = "nombre"
        case email = "correo"
        case especiality = "especialidad"
        case caseID = "casos"
        case description = "descripcion"
        case photo = "foto"
    }

    // Initializer with default values
    init(type: String = "abogado",
         userID: String = "a001",
         name: String = "Luis Peréz",
         email: String = "luisperez@bufetec.com",
         especiality: String = "Familiar",
         caseID: [String] = ["caso_01", "caso_02"],
         description: String = "Abogado con 10 años de experiencia especializado en leyes familiares.",
         photo: String = "default_picture") {
        self.type = type
        self.userID = userID
        self.name = name
        self.email = email
        self.especiality = especiality
        self.caseID = caseID
        self.description = description
        self.photo = photo
    }

// Manually implementing encoding (optional if automatic is not working)
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(type, forKey: .type)
//        try container.encode(userID, forKey: .userID)
//        try container.encode(name, forKey: .name)
//        try container.encode(email, forKey: .email)
//        try container.encode(especiality, forKey: .especiality)
//        try container.encode(caseID, forKey: .caseID)
//        try container.encode(description, forKey: .description)
//        try container.encode(photo, forKey: .photo)
//    }
//
//    // Manually implementing decoding (optional if automatic is not working)
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(UUID.self, forKey: .id)
//        type = try container.decode(String.self, forKey: .type)
//        userID = try container.decode(String.self, forKey: .userID)
//        name = try container.decode(String.self, forKey: .name)
//        email = try container.decode(String.self, forKey: .email)
//        especiality = try container.decode(String.self, forKey: .especiality)
//        caseID = try container.decode([String].self, forKey: .caseID)
//        description = try container.decode(String.self, forKey: .description)
//        photo = try container.decode(String.self, forKey: .photo)
//    }
}

// Extension to provide default values
extension UserModel {
    static var defaultValue: UserModel = UserModel(
        type: "abogado",
        userID: "a001",
        name: "Luis Peréz",
        email: "luisperez@bufetec.com",
        especiality: "Familiar",
        caseID: ["caso_01", "caso_02"],
        description: "Abogado con 10 años de experiencia especializado en leyes familiares.",
        photo: "default_picture"
    )
}
