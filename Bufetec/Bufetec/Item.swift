//
//  Item.swift
//  Bufetec
//
//  Created by Alumno on 17/09/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
