import Foundation

class ProfileModel: Identifiable, Codable {
    var id: String
    var type: String
    var userID: String
    var name: String
    var email: String
    var especiality: String? // Campo opcional
    var description: String? // Campo opcional
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
}
