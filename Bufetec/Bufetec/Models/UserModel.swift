import Foundation

class UserModel: Codable, Identifiable {
    var id = UUID()
    var type: String
    var userID: String
    var name: String
    var email: String
    var especiality: String
    var caseID: [String]
    var description: String
    var photo: String
    
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
    
    init(type: String, userID: String, name: String, email: String, especiality: String, caseID: [String], description: String, photo: String) {
        self.type = type
        self.userID = userID
        self.name = name
        self.email = email
        self.especiality = especiality
        self.caseID = caseID
        self.description = description
        self.photo = photo
    }
}

// Extension to provide default values
extension UserModel {
    static var defaultValue: UserModel = UserModel(
        type: "Abogado",
        userID: "a001",
        name: "Luis Peréz",
        email: "luisperez@bufetec.com",
        especiality: "Familiar",
        caseID: ["caso_01", "caso_02"],
        description: "Abogado con 10 años de experiencia especializado en leyes familiares.",
        photo: "default_picture"
    )
}
