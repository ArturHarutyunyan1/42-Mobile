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

enum AuthenticationError : Error {
    case runtimeError(String)
}

@MainActor
class Authentication : ObservableObject {
    @Published var isLoggedIn = false
    
    init() {
        self.isLoggedIn = (Auth.auth().currentUser != nil)
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
        isLoggedIn = true
    }
}
