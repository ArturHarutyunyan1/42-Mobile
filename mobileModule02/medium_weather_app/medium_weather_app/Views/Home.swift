//
//  Home.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 01.03.25.
//

import SwiftUI

struct Home: View {
    @Binding var locationInfo: LocationInfo?
    @StateObject private var handler = WeatherViewModel()

    var body: some View {
        ScrollView {
            VStack {
                if let error = handler.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text(locationInfo?.city ?? "Unknown City")
                    Text(locationInfo?.state ?? "Unknown State")
                    Text(locationInfo?.country ?? "Unknown Country")
                    
                    if let data = locationInfo?.weaterData {
                        Text("\(String(format: "%.1f", data.current.temperature_2m)) ℃")
                        Text("\(String(format: "%.1f", data.current.wind_speed_10m)) km/h")
                        Text("\(locationInfo?.currentStatus ?? "")")
                    }
                }
            }
            .padding()
        }
    }
}

