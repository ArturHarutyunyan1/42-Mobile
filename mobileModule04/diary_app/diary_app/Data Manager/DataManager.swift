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
    
    init() {
        getNotes()
    }
    
    func getNotes() {
        diary.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("notes")
        ref.getDocuments {snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
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
    func addNote(feeling: String, text: String, title: String, usermail: String) {
        let db = Firestore.firestore()
        let ref = db.collection("notes").document()
        let colors: [String] = [".cyanBackground", ".yellowBackground", ".greenBackground", ".pinkBackground", ".purpleBackground", ".redBackground"]
        let color = colors.randomElement() ?? ".blue"
        
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
                print("Error adding document: \(error)")
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
                print("Error white deleting note \(error)")
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
                print("Something went wrong while updating note \(error)")
            } else {
                print("Note updated successfully!")
            }
        }
    }
    func getDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
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
