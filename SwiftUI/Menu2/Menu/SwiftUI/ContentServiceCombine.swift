//
//  ContentServiceCombine.swift
//  Menu
//
//  Created by manolo on 3/28/22.
//  Copyright © 2022 DoorDash, Inc. All rights reserved.
//

import Combine
import Foundation

class ContentServiceCombine {
    private var cancellables = Set<AnyCancellable>()
    private let session = FakeNetworkSession()
    /// fetches data to retrieve item content
    func getMenuItemData() -> AnyPublisher<MenuContent, Error> {
        // pretend this is a real network request, but you
        // can assume there will always be data and no error
        return session
            .networkCall
            .decode(type: MenuContent.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

class ContentServiceViewModel: ObservableObject {
    
    @Published var menuItems: [MenuItem] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let contentService =  ContentServiceCombine()
    
    func fetchdata() {
        contentService.getMenuItemData()
            .receive(on: DispatchQueue.main)
            .sink { completion in
            
        } receiveValue: { content in
            self.menuItems = content.content_items
        }.store(in: &cancellables)

        
    }
}
