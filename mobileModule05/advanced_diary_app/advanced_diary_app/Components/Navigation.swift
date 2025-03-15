//
//  Navigation.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 13.03.25.
//

import SwiftUI

struct Navigation: View {
    @StateObject var authManager: Authentication
    @State private var logoutAlert = false
    @State private var errorAlert = false
    var body: some View {
        HStack {
            Text("Recent Notes")
                .font(.headline)
            Spacer()
            Button (action: {
                Task {
                    logoutAlert = true
                }
            }, label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .frame(width: 30, height: 30)
            })
            .foregroundStyle(.red)
        }
        .padding()
        .frame(height: 50)
        .alert("Are you sure you want to log out?",isPresented: $logoutAlert) {
            Button(action: {
                Task {
                    do {
                        try await authManager.logOut()
                    } catch {
                        errorAlert = true
                    }
                }
            }, label: {
                Text("Yes")
            })
            Button("Cancel", role: .cancel) {}
        }
        .alert("Something went wrong, try again!",isPresented: $errorAlert) {
            Button("Cancel", role: .cancel) {
                errorAlert = false
                logoutAlert = false
            }
        }
    }
}
