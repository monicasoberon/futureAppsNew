//
//  TesisModel.swift
//  Bufetec
//
//  Created by Jorge on 08/10/24.
//

import Foundation

struct TesisModel: Identifiable {
    let id: String
    let registroDigital: String
    let tesis: String
    let description: String
    let date: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case registroDigital = "Registro digital"
        case tesis = "Tesis"
        case description = "Rubro"
        case location = "Localización"
    }

}
