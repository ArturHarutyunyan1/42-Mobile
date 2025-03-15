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
    @State private var color = ""
    @State private var errorMessage = ""
    @State private var errorAlert = false
    let colors: [String] = [".cyanBackground", ".yellowBackground", ".greenBackground", ".pinkBackground", ".purpleBackground", ".redBackground"]
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
                            errorMessage = "Fields can't be empty!"
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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(["😊 Happy", "😢 Sad", "😠 Angry", "😌 Calm", "😍 Loved", "🤯 Stressed"], id: \.self) { mood in
                            Button(action: {
                                feeling = mood
                            }) {
                                Text(mood)
                                    .padding()
                                    .background(feeling == mood ? Color.blue.opacity(0.7) : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                ZStack (alignment: .topLeading){
                    TextEditor(text: $text)
                        .scrollContentBackground(.hidden)
                        .foregroundStyle(.bovandakutyun)
                        .font(.system(size: 25))
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
        .alert(errorMessage, isPresented: $errorAlert) {
            Button("OK", role :.cancel) {}
        }
        .onAppear {
            color = colors.randomElement() ?? ".blue"
        }
        .onReceive(dataManager.$errorMessage) { error in
            if let error = error, !error.isEmpty {
                errorMessage = error
                errorAlert = true
            }
        }
    }
}
