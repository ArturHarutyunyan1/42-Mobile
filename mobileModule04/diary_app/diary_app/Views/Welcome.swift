//
//  Welcome.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 12.03.25.
//

import SwiftUI

struct Welcome: View {
    @StateObject var authenticationManager: Authentication
    var body: some View {
        GeometryReader {geometry in
            ZStack {
                Image("LoginBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height * 1.1)
                    .ignoresSafeArea(.all)
                    .overlay(Color.black.opacity(0.3))
                NavigationStack {
                    Text("Welcome to your")
                        .font(.custom("Snell Roundhand", size: 34))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Diary")
                        .font(.custom("Snell Roundhand", size: 40))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    NavigationLink(destination: Login(authenticationManager: authenticationManager)) {
                        Text("Login")
                            .frame(width: 150, height: 50)
                            .background(.loginButton)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                }
                .frame(width: geometry.size.width * 0.8, height: 300)
                .background(.white)
                .cornerRadius(20)
                .shadow(radius: 10)
            }
        }
    }
}

