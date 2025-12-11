//
//  ContentView.swift
//  WorryWart
//
//  Created by Angel Bitsov on 12/9/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ContentView()
}
