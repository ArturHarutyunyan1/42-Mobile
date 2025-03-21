//
//  NoteDetails.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 14.03.25.
//

import SwiftUI

struct NoteDetails: View {
    @Binding var noteDetails: Notes?
    @EnvironmentObject var dataManager: DataManager
    @State private var showAlert = false
    @State private var deleteAlert = false
    @State private var errorAlert = false
    @State private var errorMessage = ""
    var onNoteDeleted: () -> Void
    var body: some View {
        GeometryReader {geometry in
            let color = DataManager().stringToColor(noteDetails?.style ?? "")
            VStack {
                HStack {
                    Text("Edit note")
                        .foregroundStyle(.darkBlue)
                        .font(.system(size: 20))
                    Spacer()
                    Menu {
                        Button(action: {
                            deleteAlert = true
                        }, label: {
                            Text("Delete")
                        })
                        Button(action: {
                            if let noteDetails = noteDetails {
                                Task {
                                    if !noteDetails.title.isEmpty, !noteDetails.text.isEmpty {
                                        dataManager.editNote(note: noteDetails)
                                        onNoteDeleted()
                                    } else {
                                        errorMessage = "Fields can't be empty!"
                                        errorAlert = true
                                    }
                                }
                            }
                        }, label: {
                            Text("Save")
                        })
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.black)
                            .font(.title)
                    }
                }
                TextEditor(text: Binding(
                    get: {noteDetails?.title ?? ""},
                    set: {noteDetails?.title = $0}
                ))
                    .scrollContentBackground(.hidden)
                    .foregroundStyle(.vernagir)
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .frame(height: 50)
                HStack {
                    Text("\(noteDetails?.feeling ?? "")")
                        .foregroundStyle(.vernagir)
                        .font(.system(size: 20))
                    Spacer()
                }
                HStack {
                    Text("\(noteDetails?.date ?? "")")
                        .foregroundStyle(.vernagir)
                    Spacer()
                }
                TextEditor(text: Binding(
                    get: {noteDetails?.text ?? ""},
                    set: {noteDetails?.text = $0}
                ))
                .scrollContentBackground(.hidden)
                .foregroundStyle(.bovandakutyun)
                .font(.system(size: 23))
                Spacer()
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(color)
        }
        .alert("Delete note \(noteDetails?.title ?? "")?",isPresented: $deleteAlert) {
            Button(action: {
                if let noteDetails = noteDetails {
                    Task {
                        dataManager.deleteNote(note: noteDetails)
                        onNoteDeleted()
                    }
                }

            }, label: {
                Text("Delete")
                    .foregroundStyle(.red)
            })
            Button("Canclel", role: .cancel) {}
        }
        .alert(errorMessage, isPresented: $errorAlert) {
            Button("OK", role: .cancel) {}
        }
        .onReceive(dataManager.$errorMessage) { error in
            if let error = error, !error.isEmpty {
                errorMessage = error
                errorAlert = true
            }
        }
    }
}
