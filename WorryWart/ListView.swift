//
//  ListView.swift
//  WorryWart
//
//  Created by Angel Bitsov on 12/11/25.
//

import SwiftUI

struct ListView: View {
    @State private var searchText: String = ""
    
    var allItems: [String] {
        (1...16).map { "Assignment #\($0)" } // Temp Data
    }
    
    var searchResults: [String] {
        guard !searchText.isEmpty else { return [] } // Return Empty Array if not searhing for anything
        return allItems.filter { $0.localizedCaseInsensitiveContains(searchText) } // Filters items by searchText
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    if !searchText.isEmpty {
                        ForEach(searchResults, id: \.self) { item in
                            Text(item)
                        }
                    } else {
                        Section(header: Text("Due Soon")) {
                            ForEach(allItems.prefix(5), id: \.self) { item in
                                Text(item)
                            }
                        }
                        Section(header: Text("Past Due")) {
                            ForEach(allItems[5..<10], id: \.self) { item in
                                Text(item)
                            }
                            .foregroundStyle(.red)
                            .bold()
                        }
                        Section(header: Text("Completed")) {
                            ForEach(allItems[10..<16], id: \.self) { item in
                                Text(item)
                            }
                            .foregroundStyle(.secondary)
                            .strikethrough()
                        }
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer)
                .scrollContentBackground(.hidden)
            }
            .background(.background.secondary)
        }
    }
}

#Preview {
    ListView()
}
