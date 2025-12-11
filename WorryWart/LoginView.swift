//
//  LoginView.swift
//  WorryWart
//
//  Created by Angel Bitsov on 12/11/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                SecureField("Enter Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                NavigationLink("Log In") {
                    ContentView()
                }
            }
            .toolbar {
                NavigationLink(destination: ContentView(), label: {
                    Text("Use without Schoology")
                        .foregroundStyle(.red)
                        .padding()
                })
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func attemptLogin() {
        // Login Logic
    }
}

#Preview {
    LoginView()
}

