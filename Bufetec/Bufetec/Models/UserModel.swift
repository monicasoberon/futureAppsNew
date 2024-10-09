import Foundation

class UserModel: Identifiable, Codable, ObservableObject {
    var id: String
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
        case userID = "uid"
        case name = "nombre"
        case email = "correo"
        case especiality = "especialidad"
        case caseID = "caso_id"
        case description = "descripcion"
        case photo = "foto"
    }

    init(type: String = "abogado",
         userID: String = "a001",
         name: String = "Luis Peréz",
         email: String = "luisperez@bufetec.com",
         especiality: String = "Familiar",
         caseID: [String] = ["caso_01", "caso_02"],
         description: String = "Abogado con 10 años de experiencia especializado en leyes familiares.",
         photo: String = "default_picture") {
        self.id = UUID().uuidString
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
