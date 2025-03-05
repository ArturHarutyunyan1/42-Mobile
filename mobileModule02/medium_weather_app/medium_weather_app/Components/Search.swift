//
//  Search.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 02.03.25.
//

import SwiftUI

struct Search: View {
    @State private var input: String = ""
    @State private var isActive: Bool = false
    @ObservedObject var handler: WeatherViewModel
    @StateObject private var location = LocationManager()

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search...", text: $input)
                .padding(.vertical, 10)
                .onChange(of: input, {
                    isActive = true
                    if input == "" {
                        handler.setCoords(name: "", latitude: "", longitude: "")
                        isActive = false
                    }
                    searchCity()
                })
//                .onSubmit {
//                    searchCity()
//                }
            Button {
                location.checkStatus()
                handler.setCoords(name: "", latitude: location.lat ?? "", longitude: location.lon ?? "")
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
        if isActive == true && handler.searchResults.count > 0 {
            Spacer()
            Spacer()
            ScrollView {
                ForEach(handler.searchResults) { result in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(result.name)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        HStack {
                            Text("\(result.admin1), \(result.country)")
                                .foregroundStyle(Color(.systemGray2))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(10)
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
            .ignoresSafeArea(.all)
        }
    }
    private func searchCity() {
        handler.setCoords(name: input, latitude: "", longitude: "")
        Task {
            await handler.searchAPI(name: input)
        }
    }
}

