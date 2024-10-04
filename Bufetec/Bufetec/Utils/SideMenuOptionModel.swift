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
    case newsView
    case casesView
    case faqView
    case contactView
    case signOut
    
    var title: String {
        switch self {
        case .homeView:
            return "Home Page"
        case .appointmentView:
            return "Agendar Cita"
        case .lawyersView:
            return "Consultar Abogados"
        case .newsView:
            return "Novedades y Biblioteca"
        case .casesView:
            return "Mis Casos"
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
        case .appointmentView:
            return "calendar.badge.plus"
        case .lawyersView:
            return "person.3.fill"
        case .newsView:
            return "newspaper.fill"
        case .casesView:
            return "doc.text.fill"
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
