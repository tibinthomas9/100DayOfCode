//
//  ContentView.swift
//  FunDraw
//
//  Created by Tibin Thomas on 2024-02-20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            DrawingCanvasView()    
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}

#Preview {
    ContentView()
}
