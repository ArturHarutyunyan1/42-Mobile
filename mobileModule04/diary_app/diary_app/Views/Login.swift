//
//  Login.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 12.03.25.
//

import SwiftUI

struct Login: View {
    @StateObject var authenticationManager: Authentication
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Button(action: {
                    Task {
                        do {
                            try await authenticationManager.googleOAuth()
                        } catch AuthenticationError.runtimeError {
                            print ("Error\n")
                        }
                    }
                }, label: {
                    HStack {
                        Image("Google")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.red)
                        Spacer()
                        Text("Continue with Google")
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                        Spacer()
                    }
                    .padding(10)
                    .frame(width: geometry.size.width * 0.9)
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .frame(minWidth: 200)
                    .padding()
                })
                Button(action: {
                    Task {
                        do {
                            try await authenticationManager.githubAuth()
                        } catch {
                            print("Error")
                        }
                    }
                }, label: {
                    HStack {
                        Image("GitHub")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.black)
                        Spacer()
                        Text("Continue with GitHub")
                            .foregroundStyle(.black)
                            .font(.system(size: 20))
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                        Spacer()
                    }
                    .padding(10)
                    .frame(width: geometry.size.width * 0.9)
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .frame(minWidth: 200)
                    .padding()
                })
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}
