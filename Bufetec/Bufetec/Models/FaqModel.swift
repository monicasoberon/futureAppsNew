import Foundation

class FaqModel: Codable {
    var id: String
    var question: String
    var answer: String


    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case question = "pregunta"
        case answer = "respuesta"
    }

    init(id: String, question: String, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
}


// Extension to provide default values
extension FaqModel {
    static var defaultValue: FaqModel = FaqModel(
        id: "default_id",
        question: "default_type",
        answer: "default_user_id"
    )
}
