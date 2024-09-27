//
//  BufetecApp.swift
//  Bufetec
//
//  Created by Alumno on 17/09/24.
//

import SwiftUI
import SwiftData
import Firebase
import GoogleSignIn


@main struct BufetecApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    //@State var legalCase: LegalCase = LegalCase.defaultValue


    var body: some Scene {
        WindowGroup {
            HomeView()
                .onOpenURL(perform: { url in
                    GIDSignIn.sharedInstance.handle(url)
                })
        }
        .modelContainer(sharedModelContainer)
    }
}
