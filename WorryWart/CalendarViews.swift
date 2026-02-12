//
//  CalendarView.swift
//  WorryWart
//
//  Created by Angel Bitsov on 2/4/26.
//

import SwiftUI
import SwiftData

struct WeekCalendarView: View {
    var body: some View {
        VStack {
            Text("Week Calendar View")
        }
    }
}

struct MonthCalendarView: View {
    @Environment(\.modelContext) var context
    
    @Query var assignments: [Assignment] = []
    
    @State private var selectedDate: Date = Date()
    
    let columnLayout = Array(repeating: GridItem(.fixed(45)), count: 7)
    
    var body: some View {
        VStack {
            
            Group {
                LazyVGrid(columns: columnLayout) {
                    
                }
                LazyVGrid(columns: columnLayout) {
                    ForEach(0..<32, id: \.self) { day in
                        Text("\(day)")
                            .font(.caption)
                            .frame(width: 45, height: 45)
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                    }
                }
            }
            .frame(minWidth: 100, idealWidth: 300, maxWidth: 400, minHeight: 100, idealHeight: 300, maxHeight:400, alignment: .center)
            .padding()
            .background(.white)
            .cornerRadius(15)
            
            
            Group {
                List(assignments) { assignment in
                    Text(assignment.name)
                }
                .scrollContentBackground(.hidden)
                .padding(5)
            }
            .frame(minWidth: 100, idealWidth: 300, maxWidth: 400, minHeight: 100, idealHeight: 150, maxHeight:200, alignment: .center)
            .padding()
            .background(.white)
            .cornerRadius(15)
            
        }
        .frame(maxHeight: .infinity)
        .padding(10)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        
    }
    
}

struct AlternateCalendarView: View {
    var body: some View {
        VStack {
            
        }
    }
}

#Preview {
    AlternateCalendarView()
}

#Preview {
    MonthCalendarView()
}

#Preview {
    WeekCalendarView()
}
