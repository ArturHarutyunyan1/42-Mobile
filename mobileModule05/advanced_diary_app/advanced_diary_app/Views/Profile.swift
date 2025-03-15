//
//  Profile.swift
//  advanced_diary_app
//
//  Created by Artur Harutyunyan on 15.03.25.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

struct Profile: View {
    @StateObject var authenticationManager: Authentication
    @EnvironmentObject var dataManager: DataManager
    @State private var logoutAlert = false
    @State private var errorAlert = false
    var body: some View {
        HStack {
            Spacer()
            Button (action: {
                logoutAlert = true
            }, label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .frame(width: 30, height: 30)
            })
            .foregroundStyle(.red)
        }
        ScrollView {
            VStack {
                HStack {
                    if let url = authenticationManager.userData.avatarURL {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.red)
                    }
                    VStack {
                        Text(authenticationManager.userData.name)
                            .font(.system(size: 30))
                            .font(.headline)
                    }
                }
            }
        }
        .alert("Are you sure you want to log out?",isPresented: $logoutAlert) {
            Button(action: {
                Task {
                    do {
                        try await authenticationManager.logOut()
                    } catch {
                        errorAlert = true
                    }
                }
            }, label: {
                Text("Yes")
            })
            Button("Cancel", role: .cancel) {}
        }
        .alert("Something went wrong, try again!",isPresented: $errorAlert) {
            Button("Cancel", role: .cancel) {
                errorAlert = false
                logoutAlert = false
            }
        }
    }
}
