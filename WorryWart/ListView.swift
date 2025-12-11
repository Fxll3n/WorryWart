//
//  ListView.swift
//  WorryWart
//
//  Created by Angel Bitsov on 12/11/25.
//

import SwiftUI

struct ListView: View {
    var body: some View {
        NavigationStack {
            VStack {
                List() {
                    Section(header: Text("Due Soon")) {
                        ForEach(1..<6) {
                            Text("Assignment #\($0)")
                        }
                    }
                    Section(header: Text("Past Due")) {
                        ForEach(6..<11) {
                            Text("Assignment #\($0)")
                        }
                        .foregroundStyle(.red)
                    }
                    Section(header: Text("Completed")) {
                        ForEach(11..<16) {
                            Text("Assignment #\($0)")
                        }
                        .foregroundStyle(.secondary)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .background(.background.secondary)
        }
    }
}

#Preview {
    ListView()
}
