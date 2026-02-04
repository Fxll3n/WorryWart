//
//  SettingsView.swift
//  WorryWart
//
//  Created by Angel Bitsov on 12/15/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) var context
    @Query private var courses: [Course]
    @Query private var assignments: [Assignment]

    // Would have preffered @AppStorage but it doesn't accept String Arrays as of writing
    @State private var listOrder = UserDefaults.standard.stringArray(forKey: "listOrder") ?? []
    
    @AppStorage("enableAlternateListStyle") private var enableAlternateListStyle: Bool = false
    @AppStorage("calendarViewType") private var calendarViewType: String = "week"
    @AppStorage("enableAlternateCalendarSwitcher") private var enableAltCalSwitcher: Bool = false
    
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
                        HStack {
                            Label(item, systemImage: "arrow.2.circlepath.circle")
                            Spacer()
                            Image(systemName: "line.3.horizontal")
                                .foregroundStyle(.secondary)
                                
                        }
                    }
                    .onMove (perform: moveItems)
                }
                Section(header: Text("Preferences")){
                    Toggle("Enable Alternate List Style", isOn: $enableAlternateListStyle)
                    Toggle("Enable Alternate Calendar Switcher", isOn: $enableAltCalSwitcher)
                    Picker("Calendar View Type", selection: $calendarViewType) {
                        Text("Week").tag("week")
                        Text("Month").tag("month")
                    }.disabled(enableAltCalSwitcher)
                }
            }
            .navigationTitle("Settings")
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
