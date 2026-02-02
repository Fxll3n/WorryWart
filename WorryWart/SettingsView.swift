//
//  SettingsView.swift
//  WorryWart
//
//  Created by Angel Bitsov on 12/15/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    // Would have preffered @AppStorage but it doesn't accept String Arrays as of writing
    @State private var listOrder = UserDefaults.standard.stringArray(forKey: "listOrder") ?? []
    
    @Environment(\.modelContext) var context
    @Query private var courses: [Course]
    @Query private var assignments: [Assignment]

    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Clear All Data")) {
                    Button("Clear All Courses") {
                        for course in courses {
                            context.delete(course)
                        }
                    }
                    Button("Clear All Assignments") {
                        for assignment in assignments {
                            context.delete(assignment)
                        }
                    }
                }
                
                Section(header: Text("List Order")) {
                    ForEach(listOrder, id: \.self) { item in
                        Label(item, systemImage: "arrow.2.circlepath.circle")
                    }
                    .onMove (perform: moveItems)
                }
            }
            .navigationTitle("Settings")
            .toolbar{ EditButton() }
        }
        .onAppear() {
            listOrder = UserDefaults.standard.stringArray(forKey: "listOrder") ?? []
            
            if listOrder.isEmpty { // Will only run the first time the app is run.
                UserDefaults.standard.set(["Due Soon", "Past Due", "Completed"], forKey: "listOrder")
            }
        }
    }
    
    func moveItems(from source: IndexSet, to destination: Int) {
        listOrder.move(fromOffsets: source, toOffset: destination)
        UserDefaults.standard.set(listOrder, forKey: "listOrder")
    }
}


#Preview {
    SettingsView()
}
