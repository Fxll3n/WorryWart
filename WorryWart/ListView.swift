//
//  ListView.swift
//  WorryWart
//
//  Created by Angel Bitsov on 12/11/25.
//

import SwiftUI
import SwiftData

struct ListView: View {
    @Environment(\.modelContext) var context
    @Query private var assignments: [Assignment]
    
    @State private var searchText: String = ""
    @State private var activeTags: [searchTag] = []
    
    private var searchResults: [Assignment] {
        if searchText.isEmpty {
            return assignments
        } else {
            return assignments.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                
                if !searchText.isEmpty {
                    ForEach(searchResults, id: \.self) { item in
                        ListItemView(data: item)
                    }
                    
                }
                else
                {
                    
                    Section(header: Text("Due Soon"))
                    {
                        ForEach(assignments, id: \.self) { assignment in
                            if !(assignment.dueDate?.timeIntervalSinceNow ?? 0 < 0 || assignment.isCompleted) {
                                ListItemView(data: assignment)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    
                    Section(header: Text("Past Due"))
                    {
                        ForEach(assignments, id: \.self) { assignment in
                            if (assignment.dueDate?.timeIntervalSinceNow ?? 0 < 0 && !assignment.isCompleted) {
                                ListItemView(data: assignment)
                            }
                        }
                        .onDelete(perform: deleteItems)
                        .foregroundStyle(.red)
                        .bold()
                    }
                    
                    Section(header: Text("Completed"))
                    {
                        ForEach(assignments, id: \.self) { assignment in
                            if assignment.isCompleted {
                                ListItemView(data: assignment)
                            }
                        }
                        .onDelete(perform: deleteItems)
                        .foregroundStyle(.secondary)
                        .strikethrough()
                    }
                    
                }
                
            }
            .searchable(text: $searchText, tokens: $activeTags, placement: .navigationBarDrawer) { tag in
                Text(tag.title)
            }
            .onSubmit(of: .search) {
                if !searchText.isEmpty {
                    activeTags.append(searchTag(title: searchText))
                    searchText = ""
                }
            }
            .scrollContentBackground(.hidden)
            .background(.background.secondary)
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let assignment = assignments[index]
            context.delete(assignment)
        }
    }
}

struct searchTag: Identifiable, Hashable {
    var id: UUID = UUID()
    var title: String
}

#Preview {
    ListView()
}
