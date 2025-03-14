//
//  Navigation.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 13.03.25.
//

import SwiftUI

struct Navigation: View {
    var body: some View {
        HStack {
            Text("Recent Notes")
                .font(.headline)
            Spacer()
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
        }
        .padding()
        .frame(height: 50)
    }
}

#Preview {
    Navigation()
}
