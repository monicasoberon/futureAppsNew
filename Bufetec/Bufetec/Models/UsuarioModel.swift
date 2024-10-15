import Foundation

class UsuarioModel: Codable, Identifiable {
    var id: String
    var tipo: String
    var uid: String
    var nombre: String
    var correo: String
    var especialidad: String?
    var descripcion: String?
    var foto: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case tipo
        case uid
        case nombre
        case correo
        case especialidad
        case descripcion
        case foto
    }
}
