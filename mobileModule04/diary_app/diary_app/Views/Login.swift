//
//  Login.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 12.03.25.
//

import SwiftUI

struct Login: View {
    var body: some View {
        VStack {
            Text("Choose a way to Sign in")
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Button(action: {
                print("Google button")
            }, label: {
                HStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.red)
                    Text("Continue with Google")
                        .foregroundStyle(.black)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .frame(minWidth: 200)
                .padding()
            })
            Button(action: {
                print("GitHub button")
            }, label: {
                HStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.black)
                    Text("Continue with GitHub")
                        .foregroundStyle(.black)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .frame(minWidth: 200)
                .padding()
            })
        }
    }
}

#Preview {
    Login()
}
