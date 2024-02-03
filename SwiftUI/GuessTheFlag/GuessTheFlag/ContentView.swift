//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Tibin Thomas on 2024-02-02.
//

import SwiftUI

struct ContentView: View {
    @State private  var countries = ["Estonia", "France", "Germany","Poland","UK","Ukraine","US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var scoreTilte: String = ""
    @State private var showingScore: Bool = false
    @State private var score: Int = 0
    
    var body: some View {
        ZStack {
            RadialGradient(stops:[
                .init(color: Color(red:0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red:0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700).ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap")
                            .foregroundStyle(.secondary)
                            .font(.title3.weight(.semibold))
                        Text(countries[correctAnswer])
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.weight(.heavy))
                           
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(Capsule())
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        }
                    }
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score : \(score)")
                    .font(.largeTitle.weight(.bold))
                Spacer()
            }.padding()
           
        }.alert("Score", isPresented: $showingScore) {
            Button("Coninue", action: askQuestion)
        } message: {
            Text("Your score is: \(score)")
        }
    }
    
    
    func flagTapped(_ number: Int) {
        
        if number == correctAnswer {
            scoreTilte = "Correct"
            score += 1
        } else {
            scoreTilte = "Wrong"
            score -= 1
        }
        showingScore = true
        
    }
    
     func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
}







struct ContentView4: View {
    
    @State var isPResented: Bool = false
    var body: some View {
        Button("Prss me") {
            print("Now delete")
        }
        Button("Presss me", role: .destructive, action: presme)
            .buttonStyle(.bordered)
            .tint(.gray)
        
        
        HStack {
            Button("Presss me", role: .destructive, action: presme)
                .buttonStyle(.borderedProminent)
            Button("Presss me", role: .destructive, action: presme)
                .buttonStyle(.automatic)
            Button("Presss me", role: .destructive, action: presme)
                .buttonStyle(.borderless)
            Button("Presss me", role: .destructive, action: presme)
                .buttonStyle(.plain)
        }.alert("alert", isPresented: $isPResented) {
            
        } message: {
           Text("nothing")
        }
    }
    
    func presme() {
        isPResented = true
    }
}


#Preview {
    ContentView()
}


struct ContentView3: View {
    var body: some View {
        Button("Prss me") {
            print("Now delete")
        }
        Button("Presss me", role: .destructive, action: presme)
            .buttonStyle(.bordered)
            .tint(.gray)
        
        
        
        Button("Presss me", role: .destructive, action: presme)
            .buttonStyle(.borderedProminent)
        Button("Presss me", role: .destructive, action: presme)
            .buttonStyle(.automatic)
        Button("Presss me", role: .destructive, action: presme)
            .buttonStyle(.borderless)
        Button("Presss me", role: .destructive, action: presme)
            .buttonStyle(.plain)
    }
    
    func presme() {
        
    }
}
struct ContentView2: View {
    var body: some View {
        ZStack {
            Text("Tibin")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.white)
                .background(.red.gradient)
        }
    }
}
struct ContentView1: View {
    var body: some View {
        ZStack {
            VStack {
                Color.gray
                Color.red
            }
            Text("Hello, world!")
                .foregroundStyle(.foreground)
                .padding(50)
                .background(.thinMaterial)
        }
    }
}
