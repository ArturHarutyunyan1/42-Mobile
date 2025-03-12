//
//  ContentView.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 12.03.25.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    var body: some View {
        if !isLoggedIn {
            Welcome()
        }
    }
}

#Preview {
    ContentView()
}
