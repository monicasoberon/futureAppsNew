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
    case lawyersView
    case appointmentView
    case citasView
    case casesView
    case tesisView
    case precedentesView
    case faqView
    case contactView
    
    case signOut
    
    var title: String {
        switch self {
        case .homeView:
            return "Home Page"
        case .lawyersView:
            return "Consultar Abogados"
        case .appointmentView:
            return "Agendar Cita"
        case .citasView:
            return "Mis Citas"
        case .casesView:
            return "Mis Casos"
        case .tesisView:
            return "Tesis Recientes"
        case .precedentesView:
            return "Precedentes"
        case .faqView:
            return "Preguntas Frecuentes"
        case .contactView:
            return "Contactar"

        case .signOut:
            return "Sign Out"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .homeView:
            return "house.fill"
        case .lawyersView:
            return "person.3.fill"
        case .appointmentView:
            return "calendar.badge.plus"
        case .citasView:
            return "list.bullet"
        case .casesView:
            return "doc.text.fill"
        case .tesisView:
            return "newspaper.fill"
        case .precedentesView:
            return "books.vertical.fill"
        case .faqView:
            return "questionmark.circle.fill"
        case .contactView:
            return "phone.fill"

        case .signOut:
            return "rectangle.portrait.and.arrow.forward"
        }
    }
}




extension SideMenuOptionModel: Identifiable {
    var id: Int {return self.rawValue}
}
