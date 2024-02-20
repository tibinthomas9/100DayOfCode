//
//  ContentView.swift
//  SwiftDataProject
//
//  Created by Tibin Thomas on 2024-02-18.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<User> {user in user.name.localizedStandardContains("R")},
        sort: \User.name) var users: [User]
    @State private var path = [User]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List(users) {
                user in
                NavigationLink(value: user) {
                    Text(user.name)
                }
                
            }
            .navigationDestination(for: User.self) { user in
                EditUserView(user: user)
            }
            .toolbar {
                ToolbarItem {
                    Button("Add", systemImage: "plus") {
                        let user = User(name: "Tibin", city: "KTONA", joinDate: Date())
                        modelContext.insert(user)
                        path = [user]
                        
                    }
                }
            }
            
        }
        .padding()
    }
}

struct EditUserView: View {
    @Bindable var user: User
    
    var body: some View {
        Form {
            TextField("Name", text: $user.name)
            TextField("City", text: $user.city)
            DatePicker("JOin Date", selection:  $user.joinDate)
        }
    }
}


#Preview {
    ContentView()
}
