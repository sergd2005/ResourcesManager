//
//  Items.swift
//  ResourcesManager
//
//  Created by Sergii D on 7/27/24.
//

import Foundation
import SwiftData

@Model
final class Item: Identifiable {
    var id: String {
        name
    }
    
    @Attribute(.unique) var name: String
    var requiredResources: [Item] = []
    var count: String
    
    init(name: String, count: String) {
        self.name = name
        self.count = count
    }
}
