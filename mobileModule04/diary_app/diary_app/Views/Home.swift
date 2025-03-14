//
//  Home.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 12.03.25.
//

import SwiftUI
import MasonryStack

struct Home: View {
    @EnvironmentObject var dataManager: DataManager
    @StateObject var authenticationManager: Authentication
    @State private var showPopup = true
    
    @State private var showDetails = false
    @State private var noteColors: [String: Color] = [:]
    @State private var noteDetails: Notes?
    var userNotesCount: Int {
        dataManager.diary.filter { $0.usermail == authenticationManager.userEmail }.count
    }
    var body: some View {
        VStack {
            Navigation()
            ScrollView {
                if userNotesCount < 1 {
                    Text("No recent notes")
                } else {
                    MasonryVStack(columns: 2, spacing: 20) {
                        ForEach(dataManager.diary.filter { $0.usermail == authenticationManager.userEmail }, id: \.id) { note in
                            let color = dataManager.stringToColor(note.style)
                            Button(action: {
                                showDetails = true
                                noteDetails = note
                            }, label: {
                                VStack(alignment: .leading) {
                                    Text(note.title)
                                        .font(.headline)
                                        .foregroundStyle(.vernagir)
                                    Text(note.text)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .foregroundStyle(.bovandakutyun)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(10)
                                .background(color)
                                .cornerRadius(15)
                            })
                        }
                    }
                    .padding(.horizontal)
                }
            }
            Button(action: {
                showPopup = true
            }, label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.white)
            })
            .frame(width: 50, height: 50)
            .background(.red)
            .cornerRadius(100)
            .sheet(isPresented: $showPopup) {
                Note(auth: authenticationManager, onNoteAdded: {
                    showPopup = false
                    dataManager.getNotes()
                })
            }
            .sheet(isPresented: $showDetails) {
                NoteDetails(noteDetails: $noteDetails, onNoteDeleted: {
                    showDetails = false
                    dataManager.getNotes()
                })
            }
            Spacer()
        }
    }
}
