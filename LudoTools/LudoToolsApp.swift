//
//  LudoToolsApp.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 10/08/25.
//

import SwiftUI
import SwiftData

@main
struct LudoToolsApp: App {
    @Inject(ModelContainer.self)
    var sharedModelContainer: ModelContainer

    init() {
        ModuleRegister().register()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
