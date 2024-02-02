//
//  FakeNetworkSession.swift
//  Menu
//
//  Created by Alice Hyun on 11/10/21.
//  Copyright © 2021 DoorDash, Inc. All rights reserved.
//

import Foundation

class ContentService {
    private let session = FakeNetworkSession()
    
    /// fetches data to retrieve item content
    func getItemData(onCompletion: @escaping ([MenuItems]) -> Void) {
        // pretend this is a real network request, but you
        // can assume there will always be data and no error
        session.networkTask { data in
            guard let menuItems = try? JSONDecoder().decode(ContentItems.self, from: data) else {
                onCompletion([])
                return
            }
            DispatchQueue.main.async {
                onCompletion(menuItems.content_items ?? [])
            }
            
            print(String(data: data, encoding: .utf8)!)
            
            // make updates here
        }
    }
}
