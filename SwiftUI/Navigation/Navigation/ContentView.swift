//
//  ContentView.swift
//  Navigation
//
//  Created by Tibin Thomas on 2024-02-09.
//

import SwiftUI

struct ContentView: View {
    @State private var path = [Int]()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<10) { i in
                    NavigationLink("selldsd", value: i)
                }
                ForEach(0..<10) { i in
                    NavigationLink("String", value: String(i))
                }
            }
            
        }.navigationDestination(for: Int.self) { intItem in
            Text(intItem.formatted())
        }.navigationDestination(for: String.self) { intItem in
            Text(intItem)
        }
    }
}
struct ContentView2: View {
    @State private var path = [Int]()
    
    var body: some View {
        NavigationStack(path: $path) {
            Button("Path 34") {
                path.append(34)
            }
            Button("Path 30") {
                path = [30]
            }
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
