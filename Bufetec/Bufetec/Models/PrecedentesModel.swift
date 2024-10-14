//
//  SentenciasModel.swift
//  Bufetec
//
//  Created by Jorge on 14/10/24.
//

import Foundation

struct PrecedentesModel: Identifiable, Codable {
    let id: String
    let registroDigital: String
    let precedente: String
    let notas: String
    let promovente: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case registroDigital = "Registro digital"
        case precedente = "Precedente"
        case notas = "Notas"
        case promovente = "Promovente"
    }

}
