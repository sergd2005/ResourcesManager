//
//  ContentView.swift
//  ResourcesManager
//
//  Created by Sergii D on 7/27/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var selectedItemID = ""
    @State private var selectedResourceID = ""
    @State private var selectedAvailableResourceID = ""
    @State private var selectedItemName = ""
    @State private var selectedItemCount = ""
    @State private var newItemName = ""
    @State private var newItemCount = ""
    
    @Environment(\.modelContext) var modelContext
    
    private var selectedItem: Item? {
        items.filter { $0.id == selectedItemID }.first
    }
    
    @Query private var items: [Item]

    var body: some View {
        HStack {
            VStack {
                HStack {
                    TextField(text: $newItemName) {
                        Text("New Item Name")
                    }
                    TextField(text: $newItemCount) {
                        Text("New Item Count")
                    }
                    Button {
                        guard let _ = Int(newItemCount) else { return }
                        let newItem = Item(name: newItemName, count: newItemCount)
                        modelContext.insert(newItem)
                        newItemName = ""
                        newItemCount = ""
                    } label: {
                        Text("Add")
                    }
                }
                List(items, selection: $selectedItemID) {
                    Text($0.name)
                }
                .onChange(of: selectedItemID) {
                    selectedItemName = selectedItem?.name ?? ""
                    selectedItemCount = selectedItem?.count ?? ""
                }
            }
            if let selectedItem {
                VStack {
                    HStack {
                        TextField(text: Bindable(selectedItem).name) {
                            Text("New Item Name")
                        }
                        TextField(text: Bindable(selectedItem).count) {
                            Text("New Item Count")
                        }
//                        Button {
//                            selected
//                            newItemName = ""
//                            newItemCount = ""
//                        } label: {
//                            Text("Save")
//                        }
                    }
                    HStack {
                        List(selectedItem.requiredResources, selection: $selectedResourceID) {
                            Text($0.name)
                        }
                        List(items, selection: $selectedAvailableResourceID) {
                            Text($0.name)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
    .modelContainer(previewContainer)
}
