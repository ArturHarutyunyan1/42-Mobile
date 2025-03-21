//
//  Search.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 02.03.25.
//

import SwiftUI

struct Search: View {
    @State private var input: String = ""
    @ObservedObject var handler: WeatherViewModel

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search...", text: $input)
                .padding(.vertical, 10)
                .onSubmit {
                    handler.setCityName(input: input)
                }
            Button {
                handler.setCityName(input: "Geolocation")
            } label: {
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

