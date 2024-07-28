//
//  ResourcesManagerApp.swift
//  ResourcesManager
//
//  Created by Sergii D on 7/27/24.
//

import SwiftUI

@main
struct ResourcesManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
