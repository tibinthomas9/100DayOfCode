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

struct AstronautView: View {
    let astronaut: Astronaut
    var body: some View {
        ScrollView {
            VStack {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                Text(astronaut.description)
                    .padding()
            }
            
        }
        .background(.darkBackgroud)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct Address: Codable {
    let street: String
    let city: String
    
    
}

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    let mission: Mission
    let crewMembers: [CrewMember]

    
    var body: some View {
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, axis in
                        width * 0.6
                    }
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(.lightBackgroud)
                    .padding(.vertical)
                
                VStack(alignment: .leading) {
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    Text(mission.description)
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.lightBackgroud)
                        .padding(.vertical)
                    
                    Text("Crew")
                        .font(.title.bold())
                        .padding(.bottom)
                }
                .padding(.horizontal)
               
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(crewMembers, id: \.role) { crewMember in
                            NavigationLink {
                                AstronautView(astronaut: crewMember.astronaut)
                            } label: {
                                HStack {
                                    Image(crewMember.astronaut.id)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 104, height: 72)
                                        .clipShape(Capsule())
                                        .overlay {
                                            Capsule()
                                                .strokeBorder(.white,lineWidth: 1)
                                        }
                                    VStack(alignment: .leading) {
                                        Text(crewMember.astronaut.name)
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        Text(crewMember.role)
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.5))
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                        }
                    }
                }
                
            }
            .padding(.bottom)
        }.navigationTitle(mission.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .background(.darkBackgroud)
    }
    
    init(mission: Mission, astronaut: [String: Astronaut]) {
        self.mission = mission
        self.crewMembers = mission.crew.map { crewrole in
            if  let astronautItem = astronaut[crewrole.name] {
 let crewItem: CrewMember = CrewMember(role: crewrole.role, astronaut: astronautItem)
                return crewItem
            } else {
                fatalError()
            }
        }
    }
}


struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode(filename: "astronauts.json")
    let missions: [Mission] = Bundle.main.decode(filename: "missions.json")
    var body: some View {
        
        var columns = [GridItem(.adaptive(minimum: 150))]
        
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(missions) { mission in
                        NavigationLink {
                            MissionView(mission: mission, astronaut: astronauts)
                        } label: {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text(mission.formattedlaunchDate)
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackgroud)
                                
                            }
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(.lightBackgroud)
                            )
                        }
                    }
                }.padding([.horizontal, .bottom])
            }
            .navigationTitle("MoonShot")
            .background(.darkBackgroud)
            .preferredColorScheme(.dark)
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
