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
    @Query private var courses: [Course]
    @Query private var assignments: [Assignment]
    
    @State private var searchText: String = ""
    @State private var searchTokens: [AssignmentSearchToken] = []
    
    var dueSoonAssignments: [Assignment] {
        assignments.filter { assignment in
            guard let dueDate = assignment.dueDate else { return false }
            return dueDate.timeIntervalSinceNow > 0 && !assignment.isCompleted
        }
        .sorted { ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture) }
    }
    
    var pastDueAssignments: [Assignment] {
        assignments.filter { assignment in
            guard let dueDate = assignment.dueDate else { return false }
            return dueDate.timeIntervalSinceNow < 0 && !assignment.isCompleted
        }
        .sorted { ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture) }
    }
    
    var completedAssignments: [Assignment] {
        assignments.filter { $0.isCompleted }
            .sorted { ($0.dueDate ?? .distantFuture) > ($1.dueDate ?? .distantFuture) }
    }
    
    var filteredAssignments: [Assignment] {
        var result = assignments
        
        if !searchText.isEmpty {
            result = result.filter { assignment in
                assignment.name.localizedCaseInsensitiveContains(searchText) ||
                assignment.desc.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        for token in searchTokens {
            switch token {
            case .course(let course):
                result = result.filter { $0.course == course }
            case .dueDate(let date):
                result = result.filter { assignment in
                    guard let dueDate = assignment.dueDate else { return false }
                    return Calendar.current.isDate(dueDate, inSameDayAs: date)
                }
            case .completed:
                result = result.filter { $0.isCompleted }
            case .incomplete:
                result = result.filter { !$0.isCompleted }
            }
        }
        
        return result.sorted { ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture) }
    }
    
    var isSearching: Bool {
        !searchText.isEmpty || !searchTokens.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            List {
                if isSearching {
                    ForEach(filteredAssignments) { assignment in
                        ListItemView(data: assignment)
                    }
                    .onDelete { offsets in
                        deleteFilteredItems(at: offsets)
                    }
                } else {
                    Group {
                        if !dueSoonAssignments.isEmpty {
                            Section(header: Text("Due Soon")) {
                                ForEach(dueSoonAssignments) { assignment in
                                    ListItemView(data: assignment)
                                }
                                .onDelete { offsets in
                                    deleteItems(from: dueSoonAssignments, at: offsets)
                                }
                            }
                        }
                        
                        if !pastDueAssignments.isEmpty {
                            Section(header: Text("Past Due")) {
                                ForEach(pastDueAssignments) { assignment in
                                    ListItemView(data: assignment)
                                        .foregroundStyle(.red)
                                }
                                .onDelete { offsets in
                                    deleteItems(from: pastDueAssignments, at: offsets)
                                }
                            }
                        }
                        
                        if !completedAssignments.isEmpty {
                            Section(header: Text("Completed")) {
                                ForEach(completedAssignments) { assignment in
                                    ListItemView(data: assignment)
                                        .foregroundStyle(.secondary)
                                }
                                .onDelete { offsets in
                                    deleteItems(from: completedAssignments, at: offsets)
                                }
                            }
                        }
                        
                        if assignments.isEmpty {
                            ContentUnavailableView(
                                "No Assignments",
                                systemImage: "tray",
                                description: Text("Add your first assignment to get started")
                            )
                        }
                    }
                }
            }
            .searchable(
                text: $searchText,
                tokens: $searchTokens,
                placement: .navigationBarDrawer
            ) { token in
                Label(token.displayText, systemImage: tokenIcon(for: token))
            }
            .searchSuggestions { // For some reason stops UI code execution in the BG
                if searchText.isEmpty && searchTokens.isEmpty {
                        ZStack {
                            Color(.systemBackground)
                                .ignoresSafeArea()
                            
                            List {
                                if !courses.isEmpty {
                                    Section("Courses") {
                                        ForEach(courses) { course in
                                            Button {
                                                searchTokens.append(.course(course))
                                            } label: {
                                                Label(course.name, systemImage: "book.fill")
                                            }
                                        }
                                    }
                                }
                                
                                Section("Status") {
                                    Button {
                                        searchTokens.append(.completed)
                                    } label: {
                                        Label("Completed", systemImage: "checkmark.circle.fill")
                                    }
                                    
                                    Button {
                                        searchTokens.append(.incomplete)
                                    } label: {
                                        Label("Incomplete", systemImage: "circle")
                                    }
                                }
                            }
                        }
                    }
            }
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private func tokenIcon(for token: AssignmentSearchToken) -> String {
        switch token {
        case .course:
            return "book.fill"
        case .dueDate:
            return "calendar"
        case .completed:
            return "checkmark.circle.fill"
        case .incomplete:
            return "circle"
        }
    }
    
    private func deleteItems(from array: [Assignment], at offsets: IndexSet) {
        for index in offsets {
            let assignment = array[index]
            context.delete(assignment)
        }
    }
    
    private func deleteFilteredItems(at offsets: IndexSet) {
        for index in offsets {
            let assignment = filteredAssignments[index]
            context.delete(assignment)
        }
    }
}

#Preview {
    ListView()
        .modelContainer(for: [Course.self, Assignment.self])
}
