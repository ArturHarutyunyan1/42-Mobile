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
    @State private var showPopup = false
    let colors: [Color] = [.cyanBackground, .yellowBackground, .greenBackground, .pinkBackground, .purpleBackground, .redBackground]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack {
            Navigation()
            ScrollView {
                MasonryVStack(columns: 2, spacing: 20) {
                    ForEach(dataManager.diary.filter { $0.usermail == authenticationManager.userEmail }, id: \.date) { note in
                        let randomColor = colors.randomElement() ?? .blue
                        VStack(alignment: .leading) {
                            Text(note.title)
                                .font(.headline)
                            Text(note.text)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(10)
                        .background(randomColor)
                        .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
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
                })
            }
            Spacer()
        }
    }
}
