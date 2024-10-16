//
//  SideMenuOptionModel.swift
//  Bufetec
//
//  Created by Jorge on 03/10/24.
//

import Foundation
import SwiftUI

enum SideMenuOptionModel: Int, CaseIterable {
    case homeView
    case appointmentView
    case lawyersView
    case tesisView
    case precedentesView
    case casesView
    case faqView
    case contactView
    case citasView
    case signOut
    
    var title: String {
        switch self {
        case .homeView:
            return "Home Page"
        case .appointmentView:
            return "Agendar Cita"
        case .lawyersView:
            return "Consultar Abogados"
        case .tesisView:
            return "Tesis Recientes"
        case .precedentesView:
            return "Precedentes"
        case .casesView:
            return "Mis Casos"
        case .faqView:
            return "Preguntas Frecuentes"
        case .contactView:
            return "Contactar"
        case .citasView:
            return "Mis Citas"
        case .signOut:
            return "Sign Out"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .homeView:
            return "house.fill"
        case .appointmentView:
            return "calendar.badge.plus"
        case .lawyersView:
            return "person.3.fill"
        case .tesisView:
            return "newspaper.fill"
        case .precedentesView:
            return "books.vertical.fill"
        case .casesView:
            return "doc.text.fill"
        case .faqView:
            return "questionmark.circle.fill"
        case .contactView:
            return "phone.fill"
        case .citasView:
            return "calendar.badge.minus"
        case .signOut:
            return "rectangle.portrait.and.arrow.forward"
        }
    }
}




extension SideMenuOptionModel: Identifiable {
    var id: Int {return self.rawValue}
}
