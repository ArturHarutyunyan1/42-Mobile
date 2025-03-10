//
//  Today.swift
//  weather_app
//
//  Created by Artur Harutyunyan on 01.03.25.
//

import SwiftUI
import Foundation
import Charts

struct Today: View {
    @Binding var locationInfo: LocationInfo?
    @ObservedObject var handler: WeatherViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 24) {
                    if let error = handler.errorMessage {
                        Text(error)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.red)
                            .padding(.top, 20)
                    } else {
                        VStack(spacing: 12) {
                            Text(locationInfo?.city ?? "-")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                            Text("\(locationInfo?.state ?? "-"), \(locationInfo?.country ?? "-")")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .opacity(0.8)
                            VStack {
                                if let chart = locationInfo?.chart {
                                    Chart {
                                        ForEach(0..<chart.timeValue.count, id: \.self) { index in
                                            LineMark(
                                                x: .value("Time", chart.timeValue[index]),
                                                y: .value("Temperature", chart.temperatureValue[index])
                                            )
                                            .symbol(.circle)
                                        }
                                    }
                                    .frame(width: geometry.size.width * 0.9, height: 300)
                                    .padding(.vertical, 20)
                                }
                            }
                            .frame(width: geometry.size.width * 0.9)
                            .background(Color(.systemGray6).opacity(0.3))
                            .cornerRadius(15)
                        }
                        if let data = locationInfo?.weaterData?.hourly {
                            ScrollView (.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach (0..<data.time.count, id: \.self) {index in
                                        let fullTime = data.time[index]
                                        let time = fullTime.components(separatedBy: "T")
                                        if let datePart = time.first, datePart == handler.date {
                                            VStack {
                                                Text("\(time.last ?? "")")
                                                Spacer()
                                                Image(systemName: locationInfo?.iconsName?[index] ?? "questionmark.circle")
                                                Spacer()
                                                Text("\(String(format: "%.1f", data.temperature_2m[index]))℃")
                                                HStack {
                                                    Image(systemName: "wind")
                                                    Text("\(String(format: "%.1f", data.wind_speed_10m[index])) km/h")
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            .padding()
                                            .foregroundStyle(.white)
                                            .background(Color(.systemGray6).opacity(0.3))
                                            .cornerRadius(15)
                                        }
                                    }
                                }
                            }
                            .frame(width: geometry.size.width * 0.9)
                        }
                    }
                }
                .frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width)
            .scrollIndicators(.hidden)
        }
    }
}
