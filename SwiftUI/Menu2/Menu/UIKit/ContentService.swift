//
//  FakeNetworkSession.swift
//  Menu
//
//  Created by Alice Hyun on 11/10/21.
//  Copyright © 2021 DoorDash, Inc. All rights reserved.
//

import Foundation

@MainActor
class ContentService {
    
    enum NetworkError: Error {
        case decodingError
    }
    private let session = FakeNetworkSession()
    
    @available(*, deprecated, renamed: "getItemData()")
    func getItemData(onCompltion: @escaping (([MenuItem]) -> Void))  {
        session.networkTask { data in
            let content = try? JSONDecoder().decode(MenuContent.self, from: data)
            onCompltion(content?.content_items ?? [])

        }
        
    }
    
    /// fetches data to retrieve item content
    func getItemData() async throws -> [MenuItem] {
        // pretend this is a real network request, but you
        // can assume there will always be data and no error
        try await withCheckedThrowingContinuation { continuation in
            session.networkTask { data in
                // print(String(data: data, encoding: .utf8)!)
                do {
                     let content = try JSONDecoder().decode(MenuContent.self, from: data)
                    // make updates here
                    continuation.resume(returning: content.content_items)
                }
                catch {
                    print(error.localizedDescription)
                    continuation.resume(throwing: error)
                }
            }
        }
        
    }
}

struct MenuItem: Codable {
    let title: String?
    let image_url: String?
    let description: String
}

struct MenuContent: Codable {
    let content_items: [MenuItem]
}
