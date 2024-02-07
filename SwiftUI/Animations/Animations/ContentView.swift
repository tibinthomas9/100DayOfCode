//
//  ContentView.swift
//  Animations
//
//  Created by Tibin Thomas on 2024-02-05.
//

import SwiftUI





struct ContentView: View {
    @State private var amplitude: CGFloat = 50.0
    @State private var frequency: CGFloat = 1.0
    @State private var phase: CGFloat = 0.0
    @State private var knobPosition: CGPoint = .zero

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                
                
                SineWaveShape(amplitude: amplitude, frequency: frequency, phase: phase)
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 800, height: 200)
                
                    .padding()
                    .overlay(Knob(position: $knobPosition, amplitude: amplitude, frequency: frequency, phase: phase))
            }.scrollIndicators(.hidden)
                .frame(height: 400)
            Text("Amplitude: \(amplitude)")
            Slider(value: $amplitude, in: 10...100, step: 1)

            Text("Frequency: \(frequency)")
            Slider(value: $frequency, in: 0.1...5, step: 0.1)

            Text("Phase: \(phase)")
            Slider(value: $phase, in: 0...360, step: 1)
        }
        .padding()
    }

    struct Knob: View {
        @Binding var position: CGPoint
        var amplitude: CGFloat
        var frequency: CGFloat
        var phase: CGFloat

        var body: some View {
            Circle()
                .fill(Color.red)
                .frame(width: 20, height: 20)
                .position(calculateKnobPosition())
                .gesture(DragGesture()
                    .onChanged { value in
                        position = value.location
                    }
                )
        }

        private func calculateKnobPosition() -> CGPoint {
            let x = position.x
            let y = amplitude * sin(frequency * x + phase) + UIScreen.main.bounds.midY
            return CGPoint(x: x, y: y)
        }
    }
}

struct SineWaveShape: Shape {
    var amplitude: CGFloat
    var frequency: CGFloat
    var phase: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let step = 1.0
        let numberOfPoints = Int(rect.width / CGFloat(step))

        path.move(to: CGPoint(x: 0, y: rect.midY))

        for i in 0..<numberOfPoints {
            let x = CGFloat(i) * CGFloat(step)
            let y = amplitude * sin(frequency * x + phase) + rect.midY
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return path
    }
}



//struct ContentView: View {
//    @State private var amplitude: CGFloat = 50.0
//    @State private var frequency: CGFloat = 1.0
//    @State private var phase: CGFloat = 0.0
//    @State private var knobPosition: CGPoint = .zero
//
//    var body: some View {
//        VStack {
//            SineWaveShape(amplitude: amplitude, frequency: frequency, phase: phase)
//                .stroke(Color.blue, lineWidth: 2)
//                .frame(height: 200)
//                .padding()
//                .overlay(Knob(position: $knobPosition))
//
//            Text("Amplitude: \(amplitude)")
//            Slider(value: $amplitude, in: 10...100, step: 1)
//
//            Text("Frequency: \(frequency)")
//            Slider(value: $frequency, in: 0.1...5, step: 0.1)
//
//            Text("Phase: \(phase)")
//            Slider(value: $phase, in: 0...360, step: 1)
//        }
//        .padding()
//    }
//
//    struct Knob: View {
//        @Binding var position: CGPoint
//
//        var body: some View {
//            Circle()
//                .fill(Color.red)
//                .frame(width: 20, height: 20)
//                .position(position)
//                .gesture(DragGesture()
//                    .onChanged { value in
//                        position = value.location
//                    }
//                )
//        }
//    }
//}

//struct SineWaveShape: Shape {
//    var amplitude: CGFloat
//    var frequency: CGFloat
//    var phase: CGFloat
//
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//
//        let step = 1.0
//        let numberOfPoints = Int(rect.width / CGFloat(step))
//
//        path.move(to: CGPoint(x: 0, y: rect.midY))
//
//        for i in 0..<numberOfPoints {
//            let x = CGFloat(i) * CGFloat(step)
//            let y = amplitude * sin(frequency * x + phase) + rect.midY
//            path.addLine(to: CGPoint(x: x, y: y))
//        }
//
//        return path
//    }
//}




//struct ContentView: View {
//    @State private var amplitude: CGFloat = 50.0
//    @State private var frequency: CGFloat = 1.0
//    @State private var phase: CGFloat = 0.0
//
//    var body: some View {
//        VStack {
//            SineWaveShape(amplitude: amplitude, frequency: frequency, phase: phase)
//                .stroke(Color.blue, lineWidth: 2)
//                .frame(height: 200)
//                .padding()
//
//            Text("Amplitude: \(amplitude)")
//            Slider(value: $amplitude, in: 10...100, step: 1)
//
//            Text("Frequency: \(frequency)")
//            Slider(value: $frequency, in: 0.1...5, step: 0.1)
//
//            Text("Phase: \(phase)")
//            Slider(value: $phase, in: 0...360, step: 1)
//        }
//        .padding()
//    }
//}

//struct SineWaveShape: Shape {
//    var amplitude: CGFloat
//    var frequency: CGFloat
//    var phase: CGFloat
//
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//
//        let step = 1.0
//        let numberOfPoints = Int(rect.width / CGFloat(step))
//
//        path.move(to: CGPoint(x: 0, y: rect.midY))
//
//        for i in 0..<numberOfPoints {
//            let x = CGFloat(i) * CGFloat(step)
//            let y = amplitude * sin(frequency * x + phase) + rect.midY
//            path.addLine(to: CGPoint(x: x, y: y))
//        }
//
//        return path
//    }
//}



struct ContentViewa: View {
    @State private var isShowingRed = false
    
    var body: some View {
        VStack {
            Button("Tap") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.scale)
            }
        }
        
    }
}
struct ContentView3: View {
    let letters = Array("Hello SwiftUI")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.default.delay(Double(num) / 20), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded { _ in
                    dragAmount = .zero
                    enabled.toggle()
                }
        )
    }
}


struct ContentView2: View {
//    @State private var scale = 0.0
//    @State private var dragAmount = CGSize.zero
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    let letters = Array("Hello SwiftUI")
    
    
    
    
    var body: some View {
        
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.default.delay(Double(num/20)),value: dragAmount )
                
            }
            
        }.gesture(DragGesture().onChanged{
            dragAmount = $0.translation
        }
            .onEnded{ _ in
                dragAmount = .zero
                enabled.toggle()
            }
        )
//        LinearGradient(colors: [.yellow, .red], startPoint: .top, endPoint: .bottom)
//            .frame(width: 200, height: 200)
//            .clipShape(.rect(cornerRadius: 10))
//            .offset(dragAmount)
//            .gesture(DragGesture()
//                .onChanged {dragAmount = $0.translation  }
//                .onEnded{_ in 
//                    withAnimation(.bouncy) {
//                        dragAmount = .zero
//                    }
//                    
//                }
//            )
         //   .animation(.bouncy, value: dragAmount)
       // VStack {
//            Stepper("Scakr naount", value: $scale.animation(), in: 1...10)
//            Spacer()
//            Button("Tap ") {
//                withAnimation(.spring(duration: 1,bounce: 0.5)) {
//                    scale += 360
//                }
//            }
//            .padding(40)
//            .background(.red)
//            .foregroundStyle(.white)
//            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//            .rotation3DEffect(
//                .degrees(scale),
//                                      axis: (x: 1.0, y: 0.0, z: 0.0)
//            )
   //     }
        
//        Button("tap me ") {
//          //  withAnimation {
//             //   scale += 1
//         //   }
//        }
//        .padding(50)
//        .background(.red)
//        .foregroundStyle(.white)
//        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//        .overlay {
//            Circle()
//                .stroke( .red)
//                .scaleEffect(scale)
//                .opacity(2 - scale)
//                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: false), value: scale)
//        }
//        
        
        
       
    }
}

#Preview {
    ContentView()
}
