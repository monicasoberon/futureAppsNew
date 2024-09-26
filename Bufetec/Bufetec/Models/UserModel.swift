import Foundation

class UserModel: Codable {
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
        case userID = "id"
        case name = "nombre"
        case email = "correo"
        case especiality = "especialidad"
        case caseID = "caso_id"
        case description = "descripcion"
        case photo = "foto"
    }

    init(id: String, type: String, userID: String, name: String, email: String, especiality: String, caseID: [String], description: String, photo: String) {
        self.id = id
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
        id: "09876",
        type: "Abogado",
        userID: "9687098",
        name: "Luis Peréz",
        email: "luisperez@bufetec.com",
        especiality: "Familiar",
        caseID: ["caso_01", "caso_02"], // Example default case ID
        description: "Abogado con 10 años de experiencia especializado en leyes familiares.",
        photo: "default_picture"
    )
}