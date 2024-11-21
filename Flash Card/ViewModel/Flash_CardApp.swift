//
//  Flash_CardApp.swift
//  Flash Card
//
//  Created by Muhamad Septian Nugraha on 19/11/24.
//

import SwiftUI

@main
struct Flash_CardApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            FlashcardListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
