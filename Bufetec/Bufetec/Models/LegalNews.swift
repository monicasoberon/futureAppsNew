import Foundation

struct LegalNews: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let date: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title = "titulo"
        case description = "descripcion"
        case date = "fecha"
    }
}
