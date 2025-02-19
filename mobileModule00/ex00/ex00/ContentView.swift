//
//  ContentView.swift
//  ex00
//
//  Created by Artur Harutyunyan on 19.02.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("A simple text")
                .font(.system(size: 50))
                .foregroundStyle(.white)
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 10).fill(.blue))
            Button(action: {
                print("Button pressed");
            }) {
                Text("Click me")
                    .padding(10)
                    .frame(width: 100, height: 50)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.black))
                    .foregroundStyle(.white)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
