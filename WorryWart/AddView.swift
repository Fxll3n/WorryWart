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
    
    @Query private var courses: [Course]
    
    @State private var newAssignmentName: String = ""
    @State private var newAssignmentDescription: String = ""
    @State private var newAssignmentDueDate: Date = Date()
    
    @State private var selectedCourse: Course? = nil
    
    
    var body: some View {
        VStack {
            Text("Add a new Assignment")
            
            TextField("Enter Assignment Name", text: $newAssignmentName)
            TextField("Enter Assignment Description", text: $newAssignmentDescription)
    
            
            DatePicker("Due Date", selection: $newAssignmentDueDate, displayedComponents: .date)
            
            Picker("Select a Course", selection: $selectedCourse) {
                Text("None").tag(nil as Course?)  // Add this option
                ForEach(courses) { course in
                    Text(course.name).tag(course as Course?)  // Cast to optional
                }
            }
            
            Button("Submit"){
                addAssignment()
                dismiss()
            }
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
    
    func addAssignment() {
        let newAssignment = Assignment(
            name: newAssignmentName,
            desc: newAssignmentDescription,
            isCompleted: false,
            course: selectedCourse,
            dueDate: newAssignmentDueDate
        )
        context.insert(newAssignment)
        
        // Clear the form AFTER creating the assignment
        newAssignmentName = ""
        newAssignmentDescription = ""
        newAssignmentDueDate = Date()
        selectedCourse = nil
    }
}

#Preview {
    AddAssignmentView()
}

struct AddCourseView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @Query private var courses: [Course]
    
    @State private var newCourseName: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter Course Name", text: $newCourseName)
            
            Button("Submit"){
                addCourse()
            }
            
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
    
    func addCourse() {
        let newCourse = Course(name: newCourseName)
        context.insert(newCourse)
        dismiss()
        newCourseName = ""
    }
    
}

#Preview {
    AddCourseView()
}
