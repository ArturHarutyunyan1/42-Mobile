//
//  Profile.swift
//  advanced_diary_app
//
//  Created by Artur Harutyunyan on 15.03.25.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import MasonryStack

struct Profile: View {
    @StateObject var authenticationManager: Authentication
    @EnvironmentObject var dataManager: DataManager
    @State private var logoutAlert = false
    @State private var errorAlert = false
    @State private var showDetails = false
    @State private var showPopup = false
    @State private var noteDetails: Notes?
    var userNotesCount: Int {
        dataManager.diary.filter { $0.usermail == authenticationManager.userEmail }.count
    }
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                Button (action: {
                    logoutAlert = true
                }, label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .resizable()
                        .frame(width: 30, height: 30)
                })
                .foregroundStyle(.red)
            }
            VStack {
                HStack {
                    if let url = authenticationManager.userData.avatarURL {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.red)
                    }
                    VStack {
                        Text(authenticationManager.userData.name)
                            .font(.system(size: 30))
                            .font(.headline)
                        Spacer()
                    }
                }
            }
            VStack {
                HStack {
                    Text("Last 2 entries")
                    Spacer()
                }
                .padding()
                if userNotesCount < 1 {
                    Text("No recent notes")
                } else {
                    VStack {
                        ForEach(dataManager.diary
                            .filter { $0.usermail == authenticationManager.userEmail }
                            .sorted { $0.date > $1.date}
                            .prefix(2),
                                id: \.id) { note in
                            let color = dataManager.stringToColor(note.style)
                            let mood = note.feeling.components(separatedBy: " ").first ?? "Mood"
                            let date = note.date.components(separatedBy: " ")
                            Button(action: {
                                showDetails = true
                                noteDetails = note
                            }, label: {
                                VStack(alignment: .leading) {
                                    Text(note.title)
                                        .font(.headline)
                                        .foregroundStyle(.vernagir)
                                    Text(mood)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .foregroundStyle(.bovandakutyun)
                                    Text(note.text)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .foregroundStyle(.bovandakutyun)
                                    HStack {
                                        Spacer()
                                        Text("\(date[0]) \(date[1]) \(date[2])")
                                            .foregroundStyle(.bovandakutyun)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(5)
                                .background(color)
                                .cornerRadius(15)
                            })
                        }
                    }
                    .padding(.horizontal)
                }
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
        .alert("Are you sure you want to log out?",isPresented: $logoutAlert) {
            Button(action: {
                Task {
                    do {
                        try await authenticationManager.logOut()
                    } catch {
                        errorAlert = true
                    }
                }
            }, label: {
                Text("Yes")
            })
            Button("Cancel", role: .cancel) {}
        }
        
        .alert("Something went wrong, try again!",isPresented: $errorAlert) {
            Button("Cancel", role: .cancel) {
                errorAlert = false
                logoutAlert = false
            }
        }
    }
}
