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
    @State private var errorAlert = false
    let colors: [String] = [".cyanBackground", ".yellowBackground", ".greenBackground", ".pinkBackground", ".purpleBackground", ".redBackground"]
    @State private var color = ""
    var onNoteAdded: () -> Void
    var body: some View {
        GeometryReader {geometry in
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        if !text.isEmpty, !title.isEmpty, !feeling.isEmpty {
                            dataManager.addNote(feeling: feeling, text: text, title: title, usermail: auth.userEmail, color: color)
                            onNoteAdded()
                        } else {
                            errorAlert = true
                        }
                    }, label: {
                        Text("Add note")
                    })
                }
                TextField("Title", text: $title)
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .foregroundStyle(.vernagir)
                TextField("Feeling", text: $feeling)
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .foregroundStyle(.vernagir)
                ZStack (alignment: .topLeading){
                    TextEditor(text: $text)
                        .scrollContentBackground(.hidden)
                        .foregroundStyle(.bovandakutyun)
                        .font(.system(size: 25))
                        .frame(height: .infinity)
                    if text.isEmpty {
                        Text("Text")
                            .font(.system(size: 25))
                            .foregroundStyle(.bovandakutyun)
                    }
                }
                Spacer()
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .background(dataManager.stringToColor(color))
        .alert("Fields can't be empty", isPresented: $errorAlert) {
            Button("OK", role :.cancel) {}
        }
        .onAppear {
            color = colors.randomElement() ?? ".blue"
        }
    }
}
