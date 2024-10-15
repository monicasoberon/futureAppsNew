import Foundation
import FirebaseAuth

class UserModel: Identifiable, Codable, ObservableObject {
    var id: String
    var type: String
    var userID: String
    @Published var name: String
    @Published var email: String
    var especiality: String
    var description: String
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

    // Manual encoding and decoding for @Published properties
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        userID = try container.decode(String.self, forKey: .userID)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        especiality = try container.decode(String.self, forKey: .especiality)
        description = try container.decode(String.self, forKey: .description)
        photo = try container.decode(String.self, forKey: .photo)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(userID, forKey: .userID)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(especiality, forKey: .especiality)
        try container.encode(description, forKey: .description)
        try container.encode(photo, forKey: .photo)
    }

    // Fetch authenticated user’s data
    func fetchAuthenticatedUser() {
        if let user = Auth.auth().currentUser {
            self.name = user.displayName ?? self.name
            self.email = user.email ?? self.email
            self.userID = user.uid
        }
    }

    // Default value
    static var defaultValue: UserModel = UserModel()
}
