//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Tibin Thomas on 2024-02-13.
//

import SwiftUI
import CoreHaptics

@Observable
class Order: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    var type = 0
    var quantity = 3
    var specialRequestEnabled = false {
        didSet {
            if !specialRequestEnabled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var street = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        if name.isEmpty || city.isEmpty || zip.isEmpty || street.isEmpty {
            return false
        }
        return true
    }
    
    var cost: Decimal {
        var cost = Decimal(quantity) * 2
        cost += Decimal(type) / 2
        if extraFrosting {
            cost += Decimal(quantity)
        }
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        return cost
    }
}

struct CheckoutView: View {
    var order: Order
    @State private var confMessage = ""
    @State private var showMessage = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFill()
                    
                } placeholder: {
                    ProgressView()
                }.frame(height: 212)
                Text("total cost" + order.cost.formatted(.currency(code: "USD")))
                Button("Place order") {
                    Task {
                        await placeorder()
                    }
                }.padding()
            }
            
        }.scrollBounceBehavior(.basedOnSize)
        .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Thank you", isPresented: $showMessage) {
                
            }message: {
                Text(confMessage)
            }
    }
    
    func placeorder() async {
        guard let encoded = try? JSONEncoder().encode(order) else { return }
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var urlReq = URLRequest(url: url)
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.httpMethod = "POST"
        do {
            let (data, _) = try await URLSession.shared.upload(for: urlReq, from: encoded)
            
            let decoded = try JSONDecoder().decode(Order.self, from: data)
            showMessage = true
        }
        catch {
            
        }
    }
}

struct AddressView: View {
    @Bindable var order: Order
    
    
    
    var body: some View {
        Form {
            Section {
                TextField("namr", text: $order.name)
                TextField("strret", text: $order.street)
                TextField("city", text: $order.city)
                TextField("zip", text: $order.zip)
            }
            Section {
                NavigationLink("Checkout") {
                    CheckoutView(order: order)
                }
            }.disabled(order.hasValidAddress == false)
        }
    }
    
}

struct ContentView: View {
    @State private var order = Order()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Sleect you tupe", selection: $order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    Stepper("Cakes \(order.quantity)", value: $order.quantity, in: 1...20)
                }
                Section {
                   
                    Toggle("special", isOn: $order.specialRequestEnabled)
                    if order.specialRequestEnabled {
                        Toggle("addSprinkles", isOn: $order.addSprinkles)
                        Toggle("extraFrosting", isOn: $order.extraFrosting)
                    }
                }
                Section {
                    NavigationLink("Delivery:") {
                                  AddressView(order: order)
                                   }
                }
            }
            .navigationTitle("CupCakes")
        }
    }
}

@Observable class User: Codable {
    var name = "Ylor"
    
    enum CodingKeys: String ,CodingKey {
        case _name = "name"
        
    }
}
struct ContentView3: View {
    @State private var couter = 0
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        Button("encode", action: encodeT)
        Button("Tap Cint \(couter)") {
            couter += 1
        }.sensoryFeedback(.increase, trigger: couter)
    }
    
               func encodeT() {
                   let data = try! JSONEncoder().encode(User())
                   let str = String(decoding: data, as: UTF8.self)
                   print(str)
        }
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    func complexSucess() {
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return }
//        var events = [CHHapticEvent]()
//        let intensity =
//    }
    
}

struct ContentView2: View {
    
    @State private var results: [Result] = [Result]()
    @State private var username = ""
    @State private var email = ""
    
    var body: some View {
        Form {
            Section {
                TextField("USername", text: $username)
                TextField("email", text: $email)
            }
            Section {
                Button("Create account") {
                    
                }
            }.disabled(username.isEmpty || email.isEmpty)
            
        }
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
                AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .padding()
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid url")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(Response.self, from: data) {
                results = response.results
        }
        }
        catch {
            print("error")
        }
    }
}

#Preview {
    ContentView()
}


struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}
