//
//  Home.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 01.03.25.
//

import SwiftUI


struct Home: View {
    @Binding var cityName: String
    @Binding var latitude: String?
    @Binding var longitude: String?
    @Binding var country: String?
    @Binding var city: String?
    @Binding var state: String?
    @Binding var weatherData: WeatherData?
    var body: some View {
        VStack {
            Text(city ?? "Unknown City")
            Text(state ?? "Unknown State")
            Text(country ?? "Unknown Country")
            if let data = weatherData {
                Text("\(String(format: "%.1f", data.current.temperature_2m))℃")
                Text("\(String(format: "%.1f", data.current.wind_speed_10m)) km/h")
            }
        }
    }
}
