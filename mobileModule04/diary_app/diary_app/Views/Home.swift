//
//  Home.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 12.03.25.
//

import SwiftUI

struct Home: View {
    @StateObject var authenticationManager: Authentication
    var body: some View {
        Text("Home page")
        Button(action: {
            Task {
                do {
                    try await authenticationManager.googleLogOut()
                } catch {
                    print("Error\n")
                }
            }
        }, label: {
            Text("Log out")
        })
    }
}
