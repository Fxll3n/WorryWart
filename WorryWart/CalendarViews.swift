//
//  CalendarView.swift
//  WorryWart
//
//  Created by Angel Bitsov on 2/4/26.
//

import SwiftUI

struct WeekCalendarView: View {
    var body: some View {
        VStack {
            Text("Week Calendar View")
        }
    }
}

struct MonthCalendarView: View {
    let columnLayout = Array(repeating: GridItem(.flexible(minimum: 30, maximum: 50)), count: 7)
    let weekDays: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var body: some View {
        VStack {
            LazyVGrid(columns: columnLayout) {
                ForEach(weekDays.indices, id: \.self) { day in
                    Text(weekDays[day])
                }
            }
            LazyVGrid(columns: columnLayout) {
                ForEach(getDaysInCurrentMonth(), id: \.self) { day in
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 50, height: 65)
                        .foregroundStyle(isToday(num: day) ? .blue : .gray)
                        .opacity(0.55)
                        .overlay(
                            Text("\(day)")
                        )
                }
            }
            List {
                ForEach(1...24, id: \.self) { i in
                    Section(header: Text("\(i):00")) {
                        
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }.padding(10)
    }
    func getDaysInCurrentMonth() -> Range<Int> {
        let now = Date()
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: now)!
        return range
    }
    
    func isToday(num: Int) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        let date = calendar.date(from: components)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        let currentDay = Int(dateFormatter.string(from: date))!
        return num == currentDay
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
