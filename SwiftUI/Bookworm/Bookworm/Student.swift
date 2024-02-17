//
//  Student.swift
//  Bookworm
//
//  Created by Tibin Thomas on 2024-02-15.
//

import Foundation
import SwiftData

@Model
class Student {
    var id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
