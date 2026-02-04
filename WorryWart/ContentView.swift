//
//  ContentView.swift
//  WorryWart
//
//  Created by Angel Bitsov on 12/9/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query private var assignments: [Assignment]
    
    @AppStorage("enableAlternateListStyle") var enableAlternateListStyle: Bool = false
    @AppStorage("calendarViewType") var calendarViewType: String = "week"
    @AppStorage("enableAlternateCalendarSwitcher") private var enableAltCalSwitcher: Bool = false
    
    @State private var selection: Int = 0
    @State private var isAssignmentPresented: Bool = false
    @State private var isCoursePresented: Bool = false
    
    
    var body: some View {
        NavigationStack {
            VStack {
                switch selection {
                case 0:
                    if enableAlternateListStyle {
                        ListViewAlternative()
                    } else {
                        ListView()
                    }
                case 1:
                    if enableAltCalSwitcher {
                        
                    } else {
                        switch calendarViewType {
                        case "week":
                            WeekCalendarView()
                        case "month":
                            MonthCalendarView()
                        default:
                            WeekCalendarView()
                        }
                    }
                default:
                    Text("Oops! Something went wrong")
                }
            }
            .sheet(isPresented: $isAssignmentPresented){
                AddAssignmentView()
            }
            .sheet(isPresented: $isCoursePresented){
                AddCourseView()
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("", selection: $selection) {
                        Text("List").tag(0)
                        Text("Calendar").tag(1)
                    }
                    .frame(minWidth: 220, idealWidth: 240, maxWidth: 300, alignment: .center)
                    .pickerStyle(.segmented)
                    .padding(.vertical)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Menu {
                        Button("Add Assignment") {
                            isAssignmentPresented.toggle()
                        }
                        Button("Add Course") {
                            isCoursePresented.toggle()
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ContentView()
}
