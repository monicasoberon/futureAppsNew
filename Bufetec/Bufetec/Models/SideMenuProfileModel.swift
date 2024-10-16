import Foundation

class SideMenuProfileModel: Identifiable, Codable {
    var id: String
    var type: String // Agregar esta línea
    var name: String
    var email: String
    var photo: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type = "tipo" // Agregar esta línea
        case name = "nombre"
        case email = "correo"
        case photo = "foto"
    }
}
