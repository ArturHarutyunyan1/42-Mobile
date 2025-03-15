//
//  Authentication.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 12.03.25.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

enum AuthenticationError : Error {
    case runtimeError(String)
}

@MainActor
class Authentication : ObservableObject {
    @Published var isLoggedIn = false
    @Published var userEmail = ""
    @Published var userData: UserData
    
    init() {
        self.isLoggedIn = (Auth.auth().currentUser != nil)
        if let savedEmail = UserDefaults.standard.string(forKey: "userEmail") {
            self.userEmail = savedEmail
        }
        userData = UserData(name: "", avatarURL: URL(string: ""))
    }
    
    func googleOAuth() async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("Firebase client ID could not be found")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        guard let rootVC = scene.windows.first?.rootViewController else {
            fatalError("Could not find root view controller")
        }
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
        let user = result.user
        guard let idToken = user.idToken?.tokenString else {
            throw AuthenticationError.runtimeError("Unexpected error occured")
        }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
        try await Auth.auth().signIn(with: credential)
        self.userEmail = user.profile?.email ?? ""
        UserDefaults.standard.set(self.userEmail, forKey: "userEmail")
        isLoggedIn = true
    }
    func githubAuth() async throws {
        let provider = OAuthProvider(providerID: "github.com")
        provider.customParameters = ["prompt": "select_account"]
        provider.scopes = ["user:email"]
        let credential: AuthCredential = try await withCheckedThrowingContinuation { continuation in
            provider.getCredentialWith(nil) { credential, error in
                if let error = error {
                    print("GitHub credential error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else if let credential = credential {
                    print("GitHub credential obtained successfully.")
                    continuation.resume(returning: credential)
                } else {
                    print("No GitHub credential returned.")
                    continuation.resume(throwing: AuthenticationError.runtimeError("No credential returned from GitHub."))
                }
            }
        }
        let authResult = try await Auth.auth().signIn(with: credential)
        let user = authResult.user
        self.userEmail = user.email ?? ""
        UserDefaults.standard.set(self.userEmail, forKey: "userEmail")
        isLoggedIn = true
    }

    func logOut() async throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
        isLoggedIn = false
    }
    func setUserData() {
        self.userData.avatarURL = Auth.auth().currentUser?.photoURL ?? URL(string: "")
        self.userData.name = Auth.auth().currentUser?.displayName ?? ""
    }
}
