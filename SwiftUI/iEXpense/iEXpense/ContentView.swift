//
//  ContentView.swift
//  iEXpense
//
//  Created by Tibin Thomas on 2024-02-06.
//

import SwiftUI

import SwiftUI

import SwiftUI

struct MovingSemiCircle2: Shape{
    var progress: Double
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)

        var path = Path()

        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(180 * progress),
            clockwise: false
        )

        return path
    }
}

struct ContentView2: View {
    @State private var progress: Double = 0.0

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.blue, lineWidth: 10)
                .frame(width: 200, height: 200)

            MovingSemiCircle2(progress: progress)
                .stroke(Color.red, lineWidth: 10)
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(180))
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                self.progress = 1.0
            }
        }
    }
}


struct MovingSemiCircle: View {
    @State private var trimEnd: CGFloat = 0.0
    @State private var rotation: Double = 180

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.blue, lineWidth: 10)
                .frame(width: 200, height: 200)

            Path { path in
                let radius: CGFloat = 100
                let center = CGPoint(x: 100, y: 100)
                let startAngle: Angle = .degrees(0)
                let endAngle: Angle = .degrees(180)

                path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            }
            .trim(from: 0, to: trimEnd)
            .stroke(Color.red, lineWidth: 30)
            .frame(width: 200, height: 200)
           .rotationEffect(.degrees(rotation))
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                self.trimEnd = 1.0
                self.rotation = 360
            }
        }
    }
}



struct AddView: View {
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @Environment(\.dismiss) var dismiss
    
    var expenses: Expenses
    
    let types = ["Personal", "Business"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Circle()
                    .fill(.red)
                    .overlay {
                        Circle().stroke(lineWidth: 4)
                    }
                Form {
                    TextField("Name", text: $name)
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.automatic)
                    TextField("Amount", value: $amount, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                    
                }.navigationTitle("Add New")
                    .toolbar {
                        Button("save") {
                            expenses.items.append(ExpenseItem(amount: amount, name: name, type: type))
                            dismiss()
                        }
                    }
            }
        }
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items, id: \.id) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text(item.amount, format: .currency(code: "USD"))
                    }
                }.onDelete(perform: { indexSet in
                    removeItems(at: indexSet)
                })
            }
            .navigationTitle("iExpense")
                .toolbar {
                    Button("Add", systemImage: "plus") {
                        showingAddExpense = true
                    }
                }
            
        }
        .sheet(isPresented: $showingAddExpense, content: {
            AddView(expenses: expenses)
        })
        .padding()
    }
    
    
    func addExpense() {
        expenses.items.append(ExpenseItem(amount: 0, name: "Tibin", type: "Hotel"))
    }
    
    func removeItems(at offset: IndexSet) {
        expenses.items.remove(atOffsets: offset)
    }
}

#Preview {
    ContentView()
}

struct ExpenseItem: Codable, Identifiable{
    var id = UUID()
    
    let amount: Double
    let name: String
    let type: String
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try?  JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "expense")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "expense"), let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: data) {
            
            items = decoded
        } else {
            print("init else")
            items = []
        }
    }
}
