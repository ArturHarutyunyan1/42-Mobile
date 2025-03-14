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
    var body: some View {
        GeometryReader {geometry in
            let color = DataManager().stringToColor(noteDetails?.style ?? "")
            VStack {
                HStack {
                    Text("Edit note")
                        .foregroundStyle(.darkBlue)
                        .font(.system(size: 20))
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 25, height: 25)
                    })
                    .foregroundStyle(.red)
                }
                Text("\(noteDetails?.title ?? "")")
                    .foregroundStyle(.vernagir)
                    .font(.system(size: 35))
                    .fontWeight(.bold)
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
    }
}
