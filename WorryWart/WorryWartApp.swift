//
//  WorryWartApp.swift
//  WorryWart
//
//  Created by Angel Bitsov on 12/9/25.
//

import SwiftUI
import SwiftData

@main
struct WorryWartApp: App {
    var body: some Scene {
        @State var viewModel = SchoologyViewModel()
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
        .modelContainer(for: [Course.self, Assignment.self])
    }
}
