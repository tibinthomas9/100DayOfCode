//
//  ContentView.swift
//  iEXpense
//
//  Created by Tibin Thomas on 2024-02-06.
//

import SwiftUI
struct AddView: View {
    
    @State private var name = ""
    @State private var type = "personal"
    @State private var amount = 0.0
    @Environment(\.dismiss) var dismiss
    
    var expenses: Expenses
    
    let types = ["Personal", "Business"]
    
    var body: some View {
        NavigationStack {
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
                UserDefaults.standard.setValue(encoded, forKey: "expenses")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "expenses"), let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: data) {
            
            items = decoded
        } else {
            items = []
        }
    }
}
