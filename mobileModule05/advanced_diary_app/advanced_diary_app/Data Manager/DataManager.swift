//
//  DataManager.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 13.03.25.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseFirestoreInternal

class DataManager : ObservableObject {
    @Published var diary: [Notes] = []
    @Published var errorMessage: String?
    
    init() {
        getNotes()
    }
    
    func getNotes() {
        diary.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("notes")
        ref.getDocuments {snapshot, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let date = data["date"] as? String ?? ""
                    let feeling = data["feeling"] as? String ?? ""
                    let text = data["text"] as? String ?? ""
                    let title = data["title"] as? String ?? ""
                    let usermail = data["usermail"] as? String ?? ""
                    let style = data["style"] as? String ?? ""
                    
                    let note = Notes(id: document.documentID, date: date, feeling: feeling, text: text, title: title, usermail: usermail, style: style)
                    self.diary.append(note)
                }
            }
        }
    }
    func addNote(feeling: String, text: String, title: String, usermail: String, color: String) {
        let db = Firestore.firestore()
        let ref = db.collection("notes").document()
        
        let noteData: [String: Any] = [
            "date": getDate(),
            "feeling": feeling,
            "text": text,
            "title": title,
            "usermail": usermail,
            "style": color
        ]
        ref.setData(noteData) {error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                print("\(UserDefaults.standard.string(forKey: "userMail") ?? "")")
                print("Document added successfully!")
            }
        }
    }
    func deleteNote(note: Notes) {
        let db = Firestore.firestore()
        
        let ref = db.collection("notes").document(note.id)
        
        ref.delete {error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                print("Deleted successfully")
            }
        }
    }
    func editNote(note: Notes) {
        let db = Firestore.firestore()
        let ref = db.collection("notes").document(note.id)
        
        let updatedData: [String: Any] = [
            "date": getDate(),
            "feeling": note.feeling,
            "text": note.text,
            "title": note.title,
            "usermail": note.usermail,
            "style": note.style
        ]
        ref.updateData(updatedData) {error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                print("Note updated successfully!")
            }
        }
    }
    func getDate() -> String {
        var selectedDate: DateComponents? = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        if let selectedDate = selectedDate,
           let date = Calendar.current.date(from: selectedDate) {
            return date.formatted(.dateTime.weekday(.wide).day().month(.wide).year())
        }
        return ""
    }
    func stringToColor(_ string: String) -> Color {
        switch (string) {
        case ".cyanBackground":
            return .cyanBackground
        case ".yellowBackground":
            return .yellowBackground
        case ".greenBackground":
            return .greenBackground
        case ".pinkBackground":
            return .pinkBackground
        case ".purpleBackground":
            return .purpleBackground
        case ".redBackground":
            return .redBackground
        default:
            return .blue
        }
    }
}
