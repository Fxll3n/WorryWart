//
//  AddAssignmentView.swift
//  WorryWart
//
//  Created by Angel Bitsov on 1/7/26.
//

import SwiftUI
import SwiftData

struct AddAssignmentView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State private var newAssignmentName: String = ""
    @State private var newAssignmentDescription: String = ""
    @State private var newAssignmentDueDate: Date = Date()
    
    var body: some View {
        VStack {
            Text("Add a new Assignment")
            
            TextField("Enter Assignment Name", text: $newAssignmentName)
            TextField("Enter Assignment Description", text: $newAssignmentDescription)
            
            DatePicker("Due Date", selection: $newAssignmentDueDate, displayedComponents: .date)
            
            Button("Submit"){
                addAssignment()
                dismiss()
            }
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
    
    func addAssignment() {
        let newAssignment = Assignment(name: newAssignmentName, desc: newAssignmentDescription, isCompleted: false, dueDate: newAssignmentDueDate)
        context.insert(newAssignment)
    }
}

#Preview {
    AddAssignmentView()
}
