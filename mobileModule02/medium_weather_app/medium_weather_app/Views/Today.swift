//
//  Today.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 01.03.25.
//

import SwiftUI
import Foundation

struct Today: View {
    @Binding var locationInfo: LocationInfo?
    @ObservedObject var handler: WeatherViewModel
    @State private var date: String?
    var body: some View {
        if let error = handler.errorMessage {
            Text(error)
                .foregroundColor(.red)
                .padding()
        } else {
            ScrollView {
                Text("\(locationInfo?.city ?? "Unknown City")")
                Text("\(locationInfo?.state ?? "Unknown State")")
                Text("\(locationInfo?.country ?? "Unknown Country")")
                
                if let data = locationInfo?.weaterData?.hourly {
                    ForEach(0..<data.time.count, id: \.self) {index in
                        let fullTime = data.time[index]
                        let time = fullTime.components(separatedBy: "T")
                        if let datePart = time.first, datePart == date {
                            HStack {
                                Spacer()
                                Text("\(time.last ?? "")")
                                Spacer()
                                Text("\(String(format: "%.1f", data.temperature_2m[index])) ℃")
                                Spacer()
                                Text("\(locationInfo?.todayStatus?[index] ?? "")")
                                Spacer()
                                Text("\(String(format: "%.1f", data.wind_speed_10m[index])) km/h")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .frame(minWidth: UIScreen.main.bounds.width * 0.9)
            .scrollIndicators(.hidden)
            .onAppear() {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let current = dateFormatter.string(from: Date())
                date = current
            }
        }
    }
}
