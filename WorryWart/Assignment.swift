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
    var dueDate: Date?
    
    init(name: String, desc: String, isCompleted: Bool, dueDate: Date? = nil) {
        self.name = name
        self.desc = desc
        self.isCompleted = isCompleted
        self.dueDate = dueDate
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
                if let due = data.dueDate {
                    HStack {
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
                    }
                } else {
                    Text("None")
                        .foregroundStyle(.blue)
                        .padding(.horizontal, 5.0)
                        .bold()
                        .background(.quinary)
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
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
    ListItemView(data: Assignment(name: "Math Homework", desc: "Blah blah blah", isCompleted: false, dueDate: nil))
}
