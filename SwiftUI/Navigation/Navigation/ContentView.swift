//
//  ContentView.swift
//  Navigation
//
//  Created by Tibin Thomas on 2024-02-09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(0..<100) { num in
                NavigationLink("Selcting", value: num)
                
            }.navigationDestination(for: Int.self) { num in
                Text(num.formatted())
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
