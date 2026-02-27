//
//  CalendarView.swift
//  WorryWart
//
//  Created by Angel Bitsov on 2/4/26.
//

import SwiftUI
import SwiftData

struct WeekCalendarView: View {
    @Environment(\.modelContext) var context
    
    @Query var assignments: [Assignment] = []
    
    @State private var selectedDate: Date = Date()
    
    private var calendar: Calendar = Calendar.current
    
    private var datesInWeek: [Date] {
        let calendar = Calendar.current
        let today = Date.now
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        // Generate 7 days starting from startOfWeek
        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: startOfWeek)
        }
    }
    
    private var assignemntsForDay: [Assignment] {
        var result: [Assignment] = []
        for assignment in assignments {
            guard let dueDate = assignment.dueDate else { continue }
            if calendar.isDate(dueDate, inSameDayAs: selectedDate) {
                result.append(assignment)
            }
        }
        return result
    }
    
    let columnLayout = Array(repeating: GridItem(.flexible(minimum: 45, maximum: 55)), count: 7)
    
    
    
    var body: some View {
        VStack {
            HStack {
                LazyVGrid(columns: columnLayout) {
                    ForEach(datesInWeek, id: \.self) { day in
                        Text(formatDate(day))
                            .bold(isSameDay(Date(), day))
                            .font(.system(size: isSameDay(Date(), day) ? 14 : 12))
                            .foregroundStyle(isSameDay(Date(), day) ? .blue : .black)
                            .frame(width: 45, height: 45, alignment: .center)
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .onTapGesture {
                                selectedDate = day
                            }
                            .overlay {
                                if selectedDate == day {
                                    Color.blue.opacity(0.1)
                                } else {
                                    Color.clear
                                }
                            }
                    }
                }
                .frame(minWidth: 100, idealWidth: 300, maxWidth: 400, minHeight: 10, idealHeight: 30, maxHeight: 35, alignment: .center)
                .padding()
                .background(.white)
                .cornerRadius(15)
            }
            
            List(assignemntsForDay) { assignment in
                Text("\(assignment.name)")
            }
            
        }
        .frame(maxHeight: .infinity)
        .padding(10)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
    }
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM\ndd"
        return formatter.string(from: date)
    }
    private func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool {
        let x = calendar.isDate(lhs, inSameDayAs: rhs)
        return x
    }
}

struct MonthCalendarView: View {
    @Environment(\.modelContext) var context
    
    @Query var assignments: [Assignment] = []
    
    @State private var selectedDate: Date = Date()
    @State private var displayedMonth: Date = Calendar.current.startOfDay(for: Date())
    
    let columnLayout = Array(repeating: GridItem(.fixed(45)), count: 7)
    
    let daysInWeek: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    private var calendar: Calendar { Calendar.current }
    
    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "LLLL, yyyy"
        return formatter.string(from: displayedMonth)
    }
    
    private var monthGridDates: [Date] {
        // Build a 5x7 grid with leading/trailing days (if any)
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        let numberOfDaysInMonth = range.count
        
        // Determine the weekday for the first day of the month
        let firstWeekdayOfMonth = calendar.component(.weekday, from: startOfMonth)
        let leadingDays = firstWeekdayOfMonth - 1
        
        // Previous month
        let previousMonth = calendar.date(byAdding: DateComponents(month: -1), to: startOfMonth)!
        let prevMonthRange = calendar.range(of: .day, in: .month, for: previousMonth)!
        let prevMonthDays = prevMonthRange.count
        
        var dates: [Date] = []
        // Leading days from previous month
        if leadingDays > 0 {
            for i in stride(from: leadingDays - 1, through: 0, by: -1) {
                let day = prevMonthDays - i
                if let date = calendar.date(bySetting: .day, value: day, of: previousMonth) {
                    dates.append(date)
                }
            }
        }
        
        // Current month days
        for day in 1...numberOfDaysInMonth {
            if let date = calendar.date(bySetting: .day, value: day, of: startOfMonth) {
                dates.append(date)
            }
        }
        
        // Trailing days to complete 5x7 grid (35 cells)
        let remaining = 35 - dates.count
        if remaining > 0 {
            let nextMonth = calendar.date(byAdding: DateComponents(month: 1), to: startOfMonth)!
            for day in 1...remaining {
                if let date = calendar.date(bySetting: .day, value: day, of: nextMonth) {
                    dates.append(date)
                }
            }
        }
        return dates
    }
    
    private func isInDisplayedMonth(_ date: Date) -> Bool {
        let m1 = calendar.dateComponents([.year, .month], from: date)
        let m2 = calendar.dateComponents([.year, .month], from: displayedMonth)
        return m1.year == m2.year && m1.month == m2.month
    }
    
    private func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool {
        let x = calendar.isDate(lhs, inSameDayAs: rhs)
        return x
    }
    
    private func changeMonth(by delta: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: delta, to: displayedMonth) {
            displayedMonth = newMonth
            // If the selected date is not in the new month, change selectedMonth to the
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header with month title and navigation
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .padding(8)
                }
                Spacer()
                Text(monthTitle)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .padding(8)
                }
            }
            .padding(.horizontal)
            
            Group {
                // Weekday headers
                LazyVGrid(columns: columnLayout) {
                    ForEach(daysInWeek.indices, id: \.self) { day in
                        Text(daysInWeek[day])
                            .font(.caption)
                            .frame(width: 45, height: 45)
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                    }
                }
                .frame(minWidth: 100, idealWidth: 300, maxWidth: 400, minHeight: 10, idealHeight: 30, maxHeight: 35, alignment: .center)
                .padding()
                .background(.white)
                .cornerRadius(15)
                
                // Month grid
                LazyVGrid(columns: columnLayout, spacing: 8) {
                    ForEach(monthGridDates, id: \.self) { date in
                        let inMonth = isInDisplayedMonth(date)
                        let isSelected = isSameDay(date, selectedDate)
                        Text("\(calendar.component(.day, from: date))")
                            .font(.system(size: isSameDay(Date(), date) ? 18 : 14))
                            .frame(width: 45, height: 45)
                            .bold(isSameDay(Date(), date))
                            .background(
                                ZStack {
                                    if isSelected {
                                        Color(.systemBlue)
                                            .opacity(0.2)
                                    } else {
                                        Color(.systemGray6)
                                    }
                                }
                            )
                            .foregroundStyle(inMonth ? .primary : .secondary)
                            .foregroundStyle(isSameDay(Date(), date) ? .blue : .primary)
                            .cornerRadius(5)
                            .onTapGesture {
                                selectedDate = date
                                // Snap to the new month when tapping a leading/trailing day
                                if !inMonth {
                                    displayedMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) ?? displayedMonth
                                }
                            }
                    }
                }
                .frame(minWidth: 100, idealWidth: 300, maxWidth: 400, minHeight: 100, idealHeight: 150, maxHeight: 255, alignment: .top)
                .padding()
                .background(.white)
                .cornerRadius(15)
            }
            
            Group {
                List {
                    EmptyView()
                }
                .scrollContentBackground(.hidden)
                .padding(5)
            }
            .frame(minWidth: 100, idealWidth: 300, maxWidth: 400, minHeight: 100, idealHeight: 150, maxHeight:200, alignment: .center)
            .padding()
            .background(.white)
            .cornerRadius(15)
            
        }
        .onAppear {
            if let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth)) {
                displayedMonth = firstOfMonth
            }
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
    MonthCalendarView()
}

#Preview {
    WeekCalendarView()
}
