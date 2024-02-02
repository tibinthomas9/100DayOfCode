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
    func getMenuItemData() {
        // pretend this is a real network request, but you
        // can assume there will always be data and no error
        session
            .networkCall
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                    }
                },
                receiveValue: { data in
                    print(String(data: data, encoding: .utf8)!)
                    // make updates here
                }
            )
            .store(in: &cancellables)
    }
}
