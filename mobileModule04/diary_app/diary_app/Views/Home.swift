//
//  Home.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 12.03.25.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var dataManager: DataManager
    @StateObject var authenticationManager: Authentication
    @State private var showPopup = false
    var body: some View {
            Text("Home page")
            Text("Hello \(authenticationManager.userEmail)")
        Button(action: {
            showPopup = true
        }, label: {
            Text("ADD")
        })
        List(dataManager.diary.filter{$0.usermail == authenticationManager.userEmail}, id: \.date) {result in
                Text("\(result)")
            }
            Button(action: {
                Task {
                    do {
                        try await authenticationManager.logOut()
                    } catch  {
                        print("Error")
                    }
                }
            }, label: {
                Text("Log out")
            })
        .sheet(isPresented: $showPopup) {
            Note(auth: authenticationManager, onNoteAdded: {
                showPopup = false
            })
        }
        .onChange(of: showPopup) {
            dataManager.getNotes()
        }
    }
}
