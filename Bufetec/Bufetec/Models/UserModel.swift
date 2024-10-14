import Foundation

class UserModel: Identifiable, Codable, ObservableObject {
    var id: String
    var type: String
    var userID: String
    var name: String
    var email: String
    var especiality: String // Campo opcional
    var description: String // Campo opcional
    var photo: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type = "tipo"
        case userID = "uid"
        case name = "nombre"
        case email = "correo"
        case especiality = "especialidad"
        case description = "descripcion"
        case photo = "foto"
    }

    init(type: String = "abogado",
         userID: String = "a001",
         name: String = "Luis Peréz",
         email: String = "luisperez@bufetec.com",
         especiality: String = "Familiar",
         description: String = "Abogado con 10 años de experiencia especializado en leyes familiares.",
         photo: String = "default_picture") {
        self.id = UUID().uuidString
        self.type = type
        self.userID = userID
        self.name = name
        self.email = email
        self.especiality = especiality
        self.description = description
        self.photo = photo
    }
}

// Extension para proporcionar valores por defecto
extension UserModel {
    static var defaultValue: UserModel = UserModel(
        type: "abogado",
        userID: "a001",
        name: "Luis Peréz",
        email: "luisperez@bufetec.com",
        especiality: "Familiar",
        description: "Abogado con 10 años de experiencia especializado en leyes familiares.",
        photo: "default_picture"
    )
}
