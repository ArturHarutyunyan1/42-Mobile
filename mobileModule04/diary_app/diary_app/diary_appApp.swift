//
//  diary_appApp.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 12.03.25.
//

import GoogleSignIn
import Firebase
import FirebaseAuth

import SwiftUI

@main
struct diary_appApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL {url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
