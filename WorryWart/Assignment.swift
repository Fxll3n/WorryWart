//
//  Assignment.swift
//  WorryWart
//
//  Created by Angel Bitsov on 1/7/26.
//

import SwiftUI
import SwiftData

@Model
class Assignment
{
    var name: String
    var desc: String
    var isCompleted: Bool = false
    var course: Course?
    var dueDate: Date?
    
    init(name: String, desc: String, isCompleted: Bool, course: Course? = nil, dueDate: Date? = nil) {
        self.name = name
        self.desc = desc
        self.isCompleted = isCompleted
        self.course = course
        self.dueDate = dueDate
    }
    
}

@Model
class Course
{
    var name: String
    var assignments: [Assignment]
    
    init(name: String, assignments: [Assignment]) {
        self.name = name
        self.assignments = assignments
    }
}

struct ListItemView: View {
    @State var data: Assignment
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(data.name)
                    .font(.headline)
                Text(data.desc)
                    .font(.subheadline)
                HStack {
                    if let course = data.course {
                        Text("\(course.name)")
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 5.0)
                            .bold()
                            .background(.quinary)
                            .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    } else {
                        EmptyView()
                    }
                    if let due = data.dueDate {
                        Text("\(due.formatted(Date.FormatStyle().month(.abbreviated).day(.twoDigits)))")
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 5.0)
                            .bold()
                            .background(.quinary)
                            .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        Text("\(due.formatted(Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)).minute(.twoDigits)))")
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 5.0)
                            .bold()
                            .background(.quinary)
                            .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    } else {
                        EmptyView()
                    }
                    
                }
            }
            Spacer()
            Image(systemName: data.isCompleted ? "checkmark.square.fill" : "square")
                .onTapGesture {
                    data.isCompleted.toggle()
                }
        }
    }
}

#Preview {
    List {
        
        ListItemView(data: Assignment(name: "Math Homework", desc: "Blah blah blah", isCompleted: false, course: Course(name: "AP PRECALC", assignments: []), dueDate: Date.now))
        ListItemView(data: Assignment(name: "Math Homework", desc: "Blah blah blah", isCompleted: false, course: nil, dueDate: nil))
    }
}
