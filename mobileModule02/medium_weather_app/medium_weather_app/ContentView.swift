//
//  ContentView.swift
//  medium_weather_app
//
//  Created by Artur Harutyunyan on 03.03.25.
//

import SwiftUI
import MapKit

enum AppTab: CaseIterable, Hashable {
    case currently, today, weekly
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .currently
    @StateObject private var handler = WeatherViewModel()

    var body: some View {
        VStack(spacing: 0) {
            Search(handler: handler)
            TabView(selection: $selectedTab) {
                Home(cityName: $handler.cityName)
                    .tag(AppTab.currently)
                Today(cityName: $handler.cityName)
                    .tag(AppTab.today)
                Weekly(cityName: $handler.cityName)
                    .tag(AppTab.weekly)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: selectedTab)
            Navigation(selectedTab: $selectedTab)
                .frame(height: 80)
                .padding(.horizontal)
        }
        .onAppear() {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
