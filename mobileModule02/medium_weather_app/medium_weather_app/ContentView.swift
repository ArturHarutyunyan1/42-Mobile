//
//  ContentView.swift
//  medium_weather_app
//
//  Created by Artur Harutyunyan on 03.03.25.
//

import SwiftUI
import MapKit
import Combine

enum AppTab: CaseIterable, Hashable {
    case currently, today, weekly
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .currently
    @StateObject private var handler = WeatherViewModel()
    @StateObject private var location = LocationManager()

    var body: some View {
        VStack(spacing: 0) {
            Search(handler: handler, location: location)
            if location.status == false && handler.cityName == "" {
                VStack {
                    Text("Your location services are disabled. Please enable them in your settings.")
                }
                .frame(width: UIScreen.main.bounds.width, height: 50)
                .padding(10)
                .background(Color.red)
                
            }
            VStack {
                TabView(selection: $selectedTab) {
                    Home(locationInfo: $handler.locationInfo)
                        .tag(AppTab.currently)
                    Today(locationInfo: $handler.locationInfo)
                        .tag(AppTab.today)
                    Weekly(cityName: $handler.cityName, latitude: $location.lat, longitude: $location.lon)
                        .tag(AppTab.weekly)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
                Navigation(selectedTab: $selectedTab)
                    .frame(height: 80)
                    .padding(.horizontal)
            }
            .onAppear() {
                location.checkStatus()
            }
            .onReceive(Publishers.CombineLatest(location.$lat, location.$lon)) { lat, lon in
                if let stringLat = lat,
                   let stringLon = lon,
                   let lat = Double(stringLat),
                   let lon = Double(stringLon) {
                    Task {
                        handler.getWeatherForecast(lat: lat, lon: lon, location: location)
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .ignoresSafeArea(.keyboard)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
