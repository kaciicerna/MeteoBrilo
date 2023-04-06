//
//  MeteoAppApp.swift
//  MeteoApp
//
//  Created by Kateřina Černá on 06.04.2023.
//

import SwiftUI

@main
struct MeteoAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MeteoListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
