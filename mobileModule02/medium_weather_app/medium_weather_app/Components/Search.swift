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
    @State private var city: String = ""
    @State private var country: String = ""
    @State private var state: String = ""
    @ObservedObject var handler: WeatherViewModel
    @ObservedObject var location: LocationManager

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search...", text: $input)
                .padding(.vertical, 10)
                .onChange(of: input, {
                    isActive = true
                    if input == "" {
                        isActive = false
                    }
                    searchCity(name: input)
                })
            Button {
                
                if input != "",
                   let stringLat = location.lat,
                   let stringLon = location.lon,
                   let lat = Double(stringLat),
                   let lon = Double(stringLon) {
                    location.cityName = city
                    location.countryName = country
                    location.stateName = state
                    handler.getWeatherForecast(lat: lat, lon: lon, location: location)
                }
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
                    Button(action: {
                        Task {
                            DispatchQueue.main.async {
                                location.cityName = result.name
                                location.countryName = result.country
                                location.stateName = result.admin1
                                handler.getWeatherForecast(lat: result.latitude, lon: result.longitude, location: location)
                                isActive = false
                            }
                        }
                    }) {
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
            .onAppear() {
                if input != "" {
                    city = location.cityName ?? ""
                    country = location.countryName ?? ""
                    state = location.stateName ?? ""
                }
            }
        }
    }
    private func searchCity(name: String) {
        Task {
            await handler.searchAPI(name: name)
        }
    }
}

