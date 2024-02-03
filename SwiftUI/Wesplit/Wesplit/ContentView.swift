//
//  ContentView.swift
//  Wesplit
//
//  Created by Tibin Thomas on 2024-02-02.
//

import SwiftUI


struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocussed: Bool
    
    
    @State private var temperature = 0.0
    @State private var inputTempUnits: UnitTemperature = .celsius
    @State private var outputTempUnits: UnitTemperature = .celsius
    private var tempUnits: [UnitTemperature] = [.celsius, .kelvin, .fahrenheit]
    
    var outputTemp: String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temperature, unit: inputTempUnits)
        let output = input.converted(to: outputTempUnits)
        return mf.string(from: output)
    }
    
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalAmount: Double {
        let tip = Double(tipPercentage)/100.0 * checkAmount
        return (checkAmount + tip) / Double(numberOfPeople)
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                       // .keyboardType(.)
                        .focused($amountIsFocussed)
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(2...100, id: \.self) {
                            Text("\($0) people")
                        }
                    }.pickerStyle(.menu)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    
                }
                Section("How much do you want to tip?") {
                   
                        
                        Picker("Tip %", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) {
                                Text(($0), format: .percent)
                            }
                        }.pickerStyle(.segmented)
                    
                }
                
                Section("Amount Per person") {
                    Text(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                
                Section("Unit Converter Temp") {
                    Picker("Input Temp Unit", selection: $inputTempUnits) {
                        ForEach(tempUnits, id: \.self) {
                            Text("\($0.symbol)")
                        }
                    }.pickerStyle(.segmented)
                    TextField("Input Temperature",value: $temperature, format: .number)
                    
                    Picker("Temp Unit", selection: $outputTempUnits) {
                        ForEach(tempUnits, id: \.self) {
                            Text("\($0.symbol)")
                        }
                    }.pickerStyle(.segmented)
                    Text(outputTemp)
                }
            }.navigationTitle("WeSplit")
                .toolbar {
                    if amountIsFocussed {
                        Button("Done") {
                           amountIsFocussed = false
                        }
                    }
                }
            
        }
    }
}










struct ContentViewOLd: View {
    
    @State private var tapCount = 0
    @State private var name = ""
    let students = ["Nathan", "Maria", "Shreya"]
    @State private var selectedStudent = "Maria"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Form items") {
                    Text("Tibin's form")
                }
                Section {
                    Text("It contains nothing")
                    Button("Tap count is \(tapCount)") {
                        tapCount += 1
                    }
                    TextField("name", text: $name)
                    Text("Your name is \(name)")
                }
                Section {
                    Picker("Select your student", selection: $selectedStudent) {
                        ForEach(students, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section {
                    ForEach(0...100, id:\.self) {
                        Text("Row \($0)")
                    }
                }
            }
            .navigationTitle("WeSplit")
            .safeNavigationBarTitleDisplayMode(.inline)
            
        }
    }
}

#Preview {
    ContentView()
}

extension View {
    @ViewBuilder
    func safeNavigationBarTitleDisplayMode(_ displayMode: MyTitleDisplayMode) -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(displayMode.titleDisplayMode)
        #else
            self
        #endif
    }
}

enum MyTitleDisplayMode {
    case automatic
    case inline
    case large
    #if !os(macOS)
        var titleDisplayMode: NavigationBarItem.TitleDisplayMode {
            switch self {
            case .automatic:
                return .automatic
            case .inline:
                return .inline
            case .large:
                return .large
            }
        }
    #endif
}
