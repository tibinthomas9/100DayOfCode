//
//  MoonShotApp.swift
//  MoonShot
//
//  Created by Tibin Thomas on 2024-02-08.
//

import SwiftUI

@main
struct MoonShotApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    
}

struct Mission: Codable, Identifiable {
    
    var displayName: String {
        return "Apollo \(id)"
        
    }
    var image: String {
        return "apollo\(id)"
    }
    
    var formattedlaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "NA"
    }
    
    struct CrewRole: Codable {
        let name: String
        let role: String
        
    }
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
}


extension Bundle {
    func decode<T: Codable>(filename: String) -> T {
        guard let url = self.url(forResource: filename, withExtension: nil) else {
            fatalError()
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError()
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError()
        }
        return loaded
        
    }
}

extension ShapeStyle where Self == Color {
    static var darkBackgroud: Color {
        Color(red: 0.1, green: 0.1, blue: 0.2)
    }
    static var lightBackgroud: Color {
        Color(red: 0.2, green: 0.2, blue: 0.3)
    }
}
