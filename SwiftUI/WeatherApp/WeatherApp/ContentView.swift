//
//  ContentView.swift
//  WeatherApp
//
//  Created by Tibin Thomas on 2024-02-24.
//

import SwiftUI


import SwiftUI







struct PinnableHeaderLazyVGrid: View {
    let columns = [
        GridItem(.fixed(100), spacing: 0),
        GridItem(.fixed(100), spacing: 0),
        // Add more columns as needed
    ]

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(0..<10) { row in
                    VStack {
                        // Your content for each grid item
                        Text("Item \(row)")
                            .frame(width: 100, height: 100)
                    }
                }
            }
            .overlay(
                GeometryReader { proxy in
                    HStack {
                        // Your pinnable header content
                        Text("Header 1")
                            .frame(width: 100, height: 50)
                            .background(Color.blue)
                            .fixedSize()
                            .offset(x: proxy.frame(in: .global).minX)
                        
                        Text("Header 2")
                            .frame(width: 100, height: 50)
                            .background(Color.green)
                            .fixedSize()
                            .offset(x: proxy.frame(in: .global).maxX - 100)
                    }
                }
                .frame(height: 50)
            )
        }
    }
}




enum WeatherSectionItems {
    case hourly
    case tenday
    case airquality
    
}

import SwiftUI

struct ContentView2: View {
    let columns = [
        GridItem(.flexible(minimum: 100)),
        GridItem(.flexible(minimum: 100))
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [.white, .blue], startPoint: .top, endPoint: .bottomTrailing)
            
                
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], content: {
                Section("hourly") {
                  Rectangle()
                        .fill(.red)
                        .frame(maxWidth: .infinity)
                }.frame(maxWidth: .infinity)
            HStack {
                Section("section 2") {
                  Rectangle()
                        .fill(.green)
                }
                Section("section 3") {
                  Rectangle()
                        .fill(.blue)
                }
            }
                
            })
            .padding()
        }
    }
}



struct WeatherSection {
    var section: String
    var items: [WeatherSectionItems]
    
}

struct ContentView: View {
    
    let data = [
        WeatherSection(section: "Section 1", items: [.airquality]),
        WeatherSection(section: "Section 2", items: [.hourly,.tenday]),
            // Add more sections as needed
        ]
    
    var body: some View {
        let columns = [GridItem(.flexible())]
        ScrollView {
            LazyVGrid(columns: columns) {
                
            }
        }
        .padding()
    }
}

#Preview {
    ContentView2()
}
