//
//  Welcome.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 12.03.25.
//

import SwiftUI

struct Welcome: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("LoginBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea(.all)
                    .overlay(Color.black.opacity(0.3))
                VStack {
                    Text("Welcome to your")
                        .font(.custom("Snell Roundhand", size: 34))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Diary")
                        .font(.custom("Snell Roundhand", size: 40))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    NavigationLink(destination: Login()) {
                        Text("Login")
                            .frame(width: 150, height: 50)
                            .background(.loginButton)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 300)
                .background(Color.white.opacity(0.85))
                .cornerRadius(20)
                .shadow(radius: 10)
            }
        }
    }
}

#Preview {
    Welcome()
}
