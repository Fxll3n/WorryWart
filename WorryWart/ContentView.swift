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
    
    @State private var selection: Int = 0
    @State private var isPresented: Bool = false
    var body: some View {
            NavigationStack {
                VStack {
                    switch selection {
                    case 0:
                        ListView()
                    case 1:
                        Text("Not Implemented Yet!")
                    default:
                        Text("Oops! Something went wrong")
                    }
                }
                .sheet(isPresented: $isPresented){
                    AddAssignmentView()
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
                        Button(action: {
                            isPresented.toggle()
                        }, label: {
                            Image(systemName: "plus")
                        })
                    }
                }
            }
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    ContentView()
}
