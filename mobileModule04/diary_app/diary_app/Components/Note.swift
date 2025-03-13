//
//  Note.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 13.03.25.
//

import SwiftUI

struct Note: View {
    @EnvironmentObject var dataManager: DataManager
    @StateObject var auth: Authentication
    @State private var title: String = ""
    @State private var feeling: String = ""
    @State private var text: String = ""
    var onNoteAdded: () -> Void
    var body: some View {
        VStack {
            TextField("Title", text: $title)
            TextField("Feeling", text: $feeling)
            TextField("Text", text: $text)
            Button(action: {
                dataManager.addNote(feeling: feeling, text: text, title: title, usermail: auth.userEmail)
                onNoteAdded()
            }, label: {
                Text("Add note")
            })
        }
    }
}
