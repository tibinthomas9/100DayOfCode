//
//  _048App.swift
//  2048
//
//  Created by Tibin Thomas on 2024-02-03.
//

import SwiftUI

@main
struct _048App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
