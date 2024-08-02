//
//  LootView.swift
//  ResourcesManager
//
//  Created by Sergii D on 8/1/24.
//

import SwiftUI
import SwiftData

struct LootView: View {
    @State private var selectedItemIDs = Set<UUID>()
    @State private var selectedItemsFromLoot = Set<UUID>()
    @State private var itemsCount: Int = 0
    
    @Query(filter: #Predicate<Item> {!$0.isLooted } )
    private var items: [Item]
    
    @Query private var lootItems: [Loot]
    
    private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        HStack {
            VStack {
                Text("Loot")
                List(lootItems, selection: $selectedItemsFromLoot) { loot in
                    HStack {
                        Text(loot.name)
                        TextField(loot.name,
                                  value: Bindable(loot).count,
                                  formatter: numberFormatter)
                    }
                }
            }
            VStack {
                if !selectedItemIDs.isEmpty {
                    Button {
                        items
                            .filter { selectedItemIDs.contains($0.id) }
                            .map {
                                $0.isLooted = true
                                return Loot(name: $0.name, item: $0.id, count: 1)
                            }
                            .forEach { modelContext.insert($0) }
                        selectedItemIDs = []
                    } label: {
                        Text("<-")
                    }
                }
                if !selectedItemsFromLoot.isEmpty {
                    Button {
                        lootItems
                            .filter { selectedItemsFromLoot.contains($0.id) }
                            .forEach { lootItem in
                                let lootItemID = lootItem.item
                                let fetchedItem = try? modelContext.fetch(FetchDescriptor<Item>(predicate: #Predicate<Item> { item in item.id == lootItemID }))
                                fetchedItem?.forEach { $0.isLooted = false }
                                modelContext.delete(lootItem)
                            }
                        selectedItemsFromLoot = []
                    } label: {
                        Text("->")
                    }
                }
            }
            VStack {
                Text("All Items")
                List(items, selection: $selectedItemIDs) {
                    Text($0.name)
                }
            }
        }
    }
}

#Preview {
    LootView()
        .frame(width: 1000, height: 500)
        .modelContainer(previewContainer)
}
