//
//  NoteDetails.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 14.03.25.
//

import SwiftUI

struct NoteDetails: View {
    @Binding var noteDetails: Notes?
    var body: some View {
        Text("\(noteDetails?.date ?? "asdadasd")")
    }
}
