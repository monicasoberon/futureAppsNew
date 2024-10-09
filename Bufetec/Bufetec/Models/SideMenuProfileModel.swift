import Foundation

class SideMenuProfileModel: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var photo: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "nombre"
        case email = "correo"
        case photo = "foto"
    }
}
