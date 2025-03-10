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
    @State private var connectionStatus: Bool = false
    @StateObject private var handler = WeatherViewModel()
    @StateObject private var location = LocationManager()
    @State private var hasFetchedWeather = false
    @State private var locationError: Bool = false

    var body: some View {
        GeometryReader {geometry in
            if !connectionStatus {
                VStack {
                    Image(systemName: "wifi.slash")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.red)
                    Text("No internet connection")
                        .font(.system(size: 32))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            ZStack {
                Image("Sunny")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
            VStack {
                Search(handler: handler, location: location)
                VStack {
                    TabView(selection: $selectedTab) {
                        if locationError ||
                            (location.status == false && location.show == false) ||
                            location.cityName == "Unknown" {
                            VStack {
                                Image(systemName: "location.slash.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundStyle(.red)
                                Text("Your location services are disabled. Please enable them in your settings.")
                                    .font(.system(size: 32))
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                        } else {
                            Home(locationInfo: $handler.locationInfo, handler: handler)
                                .tag(AppTab.currently)
                            Today(locationInfo: $handler.locationInfo, handler: handler)
                                .tag(AppTab.today)
                            Weekly(locationInfo: $handler.locationInfo, handler: handler)
                                .tag(AppTab.weekly)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.3), value: selectedTab)
                    
                    Navigation(selectedTab: $selectedTab)
                        .frame(height: 80)
                        .padding(.horizontal)
                }
            }
        }
        .onAppear {
            checkInternetConnection { connection in
                connectionStatus = connection
                if connection {
                    location.checkStatus()
                }
            }
        }
        .onChange(of: connectionStatus) { status, _ in
            if status {
                location.checkStatus()
            }
        }
        .onChange(of: location.status) { newStatus, _ in
            locationError = (newStatus == false)
        }
        .onReceive(Publishers.CombineLatest(location.$lat, location.$lon)) { lat, lon in
            if !hasFetchedWeather,
               let stringLat = lat,
               let stringLon = lon,
               let lat = Double(stringLat),
               let lon = Double(stringLon) {
                hasFetchedWeather = true
                Task {
                    handler.getWeatherForecast(lat: lat, lon: lon, location: location)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
