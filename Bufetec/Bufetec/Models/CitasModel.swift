//
//  CitasModel.swift
//  Bufetec
//
//  Created by Luis Gzz on 15/10/24.
//

import Foundation

class CitasModel: Codable {

    var id: Int
    var cliente_id: Int
    var abogado_id: Int
    var hora: Date

    init(id: Int, cliente_id: Int, abogado_id: Int, hora: Date) {
        self.id = id
        self.cliente_id = cliente_id
        self.abogado_id = abogado_id
        self.hora = hora
    }

    enum CodingKeys: String, CodingKey {
        case id
        case cliente_id = "clienteId"
        case abogado_id = "abogadoId"
        case hora
    }
}
