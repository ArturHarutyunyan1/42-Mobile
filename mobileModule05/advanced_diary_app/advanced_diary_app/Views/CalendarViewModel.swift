//
//  CalendarViewModel.swift
//  advanced_diary_app
//
//  Created by Artur Harutyunyan on 16.03.25.
//

import SwiftUI
import CalendarView
import MasonryStack

struct CalendarViewModel: View {
    @State private var selectedDate: DateComponents? = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    @EnvironmentObject var dataManager: DataManager
    @StateObject var authenticationManager: Authentication
    @State private var showDetails = false
    @State private var noteDetails: Notes?
    var body: some View {
        GeometryReader {geometry in
            ScrollView {
                VStack {
                    CalendarView(selection: $selectedDate)
                }
                VStack {
                    if let selectedDate = selectedDate,
                       let date = Calendar.current.date(from: selectedDate) {
                        let dateString = String(describing: date.formatted(.dateTime.weekday(.wide).day().month(.wide).year()))
                        Text("Note entries for \(dateString)")
                        MasonryVStack(columns: 2, spacing: 20) {
                            ForEach(dataManager.diary.filter { $0.usermail == authenticationManager.userEmail && $0.date == dateString }, id: \.id) {note in
                                let color = dataManager.stringToColor(note.style)
                                let mood = note.feeling.components(separatedBy: " ").first ?? "Mood"
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
                                            Text("\(note.date)")
                                                .foregroundStyle(.bovandakutyun)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(10)
                                    .background(color)
                                    .cornerRadius(15)
                                })
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width * 0.9)
            }
            .sheet(isPresented: $showDetails) {
                NoteDetails(noteDetails: $noteDetails, onNoteDeleted: {
                    showDetails = false
                    dataManager.getNotes()
                })
            }
        }
    }
}
