//
//  ContentView.swift
//  ex02
//
//  Created by Artur Harutyunyan on 19.02.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Calculator")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(.blue)
                .foregroundStyle(.white)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        VStack {
            Text("Display");
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3)
        .background(.red)
        VStack {
            Text("Digits")
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.7)
        .background(.blue)
        
    }
}

#Preview {
    ContentView()
}
