//
//  Home.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 12.03.25.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var dataManager: DataManager
    @StateObject var authenticationManager: Authentication
    var body: some View {
            Text("Home page")
            Text("Hello \(authenticationManager.userEmail)")
        List(dataManager.diary.filter{$0.usermail == authenticationManager.userEmail}, id: \.usermail) {result in
                Text("\(result)")
            }
            Button(action: {
                Task {
                    do {
                        try await authenticationManager.logOut()
                    } catch  {
                        print("Error")
                    }
                }
            }, label: {
                Text("Log out")
            })
    }
}
