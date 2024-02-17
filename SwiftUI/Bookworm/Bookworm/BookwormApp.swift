//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Tibin Thomas on 2024-02-15.
//
import SwiftData
import SwiftUI


@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
