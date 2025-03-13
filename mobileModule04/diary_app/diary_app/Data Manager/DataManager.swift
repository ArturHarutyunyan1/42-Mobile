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
                    
                    let note = Notes(date: date, feeling: feeling, text: text, title: title, usermail: usermail)
                    self.diary.append(note)
                }
            }
        }
    }
}
