//
//  ContentView.swift
//  MoonShot
//
//  Created by Tibin Thomas on 2024-02-08.
//

import SwiftUI

struct User: Codable {
    let name: String
    let address: Address
    
}

struct Address: Codable {
    let street: String
    let city: String
    
}


struct ContentView: View {
    var body: some View {
        
        let layout = [
            GridItem(.adaptive(minimum: 80)),
                     ]
        ScrollView(.horizontal) {
            LazyHGrid(rows: layout) {
                ForEach(0..<100) {
                    Text("Tem \($0)")
                }
            }
        }
//        NavigationStack {
//            List(0..<100) { row in
//                NavigationLink("Row \(row)") {
//                    Text("Detail \(row)")
//                }
//                
//                            Button("Decode Json") {
//                                let input = """
//                                        {
//                                            "name": "Taylor",
//                                            "address": {
//                                                "street": "stree",
//                                                "city": "Nash"
//                                            }
//                                        }
//                                        """
//                                let data = Data(input.utf8)
//                                if let decodedUser = try? JSONDecoder().decode(User.self, from: data) {
//                                    print(decodedUser)
//                                }
//                            }
//                
//            }
//            //        NavigationStack {
//            //            NavigationLink("Hello, world!") {
//            //                Text("Detail view")
//            //            }
//            //                .navigationTitle("MoonShot")
//            //        }
//            .padding()
//        }
    }
}

#Preview {
    ContentView()
}
