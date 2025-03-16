//
//  Profile.swift
//  advanced_diary_app
//
//  Created by Artur Harutyunyan on 15.03.25.
//
import SwiftUI
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
    @State private var feelingList: [String] = []
    @State private var feelingPercentage: [(String, Double)] = []
    @State private var noteDetails: Notes?
    
    var userNotesCount: Int {
        dataManager.diary.filter { $0.usermail == authenticationManager.userEmail }.count
    }
    
    var body: some View {
        ScrollView {
            HeaderView()
            UserInfoView()
            if userNotesCount > 0 {
                LastEntriesView()
                FeelingStatisticsView()
            } else {
                Text("No recent notes")
            }
        }
        FloatingAddButton()
        .onAppear { updateFeelings() }
        .onChange(of: dataManager.diary.count) { updateFeelings() }
        
    }
    
    private func HeaderView() -> some View {
        HStack {
            Spacer()
            Button(action: { logoutAlert = true }) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.red)
            }
        }
        .padding()
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
    
    private func UserInfoView() -> some View {
        VStack {
            HStack {
                AvatarView()
                VStack {
                    Text(authenticationManager.userData.name)
                        .font(.system(size: 30))
                        .font(.headline)
                    Spacer()
                }
            }
        }
    }
    
    private func AvatarView() -> some View {
        Group {
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
        }
    }
    
    private func LastEntriesView() -> some View {
        VStack {
            SectionHeaderView(title: "Last 2 entries")
            if userNotesCount < 1 {
                Text("No recent notes")
            } else {
                ForEach(dataManager.diary
                    .filter { $0.usermail == authenticationManager.userEmail }
                    .sorted { $0.date > $1.date }
                    .prefix(2), id: \ .id) { note in
                    NoteEntryView(note: note)
                }
                .padding(.horizontal)
                .lineLimit(10)
            }
        }
    }
    
    private func FeelingStatisticsView() -> some View {
        VStack {
            SectionHeaderView(title: "Your feeling across your \(userNotesCount) entries")
            ForEach(feelingPercentage, id: \ .0) { percentage in
                FeelingBarView(feeling: percentage.0, percentage: percentage.1)
            }
        }
        .padding()
    }
    
    private func FloatingAddButton() -> some View {
        Button(action: { showPopup = true }) {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(.white)
        }
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
    }
    
    private func SectionHeaderView(title: String) -> some View {
        HStack {
            Text(title)
            Spacer()
        }
        .padding()
    }
    
    private func NoteEntryView(note: Notes) -> some View {
        let color = dataManager.stringToColor(note.style)
        let mood = note.feeling.components(separatedBy: " ").first ?? "Mood"
        let date = note.date.components(separatedBy: " ")
        
        return Button(action: {
            showDetails = true
            noteDetails = note
        }) {
            VStack(alignment: .leading) {
                Text(note.title)
                    .font(.headline)
                    .foregroundStyle(.vernagir)
                Text(mood)
                    .foregroundStyle(.bovandakutyun)
                Text(note.text)
                    .foregroundStyle(.bovandakutyun)
                HStack {
                    Spacer()
                    Text("\(note.date)")
                        .foregroundStyle(.bovandakutyun)
                }
            }
            .padding()
            .background(color)
            .cornerRadius(15)
        }
    }
    
    private func FeelingBarView(feeling: String, percentage: Double) -> some View {
        VStack {
            HStack {
                Text(feeling)
                Text("\(String(format: "%.1f", percentage))%")
                Spacer()
            }
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .cornerRadius(15)
        }
    }
    
    private func updateFeelings() {
        feelingList = dataManager.diary
            .filter { $0.usermail == authenticationManager.userEmail }
            .map { $0.feeling.components(separatedBy: " ").first ?? "Mood" }
        feelingPercentage = calculatePercentage()
    }
    
    private func calculatePercentage() -> [(String, Double)] {
        let totalCount = feelingList.count
        guard totalCount > 0 else { return [] }
        let wordCount = Dictionary(grouping: feelingList, by: { $0 }).mapValues { $0.count }
        return wordCount.map { (word, count) in
            (word, (Double(count) / Double(totalCount)) * 100)
        }
    }
}
