import Foundation

class CitasModel: Codable, Identifiable {
    var id: String
    var cliente_id: String
    var abogado_id: String
    var hora: Date

    // Nuevas propiedades opcionales para los nombres
    var cliente_nombre: String?
    var abogado_nombre: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case cliente_id
        case abogado_id
        case hora
    }
}
