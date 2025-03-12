//
//  ContentView.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 12.03.25.
//
import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @StateObject private var authenticationManager = Authentication()

    var body: some View {
        if !authenticationManager.isLoggedIn {
            Welcome(authenticationManager: authenticationManager)
        }
    }
}

#Preview {
    ContentView()
}
