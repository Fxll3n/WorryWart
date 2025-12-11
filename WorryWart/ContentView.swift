//
//  ContentView.swift
//  WorryWart
//
//  Created by Angel Bitsov on 12/9/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Int = 0
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
                }
            }
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    ContentView()
}
