//
//  Navigation.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 13.03.25.
//

import SwiftUI


struct Navigation: View {
    @StateObject var authManager: Authentication
    @State private var logoutAlert = false
    @State private var errorAlert = false

    var body: some View {
        HStack {
            Text("Recent Notes")
                .font(.headline)
            Spacer()
            NavigationLink(destination: Profile(authenticationManager: authManager)) {
                if let url = authManager.userData.avatarURL {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .frame(height: 50)
        .alert("Are you sure you want to log out?", isPresented: $logoutAlert) {
            Button("Yes") {
                Task {
                    do {
                        try await authManager.logOut()
                    } catch {
                        errorAlert = true
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Something went wrong, try again!", isPresented: $errorAlert) {
            Button("OK", role: .cancel) {
                errorAlert = false
                logoutAlert = false
            }
        }
    }
}
