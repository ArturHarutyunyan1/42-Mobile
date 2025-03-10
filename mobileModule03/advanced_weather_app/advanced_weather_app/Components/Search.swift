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
    @ObservedObject var location: LocationManager

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search...", text: $input)
                    .padding(.vertical, 10)
                    .onChange(of: input) { newValue, _ in
                        if input != "" {
                            isActive = !newValue.isEmpty
                            searchCity(name: newValue)
                        }
                        if input == "" {
                            isActive = false
                        }
                    }
                Button {
                    if location.show == true && location.status == false {
                        location.show = false
                    }
                    else {
                        location.checkStatus()
                        location.locationManager.startUpdatingLocation()
                        if !input.isEmpty,
                           let stringLat = location.lat,
                           let stringLon = location.lon,
                           let lat = Double(stringLat),
                           let lon = Double(stringLon) {
                            handler.getWeatherForecast(lat: lat, lon: lon, location: location)
                        }
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
            if isActive {
                Spacer()
                Spacer()
                ScrollView {
                    if let error = handler.searchError {
                        if input != "" {
                            Text(error)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                    }
                    else if handler.searchResults.count > 0 {
                        ForEach(0..<min(5, handler.searchResults.count), id: \.self) { index in
                            let result = handler.searchResults[index]
                            Button(action: {
                                Task {
                                    DispatchQueue.main.async {
                                        location.cityName = result.name
                                        location.countryName = result.country
                                        location.stateName = result.admin1
                                        handler.getWeatherForecast(lat: result.latitude, lon: result.longitude, location: location)
                                        isActive = false
                                        handler.errorMessage = nil
                                        location.show = true
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .ignoresSafeArea(.all)
            }
        }
    }
    
    private func searchCity(name: String) {
        Task {
            await handler.searchAPI(name: name)
        }
    }
}

