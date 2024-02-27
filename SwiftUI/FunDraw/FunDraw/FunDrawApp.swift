//
//  FunDrawApp.swift
//  FunDraw
//
//  Created by Tibin Thomas on 2024-02-20.
//

import SwiftUI

@main
struct FunDrawApp: App {
   
    @State private var percentage = 25.0
    var body: some Scene {
        WindowGroup {
            VStack {
                SineWave(frequency: 0.5, amplitude: 0.7, percentage: $percentage)
                .overlay(alignment: .topLeading) {
                    VStack {
                        Text(percentage.formatted())
                        
                    }
                }
            Button("Half") {
                percentage = 50.0
            }
        }
              
            
        }
    }
}
