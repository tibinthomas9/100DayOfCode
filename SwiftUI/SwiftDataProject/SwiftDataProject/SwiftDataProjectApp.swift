//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by Tibin Thomas on 2024-02-18.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: User.self)
    }
}

