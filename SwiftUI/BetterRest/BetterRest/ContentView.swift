//
//  ContentView.swift
//  BetterRest
//
//  Created by Tibin Thomas on 2024-02-04.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var sleepAmount: Double = 8.0
    @State private var wakeUp = Date.now
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please enter time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                Text("Desired Amnount of sleep").font(.headline)
                Stepper("\(sleepAmount.formatted()) hours",value: $sleepAmount, in: 4...12, step: 0.25)
                Text("Cofeee")
                    .font(.headline)
                Stepper("\(coffeeAmount) cups", value: $coffeeAmount, in: 0...12, step: 1)
                
                
                
                
            }.padding()
            .navigationTitle("Better Rest")
                .toolbar {
                    Button("Calculate", action: calculateBedtime)
                }
                .alert(alertTitle, isPresented: $isAlert) {
                    Button("Ok") {}
                } message: {
                    Text(alertMessage)
                }
        }
        
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            
            let comp = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (comp.hour ?? 0) * 60 * 60
            let min = (comp.minute ?? 0)  * 60
            
            let prediction = try model.prediction(wake: Int64(hour + min), estimatedSleep: sleepAmount, coffee: Int64(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let minutes = Int(prediction.actualSleep / 60)
            let hourT = minutes / 60
            let balanceMinutes = minutes % 60
                                       

            
            alertTitle = "Sleep at tthis"
            let actuallyNeed = prediction.actualSleep
            alertMessage =  "you need to sleep \(hourT.formatted()) hours and \(balanceMinutes) minutes, so sleep at" + sleepTime.formatted(date: .omitted, time: .shortened)
            
            
            
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was an error"
        }
        isAlert = true
    }
    
    
}
struct ContentView2: View {
    @State private var sleepAmount: Double = 8.0
    @State private var wakeUp = Date.now
    
    var body: some View {
        VStack {
            Stepper("\(sleepAmount.formatted()) hours",value: $sleepAmount, in: 2...13, step: 0.25)
            DatePicker("Enter date", selection: $wakeUp, in: Date.now..., displayedComponents: .hourAndMinute)
                .labelsHidden()
            Text(Date.now.formatted(date: .long, time: .shortened))
        }.padding()
    }
    
    func exampleDates() {
        let tommorow = Date.now.addingTimeInterval(86400)
        let range = Date.now...tommorow
    }
    func exampleDatess() {
        let now = Date.now
        let tommorow = Date.now.addingTimeInterval(86400)
        let range = now...tommorow
        
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        let date = Calendar.current.date(from: components) ?? .now
        
        
       
        
        
    }
    
}

#Preview {
    ContentView()
}
